`timescale 1ns / 1ps

module run_count(
    input [31:0] a,
    output reg [4:0] count
    );

	// bit i is the top bit of a run when a[i] = 1 and the bit above it is 0
	wire [31:0] tops = a & ~(a >> 1);

	integer i;
	always @(*) begin
		count = 5'd0;
		for (i = 0; i < 32; i = i + 1) begin
			count = count + tops[i];
		end
	end

endmodule
