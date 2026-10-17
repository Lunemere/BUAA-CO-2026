`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:49:05 10/15/2026
// Design Name:   different
// Module Name:   C:/study document/CO/Experiment/Past/P1/2024/different/testbench.v
// Project Name:  different
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: different
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
	reg [31:0] a;
	reg [31:0] b;

	// Outputs
	wire [5:0] count;

	// Instantiate the Unit Under Test (UUT)
	different uut (
		.a(a), 
		.b(b), 
		.count(count)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		a = 32'b0110_1100_0101_1111_0000_1010_0101_0110;
		b = 32'b0011_1001_0110_0000_1001_0011_1001_1100;
		#100;
		a = 32'hffff_ffff;
		b = 32'h0000_0000;

	end
      
endmodule

