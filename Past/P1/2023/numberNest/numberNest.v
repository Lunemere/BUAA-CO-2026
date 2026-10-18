`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:15:42 10/17/2026 
// Design Name: 
// Module Name:    numberNest 
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
module numberNest(
    input clk,
    input rst_n,
    input [2:0] in,
    output reg check
    );

	reg [2:0] state; // store the current state
    reg [2:0] next_state; // store the next state

    reg valid; // indicate whether the sequence is valid

    always @(*) begin
        if (in == state + 1) begin
            next_state = state +  1;
            valid = 1'b0;
				
        end
        else if (in == state) begin
            next_state = state - 1;
            valid = 1'b0;
        end
        else begin
            next_state = 3'b0;
            valid = 1'b1;
        end
    end

    always @(posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0) begin
            state <= 3'b0;
            check <= 1'b0;
        end
        else begin
            state <= next_state;
            check <= valid;
        end    
    end

endmodule
