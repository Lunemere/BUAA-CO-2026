`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:50:47 10/18/2026
// Design Name:   cook
// Module Name:   C:/study document/CO/Experiment/Past/P1/2020/cook/testbench.v
// Project Name:  cook
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cook
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
	reg [7:0] temp;
	reg flip;

	// Outputs
	wire [1:0] status;
	wire need_flip;

	// Instantiate the Unit Under Test (UUT)
	cook uut (
		.clk(clk), 
		.reset(reset), 
		.temp(temp), 
		.flip(flip), 
		.status(status), 
		.need_flip(need_flip)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		temp = 0;
		flip = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;	#20;
		reset = 0;
		flip = 1;	#20;	// LOSE

		reset = 1;	#20;
		reset = 0;
		flip = 0;
		temp = 110;	#20;	// RAW
		temp = 125;	#20;	// HALF_NEED_FLIP
		flip = 1;
		temp = 135;	#20;	// HALF_FLIPPED
		flip = 0;	#20;	// HALF_FLIPPED
		temp = 165;	#20;	// COOKED
		temp = 125;	#20;	// COOKED
		flip = 1;	#20;	// LOSE

		reset = 1;	#20;
		reset = 0;
		$finish;
	end
    
	always #10 clk = ~clk;
endmodule

