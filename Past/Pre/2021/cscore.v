module cscore(
    input              clk,
    input              reset,
    input      [7:0]   char_in,
    output reg [31:0]  max_count
);

    localparam S_IDLE = 3'd0,
               S_C    = 3'd1,
               S_CS   = 3'd2,
               S_CSC  = 3'd3,
               S_CSCO = 3'd4,
               S_CSCOR= 3'd5;

    reg [2:0]  state;
    reg [31:0] current_count;
    reg        waiting_space;

    wire [7:0] ch;

    // Convert uppercase ASCII letters to lowercase.
    assign ch = (char_in >= "A" && char_in <= "Z")
              ? char_in + 8'd32
              : char_in;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state         <= S_IDLE;
            current_count <= 32'd0;
            max_count     <= 32'd0;
            waiting_space <= 1'b0;
        end
        else begin
            case (state)

                S_IDLE: begin
                    if (waiting_space) begin
                        if (ch == " ") begin
                            state <= S_IDLE;
                        end
                        else if (ch == "c") begin
                            state         <= S_C;
                            waiting_space <= 1'b0;      // ensure the counting stops upon encountering a non-space character
                        end
                        else begin
                            state         <= S_IDLE;
                            current_count <= 32'd0;
                            waiting_space <= 1'b0;
                        end
                    end
                    else begin
                        if (ch == "c")
                            state <= S_C;
                        else
                            state <= S_IDLE;
                    end
                end

                S_C: begin
                    if (ch == "s")
                        state <= S_CS;
                    else if (ch == "c")
                        state <= S_C;
                    else begin
                        state         <= S_IDLE;
                        current_count <= 32'd0;
                    end
                end

                S_CS: begin
                    if (ch == "c")
                        state <= S_CSC;
                    else begin
                        state         <= S_IDLE;
                        current_count <= 32'd0;
                    end
                end

                S_CSC: begin
                    if (ch == "o")
                        state <= S_CSCO;
                    else if (ch == "c")
                        state <= S_C;
                    else begin
                        state         <= S_IDLE;
                        current_count <= 32'd0;
                    end
                end

                S_CSCO: begin
                    if (ch == "r")
                        state <= S_CSCOR;
                    else begin
                        state         <= S_IDLE;
                        current_count <= 32'd0;
                    end
                end

                S_CSCOR: begin
                    if (ch == "e") begin
                        state         <= S_IDLE;
                        waiting_space <= 1'b1;

                        if (current_count + 32'd1 > max_count)
                            max_count <= current_count + 32'd1;

                        current_count <= current_count + 32'd1;
                    end
                    else begin
                        state         <= S_IDLE;
                        current_count <= 32'd0;
                    end
                end
            endcase
        end
    end

endmodule
