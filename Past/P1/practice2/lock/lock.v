`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:21:34 10/16/2026 
// Design Name: 
// Module Name:    lock 
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
module lock(
    input clk,
    input rst,
    input key_valid,
    input [3:0] key,
    output reg open,
    output reg locked
    );

    localparam  IDLE = 4'b0000, // no digit entered
                RIGHT1 = 4'b0001, // "2" entered
                RIGHT2 = 4'b0010, // "20" entered
                RIGHT3 = 4'b0011, // "202" entered
                WRONG1 = 4'b0100, // 1 digit entered, already wrong
                WRONG2 = 4'b0101, // 2 digits entered, already wrong
                WRONG3 = 4'b0110, // 3 digits entered, already wrong
                OPEN = 4'b0111, // like IDLE, but the lock is open
                LOCK = 4'b1000; // locked up

    reg [3:0] state;
    reg [3:0] next_state;
    reg [1:0] wrong_num; // failed attempts
    reg [3:0] lock_cnt; // edges already spent in LOCK

    always @(*) begin
        case(state)
            IDLE, OPEN: begin
                if (key_valid == 0) begin
                    next_state = state;
                end
                else if (key == 4'd2) begin
                    next_state = RIGHT1;
                end
                else begin
                    next_state = WRONG1;
                end
            end
            RIGHT1: begin
                if (key_valid == 0) begin
                    next_state = RIGHT1;
                end
                else if (key == 4'd0) begin
                    next_state = RIGHT2;
                end
                else begin
                    next_state = WRONG2;
                end
            end
            RIGHT2: begin
                if (key_valid == 0) begin
                    next_state = RIGHT2;
                end
                else if (key == 4'd2) begin
                    next_state = RIGHT3;
                end
                else begin
                    next_state = WRONG3;
                end
            end
            RIGHT3: begin
                if (key_valid == 0) begin
                    next_state = RIGHT3;
                end
                else if (key == 4'd4) begin
                    next_state = OPEN;
                end
                else if (wrong_num == 2'd2) begin
                    next_state = LOCK;
                end
                else begin
                    next_state = IDLE;
                end
            end
            WRONG1: begin
                if (key_valid == 0) begin
                    next_state = WRONG1;
                end
                else begin
                    next_state = WRONG2;
                end
            end
            WRONG2: begin
                if (key_valid == 0) begin
                    next_state = WRONG2;
                end
                else begin
                    next_state = WRONG3;
                end
            end
            WRONG3: begin
                if (key_valid == 0) begin
                    next_state = WRONG3;
                end
                else if (wrong_num == 2'd2) begin
                    next_state = LOCK;
                end
                else begin
                    next_state = IDLE;
                end
            end
            LOCK: begin
                if (lock_cnt == 4'd9) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = LOCK;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst == 1) begin
            state <= IDLE;
            wrong_num <= 2'd0;
            lock_cnt <= 4'd0;
        end
        else begin
            state <= next_state;

            // failed attempts: cleared on success or when entering LOCK
            if (next_state == OPEN || next_state == LOCK) begin
                wrong_num <= 2'd0;
            end
            else if ((state == RIGHT3 || state == WRONG3) && key_valid == 1) begin
                wrong_num <= wrong_num + 1;
            end

            // edges spent in LOCK
            if (state == LOCK) begin
                lock_cnt <= lock_cnt + 1;
            end
            else begin
                lock_cnt <= 4'd0;
            end
        end
    end

    always @(*) begin
        if (state == OPEN) begin
            open = 1'b1;
            locked = 1'b0;
        end
        else if (state == LOCK) begin
            open = 1'b0;
            locked = 1'b1;
        end
        else begin
            open = 1'b0;
            locked = 1'b0;
        end
    end

endmodule
