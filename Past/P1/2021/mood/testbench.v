`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:26:38 10/18/2026
// Design Name:   mood
// Module Name:   C:/study document/CO/Experiment/Past/P1/2021/mood/testbench.v
// Project Name:  mood
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mood
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
	reg [1:0] sign;
	
	// Outputs
	wire [2:0] status;

	// Instantiate the Unit Under Test (UUT)
	mood uut (
		.clk(clk), 
		.reset(reset), 
		.sign(sign), 
		.status(status)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		sign = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		#20;
		reset = 0;
		
		sign = 2'b00;	// alarm
		#20;	
		
		#20;
		
		#20;
		sign = 2'b10;
		#20;			// SAD1
		
		#20;			// SAD2
		
		#20;			// CLUELESS
		sign = 2'b01;
		#20;			// BUSY1
		
		#20;			// BUSY2
		
		#20;			// BUSY3
		
		#20;			// ASLEEP
		sign = 2'b00;	// alarm
		#20;			// BUSY1
		sign = 2'b11;
		#20;				// HAPPY
		sign = 2'b01;
		#20;
		sign = 2'b00;
		#20;
		sign = 2'b10;
		#20;
		
		reset = 1;
		#20;
		reset = 0;
		
		sign = 2'b00;	// alarm
		#20;				// BUSY1
		sign = 2'b10;	// fail
		#20;				// SAD1
		
		#20;				// SAD2
		
		#20;				// CLUELESS1
	
		#20;				// CLUELESS2
		
		#20;				// CLUELESS3
		
		#20;				// ASLEEP
	
	end
	
	always #10 clk = ~clk;
      
endmodule

