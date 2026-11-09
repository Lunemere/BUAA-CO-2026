`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:45:57 11/02/2026 
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
    // PC and NPC
    wire [31:0] grf;
    wire [31:0] pc;
    wire [31:0] newpc;

    // IM
    wire [31:0] Instr;
    wire [5:0] OpCode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [5:0] Funct;
    wire [15:0] imm16;
    wire [25:0] imm26;

    // Controller
    wire [2:0] npc_sel;
    wire RegWrite;
    wire EXTop;
    wire ALUSrc;
    wire RegDst;
    wire MemWrite;
    wire MemtoReg;
    wire PCtoReg;
    wire Regra;
    wire [5:0] type;

    // GRF
    wire [4:0] A1;
    wire [4:0] A2;
    wire [4:0] A3;
    wire [31:0] WD_Reg;
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] RD3;

    // EXT
    wire [31:0] ext32;

    // ALU
    wire [31:0] inputA;
    wire [31:0] inputB;
    wire [31:0] res;
    wire b_jump;

    // DM
    wire [31:0] addr;
    wire [31:0] WD_Mem;
    wire [31:0] Mem;

    // PC and NPC
	 assign grf = RD1;

    // IM
	 IM IM (.addr(pc), .data(Instr));
	 
	 assign OpCode = Instr[31:26];
    assign rs = Instr[25:21];
    assign rt = Instr[20:16];
    assign rd = Instr[15:11];
    assign shamt = Instr[10:6];
    assign Funct = Instr[5:0];
    assign imm16 = Instr[15:0];
    assign imm26 = Instr[25:0];
	 
	 // new instr
	reg [31:0] tAddr;
	reg [31:0] tWD_Mem;
 	 wire new;
	 assign new = ((OpCode == 6'b111110) )? 1:0;
		
	integer i; 
	reg [31:0] tmp; reg [31:0] mask; reg [7:0] membyte; reg [7:0] maskbyte; 
	wire [4:0] start; wire [4:0] term;
	assign start = imm16[15:11]; assign term = RD1[31:27];
	 always @(*) begin
			if(new && !reset)begin
				tAddr = RD1 + {{16{imm16[15]}}, imm16};
				tmp = (RD2 << RD1[4:0])|(RD2 >> (32 - RD1[4:0]));
				if(term >= start)begin
					for(i=0;i<32;i=i+1)begin
						mask[i] = ((i>=start)&&(i<term))? 1:0;
					end
				end
				else begin
					for(i=0;i<32;i=i+1)begin
						mask[i] = ((i>=term)&&(i<start))? 0:1;
					end					
				end
				membyte = tmp >> (8*tAddr[1:0]); maskbyte = mask >> (8*tAddr[1:0]);
				membyte = maskbyte & membyte;
				case(tAddr[1:0])
					0:tWD_Mem = {Mem[31:8], membyte};					
					1:tWD_Mem = {Mem[31:16], membyte, Mem[7:0]};
					2:tWD_Mem = {Mem[31:24], membyte, Mem[15:0]};					
					3:tWD_Mem = {membyte, Mem[23:0]};
				endcase
			end

		end

	 
	
    // Controller
	 
	  Controller Controller (.OpCode(OpCode), .Funct(Funct), .RegDst(RegDst),
								.ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
								.MemWrite(MemWrite), .npc_sel(npc_sel), .EXTop(EXTop),
								.PCtoReg(PCtoReg), .Regra(Regra), .type(type));

    
    // GRF

	 
	 assign A1 = rs;
    assign A2 = rt;
    assign A3 = (Regra) ? 5'b11111 :
                (RegDst) ? rd : rt;
    assign WD_Reg = (PCtoReg) ? newpc :
                    (MemtoReg) ? Mem : res;
	 
	     GRF GRF (.clk(clk), .reset(reset), .WE(RegWrite), .A1(A1), .A2(A2),
             .A3(A3),.PC(pc), .WD(WD_Reg), .RD1(RD1), .RD2(RD2), .RD3(RD3));
    
    // EXT
	 
	 EXT EXT (.imm16(imm16), .EXTop(EXTop), .ext32(ext32));
    
    // ALU
	 
	 assign inputA = RD1;
    assign inputB = (ALUSrc) ? ext32 : RD2;
	 
    ALU ALU (.inputA(inputA), .inputB(inputB), .type(type), .res(res),
             .b_jump(b_jump));	 
    
    // DM
	 
    assign addr = res;
    assign WD_Mem = RD2;    

    DM DM (.clk(clk), .reset(reset), .WE(new? 1:MemWrite), .addr(new? tAddr:addr), .WD(new? tWD_Mem:WD_Mem),.PC(pc),
           .data(Mem));

    PC_NPC PC_NPC (.clk(clk), .reset(reset),.pc(pc), .newpc(newpc),.npc_sel(npc_sel), .b_jump(b_jump), .imm16(imm16),
             .imm26(imm26), .GRF(grf));



endmodule
