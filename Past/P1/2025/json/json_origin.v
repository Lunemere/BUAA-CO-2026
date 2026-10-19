`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:34:11 10/14/2026
// Design Name:
// Module Name:    json
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
module json(
    input clk,
    input reset,
    input [7:0] char,
    output reg [7:0] cur_num,
    output reg [7:0] max_num
    );

         localparam IDLE = 4'b0000,
                                INPUT_FORE_BRACKET = 4'b0001,
                                KEY_FORE_QUOTE = 4'b0010,
                                KEY_MIDDLE_CHARACTER = 4'b0011,
                                KEY_BACK_QUOTE = 4'b0100,
                                INPUT_COLON = 4'b0101,
                                INPUT_COMMA = 4'b0110,
                                VALUE_FORE_QUOTE = 4'b0111,
                                VALUE_MIDDLE_CHARACTER = 4'b1000,
                                VALUE_BACK_QUOTE = 4'b1001,
                                OTHER = 4'b1010,
                                INPUT_BACK_BRACKET = 4'b1011;

         reg valid;
         reg [7:0] pair_num;
         reg [3:0] status;

         initial begin
                 cur_num = 8'b0;
                 max_num = 8'b0;
                 valid = 1'b0;
                 pair_num = 8'b0;
                 status = IDLE;
         end

         always @(posedge clk, posedge reset) begin
                 if (reset) begin
                         cur_num <= 8'b0;
                         max_num <= 8'b0;
                         valid <= 1'b0;
                         status <= IDLE;
                         pair_num <= 8'b0;
                 end
                 else begin
                         case(status)
                                 IDLE: begin
                                         if (char == 8'h7b) begin
                                                 valid <= 1'b0;
                                                 status <= INPUT_FORE_BRACKET;
                                                 pair_num <= 8'b0;
                                         end
                                         else begin
                                                 status <= IDLE;
                                         end
                                 end
                                 INPUT_FORE_BRACKET: begin
                                         if (char == 8'h22) begin
                                                 status <= KEY_FORE_QUOTE;
                                         end
                                         else if (char == 8'h7d) begin
                                                 status <= INPUT_BACK_BRACKET;
                                                 valid <= 1'b1;
                                         end
                                         else begin
                                                 status <= OTHER;
                                                 valid <= 1'b1;
                                         end
                                 end
                                 KEY_FORE_QUOTE: begin
                                         if (char == 8'h22) begin
                                                 status <= OTHER;
                                                 valid <= 1'b1;
                                         end
                                         else begin
                                                 status <= KEY_MIDDLE_CHARACTER;
                                         end
                                 end
                                 KEY_MIDDLE_CHARACTER: begin
                                         if (char == 8'h22) begin
                                                 status <= KEY_BACK_QUOTE;
                                         end
                                         else begin
                                                 status <= KEY_MIDDLE_CHARACTER;
                                         end
                                 end
                                 KEY_BACK_QUOTE: begin
                                         if (char == 8'h3a) begin
                                                 status <= INPUT_COLON;
                                         end
                                         else begin
                                                status <= OTHER;
                                                valid <= 1'b1;
                                         end
                                 end
                                 INPUT_COLON: begin
                                         if (char == 8'h22) begin
                                                 status <= VALUE_FORE_QUOTE;
                                         end
                                         else begin
                                                 status <= OTHER;
                                                 valid <= 1'b1;
                                         end
                                 end
                                 VALUE_FORE_QUOTE: begin
                                         if (char == 8'h22) begin
                                                 status <= OTHER;
                                                 valid <= 1'b1;
                                         end
                                         else begin
                                                 status <= VALUE_MIDDLE_CHARACTER;
                                         end
                                 end
                                 VALUE_MIDDLE_CHARACTER: begin
                                         if (char == 8'h22) begin
                                                 status <= VALUE_BACK_QUOTE;
                                         end
                                         else begin
                                                 status <= VALUE_MIDDLE_CHARACTER;
                                         end
                                 end
                                 VALUE_BACK_QUOTE: begin
                                         if (char == 8'h2c) begin
                                                 status <= INPUT_COMMA;
                                                 pair_num <= pair_num + 1;
                                         end
                                         else if (char == 8'h7d) begin
                                                 status <= INPUT_BACK_BRACKET;
                                                 pair_num <= pair_num + 1;
                                         end
                                         else begin
                                                status <= OTHER;
                                                valid <= 1'b1;
                                         end
                                 end
                                 INPUT_COMMA: begin
                                         if (char == 8'h22) begin
                                                 status <= KEY_FORE_QUOTE;
                                         end
                                         else begin
                                                 status <= OTHER;
                                                 valid <= 1'b1;
                                         end
                                 end
                                 OTHER: begin
                                         if (char == 8'h7d) begin
                                                 status <= INPUT_BACK_BRACKET;
                                         end
                                         else begin
                                                 status <= OTHER;
                                         end
                                 end
                                 INPUT_BACK_BRACKET: begin
                                         if (char == 8'h20) begin
                                                 status <= IDLE;
                                         end
                                         else if (char == 8'h7b) begin
                                                 valid <= 1'b0;
                                                 status <= INPUT_FORE_BRACKET;
                                                 pair_num <= 8'h0;
                                         end
                                         else begin
                                                 status <= OTHER;
                                                 valid <= 1'b1;
                                         end
                                 end
                         endcase
                 end
         end


         always @(*) begin
                 if (status == INPUT_BACK_BRACKET) begin
                         cur_num = (valid == 1'b0) ? pair_num : 8'h0;
                         max_num = (max_num < cur_num) ? cur_num : max_num;
                 end
                 else begin
                         cur_num <= cur_num;
                 end
         end



endmodule