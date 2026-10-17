`timescale 1ns / 1ps

module hex_list(
    input clk,
    input rst,
    input [7:0] chr,
    output reg [7:0] cnt,
    output reg [7:0] best
    );

	localparam OUT  = 3'd0,  // outside any list
	           PRE  = 3'd1,  // element start, only spaces so far
	           SIGN = 3'd2,  // after '+' or '-'
	           ZERO = 3'd3,  // after '0'
	           X    = 3'd4,  // after 'x' / 'X'
	           HEX  = 3'd5,  // inside the hex digits
	           POST = 3'd6,  // spaces after the digits
	           BAD  = 3'd7;  // element already invalid

	reg [2:0] st;

	wire space = (chr == " ");
	wire hex   = (chr >= "0" && chr <= "9") || (chr >= "a" && chr <= "f") || (chr >= "A" && chr <= "F");
	wire ok    = (st == HEX || st == POST);  // current element is complete and valid
	wire [7:0] n = cnt + ok;                 // count including the current element

	always @(posedge clk) begin
		if (rst) begin
			st <= OUT;
			cnt <= 8'd0;
			best <= 8'd0;
		end
		else if (st == OUT) begin
			if (chr == "(") begin
				st <= PRE;
				cnt <= 8'd0;
			end
		end
		else if (chr == ";") begin
			cnt <= n;
			st <= PRE;
		end
		else if (chr == ")") begin
			if (n > best) best <= n;
			cnt <= 8'd0;
			st <= OUT;
		end
		else begin
			case (st)
				PRE:     st <= space ? PRE : (chr == "+" || chr == "-") ? SIGN : (chr == "0") ? ZERO : BAD;
				SIGN:    st <= (chr == "0") ? ZERO : BAD;
				ZERO:    st <= (chr == "x" || chr == "X") ? X : BAD;
				X:       st <= hex ? HEX : BAD;
				HEX:     st <= hex ? HEX : space ? POST : BAD;
				POST:    st <= space ? POST : BAD;
				default: st <= BAD;
			endcase
		end
	end

endmodule
