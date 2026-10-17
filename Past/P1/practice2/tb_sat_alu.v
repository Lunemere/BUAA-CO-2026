`timescale 1ns / 1ps

module tb_sat_alu;

	reg [7:0] a;
	reg [7:0] b;
	reg op;
	wire [7:0] y;
	wire of;

	integer i, j, k, exact, expected_y, errors, checks;
	reg expected_of;

	sat_alu uut (
		.a(a),
		.b(b),
		.op(op),
		.y(y),
		.of(of)
	);

	// tries every a, b and op (2 x 256 x 256 cases)
	initial begin
		errors = 0;
		checks = 0;
		for (k = 0; k < 2; k = k + 1)
			for (i = 0; i < 256; i = i + 1)
				for (j = 0; j < 256; j = j + 1) begin
					a = i;
					b = j;
					op = k;
					#1;
					exact = (i > 127 ? i - 256 : i) + (k ? -(j > 127 ? j - 256 : j) : (j > 127 ? j - 256 : j));
					expected_of = (exact > 127 || exact < -128);
					expected_y = exact > 127 ? 127 : (exact < -128 ? -128 : exact);
					checks = checks + 1;
					if (y !== expected_y[7:0] || of !== expected_of) begin
						errors = errors + 1;
						if (errors <= 10) $display("FAIL: a = %0d, b = %0d, op = %0d: y = %0d, of = %b, expected y = %0d, of = %b",
							$signed(a), $signed(b), op, $signed(y), of, expected_y, expected_of);
					end
				end
		if (errors == 0) $display("PASS: all %0d checks passed", checks);
		else $display("FAILED: %0d of %0d checks wrong", errors, checks);
		$finish;
	end

endmodule
