`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:38:16 09/27/2026
// Design Name:   nonDecreasing
// Module Name:   C:/study document/CO/Experiment/Past/Pre/2023/nonDecreasing/testbench.v
// Project Name:  nonDecreasing
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: nonDecreasing
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
	reg [15:0] data;

	// Outputs
	wire result;

	// Instantiate the Unit Under Test (UUT)
	nonDecreasing uut (
		.data(data), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		data = 0;

		// Wait 100 ns for global reset to finish
		#100;
		data = 16'h0123;
		#100;
		data = 16'h1123;
		#100;
		data = 16'hFFFF;
		#100;
		data = 16'h3210;
        
		// Add stimulus here

	end
      
endmodule

