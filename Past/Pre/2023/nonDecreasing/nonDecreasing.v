`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:30:04 09/27/2026 
// Design Name: 
// Module Name:    nonDecreasing 
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
module nonDecreasing(
    input [15:0] data,
    output reg result
    );

    integer i;
    reg [3:0] temp1;
    reg [3:0] temp2;

    always @(*) begin
        result = 1'b1;
        for (i = 3; i > 0; i = i - 1) begin
            temp1 = data[4*i +: 4];
            temp2 = data[4*(i-1) +: 4];
            result = result & (temp1 <= temp2);
        end
    end


endmodule
