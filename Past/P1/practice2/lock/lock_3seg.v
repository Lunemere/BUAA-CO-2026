module lock(
    input clk,
    input rst,
    input key_valid,
    input [3:0] key,
    output reg open,
    output reg locked
    );

    localparam S0   = 3'd0, // 0 digits entered
               S1   = 3'd1, // 1 digit entered
               S2   = 3'd2, // 2 digits entered
               S3   = 3'd3, // 3 digits entered
               OPEN = 3'd4, // like S0, but the lock is open
               LOCK = 3'd5; // locked out

    reg [2:0] state, next;
    reg match;              // all digits so far correct
    reg [1:0] wrong_num;    // failed attempts
    reg [3:0] lock_cnt;     // remaining locked cycles

    wire right = match && key == 4'd4;  // 4th digit completes 2024

    // part 1: state register
    always @(posedge clk, posedge rst) begin
        if (rst) state <= S0;
        else     state <= next;
    end

    // part 2: next-state logic
    always @(*) begin
        next = state;
        case (state)
            S0, OPEN: if (key_valid) next = S1;
            S1:       if (key_valid) next = S2;
            S2:       if (key_valid) next = S3;
            S3: if (key_valid) begin
                    if (right)               next = OPEN;
                    else if (wrong_num == 2) next = LOCK;
                    else                     next = S0;
                end
            LOCK:     if (lock_cnt == 1) next = S0;
            default:  next = S0;
        endcase
    end

    // part 3: outputs (Moore: depend only on state)
    always @(*) begin
        open   = (state == OPEN);
        locked = (state == LOCK);
    end

    // datapath: match / wrong_num / lock_cnt
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            match <= 1'b1;
            wrong_num <= 2'd0;
            lock_cnt <= 4'd0;
        end
        else if (state == LOCK) begin
            lock_cnt <= lock_cnt - 1;
        end
        else if (key_valid) begin
            case (state)
                S0, OPEN: match <= (key == 4'd2);
                S1:       match <= match && key == 4'd0;
                S2:       match <= match && key == 4'd2;
                S3: begin
                    match <= 1'b1;
                    if (right)               wrong_num <= 0;
                    else if (wrong_num == 2) begin wrong_num <= 0; lock_cnt <= 4'd10; end
                    else                     wrong_num <= wrong_num + 1;
                end
            endcase
        end
    end
endmodule
