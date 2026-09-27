`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:26:44 09/26/2026 
// Design Name: 
// Module Name:    roll 
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
module roll(
    input [31:0] a,
    output [31:0] b
    );

    assign b[3:0] = a[3:0];
    genvar k;

    generate
        for (k = 1; k < 8; k = k + 1) begin: g
            add u_add(
                .a(b[4 * k - 1 : 4 * (k - 1)]),
                .b(a[4 * (k + 1) - 1 : 4 * k]),
                .out(b[4 * (k + 1) - 1 : 4 * k])
            );
            end
    endgenerate

endmodule
