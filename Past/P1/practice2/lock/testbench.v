`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:01:35 10/16/2026
// Design Name:   lock
// Module Name:   C:/study document/CO/Experiment/Past/P1/practice2/lock/testbench.v
// Project Name:  lock
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lock
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
	reg rst;
	reg key_valid;
	reg [3:0] key;

	// Outputs
	wire open;
	wire locked;

	// Instantiate the Unit Under Test (UUT)
	lock uut (
		.clk(clk), 
		.rst(rst), 
		.key_valid(key_valid), 
		.key(key), 
		.open(open), 
		.locked(locked)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		key_valid = 1;
		key = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		rst = 1;
		#20;
		rst = 0;
		// input as 2 0 2 4 5
		key = 4'd2;
		#20;
		key = 4'd0;
		#20;
		key = 4'd2;
		#20;
		key = 4'd4;
		#20;
		
		key = 4'd5;
		#20;
        
		
		// Add stimulus here
		
		rst = 1;
		#20;
		rst = 0;
		
		// input as 12 * 1
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		key = 4'd1;
		#20;
		
		key = 4'd2;
		#20;
		key = 4'd0;
		#20;
		key = 4'd2;
		#20;
		key = 4'd4;
		#20;
	end
	always #10 clk = ~clk;
      
endmodule

