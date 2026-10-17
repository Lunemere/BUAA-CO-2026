`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   08:04:07 10/14/2026
// Design Name:   note_recorder
// Module Name:   C:/study document/CO/Experiment/Past/P1/2025/Note_Recorder/testbench.v
// Project Name:  Note_Recorder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: note_recorder
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
	reg [2:0] note_in;
	reg [1:0] op;
	reg [6:0] query;

	// Outputs
	wire [2:0] note_out;
	wire [7:0] count;

	// Instantiate the Unit Under Test (UUT)
	note_recorder uut (
		.clk(clk), 
		.reset(reset), 
		.note_in(note_in), 
		.op(op), 
		.query(query), 
		.note_out(note_out), 
		.count(count)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		note_in = 0;
		op = 0;
		query = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		#20;
		reset = 0;
		note_in = 3'd1;
		#20;
		note_in = 3'd2;
		#20;
		note_in = 3'd3;
		#20;
		query = 7'd127;
		op = 2'b01;
		#20;
		query = 7'd0;
		op = 2'b11;
		
        
		// Add stimulus here

	end
	
	always #10 clk = ~clk;
      
endmodule

