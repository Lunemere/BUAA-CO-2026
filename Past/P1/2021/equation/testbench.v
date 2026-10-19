`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:01:29 10/18/2026
// Design Name:   equation
// Module Name:   C:/study document/CO/Experiment/Past/P1/2021/equation/testbench.v
// Project Name:  equation
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: equation
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
	reg reset;
	reg [7:0] in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	equation uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		#20;
		reset = 0;

		in = 8'h20; #20;	// space
		in = "s"; #20;		// s
		in = "1"; #20;		// 1 output:0
		in = "+"; #20;		// + output:0
		in = "9"; #20;		// 9 output:0
		in = "="; #20;		// = output:0
		in = "9"; #20;		// 9 output:0

		reset = 1;
		#20;
		reset = 0;

		in = "1"; #20;		// 1 output:0
		in = "+"; #20;		// + output:0
		in = "9"; #20;		// 9 output:0
		in = "="; #20;		// = output:0
		in = "9"; #20;		// 9 output:1
		in = 8'h20; #20;	// space output:1
		in = "*"; #20;		// * output:0
		in = "X"; #20;		// x output:1


	end
	always #10 clk = ~clk;
      
endmodule

