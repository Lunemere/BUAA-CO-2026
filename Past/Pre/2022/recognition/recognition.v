`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:02:51 09/27/2026 
// Design Name: 
// Module Name:    recognition 
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

`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11

module recognition(
    input clk,
    input reset,
    input in,
    output out
    );

reg [1:0] status;   // record the status

initial begin
    status <= `S0;
end

always @(posedge clk, posedge reset) begin
    if (reset) begin
        status <= `S0;
    end
    else begin
        case(status)
            `S0 : begin
                if (in == 0) begin
                    status <= `S0;
                end
                else if (in == 1) begin
                    status <= `S1;
                end
            end
            `S1 : begin
                if (in == 1) begin
                    status <= `S1;
                end
                else if (in == 0) begin
                    status <= `S2;
                end
            end
            `S2 : begin
                if (in == 0) begin
                    status <= `S0;
                end
                else if (in == 1) begin
                    status <= `S3;
                end
            end
            `S3 : begin
                if (in == 0) begin
                    status <= `S2;
                end
                else if (in == 1) begin
                    status <= `S1;
                end
            end
        endcase
    end
end

assign out = (status == `S2 && in == 1) ? 1'b1 : 1'b0;

endmodule
