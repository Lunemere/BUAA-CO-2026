`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:51:49 10/15/2026
// Design Name:   alternate
// Module Name:   C:/study document/CO/Experiment/Past/P1/2024/alternate/testbench.v
// Project Name:  alternate
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alternate
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
	reg clk;
	reg res_n;
	reg number;

	// Outputs
	wire check;

	// Instantiate the Unit Under Test (UUT)
	alternate uut (
		.clk(clk), 
		.res_n(res_n), 
		.number(number), 
		.check(check)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		res_n = 1;
		number = 0;

		// Wait 100 ns for global reset to finish
		
		// Add stimulus here
		
		#100;
		res_n = 0;
		#20;
		res_n = 1;
		number = 0;
		#20;
		number = 0;
		#20;
		number = 0;
		#20;
		number = 0;
		#20;
		number = 1;
		#20;
		number = 1;
		#20;
		number = 1;
		#20;
		number = 1;
		#20;
		
		res_n = 0;
		#20;
		res_n = 1;
		number = 0;
		#20;
		number = 0;
		#20;
		number = 1;
		#20;
		number = 0;
		#20;
		number = 0;
		#20;
		
		res_n = 0;
		#20;
		res_n = 1;
		number = 0;
		#20;
		number = 1;
		#20;
		number = 0;
		#20;
		number = 0;
		#20;
		number = 1;
		#20;
		
      $finish;

	end
	
	always #10 clk = ~clk;
      
endmodule

