`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:01:31 10/19/2026
// Design Name:   comment_count
// Module Name:   C:/study document/CO/Experiment/P1/on-class/comment_count/testbench.v
// Project Name:  comment_count
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: comment_count
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
	reg [7:0] char;

	// Outputs
	wire [7:0] count;

	// Instantiate the Unit Under Test (UUT)
	comment_count uut (
		.clk(clk), 
		.reset(reset), 
		.char(char), 
		.count(count)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		char = 0;

		// Wait 100 ns for global reset to finish
		reset = 1;	#20;
		reset = 0;
		char = "a";	#20;
		char = "b";	#20;
		char = "/";	#20;
		char = "*";	#20;
		char = "x";	#20;
		char = "y";	#20;
		char = "*";	#20;
		char = "/";	#20;
		char = "b";	#20;
		char = "b";	#20;
		
		reset = 1;	#20;
		reset = 0;
        
		char = "a";	#20;
		char = "b";	#20;
		char = "/";	#20;
		char = "a";	#20;
		char = "b";	#20;
		
		reset = 1;	#20;
		reset = 0;
		
		char = "/";	#20;
		char = "*";	#20;
		char = "x";	#20;
		char = "*";	#20;
		char = "*";	#20;
		char = "/";	#20;
		char = "y";	#20;
		// Add stimulus here
		$finish;

	end

	always #10 clk = ~clk;
      
endmodule

