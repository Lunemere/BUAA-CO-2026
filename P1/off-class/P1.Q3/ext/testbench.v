`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:15:23 10/13/2026
// Design Name:   ext
// Module Name:   C:/study document/CO/Experiment/P1/off-class/P1.Q3/ext/testbench.v
// Project Name:  ext
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ext
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
	reg [15:0] imm;
	reg [1:0] EOp;
	wire [31:0] ext;

	// Instantiate the Unit Under Test (UUT)
	ext uut (
		.imm(imm), 
		.EOp(EOp), 
		.ext(ext)
	);

	initial begin
		// Initialize Inputs
		imm = 0;
		EOp = 0;

		// Wait 100 ns for global reset to finish
		#100;
		imm = 16'b1000_0010_1010_1110;
		EOp = 2'b00;
		#100;
		EOp = 2'b01;
		#100;
		EOp = 2'b10;
		#100;
		EOp = 2'b11;
        
		// Add stimulus here

	end
      
endmodule

