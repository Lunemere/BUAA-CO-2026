`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:28:02 10/14/2026 
// Design Name: 
// Module Name:    note_recorder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module note_recorder(
    input clk,
    input reset,
    input [2:0] note_in,
    input [1:0] op,
    input [6:0] query,
    output reg [2:0] note_out,
    output reg [7:0] count
    );
	 
	 reg [2:0] note [0:127];
	 reg [7:0] sum;
	 integer i;
	 
	 initial begin
		 for (i = 0; i < 128; i = i + 1) begin
			 note[i] <= 3'b000;
		 end
		 note_out <= 3'b000;
		 count <= 8'b0000_0000;
		 sum <= 8'b0000_0000;
		 
	 end
	 
	 always @(posedge clk) begin
		 if (reset) begin
			 for (i = 0; i < 128; i = i + 1) begin
				 note[i] <= 3'b000;
			 end
			 note_out <= 3'b000;
			 count <= 8'b0000_0000;
		 end
		 else begin
			 case(op)
				 2'b00: begin
					 for (i = 0; i < 127; i = i + 1) begin
						 note[i] <= note[i + 1];
					 end
					 note[127] <= note_in;
				 end
				 2'b01: begin
					 note_out <= note[query];
				 end
				 2'b11: begin
					 count <= sum;
				 end
				 2'b10: begin
				 end
			 endcase
		 end
	 end
				 
	 always @(*) begin
		 sum = 8'd0;
		 for (i = 0; i < 128; i = i + 1) begin
			 if (note[i] == query[2:0]) begin
				 sum = sum + 1;
			 end
		 end
	 end
				 

endmodule
