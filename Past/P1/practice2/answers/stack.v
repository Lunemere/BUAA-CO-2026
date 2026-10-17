`timescale 1ns / 1ps

module stack(
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] din,
    output [7:0] top,
    output reg [3:0] count,
    output reg err
    );

	reg [7:0] mem [0:7];

	assign top = (count == 4'd0) ? 8'd0 : mem[count - 4'd1];

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			count <= 4'd0;
			err <= 1'b0;
		end
		else if (push && pop) begin       // replace the top element
			if (count == 4'd0) err <= 1'b1;
			else begin
				mem[count - 4'd1] <= din;
				err <= 1'b0;
			end
		end
		else if (push) begin
			if (count == 4'd8) err <= 1'b1;
			else begin
				mem[count] <= din;
				count <= count + 4'd1;
				err <= 1'b0;
			end
		end
		else if (pop) begin
			if (count == 4'd0) err <= 1'b1;
			else begin
				count <= count - 4'd1;
				err <= 1'b0;
			end
		end
	end

endmodule
