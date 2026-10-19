`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:13:52 10/18/2026 
// Design Name: 
// Module Name:    date 
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
module date(
    input clk,
    input reset,
    input [7:0] char,
    output reg ans
    );

    localparam  IDLE = 4'b0000,
                YEAR1 = 4'b0001,
                YEAR2 = 4'b0010,
                YEAR3 = 4'b0011,
                YEAR4 = 4'b0100,
                SEPARATOR1 = 4'b0101,
                MONTH1 = 4'b0110,
                MONTH2 = 4'b0111,
                SEPARATOR2 = 4'b1000,
                DAY1 = 4'b1001,
                DAY2 = 4'b1010,
                DAY3 = 4'b1011,
                DAY4 = 4'b1100,
                OTHER = 4'b1101;
                

    reg [3:0] state;
    reg [3:0] next_state;
    reg [7:0] separator;
    reg [7:0] next_separtor;

    wire is_num = (char <= "9" && char >= "0");
    wire is_separator = (char == "." || char == "-" || char == "/");

    always @(*) begin
        case(state)
            IDLE: begin
                if (char >= "1" && char <= "9") begin
                    next_state = YEAR1;
                end
                else begin
                    next_state = OTHER;
                end
            end
            YEAR1: begin
                if (is_num) begin
                    next_state = YEAR2;
                end
                else begin
                    next_state = OTHER;
                end
            end
            YEAR2: begin
                if (is_num) begin
                    next_state = YEAR3;
                end
                else begin
                    next_state = OTHER;
                end
            end
            YEAR3: begin
                if (is_num) begin
                    next_state = YEAR4;
                end
                else begin
                    next_state = OTHER;
                end
            end
            YEAR4: begin
                if (is_separator) begin
                    next_state = SEPARATOR1;
                    next_separtor = char;
                end
                else begin
                    next_state = OTHER;
                end
            end
            SEPARATOR1: begin
                if (char == "1") begin
                    next_state = MONTH1;
                end
                else if (char >= "2" && char <= "9") begin
                    next_state = MONTH2;
                end
                else begin
                    next_state = OTHER;
                end
            end
            MONTH1: begin
                if (char >= "0" && char <= "2") begin
                    next_state = MONTH2;
                end
                else if (char == separator) begin
                    next_state = SEPARATOR2;
                end
                else begin
                    next_state = OTHER;
                end
            end
            MONTH2: begin
                if (char == separator) begin
                    next_state = SEPARATOR2;
                end
                else begin
                    next_state = OTHER;
                end
            end
            SEPARATOR2: begin
                if (char >= "1" && char <= "2") begin
                    next_state = DAY1;
                end
                else if (char == "3") begin
                    next_state = DAY3;
                end
                else if (char >= "4" && char <= "9") begin
                    next_state = DAY2;
                end
                else begin
                    next_state = OTHER;
                end
            end
            DAY1: begin
                if (is_num) begin
                    next_state = DAY2;
                end
                else begin
                    next_state = OTHER;
                end
            end
            DAY2: begin
                next_state = OTHER;
            end
            DAY3: begin
                if (char == "0") begin
                    next_state = DAY4;
                end
                else begin
                    next_state = OTHER;
                end
            end
            DAY4: begin
                next_state = OTHER;
            end
            OTHER: begin
                next_state = OTHER;
            end
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
            separator <= next_separtor;
        end
    end

    always @(*) begin
        if (state == DAY1 || state == DAY2 || state == DAY3 || state == DAY4) begin
            ans = 1'b1;
        end
        else begin
            ans = 1'b0;
        end
    end

endmodule
