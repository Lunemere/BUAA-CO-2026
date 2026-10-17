`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:07:07 10/15/2026 
// Design Name: 
// Module Name:    sequence_match 
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
module sequence_match(
    input clk,
    input rst,
    input [7:0] chr,
    output reg [7:0] each,
    output reg [7:0] total
    );

	localparam START_BRACKET = 4'b0000,
				SPACE_BEFORE_KEY = 4'b0001,
				FIRST_KEY = 4'b0010,
				KEY = 4'b0011,
				SPACE_AFTER_KEY = 4'b0100,
				COLON = 4'b0101,
				SPACE_BEFORE_VALUE = 4'b0110,
				VALUE = 4'b0111,
				COMMA = 4'b1000,
				END_BRACKET = 4'b1001,
				OTHER = 4'b1010,
				IDLE = 4'b1011,
				SPACE_AFTER_VALUE = 4'b1100;
				
	reg [3:0] status;
	reg valid; // valid == 0, it's invalid

	initial begin
		valid <= 1'b0;
		status <= IDLE;
		each <= 8'b0;
		total <= 8'b0;
	end

	wire [7:0] convert_upper = (chr >= "a" && chr <= "z") ? chr - 8'd32 : chr;

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			valid <= 1'b0;
			status <= IDLE;
			each <= 8'b0;
		end
		else begin
			case(status)
				IDLE: begin
					if (convert_upper == 8'h20) begin
						status <= IDLE;
					end
					else if (convert_upper == 8'h7b) begin
						status <= START_BRACKET;
					end
					else begin
						status <= OTHER;
					end
				end
				START_BRACKET: begin
					if (convert_upper == 8'h20) begin
						status <= SPACE_BEFORE_KEY;
					end
					else if (convert_upper <= 8'h5a && convert_upper >= 8'h41) begin
						valid <= 1'b1;
						status <= FIRST_KEY;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						valid <= 1'b0;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				SPACE_BEFORE_KEY: begin
					if (convert_upper == 8'h20) begin
						status <= SPACE_BEFORE_KEY;
					end
					else if (convert_upper <= 8'h5a && convert_upper >= 8'h41) begin
						status <= FIRST_KEY;
						valid <= 1'b1;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
						valid <= 1'b0;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				FIRST_KEY: begin
					if ((convert_upper <= 8'h5a && convert_upper >= 8'h41) || (convert_upper <= 8'h39 && convert_upper >= 8'h30)) begin
						status <= KEY;
					end
					else if (convert_upper == 8'h20) begin
						status <= SPACE_AFTER_KEY;
					end
					else if (convert_upper == 8'h3a) begin
						status <= COLON;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
						valid <= 1'b0;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				KEY: begin
					if ((convert_upper <= 8'h5a && convert_upper >= 8'h41) || (convert_upper <= 8'h39 && convert_upper >= 8'h30)) begin
						status <= KEY;
					end
					else if (convert_upper == 8'h20) begin
						status <= SPACE_AFTER_KEY;
					end
					else if (convert_upper == 8'h3a) begin
						status <= COLON;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
						valid <= 1'b0;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				SPACE_AFTER_KEY: begin
					if (convert_upper == 8'h20) begin
						status <= SPACE_AFTER_KEY;
					end
					else if (convert_upper == 8'h3a) begin
						status <= COLON;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
						valid <= 1'b0;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				COLON: begin
					if (convert_upper == 8'h20) begin
						status <= SPACE_BEFORE_VALUE;
					end
					else if (convert_upper <= 8'h39 && convert_upper >= 8'h30) begin
						status <= VALUE;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
						valid <= 1'b0;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				SPACE_BEFORE_VALUE: begin
					if (convert_upper == 8'h20) begin
						status <= SPACE_BEFORE_VALUE;
					end
					else if (convert_upper <= 8'h39 && convert_upper >= 8'h30) begin
						status <= VALUE;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
						valid <= 1'b0;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				VALUE: begin
					if (convert_upper <= 8'h39 && convert_upper >= 8'h30) begin
						status <= VALUE;
					end
					else if (convert_upper == 8'h20) begin
						status <= SPACE_AFTER_VALUE;
					end
					else if (convert_upper == 8'h2c) begin
						if (valid == 1'b1) begin
							each <= each + 1;
						end
						else begin
							each <= each;
							valid <= 1'b0;
						end
						status <= COMMA;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						valid <= 1'b1;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				SPACE_AFTER_VALUE: begin
					if (convert_upper == 8'h20) begin
						status <= SPACE_AFTER_VALUE;
					end
					else if (convert_upper == 8'h2c) begin
						if (valid == 1'b1) begin
							each <= each + 1;
							valid <= 1'b0;
						end
						else begin
							each <= each;
						end
						status <= COMMA;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						valid <= 1'b1;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				COMMA: begin
					if (convert_upper <= 8'h5a && convert_upper >= 8'h41) begin
						valid <= 1'b1;
						status <= FIRST_KEY;
					end
					else if (convert_upper == 8'h20) begin
						status <= SPACE_BEFORE_KEY;
					end
					else if (convert_upper == 8'h2c) begin
						status <= COMMA;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				END_BRACKET: begin
					if (convert_upper == 8'h20) begin
						status <= IDLE;
					end
					else if (convert_upper == 8'h7b) begin
						status <= START_BRACKET;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
				OTHER: begin
					if (convert_upper == 8'h2c) begin
						status <= COMMA;
					end
					else if (convert_upper == 8'h7d) begin
						status <= END_BRACKET;
						each <= 8'b0;
					end
					else if (convert_upper == 8'h7b) begin
						status <= START_BRACKET;
					end
					else begin
						status <= OTHER;
						valid <= 1'b0;
					end
				end
			endcase
		end
	end

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			total <= 8'b0;
		end
		else begin
			if (convert_upper == 8'h7d) begin
				if (status == VALUE || status == SPACE_AFTER_VALUE) begin
					total <= (total < each + 1) ? each + 1 : total;
				end
				else begin
					total <= (total < each) ? each : total;
				end
			end
			else begin
				total <= total;
			end
		end
	end

endmodule
