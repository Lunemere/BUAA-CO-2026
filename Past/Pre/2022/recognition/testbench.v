`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:22:04 09/27/2026
// Design Name:   recognition
// Module Name:   C:/study document/CO/Experiment/Past/Pre/2022/recognition/testbench.v
// Project Name:  recognition
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: recognition
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
	reg in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	recognition uut (
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
		#25;
		in = 1;
		#100;
		in = 0;
		#100;
		in = 1;
		#100;
		reset = 1;
		#100;
		reset = 0;
		in = 1;
		#100;
		in = 0;
		#100;
		in = 1;
        
		// Add stimulus here

	end
	
	always #50 clk = ~clk;
      
endmodule

