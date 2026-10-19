`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:16:31 10/18/2026 
// Design Name: 
// Module Name:    cook 
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
module cook(
    input clk,
    input reset,
    input [7:0] temp,
    input flip,
    output reg [1:0] status,
    output reg need_flip
    );

    localparam  RAW = 3'b000,
                HALF_NEED_FLIP = 3'b001,
                HALF_FLIPPED = 3'b010,
                COOKED = 3'b011,
                LOSE = 3'b100;

    wire minimum = temp < 120;
    wire low = (temp >= 120 && temp < 130);
    wire average = (temp >= 130 && temp < 150);
    wire high = (temp >= 150 && temp < 180);
    wire maximum = temp >= 180;

    reg [2:0] state;
    reg [2:0] next_state;
    reg allow_flip;       // indicate whether the temperature is between 130 and 150

    always @(*) begin
        case(state)
            RAW: begin
                if (flip) begin
                    next_state = LOSE;
                end
                else if (minimum) begin
                    next_state = RAW;
                end
                else if (low) begin
                    next_state = HALF_NEED_FLIP;
                end
                else begin
                    next_state = LOSE;
                end
            end
            HALF_NEED_FLIP: begin
                if (high || maximum) begin
                    next_state = LOSE;
                end
                else if (average && flip) begin
                    next_state = HALF_FLIPPED;
                end
                else if (average && flip == 0) begin
                    next_state = HALF_NEED_FLIP;
                end
                else if ((low || minimum) && flip) begin
                    next_state = LOSE;
                end
                else if ((low || minimum) && flip == 0) begin
                    next_state = HALF_NEED_FLIP;
                end
            end
            HALF_FLIPPED: begin
                if (flip) begin
                    next_state = LOSE;
                end
                else if (temp < 150) begin
                    next_state = HALF_FLIPPED;
                end
                else if (high) begin
                    next_state = COOKED;
                end
                else if (maximum) begin
                    next_state = LOSE;
                end
            end
            COOKED: begin
                if (flip) begin
                    next_state = LOSE;
                end
                else if (maximum) begin
                    next_state = LOSE;
                end
                else begin
                    next_state = COOKED;
                end
            end
            RAW: begin
                next_state = LOSE;
            end
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= RAW;
            allow_flip <= 1'b0;
        end
        else begin
            state <= next_state;
            if (average) begin
                allow_flip <= 1'b1;
            end
            else begin
                allow_flip <= 1'b0;
            end
        end
    end

    always @(*) begin
        if (state == RAW) begin
            status = 2'b00;
        end
        else if (state == HALF_NEED_FLIP || state == HALF_FLIPPED) begin
            status = 2'b01;
        end
        else if (state == COOKED) begin
            status = 2'b10;
        end
        else if (state == LOSE) begin
            status = 2'b11;
        end

        if (state == HALF_NEED_FLIP && allow_flip) begin
            need_flip = 1'b1;
        end
        else begin
            need_flip = 1'b0;
        end
    end

endmodule
