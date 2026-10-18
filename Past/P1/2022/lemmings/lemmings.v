`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:28:37 10/17/2026 
// Design Name: 
// Module Name:    lemmings 
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
module lemmings(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
    );

    localparam  LEFT = 3'b000,
                RIGHT = 3'b001,
                LEFT_DIG = 3'b010,
                LEFT_DROP = 3'b011,
                RIGHT_DIG = 3'b100,
                RIGHT_DROP = 3'b101;
                

    reg [2:0] state;
    reg [2:0] next_state;

    always @(*) begin
        case(state)
            LEFT: begin
                if (ground == 0) begin
                    next_state = LEFT_DROP;
                end
                else if (ground == 1 && dig == 1) begin
                    next_state = LEFT_DIG;
                end
                else if (bump_left == 1) begin
                    next_state = RIGHT;
                end
                    else begin
                        next_state = LEFT;
                    end
            end
            RIGHT: begin
                if (ground == 0) begin
                    next_state = RIGHT_DROP;
                end
                else if (ground == 1 && dig == 1) begin
                    next_state = RIGHT_DIG;
                end
                else if (bump_right == 1) begin
                    next_state = LEFT;
                end
                    else begin
                        next_state = RIGHT;
                    end
            end
            LEFT_DIG: begin
                if (ground == 1) begin
                    next_state = LEFT_DIG;
                end
                else begin
                    next_state = LEFT_DROP;
                end
            end
            LEFT_DROP: begin
                if (ground == 0) begin
                    next_state = LEFT_DROP;
                end
                else begin
                    next_state = LEFT;
                end
            end
            RIGHT_DIG: begin
                if (ground == 1) begin
                    next_state = RIGHT_DIG;
                end
                else begin
                    next_state = RIGHT_DROP;
                end
            end
            RIGHT_DROP: begin
                if (ground == 0) begin
                    next_state = RIGHT_DROP;
                end
                else begin
                    next_state = RIGHT;
                end
            end
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        if (areset) begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        else if (state == LEFT) begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        else if (state == RIGHT) begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        else if (state == LEFT_DIG || state == RIGHT_DIG) begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        else if (state == LEFT_DROP || state == RIGHT_DROP) begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
    end

endmodule
