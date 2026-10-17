`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:09:27 10/14/2026
// Design Name:   json
// Module Name:   C:/study document/CO/Experiment/Past/P1/2025/json/testbench.v
// Project Name:  json
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: json
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
	reg [7:0] char;

	// Outputs
	wire [7:0] cur_num;
	wire [7:0] max_num;

	// Instantiate the Unit Under Test (UUT)
	json uut (
		.clk(clk), 
		.reset(reset), 
		.char(char), 
		.cur_num(cur_num), 
		.max_num(max_num)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		char = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		#10;
		reset = 0;

		// {"k":"v"}
		#10; char = "{";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = 8'h22;
		#10; char = "}";
		// space
		#10; char = " ";
		// {"k1":"v1","k2":"v2"}
		#10; char = "{";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = "1";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = "1";
		#10; char = 8'h22;
		#10; char = ",";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = "2";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = "2";
		#10; char = 8'h22;
		#10; char = "}";
		// {}
		#10; char = "{";
		#10; char = "}";
		// {"k1":"v1","k2":"v2"}
		#10; reset = 1;
		#10;
		reset = 0;
		char = "{";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = "1";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = "1";
		#10; char = 8'h22;
		#10; char = ",";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = "2";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = "2";
		#10; char = 8'h22;
		#10; char = "}";
		#10;
		reset = 1;
		// {"key":"value"}
		#10;
		reset = 0;
		char = "{";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = "e";
		#10; char = "y";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = "a";
		#10; char = "l";
		#10; char = "u";
		#10; char = "e";
		#10; char = 8'h22;
		#10; char = "}";
		// space
		#10; char = " ";
		// {"k":"v","k":"v"}
		#10; char = "{";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = 8'h22;
		#10; char = ",";
		#10; char = 8'h22;
		#10; char = "k";
		#10; char = 8'h22;
		#10; char = ":";
		#10; char = 8'h22;
		#10; char = "v";
		#10; char = 8'h22;
		#10; char = "}";
	end
	always #5 clk = ~clk;
      
endmodule

