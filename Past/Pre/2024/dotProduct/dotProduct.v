`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:19:03 09/27/2026 
// Design Name: 
// Module Name:    dotProduct 
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
module dotProduct(
    input [31:0] vector_a,
    input [31:0] vector_b,
    output reg [5:0] answer
    );

    integer i;

    always @(*) begin
        answer = 6'b0;  // refresh the initial value
        for (i = 0; i < 32; i = i + 1) begin
            answer = answer + vector_a[i] * vector_b[i];
        end
    end

endmodule
