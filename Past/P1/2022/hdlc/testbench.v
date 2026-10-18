`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:53:31 10/17/2026
// Design Name:   hdlc
// Module Name:   C:/study document/CO/Experiment/Past/P1/2022/hdlc/testbench.v
// Project Name:  hdlc
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: hdlc
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
	wire disc;
	wire flag;
	wire err;

	// Instantiate the Unit Under Test (UUT)
	hdlc uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.disc(disc), 
		.flag(flag), 
		.err(err)
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
		
		// input: 1 1 1 1 1 0
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 0;
		#20;
		
		reset = 1;
		#20;
		reset = 0;

		// input: 1 1 1 1 1 1 0
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 0;
		#20;
		
		reset = 1;
		#20;
		reset = 0;

		// input: 1 1 1 1 1 1 1 0
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 0;
		#20;
		
		reset = 1;
		#20;
		reset = 0;

		// input: 1 1 1 1 1 1 1 1
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
		in = 1;
		#20;
	end
	always #10 clk = ~clk;
      
endmodule

