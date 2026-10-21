`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:48:01 10/19/2026 
// Design Name: 
// Module Name:    comment_count 
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
module comment_filter(
    input clk,
    input reset,
    input [7:0] char,
    output reg [7:0] count
    );

    localparam  IDLE = 2'b00,
                BACK_SLASH = 2'b01,
                STR = 2'b10,
                STAR = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    wire is_slash = char == "/";
    wire is_star = char == "*";
    wire nothing = (char != "/" && char != "*");

    always @(*) begin
        case(state)
            IDLE: begin
                if (is_slash) begin
                    next_state = BACK_SLASH;
                end
                else begin
                    next_state = IDLE;
                end
            end
            BACK_SLASH: begin
                if (is_star) begin
                    next_state = STR;
                end
                else if (is_slash) begin
                    next_state = BACK_SLASH;
                end
                else begin
                    next_state = IDLE;
                end
            end
            STR: begin
                if (is_star) begin
                    next_state = STAR;
                end
                else begin
                    next_state = STR;
                end
            end
            STAR: begin
                if (is_slash) begin
                    next_state = IDLE;
                end
                else if (is_star) begin
                    next_state = STAR;
                end
                else begin
                    next_state = STR;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            state <= IDLE;
        end
        else begin
            state <= next_state;

            if (state == IDLE) begin
                count <= count + 1;
            end
            else if (state == BACK_SLASH && is_star) begin
                count <= count - 1;
            end
            else if (state == BACK_SLASH && !is_star) begin
                count <= count + 1;
            end
        end
    end


endmodule
