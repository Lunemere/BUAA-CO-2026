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

    localparam IDLE = 2'b00, // free status
            FIR = 2'b01, // has input the first
            SEC = 2'b10, // second
            THI = 2'b11; // third

    reg match; // represent whether the input is ok to 2024
    reg [3:0] locked_cycle; // indicate the remaining lock-up cycle
    reg [1:0] status; // indicate the status
    reg [1:0] wrong_num; // store the wrong times

    wire gate = (match == 1'b1); // indicate the match situation

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            status <= IDLE;
            match <= 1'b1;
            
        end
        else if (key_valid == 1'b0 || locked) begin

        end
        else if (key_valid == 1'b1) begin
            case (status)
                IDLE: begin
                    if (key == 4'd2 && gate) begin
                        match <= 1'b1;
                    end
                    else begin
                        match <= 1'b0;
                    end
                    status <= FIR;
                end
                FIR: begin
                    if (key == 4'd0 && gate) begin
                        match <= 1'b1;
                    end
                    else begin
                        match <= 1'b0;
                    end
                    status <= SEC;
                end
                SEC: begin
                    if (key == 4'd2 && gate) begin
                        match <= 1'b1;
                    end
                    else begin
                        match <= 1'b0;
                    end
                    status <= THI;
                end
                THI: begin
                    match <= 1'b1;
                    status <= IDLE;
                end
            endcase
        end
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            locked_cycle <= 4'd0;
            open <= 1'b0;
            locked <= 1'b0;
			wrong_num <= 2'b0;
        end
        else if (locked && locked_cycle == 4'd1) begin
            locked_cycle <= locked_cycle - 1;
            locked <= 1'b0;
        end
        else if (locked) begin
            locked_cycle <= locked_cycle - 1;
        end
        else if (key_valid) begin
            if (status == THI && key == 4'd4 && gate) begin
                open <= 1'b1;
                wrong_num <= 2'b0;
            end
            else if (status == THI && wrong_num == 2'b10) begin
                locked_cycle <= 4'd10;
                wrong_num <= 2'b0;
                locked <= 1'b1;
            end
            else if (status == THI) begin
                wrong_num <= wrong_num + 1;
            end
            else if (status == IDLE) begin
                open <= 1'b0;
            end
        end
    end

endmodule
