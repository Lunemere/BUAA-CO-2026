`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:11 10/14/2026 
// Design Name: 
// Module Name:    json 
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
module json(
    input clk,
    input reset,
    input [7:0] char,
    output reg [7:0] cur_num,
    output reg [7:0] max_num
    );

    // input is always well-formed except for empty strings,
    // so only the quote structure needs tracking
    localparam  OUT = 2'b00,        // outside any string
                QUOTE = 2'b01,      // just read an opening quote
                STR = 2'b10,        // inside a non-empty string
                INVALID = 2'b11;    // empty string seen, wait for '}'

    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] pair_num;

    initial begin
        state = OUT;
        pair_num = 8'd0;
        cur_num = 8'd0;
        max_num = 8'd0;
    end

    always @(*) begin
        case(state)
            OUT: begin
                if (char == 8'h22) begin
                    next_state = QUOTE;
                end
                else begin
                    next_state = OUT;
                end
            end
            QUOTE: begin
                if (char == 8'h22) begin
                    next_state = INVALID;
                end
                else begin
                    next_state = STR;
                end
            end
            STR: begin
                if (char == 8'h22) begin
                    next_state = OUT;
                end
                else begin
                    next_state = STR;
                end
            end
            INVALID: begin
                if (char == "}") begin
                    next_state = OUT;
                end
                else begin
                    next_state = INVALID;
                end
            end
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset == 1) begin
            state <= OUT;
            pair_num <= 8'd0;
            cur_num <= 8'd0;
            max_num <= 8'd0;
        end
        else begin
            state <= next_state;
            if (char == "{") begin
                pair_num <= 8'd0;
            end
            else if (char == ":") begin
                pair_num <= pair_num + 1;
            end
            else if (char == "}") begin
                if (state == INVALID) begin
                    cur_num <= 8'd0;
                end
                else begin
                    cur_num <= pair_num;
                    if (pair_num > max_num) begin
                        max_num <= pair_num;
                    end
                end
            end
        end
    end

endmodule
