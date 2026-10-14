`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:07:24 10/13/2026
// Design Name:   gray
// Module Name:   C:/study document/CO/Experiment/P1/off-class/P1.Q4/P1.Q4/testbench.v
// Project Name:  P1.Q4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: gray
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
	reg Clk;
	reg Reset;
	reg En;

	// Outputs
	wire [2:0] Output;
	wire Overflow;

	// Instantiate the Unit Under Test (UUT)
	gray uut (
		.Clk(Clk), 
		.Reset(Reset), 
		.En(En), 
		.Output(Output), 
		.Overflow(Overflow)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		Reset = 0;
		En = 0;

		// Wait 100 ns for global reset to finish
		#75;
		En = 1;
		#1000;
		Reset = 1;
		#100;
		Reset = 0;
		#200;
		En = 0;
        
		// Add stimulus here

	end
	always #50 Clk = ~Clk;
      
endmodule

