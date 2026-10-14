`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:00:19 10/13/2026 
// Design Name: 
// Module Name:    ext 
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
module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output reg [31:0] ext
    );

    always @(*) begin
        case(EOp)
            2'b00: begin
                assign ext = {{16{imm[15]}}, {imm}};
            end
            2'b01: begin
                assign ext = {{16{1'b0}}, {imm}};
            end
            2'b10: begin
                assign ext = {{imm}, {16{1'b0}}};
            end
            2'b11: begin
                assign ext = {{16{imm[15]}}, {imm}} << 2;
            end
        endcase
    end

endmodule
