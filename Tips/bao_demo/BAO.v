`timescale 1ns / 1ps

// BAO only decides whether it owns this instruction and what the next PC is.
module BAO(
    input [31:0] Insn,
    input [31:0] PC,
    input [31:0] RD1,
    input [31:0] RD2,
    output IsBAO,
    output [31:0] NextPC
);
    wire [32:0] sum;
    wire overflow;
    wire [31:0] pc4;
    wire [31:0] offset;

    assign IsBAO = (Insn[31:26] == 6'b101101);
    assign sum = {RD1[31], RD1} + {RD2[31], RD2};
    assign overflow = (sum[32] != sum[31]);
    assign pc4 = PC + 32'd4;
    assign offset = {{14{Insn[15]}}, Insn[15:0], 2'b00};

    // Overflow is a branch condition here, not an arithmetic exception.
    assign NextPC = overflow ? pc4 + offset : pc4;
endmodule
