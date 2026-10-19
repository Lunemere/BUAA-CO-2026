`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:41:49 10/18/2026
// Design Name:   date
// Module Name:   C:/study document/CO/Experiment/Past/P1/2020/date/testbench.v
// Project Name:  date
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: date
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
	date uut (
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
        
		// Add stimulus here
		reset = 1;	#20;
		reset = 0;
		
		// 1586/7/7 
		char = "1";	#20;
		char = "5";	#20;
		char = "8";	#20;
		char = "6";	#20;
		char = "/";	#20;
		char = "7";	#20;
		char = "/";	#20;
		char = "7";	#20;
		
		reset = 1;	#20;
		reset = 0;
		
		// 0456/7/7
		char = "0";	#20;
		char = "4";	#20;
		char = "5";	#20;
		char = "6";	#20;
		char = "/";	#20;
		char = "7";	#20;
		char = "/";	#20;
		char = "7";	#20;
		
		reset = 1;	#20;
		reset = 0;
		
		// 1234/01/5
		char = "1";	#20;
		char = "2";	#20;
		char = "3";	#20;
		char = "4";	#20;
		char = "/";	#20;
		char = "0";	#20;
		char = "1";	#20;
		char = "/";	#20;
		char = "5";	#20;
		
		reset = 1;	#20;
		reset = 0;
		
		// 9564/2/05
		char = "9";	#20;
		char = "5";	#20;
		char = "6";	#20;
		char = "4";	#20;
		char = "/";	#20;
		char = "2";	#20;
		char = "/";	#20;
		char = "0";	#20;
		char = "5";	#20;
		
		reset = 1;	#20;
		reset = 0;
		
		// 4627/11-9
		char = "4";	#20;
		char = "6";	#20;
		char = "2";	#20;
		char = "7";	#20;
		char = "/";	#20;
		char = "1";	#20;
		char = "1";	#20;
		char = "-";	#20;
		char = "9";	#20;
		
		reset = 1;	#20;
		reset = 0;
		
		// 2025.7.30
		char = "2";	#20;
		char = "0";	#20;
		char = "2";	#20;
		char = "5";	#20;
		char = ".";	#20;
		char = "7";	#20;
		char = ".";	#20;
		char = "3";	#20;
		char = "0";	#20;
		
		reset = 1;	#20;
		reset = 0;
		
		$finish;
	end
	always #10 clk = ~clk;
      
endmodule

