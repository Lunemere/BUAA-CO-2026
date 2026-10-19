`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:57:28 10/18/2026 
// Design Name: 
// Module Name:    username 
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
module username(
    input clk,
    input reset,
    input [7:0] char,
    output reg ans
    );

    localparam  IDLE = 3'b00,
                LETTERS = 3'b001,
                DOT = 3'b010,
                NUMBER = 3'b011,
                OTHER = 3'b100;

    reg [2:0] state;
    reg [2:0] next_state;

    wire is_letter = ((char >= "a" && char <= "z") || (char >= "A" && char <= "Z"));
    wire is_num = (char >= "0" && char <= "9");
    wire is_dot = char == ".";

    always @(*) begin
        case(state)
            IDLE: begin
                if (is_letter) begin
                    next_state = LETTERS;
                end
                else begin
                    next_state = OTHER;
                end
            end
            LETTERS: begin
                if (is_dot) begin
                    next_state = DOT;
                end
                else if (is_letter) begin
                    next_state = LETTERS;
                end
                else begin
                    next_state = OTHER;
                end
            end
            DOT: begin
                if (is_num) begin
                    next_state = NUMBER;
                end
                else if (is_letter) begin
                    next_state = LETTERS;
                end
                else begin
                    next_state = OTHER;
                end
            end
            NUMBER: begin
                if (is_num) begin
                    next_state = NUMBER;
                end
                else if (is_letter) begin
                    next_state = LETTERS;
                end
                else begin
                    next_state = OTHER;
                end
            end
            OTHER: begin
                if (is_letter) begin
                    next_state = LETTERS;
                end
                else begin
                    next_state = OTHER;
                end
            end
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        if (state == NUMBER) begin
            ans = 1'b1;
        end
        else begin
            ans = 1'b0;
        end
    end


endmodule
