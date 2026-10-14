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

    reg [3:0] status;
    reg signed [32:0] cnt;
    reg [0:0] fail;

    initial begin
        status <= IDLE;
        cnt <= 33'b0;
        fail <= 1'b0;
		  result <= 1'b0;
    end

    wire [7:0] convert_upper = (in >= "a" && in <= "z") ? in - 8'd32 : in; // convert the uppercase letters into lowercasse

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            status <= IDLE;
            cnt <= 33'b0;
            fail <= 1'b0;
        end
        else begin
            case(status)
                IDLE: begin
                    if (convert_upper == "B") begin
                        status <= B;
                    end
                    else if (convert_upper == "E") begin
                        status <= E;
                    end
                    else if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
                B: begin
                    if (convert_upper == "E") begin
                        status <= BE;
                    end
                    else if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
                BE: begin
                    if (convert_upper == "G") begin
                        status <= BEG;
                    end
                    else if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
                BEG: begin
                    if (convert_upper == "I") begin
                        status <= BEGI;
                    end
                    else if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
                BEGI: begin
                    if (convert_upper == "N") begin
                        status <= BEGIN;
                        cnt <= cnt + 1;
                    end
                    else if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
                BEGIN: begin
                    if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                        cnt <= cnt - 1;
                    end
                end
                E: begin
                    if (convert_upper == "N") begin
                        status <= EN;
                    end
                    else if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
                EN: begin
                    if (convert_upper == "D") begin
                        status <= END;
                        cnt <= cnt - 1;
                    end
                    else if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
                END: begin
                    if (convert_upper == " ") begin
                        status <= IDLE;
                        if (cnt == -1) begin
                            fail <= 1'b1;
                        end
                    end
                    else begin
                        cnt <= cnt + 1;
                        status <= OTHER;
                    end
                end
                OTHER: begin
                    if (convert_upper == " ") begin
                        status <= IDLE;
                    end
                    else begin
                        status <= OTHER;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        result <= (cnt == 0 && fail == 0) ? 1'b1 : 1'b0;
    end

endmodule
