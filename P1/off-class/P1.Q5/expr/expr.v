`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:23 10/13/2026 
// Design Name: 
// Module Name:    expr 
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
module expr(
    input clk,
    input clr,
    input [7:0] in,
    output reg out
    );
	 parameter State1 = 2'b00,
        State2 = 2'b01,
        State3 = 2'b10,
        State4 = 2'b11;
		  
    reg [1:0] state = State2;

    initial begin
        out <= 1'b0;
    end

    always @(posedge clk, posedge clr) begin
        if (clr) begin
            state <= State2;
            out <= 1'b0;
        end
        else begin
            case(state)
                State1: begin
                    state <= State1;
                end
                State2: begin
                    if (in >= 8'd48 && in <= 8'd57) begin
                        state <= State3;
                    end
                    else begin
                        state <= State1;
                    end
                end
                State3: begin
                    if (in == 8'd42 || in == 8'd43) begin
                        state <= State4;
                    end
                    else begin
                        state <= State1;
                    end
                end
                State4: begin
                    if (in >= 8'd48 && in <= 8'd57) begin
                        state <= State3;
                    end
                    else begin
                        state <= State1;
                    end
                end
            endcase
        end
    end

    always @(state) begin
		  out <= (state == State3) ? 1'b1 : 1'b0;
	 end

endmodule
