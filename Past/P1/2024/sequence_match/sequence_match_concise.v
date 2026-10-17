`timescale 1ns / 1ps

module sequence_match(
    input clk,
    input rst,
    input [7:0] chr,
    output reg [7:0] each,
    output reg [7:0] total
    );

	// OUT: outside a set. The other states track the current item inside a set.
	localparam OUT   = 3'd0,  // outside any set
	           PRE   = 3'd1,  // item start, only spaces so far (empty item)
	           KEY   = 3'd2,  // inside the key
	           KEYSP = 3'd3,  // spaces after the key
	           COLON = 3'd4,  // after ':' (and spaces)
	           VAL   = 3'd5,  // inside the value
	           VALSP = 3'd6,  // spaces after the value
	           BAD   = 3'd7;  // item already invalid, wait for ',' or '}'

	reg [2:0] st;

	wire space  = (chr == " ");
	wire digit  = (chr >= "0" && chr <= "9");
	wire letter = (chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z");
	wire ok     = (st == VAL || st == VALSP);  // current item is a complete key:value
	wire [7:0] cnt = each + ok;                // count including the current item

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			st <= OUT;
			each <= 8'd0;
			total <= 8'd0;
		end
		else if (st == OUT) begin
			if (chr == "{") begin
				st <= PRE;
				each <= 8'd0;
			end
		end
		else if (chr == ",") begin
			each <= cnt;
			st <= PRE;
		end
		else if (chr == "}") begin
			if (cnt > total) total <= cnt;
			each <= 8'd0;
			st <= OUT;
		end
		else begin
			case (st)
				PRE:     st <= space ? PRE   : letter ? KEY : BAD;
				KEY:     st <= (letter || digit) ? KEY : space ? KEYSP : (chr == ":") ? COLON : BAD;
				KEYSP:   st <= space ? KEYSP : (chr == ":") ? COLON : BAD;
				COLON:   st <= space ? COLON : digit ? VAL : BAD;
				VAL:     st <= digit ? VAL   : space ? VALSP : BAD;
				VALSP:   st <= space ? VALSP : BAD;
				default: st <= BAD;
			endcase
		end
	end

endmodule
