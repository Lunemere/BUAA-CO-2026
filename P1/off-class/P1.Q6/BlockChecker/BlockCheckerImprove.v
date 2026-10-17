`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:05:29 10/13/2026 
// Design Name: 
// Module Name:    BlockChecker 
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
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output reg result
    );

    localparam IDLE = 4'b0000,
            B = 4'b0001,
            BE = 4'b0010,
            BEG = 4'b0011,
            BEGI = 4'b0100,
            BEGIN = 4'b0101,
            E = 4'b0110,
            EN = 4'b0111,
            END = 4'b1000,
            OTHER = 4'b1001;

    reg [3:0] state;
    reg [3:0] next_state;
    reg signed [32:0] cnt;

    wire [7:0] convert = (in <= "z" && in >= "a") ? in - 8'd32 : in;
    wire space = (in == 8'd32);
    reg fail;

    always @(*) begin
        case(state)
            IDLE:   next_state = (convert == "B") ? B : ((convert == "E") ? E : (space ? IDLE : OTHER));
            B:      next_state = (convert == "E") ? BE : (space ? IDLE : OTHER);
            BE:     next_state = (convert == "G") ? BEG : (space ? IDLE : OTHER);
            BEG:    next_state = (convert == "I") ? BEGI : (space ? IDLE : OTHER);
            BEGI:   next_state = (convert == "N") ? BEGIN : (space ? IDLE : OTHER);
            BEGIN:  next_state = space ? IDLE : OTHER;  // space
            E:      next_state = (convert == "N") ? EN : (space ? IDLE : OTHER);
            EN:     next_state = (convert == "D") ? END : (space ? IDLE : OTHER);
            END:    next_state = space ? IDLE : OTHER;  // space
            OTHER:  next_state = space ? IDLE : OTHER;
        endcase
    end

    always @(posedge clk, posedge reset) begin
        if (reset == 1) begin
            status <= IDLE;
            cnt <= 33'b0;
            fail <= 1'b0;
        end
        else begin
            if (status == BEGI && convert == "N") begin
                cnt <= cnt + 1;
            end
            else if (status == BEGIN && convert != 8'd32) begin
                cnt <= cnt - 1;
            end
            else if (status == EN && convert == "D") begin
                cnt <= cnt - 1;
            end
            else if (status == END && convert != 8'd32) begin
                cnt <= cnt + 1;
            end
            else if (status == END && space) begin
                if (cnt < 0) begin
                    fail <= 1'b1;
                end
            end
        end
    end

    always @(*) begin
        result = (cnt == 33'b0 && fail == 1'b0);
    end

endmodule
