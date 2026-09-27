`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:36:30 09/27/2026
// Design Name:   dotProduct
// Module Name:   C:/study document/CO/Experiment/Past/Pre/dotProduct/testbench.v
// Project Name:  dotProduct
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dotProduct
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
	reg [31:0] vector_a;
	reg [31:0] vector_b;

	// Outputs
	wire [5:0] answer;

	// Instantiate the Unit Under Test (UUT)
	dotProduct uut (
		.vector_a(vector_a), 
		.vector_b(vector_b), 
		.answer(answer)
	);

	initial begin
		// Initialize Inputs
		vector_a = 0;
		vector_b = 0;

		// Wait 100 ns for global reset to finish
		#100;
		vector_a = 32'h11111111;
		vector_b = 32'h11111111;
		#100;
		vector_a = 32'b0110_1100_1001_0010_0101_1010_1111_0000;
		vector_b = 32'b1010_1100_1001_0010_0101_1010_1100_0110;
        
		// Add stimulus here

	end
      
endmodule

