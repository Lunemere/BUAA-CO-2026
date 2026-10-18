`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:44:22 10/16/2026 
// Design Name: 
// Module Name:    coloring 
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
module coloring(
    input clk,
    input rst_n,
    input [1:0] color,
    output reg check
    );

    localparam IDLE = 3'b000,
            R1 = 3'b001,
            R2 = 3'b010,
            G1 = 3'b011,
            G2 = 3'b100,
            B1 = 3'b101,
            B2 = 3'b110;

    wire red = (color == 2'b00);
    wire green = (color == 2'b01);
    wire blue = (color == 2'b10);

    reg [2:0] state;
    reg [2:0] next_state;

    always @(*) begin
        case(state)
            IDLE:   next_state = red ? R1 : (green ? G1 : (blue ? B1 : IDLE));
            R1:     next_state = red ? R2 : (green ? R1 : (blue ? B1 : IDLE));
            R2:     next_state = red ? R2 : (green ? R2 : (blue ? B1 : IDLE));
            G1:     next_state = red ? G1 : (green ? G2 : (blue ? B1 : IDLE));
            G2:     next_state = red ? G2 : (green ? G2 : (blue ? B1 : IDLE));
            B1:     next_state = red ? R1 : (green ? G1 : (blue ? B2 : IDLE));
            B2:     next_state = red ? R1 : (green ? G1 : (blue ? B2 : IDLE));
				default:next_state = IDLE;
        endcase
    end

    always @(posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0) begin
            state <= IDLE;
			check <= 0;
        end
        else begin
            state <= next_state;
            if (state == next_state) begin
                check <= 1;
            end
            else begin
                check <= 0;
            end
        end
    end

endmodule
