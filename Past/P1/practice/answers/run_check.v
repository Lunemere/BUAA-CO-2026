`timescale 1ns / 1ps

module run_check(
    input clk,
    input res_n,
    input number,
    output check
    );

	reg started;  // at least one bit received since reset
	reg cur_bit;  // value of the current (last) run
	reg cur_odd;  // length of the current run is odd
	reg ok;       // every finished run met its rule

	// 0-runs must be odd, 1-runs must be even
	wire cur_ok = cur_bit ? ~cur_odd : cur_odd;

	always @(posedge clk, negedge res_n) begin
		if (!res_n) begin
			started <= 1'b0;
			cur_bit <= 1'b0;
			cur_odd <= 1'b0;
			ok <= 1'b1;
		end
		else if (started && number == cur_bit) begin
			cur_odd <= ~cur_odd;           // current run grows by one
		end
		else begin
			if (started) ok <= ok & cur_ok;  // the current run just ended: its length is final
			started <= 1'b1;
			cur_bit <= number;
			cur_odd <= 1'b1;
		end
	end

	assign check = started & ok & cur_ok;

endmodule
