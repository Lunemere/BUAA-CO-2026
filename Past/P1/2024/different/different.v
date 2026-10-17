`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:43:09 10/15/2026 
// Design Name: 
// Module Name:    different 
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
module different(
    input [31:0] a,
    input [31:0] b,
    output [5:0] count
    );

	 integer i;
	 
	 reg [5:0] sum;
	 	 
	 always @(*) begin
		 sum = 6'b0;
		 
		 for (i = 0; i < 32; i = i + 1) begin
			 sum = sum + (a[31 - i] ^ b[i]);
		 end
	 end
	 
	 assign count = sum;

endmodule
