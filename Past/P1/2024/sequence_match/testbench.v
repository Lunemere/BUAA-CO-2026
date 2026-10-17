`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:09:22 10/15/2026
// Design Name:   sequence_match
// Module Name:   C:/study document/CO/Experiment/Past/P1/2024/sequence_match/testbench.v
// Project Name:  sequence_match
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sequence_match
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
	reg [7:0] chr;

	// Outputs
	wire [7:0] each;
	wire [7:0] total;

	// Instantiate the Unit Under Test (UUT)
	sequence_match uut (
		.clk(clk), 
		.rst(rst), 
		.chr(chr), 
		.each(each), 
		.total(total)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		chr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 1;
		#20
		rst = 0;

		// {ab:32, b3: 43}
		chr = "{"; #20;
		chr = "a"; #20;
		chr = "b"; #20;
		chr = ":"; #20;
		chr = "3"; #20;
		chr = "2"; #20;
		chr = ","; #20;
		chr = " "; #20;
		chr = "b"; #20;
		chr = "3"; #20;
		chr = ":"; #20;
		chr = " "; #20;
		chr = "4"; #20;
		chr = "3"; #20;
		chr = "}"; #20;
		
		rst = 1;
		#20
		rst = 0;

		// " {  3a: 5, g79wFOn   :9  } "
		chr = " "; #20;
		chr = "{"; #20;
		chr = " "; #20;
		chr = "3"; #20;
		chr = "a"; #20;
		chr = ":"; #20;
		chr = " "; #20;
		chr = "5"; #20;
		chr = ","; #20;
		chr = " "; #20;
		chr = "g"; #20;
		chr = "7"; #20;
		chr = "9"; #20;
		chr = "w"; #20;
		chr = "F"; #20;
		chr = "O"; #20;
		chr = "n"; #20;
		chr = " "; #20;
		chr = ":"; #20;
		chr = "9"; #20;
		chr = " "; #20;
		chr = "}"; #20;
		chr = " "; #20;

		// "{ae9:r, fe8c: 79, fe8c: 79} "
		chr = "{"; #20;
		chr = "a"; #20;
		chr = "e"; #20;
		chr = "9"; #20;
		chr = ":"; #20;
		chr = "r"; #20;
		chr = ","; #20;
		chr = " "; #20;
		chr = "f"; #20;
		chr = "e"; #20;
		chr = "8"; #20;
		chr = "c"; #20;
		chr = ":"; #20;
		chr = " "; #20;
		chr = "7"; #20;
		chr = "9"; #20;
		chr = ","; #20;
		chr = " "; #20;
		chr = "f"; #20;
		chr = "e"; #20;
		chr = "8"; #20;
		chr = "c"; #20;
		chr = ":"; #20;
		chr = " "; #20;
		chr = "7"; #20;
		chr = "9"; #20;
		chr = "}"; #20;
		chr = " "; #20;
		
		rst = 1;
		#20
		rst = 0;
		
		chr = "{"; #20;
		chr = "}"; #20;
		
	end
	always #10 clk = ~clk;
      
endmodule

