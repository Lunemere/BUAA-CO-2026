`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:42:11 10/17/2026
// Design Name:   numberNest
// Module Name:   C:/study document/CO/Experiment/Past/P1/2023/numberNest/testbench.v
// Project Name:  numberNest
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: numberNest
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
	reg rst_n;
	reg [2:0] in;

	// Outputs
	wire check;

	// Instantiate the Unit Under Test (UUT)
	numberNest uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.in(in), 
		.check(check)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst_n = 0;
		#20;
		rst_n = 1;
		
		// input: 1 2 3 3 2 1
		in = 3'd1;
		#20;
		in = 3'd2;
		#20;
		in = 3'd3;
		#20;
		in = 3'd3;
		#20;
		in = 3'd2;
		#20;
		in = 3'd1;
		#20;

		rst_n = 0;
		#20;
		rst_n = 1;
		
		// input: 1 2 3 2 1 3
		in = 3'd1;
		#20;
		in = 3'd2;
		#20;
		in = 3'd3;
		#20;
		in = 3'd2;
		#20;
		in = 3'd1;
		#20;
		in = 3'd3;
		#20;
		
		rst_n = 0;
		#20;
		rst_n = 1;
		
		// input: 1 2 2 2 2 1
		in = 3'd1;
		#20;
		in = 3'd2;
		#20;
		in = 3'd2;
		#20;
		in = 3'd2;
		#20;
		in = 3'd2;
		#20;
		in = 3'd1;
		#20;
		
		rst_n = 0;
		#20;
		rst_n = 1;
		
		// input : 1 3 3 1
		in = 3'd1;
		#20;
		in = 3'd3;
		#20;
		in = 3'd3;
		#20;
		in = 3'd1;
		#20;
		
		rst_n = 0;
		#20;
		rst_n = 1;
		
		// input: 1 2 3 4 5 5 5 5 4 3 2 1
		in = 3'd1;
		#20;
		in = 3'd2;
		#20;
		in = 3'd3;
		#20;
		in = 3'd4;
		#20;
		in = 3'd5;
		#20;
		in = 3'd5;
		#20;
		in = 3'd5;
		#20;
		in = 3'd5;
		#20;
		in = 3'd4;
		#20;
		in = 3'd3;
		#20;
		in = 3'd2;
		#20;
		in = 3'd1;
		#20;

		
	end
	always #10 clk = ~clk;
      
endmodule

