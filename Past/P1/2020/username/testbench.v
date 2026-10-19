`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:09:26 10/18/2026
// Design Name:   username
// Module Name:   C:/study document/CO/Experiment/Past/P1/2020/username/testbench.v
// Project Name:  username
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: username
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
	wire ans;

	// Instantiate the Unit Under Test (UUT)
	username uut (
		.clk(clk), 
		.reset(reset), 
		.char(char), 
		.ans(ans)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		char = 0;

		// Wait 100 ns for global reset to finish
		#20;
		
		reset = 1;	#20;
		reset = 0;
        
		// Add stimulus here

		// a.2
		char = "a";	#20;
		char = ".";	#20;
		char = "2";	#20;
		
		reset = 1;	#20;
		reset = 0;

		// 1a.2b.3
		char = "1";	#20;
		char = "a";	#20;
		char = ".";	#20;
		char = "2";	#20;
		char = "b";	#20;
		char = ".";	#20;
		char = "3";	#20;
		
		
		$finish;

	end
	always #10 clk = ~clk;
      
endmodule

