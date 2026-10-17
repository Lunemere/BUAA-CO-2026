`timescale 1ns / 1ps

module sat_alu(
    input [7:0] a,
    input [7:0] b,
    input op,
    output [7:0] y,
    output of
    );

	// sign-extend to 9 bits: the 9-bit result is always exact
	wire [8:0] r = op ? {a[7], a} - {b[7], b} : {a[7], a} + {b[7], b};

	// exact result fits in 8 bits only if bit 8 and bit 7 agree
	assign of = r[8] ^ r[7];
	assign y  = !of ? r[7:0] : (r[8] ? 8'h80 : 8'h7f);

endmodule
