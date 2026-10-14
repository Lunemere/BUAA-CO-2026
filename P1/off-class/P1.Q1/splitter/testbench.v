`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:23:55 10/13/2026
// Design Name:   splitter
// Module Name:   C:/study document/CO/Experiment/P1/off-class/P1.Q1/splitter/testbench.v
// Project Name:  splitter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: splitter
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

	// Outputs
	wire [7:0] O1;
	wire [7:0] O2;
	wire [7:0] O3;
	wire [7:0] O4;

	// Instantiate the Unit Under Test (UUT)
	splitter uut (
		.A(A), 
		.O1(O1), 
		.O2(O2), 
		.O3(O3), 
		.O4(O4)
	);

	initial begin
		// Initialize Inputs
		A = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		A = 32'b1100_1010_0101_1111_0000_1001_0101_0110;
		#100;
		A = 32'b1010_0110_1001_1101_0000_1101_0100_1110;

	end
      
endmodule

