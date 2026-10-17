`timescale 1ns / 1ps

module lock(
    input clk,
    input rst,
    input key_valid,
    input [3:0] key,
    output reg open,
    output locked
    );

	reg [1:0] idx;       // how many digits of the current attempt are already in
	reg       match;     // all digits so far were correct
	reg [1:0] fails;     // wrong attempts since the last success / lockout
	reg [3:0] wait_cnt;  // clock edges of lockout still to go

	// password 2 0 2 4
	wire [3:0] want = (idx == 2'd0) ? 4'd2 : (idx == 2'd1) ? 4'd0 : (idx == 2'd2) ? 4'd2 : 4'd4;
	wire m = (idx == 2'd0 ? 1'b1 : match) & (key == want);  // attempt still correct including this key

	assign locked = (wait_cnt != 4'd0);

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			idx <= 2'd0;
			match <= 1'b0;
			fails <= 2'd0;
			wait_cnt <= 4'd0;
			open <= 1'b0;
		end
		else if (locked) begin
			wait_cnt <= wait_cnt - 4'd1;  // inputs ignored
		end
		else if (key_valid) begin
			open <= 1'b0;
			if (idx == 2'd3) begin        // fourth digit: judge the attempt
				idx <= 2'd0;
				if (m) begin
					open <= 1'b1;
					fails <= 2'd0;
				end
				else if (fails == 2'd2) begin
					fails <= 2'd0;
					wait_cnt <= 4'd10;
				end
				else begin
					fails <= fails + 2'd1;
				end
			end
			else begin
				idx <= idx + 2'd1;
				match <= m;
			end
		end
	end

endmodule
