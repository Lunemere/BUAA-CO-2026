`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:09:56 10/14/2026
// Design Name:   CNNX
// Module Name:   C:/study document/CO/Experiment/Past/P1/2025/CNNX/testbench.v
// Project Name:  CNNX
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CNNX
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
	reg [35:0] a;
	reg [8:0] b;

	// Outputs
	wire [15:0] ans;

	// Instantiate the Unit Under Test (UUT)
	CNNX uut (
		.a(a), 
		.b(b), 
		.ans(ans)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
		a = 36'hfffffffff;
		b = 9'h000;
		#100;
		a = 36'h3a9f01be7;
		b = 9'h191;
		
        
		// Add stimulus here

	end
      
endmodule

