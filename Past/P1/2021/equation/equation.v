`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:49:02 10/18/2026 
// Design Name: 
// Module Name:    equation 
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
module equation(
    input clk,
    input reset,
    input [7:0] in,
    output reg out
    );

    localparam  IDLE = 3'b000,
                FORE_OPERAND = 3'b001,
                FORE_OPERATOR = 3'b010,
                EQUAL = 3'b011,
                BACK_OPERAND = 3'b100,
                BACK_OPERATOR = 3'b101,
                OTHER = 3'b110;

    reg [2:0] state;
    reg [2:0] next_state;

    wire is_operator = (in == "*" || in == "/" || in == "+" || in == "-");
    wire is_operand = ((in >= "0" && in <= "9") || (in <= "z" && in >= "a") || (in <= "Z" && in >= "A"));
    wire is_space = (in == 8'h20);
    wire is_equal = (in == "=");

    always @(*) begin
        case(state)
            IDLE: begin
                if (is_space) begin
                    next_state = IDLE;
                end
                else if (is_operand) begin
                    next_state = FORE_OPERAND;
                end
                else begin
                    next_state = OTHER;
                end
            end
            FORE_OPERAND: begin
                if (is_space) begin
                    next_state = FORE_OPERAND;
                end
                else if (is_operator) begin
                    next_state = FORE_OPERATOR;
                end
                else if (is_equal) begin
                    next_state = EQUAL;
                end
                else begin
                    next_state = OTHER;
                end
            end
            FORE_OPERATOR: begin
                if (is_operand) begin
                    next_state = FORE_OPERAND;
                end
                else if (is_space) begin
                    next_state = FORE_OPERATOR;
                end
                else begin
                    next_state = OTHER;
                end
            end
            EQUAL: begin
                if (is_space) begin
                    next_state = EQUAL;
                end
                else if (is_operand) begin
                    next_state = BACK_OPERAND;
                end
                else begin
                    next_state = OTHER;
                end
            end
            BACK_OPERAND: begin
                if (is_space) begin
                    next_state = BACK_OPERAND;
                end
                else if (is_operator) begin
                    next_state = BACK_OPERATOR;
                end
                else begin
                    next_state = OTHER;
                end
            end
            BACK_OPERATOR: begin
                if (is_space) begin
                    next_state = BACK_OPERATOR;
                end
                else if (is_operand) begin
                    next_state = BACK_OPERAND;
                end
                else begin
                    next_state = OTHER;
                end
            end
            OTHER: begin
                next_state = OTHER;
            end
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset == 1) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end

    end

    always @(*) begin
        if (state == BACK_OPERAND) begin
            out = 1'b1;
        end
        else begin
            out = 1'b0;
        end
    end

endmodule
