`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:43:08 10/13/2026 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output reg [31:0] C
    );

    always @(*) begin
        case(ALUOp)
            3'b000: begin
                assign C = A + B;
            end
            3'b001: begin
                assign C = A - B;
            end
            3'b010: begin
                assign C = A & B;
            end
            3'b011: begin
                assign C = A | B;
            end
            3'b100: begin
                assign C = A >> B;
            end
            3'b101: begin
                assign C = $signed(A) >>> B;
            end
        endcase
    end

endmodule
