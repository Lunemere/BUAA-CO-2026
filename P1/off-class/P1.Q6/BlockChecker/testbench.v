`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:25:57 10/13/2026
// Design Name:   BlockChecker
// Module Name:   C:/study document/CO/Experiment/P1/off-class/P1.Q6/BlockChecker/testbench.v
// Project Name:  BlockChecker
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BlockChecker
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
	reg [7:0] in;

	// Outputs
	wire result;

	// Instantiate the Unit Under Test (UUT)
	BlockChecker uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		in = 0;

		// Wait 100 ns for global reset to finish
		#50;
		reset = 1;
		#50;
		reset = 0;
      in = 8'd98;
		#50;
		in = 8'd101;
		#50;
		in = 8'd103;
		#50;
		in = 8'd105;
		#50;
		in = 8'd110;
		#50;
		in = 8'd32;
		#50;
		in = 8'd101;
		#50;
		in = 8'd110;
		#50;
		in = 8'd100;
		#50;
		in = 8'd32;
		#50;
		reset = 1;
		#50;
		reset = 0;
		in = 8'd101; // e
		#50;
		in = 8'd110; // n
		#50;
		in = 8'd68; // D
		#50;
		in = 8'd74; // J
		#50;
		in = 8'd32; // space
		#50
		in = 8'd98; // b
		#50;
		in = 8'd101; // e
		#50;
		in = 8'd103; // g
		#50;
		in = 8'd105; // i
		#50;
		in = 8'd110; // n
		#50;
		in = 8'd32; // space
		#50;
		in = 8'd101; // e
		#50;
		in = 8'd110; // n
		#50;
		in = 8'd100; // d
		#50;
		in = 8'd32; // space
		#50;
		reset = 1;
		#50;
		reset = 0;
		in = 8'd101; // e
		#50;
		in = 8'd110; // n
		#50;
		in = 8'd100; // d
		#50;
		in = 8'd32; // space
		#50
		in = 8'd98; // b
		#50;
		in = 8'd101; // e
		#50;
		in = 8'd103; // g
		#50;
		in = 8'd105; // i
		#50;
		in = 8'd110; // n
		#50;
		in = 8'd32; // space
		#50;
		in = 8'd101; // e
		#50;
		in = 8'd110; // n
		#50;
		in = 8'd100; // d
		#50;
		in = 8'd32; // space
		// Add stimulus here

		// Example 1: Hello world begin comPuTer orGANization End
		#50; reset = 1;
		#50; reset = 0; in = 8'd72; // H

		#50; in = 8'd101; // e
		#50; in = 8'd108; // l
		#50; in = 8'd108; // l
		#50; in = 8'd111; // o
		#50; in = 8'd32; // space
		#50; in = 8'd119; // w
		#50; in = 8'd111; // o
		#50; in = 8'd114; // r
		#50; in = 8'd108; // l
		#50; in = 8'd100; // d
		#50; in = 8'd32; // space
		#50; in = 8'd98; // b
		#50; in = 8'd101; // e
		#50; in = 8'd103; // g
		#50; in = 8'd105; // i
		#50; in = 8'd110; // n
		#50; in = 8'd32; // space
		#50; in = 8'd99; // c
		#50; in = 8'd111; // o
		#50; in = 8'd109; // m
		#50; in = 8'd80; // P
		#50; in = 8'd117; // u
		#50; in = 8'd84; // T
		#50; in = 8'd101; // e
		#50; in = 8'd114; // r
		#50; in = 8'd32; // space
		#50; in = 8'd111; // o
		#50; in = 8'd114; // r
		#50; in = 8'd71; // G
		#50; in = 8'd65; // A
		#50; in = 8'd78; // N
		#50; in = 8'd105; // i
		#50; in = 8'd122; // z
		#50; in = 8'd97; // a
		#50; in = 8'd116; // t
		#50; in = 8'd105; // i
		#50; in = 8'd111; // o
		#50; in = 8'd110; // n
		#50; in = 8'd32; // space
		#50; in = 8'd69; // E
		#50; in = 8'd110; // n
		#50; in = 8'd100; // d
		#50; in = 8'd32; // space

		// Example 2: eND beGin study
		#50; reset = 1;
		#50; reset = 0; in = 8'd101; // e

		#50; in = 8'd78; // N
		#50; in = 8'd68; // D
		#50; in = 8'd32; // space
		#50; in = 8'd98; // b
		#50; in = 8'd101; // e
		#50; in = 8'd71; // G
		#50; in = 8'd105; // i
		#50; in = 8'd110; // n
		#50; in = 8'd32; // space
		#50; in = 8'd115; // s
		#50; in = 8'd116; // t
		#50; in = 8'd117; // u
		#50; in = 8'd100; // d
		#50; in = 8'd121; // y

		// Additional example: begin jifeok begins endx end eejoo end
		#50; reset = 1;
		#50; reset = 0; in = 8'd98; // b
		#50; in = 8'd101; // e
		#50; in = 8'd103; // g
		#50; in = 8'd105; // i
		#50; in = 8'd110; // n
		#50; in = 8'd32; // space
		#50; in = 8'd106; // j
		#50; in = 8'd105; // i
		#50; in = 8'd102; // f
		#50; in = 8'd101; // e
		#50; in = 8'd111; // o
		#50; in = 8'd107; // k
		#50; in = 8'd32; // space
		#50; in = 8'd98; // b
		#50; in = 8'd101; // e
		#50; in = 8'd103; // g
		#50; in = 8'd105; // i
		#50; in = 8'd110; // n
		#50; in = 8'd115; // s
		#50; in = 8'd32; // space
		#50; in = 8'd101; // e
		#50; in = 8'd110; // n
		#50; in = 8'd100; // d
		#50; in = 8'd120; // x
		#50; in = 8'd32; // space
		#50; in = 8'd101; // e
		#50; in = 8'd110; // n
		#50; in = 8'd100; // d
		#50; in = 8'd32; // space
		#50; in = 8'd101; // e
		#50; in = 8'd101; // e
		#50; in = 8'd106; // j
		#50; in = 8'd111; // o
		#50; in = 8'd111; // o
		#50; in = 8'd32; // space
		#50; in = 8'd101; // e
		#50; in = 8'd110; // n
		#50; in = 8'd100; // d

	end
	
	always #25 clk = ~clk;
      
endmodule

