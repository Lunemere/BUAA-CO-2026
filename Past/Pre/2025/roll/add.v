`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:29:45 09/26/2026 
// Design Name: 
// Module Name:    add 
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
module add(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] out
    );

    reg carry;
    reg [3:0] sum;

    always @(*) begin
        {carry, sum} = a + b;
        out = sum; // only reserve the low 4 bits
    end

endmodule
