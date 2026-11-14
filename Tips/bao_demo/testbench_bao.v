`timescale 1ns / 1ps

module testbench_bao;
    reg clk = 0;
    reg reset = 0;
    integer i, j, k, seed, checks;
    reg [31:0] values [0:7];
    reg [15:0] offsets [0:6];
    reg [31:0] random_a, random_b;
    reg [15:0] random_offset;
    reg [31:0] saved_regs [0:31];

    mips dut(.clk(clk), .reset(reset));

    task tick;
    begin
        #2; clk = 1; #2; clk = 0; #1;
    end
    endtask

    task reset_cpu;
    integer n;
    begin
        reset = 1;
        tick;
        reset = 0;
        for (n = 0; n < 4096; n = n + 1)
            dut.IM.ROM[n] = 0;
    end
    endtask

    task check_bao;
        input [31:0] a, b;
        input [15:0] immediate;
        reg signed [63:0] mathematical_sum;
        reg signed [31:0] signed_offset;
        reg should_branch;
        reg [31:0] expected_pc;
        integer n;
    begin
        // Set up one architectural instruction, then check its clock-edge effects.
        dut.PC.regPC = 32'h3000;
        dut.GRF.GRF[1] = a;
        dut.GRF.GRF[2] = b;
        dut.IM.ROM[0] = {6'b101101, 5'd1, 5'd2, immediate};
        for (n = 0; n < 32; n = n + 1)
            saved_regs[n] = dut.GRF.GRF[n];

        // Independent reference: add in 64 bits and test the signed 32-bit range.
        mathematical_sum = $signed(a);
        mathematical_sum = mathematical_sum + $signed(b);
        should_branch = mathematical_sum > 64'sd2147483647 ||
                        mathematical_sum < -64'sd2147483648;
        signed_offset = $signed(immediate);
        expected_pc = should_branch ? 32'h3004 + signed_offset * 32'd4 : 32'h3004;
        #2;
        if (dut.IsBAO !== 1'b1 || dut.Req !== 1'b0 || dut.ExcCodeIn !== 0 ||
            dut.WE !== 1'b0 || dut.WE_DM !== 1'b0 || dut.CP0Wr !== 1'b0 ||
            dut.NPC1 !== expected_pc) begin
            $display("FAIL BAO a=%h b=%h offset=%h expected=%h actual=%h exc=%h",
                     a, b, immediate, expected_pc, dut.NPC1, dut.ExcCodeIn);
            $finish;
        end
        tick;
        if (dut.PC1 !== expected_pc || dut.CP0.SR !== 0 ||
            dut.CP0.CAUSE !== 0 || dut.CP0.EPC !== 0) begin
            $display("FAIL BAO changed CP0 or produced the wrong PC");
            $finish;
        end
        for (n = 0; n < 32; n = n + 1)
            if (dut.GRF.GRF[n] !== saved_regs[n]) begin
                $display("FAIL BAO modified register %0d", n);
                $finish;
            end
        checks = checks + 1;
    end
    endtask

    initial begin
        seed = 20261114;
        checks = 0;
        values[0] = 0; values[1] = 1; values[2] = 32'hffffffff;
        values[3] = 32'h7fffffff; values[4] = 32'h80000000;
        values[5] = 32'h40000000; values[6] = 32'hc0000000;
        values[7] = 32'h80000001;
        offsets[0] = 0; offsets[1] = 1; offsets[2] = 2;
        offsets[3] = 16'hffff; offsets[4] = 16'hfffe;
        offsets[5] = 16'h7fff; offsets[6] = 16'h8000;
        #1;
        reset_cpu;
        for (i = 0; i < 8; i = i + 1)
            for (j = 0; j < 8; j = j + 1)
                for (k = 0; k < 7; k = k + 1)
                    check_bao(values[i], values[j], offsets[k]);
        for (i = 0; i < 3000; i = i + 1) begin
            random_a = $random(seed);
            random_b = $random(seed);
            random_offset = $random(seed);
            check_bao(random_a, random_b, random_offset);
        end
        $display("PASS %0d BAO arithmetic/offset cases, no register or CP0 writes", checks);

        // End-to-end program: overflow takes the first BAO; the second falls through.
        reset_cpu;
        dut.IM.ROM[0] = 32'h3c017fff; // 3000: lui $1, 0x7fff
        dut.IM.ROM[1] = 32'h3421ffff; // 3004: ori $1, $1, 0xffff
        dut.IM.ROM[2] = 32'h34020001; // 3008: ori $2, $0, 1
        dut.IM.ROM[3] = {6'b101101, 5'd1, 5'd2, 16'd1}; // 300c -> 3014
        dut.IM.ROM[4] = 32'h340300ee; // 3010: skipped
        dut.IM.ROM[5] = 32'h34030055; // 3014: ori $3, $0, 0x55
        dut.IM.ROM[6] = {6'b101101, 5'd2, 5'd2, 16'd1}; // 3018 -> 301c
        dut.IM.ROM[7] = 32'h34040066; // 301c: ori $4, $0, 0x66
        dut.IM.ROM[8] = 32'hac030000; // 3020: sw $3, 0($0)
        dut.IM.ROM[9] = 32'h8c050000; // 3024: lw $5, 0($0)
        repeat (9) tick;
        if (dut.PC1 !== 32'h3028 || dut.GRF.GRF[3] !== 32'h55 ||
            dut.GRF.GRF[4] !== 32'h66 || dut.GRF.GRF[5] !== 32'h55 ||
            dut.DM.RAM[0] !== 32'h55 || dut.CP0.SR !== 0) begin
            $display("FAIL mixed BAO/base instruction program"); $finish;
        end
        $display("PASS mixed BAO/base instruction program");

        // A negative offset branches backwards to 0x3000.
        reset_cpu;
        dut.IM.ROM[0] = 32'h3c014000; // lui $1, 0x4000
        dut.IM.ROM[1] = {6'b101101, 5'd1, 5'd1, 16'hfffe};
        repeat (2) tick;
        if (dut.PC1 !== 32'h3000 || dut.CP0.SR !== 0) begin
            $display("FAIL backwards BAO"); $finish;
        end
        $display("PASS negative offset / same source register");

        // BAO reads $0 normally and must not branch for 0 + 0.
        reset_cpu;
        dut.IM.ROM[0] = {6'b101101, 5'd0, 5'd0, 16'h8000};
        tick;
        if (dut.PC1 !== 32'h3004 || dut.CP0.SR !== 0) begin
            $display("FAIL BAO with zero registers"); $finish;
        end

        // An invalid branch target faults on the following fetch, not on BAO itself.
        reset_cpu;
        check_bao(32'h7fffffff, 32'd1, 16'hfffe); // target = 0x2ffc
        tick;
        if (dut.PC1 !== 32'h4180 || dut.CP0.EPC !== 32'h2ffc ||
            dut.CP0.CAUSE[6:2] !== 5'd4 || dut.CP0.SR[1] !== 1'b1) begin
            $display("FAIL invalid BAO target fetch exception"); $finish;
        end
        $display("PASS invalid target: EPC is target address, exception is fetch AdEL");

        // Existing exception handling still works for all other opcodes.
        reset_cpu;
        dut.IM.ROM[0] = 32'hfc000000;
        tick;
        if (dut.PC1 !== 32'h4180 || dut.CP0.CAUSE[6:2] !== 5'd10) begin
            $display("FAIL unrelated RI was suppressed"); $finish;
        end
        reset_cpu;
        dut.GRF.GRF[1] = 32'h7fffffff;
        dut.GRF.GRF[2] = 1;
        dut.IM.ROM[0] = 32'h00221820; // add $3, $1, $2
        tick;
        if (dut.PC1 !== 32'h4180 || dut.CP0.CAUSE[6:2] !== 5'd12 ||
            dut.GRF.GRF[3] !== 0) begin
            $display("FAIL ordinary add overflow"); $finish;
        end
        $display("PASS unrelated RI and ordinary add overflow are preserved");
        $display("PASS all BAO demo tests");
        $finish;
    end
endmodule
