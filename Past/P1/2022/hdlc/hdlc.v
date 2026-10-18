`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:40:21 10/17/2026 
// Design Name: 
// Module Name:    hdlc 
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
module hdlc(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
    );

    localparam  IDLE = 3'b000,
                ONE = 3'b001,
                TWO = 3'b010,
                THREE = 3'b011,
                FOUR = 3'b100,
                FIVE = 3'b101,
                SIX = 3'b110,
                SEVEN = 3'b111;

    reg [2:0] state;
    reg [2:0] next_state;

    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1) begin
                    next_state = ONE;
                end
                else begin
                    next_state = IDLE;
                end
            end
            ONE: begin
                if (in == 1) begin
                    next_state = TWO;
                end
                else begin
                    next_state = IDLE;
                end
            end
            TWO: begin
                if (in == 1) begin
                    next_state = THREE;
                end
                else begin
                    next_state = IDLE;
                end
            end
            THREE: begin
                if (in == 1) begin
                    next_state = FOUR;
                end
                else begin
                    next_state = IDLE;
                end
            end
            FOUR: begin
                if (in == 1) begin
                    next_state = FIVE;
                end
                else begin
                    next_state = IDLE;
                end
            end
            FIVE: begin
                if (in == 1) begin
                    next_state = SIX;
                end
                else begin
                    next_state = IDLE;
                end
            end
            SIX: begin
                if (in == 1) begin
                    next_state = SEVEN;
                end
                else begin
                    next_state = IDLE;
                end
            end
            SEVEN: begin
                if (in == 1) begin
                    next_state = SEVEN;
                end
                else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset == 1) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end
        else begin
				state <= next_state;
            if (state == IDLE) begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
            else if (state == FIVE && in == 0) begin
                disc <= 1;
            end
            else if (state == SIX && in == 0) begin
                flag <= 1;
            end
            else if (state == SIX && in == 1) begin
                err <= 1;
            end
            else if (state == SEVEN && in == 0) begin
                disc <= 0;
                flag <= 0;
                err <= 0;
            end
        end
    end

endmodule
