`timescale 1ns / 1ps

module calc(
    input clk,
    input rst,
    input [7:0] chr,
    output reg [15:0] result,
    output reg error
    );

	localparam EMPTY = 2'd0,  // expecting the first digit of a number
	           NUM   = 2'd1,  // inside a number
	           BAD   = 2'd2;  // expression already invalid, wait for '='

	reg [1:0]  st;
	reg [15:0] acc;  // sum of the finished terms
	reg [15:0] num;  // number being read
	reg        neg;  // the number being read is subtracted

	wire digit = (chr >= "0" && chr <= "9");
	wire [15:0] sum = acc + (neg ? -num : num);  // value if the expression ended now

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			st <= EMPTY;
			acc <= 16'd0;
			num <= 16'd0;
			neg <= 1'b0;
			result <= 16'd0;
			error <= 1'b0;
		end
		else if (chr == "=") begin
			if (st == NUM) begin
				result <= sum;
				error <= 1'b0;
			end
			else begin
				error <= 1'b1;
			end
			st <= EMPTY;
			acc <= 16'd0;
			num <= 16'd0;
			neg <= 1'b0;
		end
		else if (st == BAD) begin
			// ignore everything until '='
		end
		else if (digit) begin
			num <= (st == NUM ? num * 10 : 16'd0) + (chr - "0");
			st <= NUM;
		end
		else if ((chr == "+" || chr == "-") && st == NUM) begin
			acc <= sum;
			neg <= (chr == "-");
			st <= EMPTY;
		end
		else begin
			st <= BAD;
		end
	end

endmodule
