`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:21:55 10/16/2026
// Design Name:   coloring
// Module Name:   C:/study document/CO/Experiment/Past/P1/2023/coloring/testbench.v
// Project Name:  coloring
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: coloring
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
	reg rst_n;
	reg [1:0] color;

	// Outputs
	wire check;

	// Instantiate the Unit Under Test (UUT)
	coloring uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.color(color), 
		.check(check)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		color = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

		rst_n = 0;
		#20;
		rst_n = 1;
		color = 2'b00; // red
		#20;
		color = 2'b01; // green
		#20;
		color = 2'b10; // blue
		#20;
		color = 2'b01;
		#20;
		color = 2'b10;
		#20;
		color = 2'b00;
		#20;
		color = 2'b00;
		#20;
		color = 2'b00;
		#20;
		color = 2'b10;
		
		#20;
		$finish;
		
	end
	
	always #10 clk = ~clk;
      
endmodule

