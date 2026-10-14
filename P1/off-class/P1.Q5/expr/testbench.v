`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:50:19 10/13/2026
// Design Name:   expr
// Module Name:   C:/study document/CO/Experiment/P1/off-class/P1.Q5/expr/testbench.v
// Project Name:  expr
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: expr
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
	reg clr;
	reg [7:0] in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	expr uut (
		.clk(clk), 
		.clr(clr), 
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clr = 0;
		in = 0;

		// Wait 100 ns for global reset to finish
		#50;
		clr = 1;
		#50;
		clr = 0;
		in = 8'd42;
		#50;
		in = 8'd48;
		#50;
		in = 8'd43;
		#50;
		clr = 1;
		#50;
		clr = 0;
		in = 8'd51;
		#50;
		in = 8'd43;
		#50
		in = 8'd56;
		#50;
		in = 8'd42;
		#50;
		in = 8'd57;
		#50;
		clr = 1;
		#50;
		clr = 0;
		in = 8'd48;
		#50;
		in = 8'd49;
		#50;
		in = 8'd43;
		#50;
		in = 8'd54;
		#50;
		in = 8'd52;
        
		// Add stimulus here

	end
	always #25 clk = ~clk;
      
endmodule

