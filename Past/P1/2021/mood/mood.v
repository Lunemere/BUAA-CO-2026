`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:16:14 10/18/2026 
// Design Name: 
// Module Name:    mood 
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
module mood(
    input clk,
    input reset,
    input [1:0] sign,
    output reg [2:0] status
    );

    localparam  ASLEEP = 4'b0000,
                BUSY1 = 4'b0001,
                BUSY2 = 4'b0010,
                BUSY3 = 4'b0011,
                SAD1 = 4'b0100,
                SAD2 = 4'b0101,
                CLUELESS1 = 4'b0110,
                CLUELESS2 = 4'b0111,
                CLUELESS3 = 4'b1000,
                HAPPY = 4'b1001;

    localparam  ALARM = 2'b00,
                IDEA = 2'b01,
                FAIL = 2'b10,
                SUCCESS = 2'b11;

    reg [3:0] state;
    reg [3:0] next_state;

    always @(*) begin
        case(state)
            ASLEEP: begin
                if (sign == ALARM) begin
                    next_state = BUSY1;
                end
                else begin
                    next_state = ASLEEP;
                end
            end
            BUSY1: begin
                if (sign == FAIL) begin
                    next_state = SAD1;
                end
                else if (sign == SUCCESS) begin
                    next_state = HAPPY;
                end
                else begin
                    next_state = BUSY2;
                end
            end
            BUSY2: begin
                if (sign == FAIL) begin
                    next_state = SAD1;
                end
                else if (sign == SUCCESS) begin
                    next_state = HAPPY;
                end
                else begin
                    next_state = BUSY3;
                end
            end
            BUSY3: begin
                if (sign == FAIL) begin
                    next_state = SAD1;
                end
                else if (sign == SUCCESS) begin
                    next_state = HAPPY;
                end
                else begin
                next_state = ASLEEP;
                end
            end
            SAD1: begin
                next_state = SAD2;
            end
            SAD2: begin
                next_state = CLUELESS1;
            end
            CLUELESS1: begin
                if (sign == IDEA) begin
                    next_state = BUSY1;
                end
                else begin
                    next_state = CLUELESS2;
                end
            end
            CLUELESS2: begin
                if (sign == IDEA) begin
                    next_state = BUSY1;
                end
                else begin
                    next_state = CLUELESS3;
                end
            end
            CLUELESS3: begin
                if (sign == IDEA) begin
                    next_state = BUSY1;
                end
                else begin
                next_state = ASLEEP;
                end
            end
            HAPPY: begin
                next_state = HAPPY;
            end
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset == 1) begin
            state <= ASLEEP;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        if (state == ASLEEP) begin
            status = 3'b000;
        end
        else if (state == BUSY1 || state == BUSY2 || state == BUSY3) begin
            status = 3'b001;
        end
        else if (state == SAD1 || state == SAD2) begin
            status = 3'b010;
        end
        else if (state == CLUELESS1 || state == CLUELESS2 || state == CLUELESS3) begin
            status = 3'b011;
        end
        else if (state == HAPPY) begin
            status = 3'b100;
        end
    end

endmodule
