`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:05:26 10/17/2026
// Design Name:   lemmings
// Module Name:   C:/study document/CO/Experiment/Past/P1/2022/lemmings/testbench.v
// Project Name:  lemmings
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lemmings
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
	reg areset;
	reg bump_left;
	reg bump_right;
	reg ground;
	reg dig;

	// Outputs
	wire walk_left;
	wire walk_right;
	wire aaah;
	wire digging;

	// Instantiate the Unit Under Test (UUT)
	lemmings uut (
		.clk(clk), 
		.areset(areset), 
		.bump_left(bump_left), 
		.bump_right(bump_right), 
		.ground(ground), 
		.dig(dig), 
		.walk_left(walk_left), 
		.walk_right(walk_right), 
		.aaah(aaah), 
		.digging(digging)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		areset = 0;
		bump_left = 0;
		bump_right = 0;
		ground = 1;
		dig = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		areset = 1;
		#20;
		areset = 0;
        
		// Add stimulus here
		bump_left = 1;
		#20;
		bump_right = 1;
		bump_left = 0;
		#20;
		bump_right = 1;
		bump_left = 1;
		#20;
		bump_left = 1;
		#20;
		
		bump_right = 1;
		bump_left = 1;
		areset = 1;
		#20;
		areset = 0;
		
		ground = 0;
		#20;
		dig = 1;
		ground = 1;
		#20;
		dig = 0;
		#20;
		ground = 0;
		#20;
		ground = 0;
		#20;
		ground = 1;
		
		
		areset = 1;
		#20;
		areset = 0;
		
		bump_left = 1;
		bump_right = 1;
		#20;
		dig = 1;
		#20;
		ground = 0;
		#20;
		dig = 0;
		ground = 1;
		#20;
		
		areset = 1;
		bump_left = 0;
		bump_right = 0;
		ground = 1;
		dig = 0;
		#20;
		areset = 0;
		bump_left = 1;
		#20;
		bump_left = 0;
		areset = 1;
		#20;
		areset = 0;
		bump_left = 0;
		bump_right = 0;
		ground = 1;
		dig = 0;
		#20;
		
		
		
		
	end
	
	always #10 clk = ~clk;
      
endmodule

