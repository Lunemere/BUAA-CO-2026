`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:02 11/03/2026 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips(
    input clk,
    input reset
    );
	 
	 // PC
	 wire [31:0] NPC1;
	 wire [31:0] PC1;
	 
	 // NPC
	 wire [15:0] imm16;
	 wire [25:0] imm26;
	 wire [2:0] NPC_Sel;
	 wire [31:0] EPC;
	 wire zero;
	 
	 // Controller
	 wire [5:0] OpCode;
	 wire [5:0] Funct;
	 wire RFWr;
	 wire [5:0] type;
	 wire EXTOp;
	 wire ALUSrc;
	 wire RegDst;
	 wire Reg31;
	 wire IsLoad;
	 wire IsStore;
	 wire MemWr;
	 wire Mem2Reg;
	 wire Addr2Reg;
	 wire CP0Wr;
	 wire Syscall;
	 wire CP02Reg;
	 
	 // IM
	 wire [4:0] rs;
	 wire [4:0] rt;
	 wire [4:0] rd;
	 wire [31:0] Insn;
	 
	 // GRF
	 wire [4:0] RegAddr;
	 wire WE;
	 wire [31:0] WD;
	 wire [31:0] RD1;
	 wire [31:0] RD2;
	 
	 // ALU
	 wire [31:0] result;
	 wire [31:0] operand2;
	 
	 // DM
	 wire [31:0] Data;
	 wire WE_DM;
	 
	 // all
	 wire [31:0] imm32;
	 
	 // CP0
	 wire [4:0] ExcCodeIn;
	 wire [4:0] CP0Addr;
	 wire [31:0] CP0In;
	 wire [31:0] VPC;
	 wire EXLClr;
	 wire Req;
	 wire [31:0] EPCOut;
	 wire [31:0] CP0Out;
	 
	 // ExcUnit
	 wire AdELIM;
	 wire AdELDM;
	 wire AdESDM;
	 wire AdELALU;
	 wire AdESALU;
	 wire Overflow;
	 wire RI;
	 
	 // BAO demo: only this instruction takes the extra PC path.
	 wire IsBAO;
	 wire [31:0] BAONPC;
	 wire [31:0] NormalNPC;

	 BAO BAO (
	     .Insn(Insn),
	     .PC(PC1),
	     .RD1(RD1),
	     .RD2(RD2),
	     .IsBAO(IsBAO),
	     .NextPC(BAONPC)
	 );

	 // Req keeps priority: the existing NPC path already handles exceptions.
	 assign NPC1 = (IsBAO && !Req) ? BAONPC : NormalNPC;

	 // Module
	 PC PC (
    .clk(clk), 
    .reset(reset), 
    .NPC(NPC1), 
    .PC(PC1)
    );
	 
	 NPC NPC (
    .PC(PC1), 
	 .RD(RD1),
    .imm16(imm16), 
    .imm26(imm26), 
    .NPC_Sel(NPC_Sel), 
	 .EPC(EPC),
    .zero(zero), 
    .NPC(NormalNPC) // BAO demo: keep the original next-PC result
    );
	 
	 IM IM (
    .Addr(PC1), 
    .Insn(Insn),
	 .AdELIM(AdELIM)
    );
	 
	 GRF GRF (
    .A1(rs), 
    .A2(rt), 
    .A3(RegAddr), 
    .WD(WD), 
    .clk(clk), 
    .reset(reset), 
    .WE(WE), 
    .RD1(RD1), 
    .RD2(RD2)
    );
	 
	 EXT EXT (
    .imm16(imm16), 
    .EXTOp(EXTOp), 
    .imm32(imm32)
    );
	 
	 DM DM (
    .Addr(result), 
    .WD(RD2), 
    .WE(WE_DM), 
    .clk(clk), 
    .reset(reset), 
    .Data(Data),
	 .AdELDM(AdELDM),
	 .AdESDM(AdESDM)
    );
	
	 Controller Controller (
    .OpCode(OpCode), 
    .Funct(Funct),
	 .Rs(rs),
	 .Req(Req),
    .NPC_Sel(NPC_Sel), 
    .RFWr(RFWr), 
    .type(type), 
    .EXTOp(EXTOp), 
    .ALUSrc(ALUSrc), 
    .RegDst(RegDst),
    .Reg31(Reg31),
    .IsLoad(IsLoad),
    .IsStore(IsStore),
    .Mem2Reg(Mem2Reg), 
    .MemWr(MemWr), 
    .Addr2Reg(Addr2Reg),
	 .CP0Wr(CP0Wr),
	 .EXLClr(EXLClr),
	 .CP02Reg(CP02Reg),
	 .RI(RI),
	 .Syscall(Syscall)
    );
	 
	 ALU ALU (
    .operand1(RD1), 
    .operand2(operand2), 
    .type(type),
    .result(result), 
	 .Overflow(Overflow),
	 .AdELALU(AdELALU),
	 .AdESALU(AdESALU),
    .zero(zero)
    );
	 
	 ExcUnit ExcUnit (
    .AdELIM(AdELIM), 
    .AdELDM(AdELDM), 
    .AdESDM(AdESDM), 
    .AdELALU(AdELALU), 
    .AdESALU(AdESALU), 
    .Overflow(Overflow), 
    .Syscall(Syscall), 
    .RI(RI && !IsBAO), // BAO demo: BAO is now a known instruction 
    .type(type),
    .IsLoad(IsLoad),
    .IsStore(IsStore),
    .ExcCodeIn(ExcCodeIn)
    );
	 
	 CP0 CP0 (
    .clk(clk), 
    .reset(reset), 
    .en(CP0Wr), 
    .CP0Addr(CP0Addr),
    .CP0In(CP0In),
    .VPC(VPC),
    .ExcCodeIn(ExcCodeIn),
    .EXLClr(EXLClr),
    .Req(Req),
    .EPCOut(EPCOut),
    .CP0Out(CP0Out)
    );
	 
	 assign OpCode = Insn[31:26];
	 assign rs = Insn[25:21];
	 assign rt = Insn[20:16];
	 assign rd = Insn[15:11];
	 assign Funct = Insn[5:0];
	 
	 assign RegAddr = (Reg31) ? 5'b11111 : 
							(RegDst) ? rd : rt;
	 assign WD = (CP02Reg) ? CP0Out :
					 (Mem2Reg) ? Data :
					 (Addr2Reg) ? PC1 + 32'h4 : result;
	 assign operand2 = (ALUSrc) ? imm32 : RD2;
	 assign imm16 = Insn[15:0];
	 assign imm26 = Insn[25:0];
	 assign WE = RFWr && ~Req;
	 assign WE_DM = ~Req && MemWr;
	 
	 assign EPC = EPCOut;
	 assign CP0Addr = rd;
	 assign CP0In = RD2;
	 assign VPC = PC1;
					 
	 always @(posedge clk) begin
		 if (reset) begin
		 
		 end
		 else if (WE) begin
			 $display("@%h: $%d <= %h", PC1, RegAddr, WD);
		 end
		 else if (WE_DM) begin
			 $display("@%h: *%h <= %h", PC1, result, RD2);
		 end
	 end

endmodule
