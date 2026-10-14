`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:58:07 10/13/2026
// Design Name:   alu
// Module Name:   C:/study document/CO/Experiment/P1/off-class/P1.Q2/alu/testbench.v
// Project Name:  alu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] ALUOp;

	// Outputs
	wire [31:0] C;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.A(A), 
		.B(B), 
		.ALUOp(ALUOp), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		ALUOp = 0;

		// Wait 100 ns for global reset to finish
		#100;
		A = 32'b0000_0000_0101_1111_1000_0010_0100_0110;
		B = 32'b0000_0000_0001_1001_1010_0100_1001_1001;
		ALUOp = 3'b000;
		#100;
		ALUOp = 3'b001;
		#100;
		ALUOp = 3'b010;
		#100;
		ALUOp = 3'b011;
		#100;
		A = 32'b1000_0110_0101_1111_1000_0010_0100_0110;
		B = 32'b0000_0000_0000_0000_0000_0000_0000_1001;
		ALUOp = 3'b100;
		#100;
		ALUOp = 3'b101;
        
		// Add stimulus here

	end
      
endmodule

