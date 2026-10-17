`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:30:00 10/15/2026 
// Design Name: 
// Module Name:    alternate 
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
module alternate(
    input clk,
    input res_n,
    input number,
    output check
    );
	
	localparam IDLE = 2'b00,
				INPUT0 = 2'b01,
				INPUT1 = 2'b10;
	
	reg last_num; // store the last sequence's parity
	reg now_num; // store now sequence parity
	reg valid; // flag if the input sequence is valid
	reg [1:0] status;
	reg [1:0] num; // store the num type
	reg prev_valid; // store the long-term value

	always @(posedge clk, negedge res_n) begin
		if (!res_n) begin
			valid <= 1'b0;
			last_num <= 1'b0;
			now_num <= 1'b0;
			status <= IDLE;
			num <= 2'b0;
			prev_valid <= 1'b1;
			
		end
		else begin
			case(status)
				IDLE: begin
					if (number == 1) begin
						status <= INPUT1;
						now_num = now_num ^ 1;
						num <= num + 1;
					end
					else begin
						status <= INPUT0;
						now_num = now_num ^ 1;
						num <= num + 1;
					end
				end
				INPUT0: begin
					if (number == 0) begin
						status <= INPUT0;
						now_num = now_num ^ 1;
					end
					else begin
						status <= INPUT1;
						last_num <= now_num;
						now_num <= 1'b1;
						prev_valid <= (num == 2'b10) ? valid : 1'b1;
						if (num == 2'b1) begin
							num <= num + 1;
						end
						else begin
							num <= num;
						end
					end
				end
				INPUT1: begin
					if (number == 1) begin
						status <= INPUT1;
						now_num = now_num ^ 1;
					end
					else begin
						status <= INPUT0;
						last_num <= now_num;
						now_num <= 1'b1;
						prev_valid <= (num == 2'b10) ? valid : 1'b1;
						if (num == 2'b1) begin
							num <= num + 1;
						end
						else begin
							num <= num;
						end
					end
				end
			endcase
		end
	end
	
	always @(*) begin
		valid = (prev_valid == 1'b1) ? last_num ^ now_num : 1'b0;
	end
	
	assign check = (num == 2'b10) ? valid : 1'b0;

endmodule
