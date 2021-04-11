module panel_driver
(
    input clk,
    input rst,

    output [7:0] led_row,
    output [2:0] sw_row,
    inout [11:0] col,

    input ion,
    input pause,
    input run,
    input inst_and,
    input inst_tad,
    input inst_isz,
    input inst_dca,
    input inst_jms,
    input inst_jmp,
    input inst_iot,
    input inst_opr,
    input state_fetch,
    input state_defer,
    input state_execute,
    input state_word_count,
    input state_cur_addr,
    input state_break,
    input [2:0] dataf,
    input [2:0] instf,
    input [11:0] pc,
    input [11:0] ma,
    input [11:0] mb,
    input [12:0] lac,
    input [4:0] sc,
    input [11:0] mq,

    output [2:0] dfsr,
    output [2:0] ifsr,
    output [11:0] sr,
    output start,
    output load_addr,
    output dep,
    output exam,
    output cont,
    output stop,
    output sing_step,
    output sing_inst
);

reg col_t;
reg [11:0] col_in1;
reg [11:0] col_in2;
wire [11:0] col_out;
reg [7:0] led;
reg [2:0] sw;

reg [7:0]  sw_row3;
reg [5:0]  sw_row2; 
reg [11:0] sw_row1; 

wire [7:0]  sw_row3_db;
wire [5:0]  sw_row2_db; 
wire [11:0] sw_row1_db; 

assign {start, load_addr, dep, exam, cont, stop, sing_step, sing_inst} = sw_row3_db;
assign {dfsr, ifsr} = sw_row2_db;
assign sr = sw_row1_db;

wire [11:0] led_row_out [7:0];
assign led_row_out[7] = {dataf, instf, lac[12], 5'b0};
assign led_row_out[6] = {state_cur_addr, state_break, ion, pause, run, sc, 2'b0};
assign led_row_out[5] = {inst_and, inst_tad, inst_isz, inst_dca, inst_jms, inst_jmp, inst_iot, 
                     inst_opr, state_fetch, state_defer, state_execute, state_word_count};
assign led_row_out[4] = mq;
assign led_row_out[3] = lac[11:0];
assign led_row_out[2] = mb;
assign led_row_out[1] = ma;
assign led_row_out[0] = pc;

generate
    genvar i;
    for (i = 0; i < 12; i=i+1) begin : gen_col
        //IOBUF #(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW")) iobuf_col (.O(col_out[i]), .IO(col[i]), .I(col_in[i]), .T(col_t));
        bufif0 iobuf_col (col[i], col_out[i], col_t);
        //pullup(col[i]);
    end

    for (i = 0; i < 8; i=i+1) begin : gen_led
        //OBUFT #(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW")) obuft_led (.O(led_row[i]), .I(led[i]), .T(col_t));
        bufif0 iobuf_led (led_row[i], led[i], col_t);
        //pullup(led_row[i]);
    end

    for (i = 0; i < 3; i=i+1) begin : gen_sw
        //OBUFT #(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW")) obuft_sw (.O(sw_row[i]), .I(sw[i]), .T(sw[i]));
        bufif0 iobuf_sw (sw_row[i], sw[i], sw[i]);
        //pullup(sw_row[i]);
    end

    for (i = 0; i < 12; i=i+1) begin : gen_sw_row1
        debounce db_sw_row1 (.clk(clk), .rst(rst), .in(sw_row1[i]), .out(sw_row1_db[i]));
    end

    for (i = 0; i < 6; i=i+1) begin : gen_sw_row2
        debounce db_sw_row2 (.clk(clk), .rst(rst), .in(sw_row2[i]), .out(sw_row2_db[i]));
    end

    for (i = 0; i < 8; i=i+1) begin : gen_sw_row3
        debounce db_sw_row3 (.clk(clk), .rst(rst), .in(sw_row3[i]), .out(sw_row3_db[i]));
    end
endgenerate

localparam [1:0] LED_OUT = 0;
localparam [1:0] LED_WAIT = 1;
localparam [1:0] COL_IN = 2;
localparam [1:0] COL_PAUSE = 3;

reg [1:0] state;
reg [4:0] count_50us;
reg [2:0] cur_row;
reg [12:0] cycle_counter;
wire step_50us = (cycle_counter >= MAX_COUNT - 1) ? 1'b1 : 1'b0;

localparam [12:0] MAX_COUNT = 5000;

assign col_out = ~led_row_out[cur_row];

always @(posedge clk) begin
    col_in1 <= col;
    col_in2 <= col_in1;

    if (cycle_counter < MAX_COUNT - 1) begin
        //step_50us <= 1'b0;
        cycle_counter <= cycle_counter + 1;
    end else begin
        cycle_counter <= 0;
        //step_50us <= 1'b1;
    end

    if (step_50us) begin
        count_50us <= count_50us + 1;
    end

    case (state)
        LED_OUT: begin
            col_t <= 1'b0;
            if (count_50us == 31) begin
                count_50us <= 0;
                state <= LED_WAIT;
            end
        end
        LED_WAIT: begin
            col_t <= 1'b1;
            if (count_50us == 1) begin
                count_50us <= 0;
                led <= {led[6:0], led[7]};
                if (cur_row < 7) begin
                    cur_row <= cur_row + 1;
                    state <= LED_OUT;
                end else begin
                    cur_row <= 0;
                    state <= COL_IN;
                end
            end
        end
        COL_IN: begin
            col_t <= 1'b1;
            case (count_50us)
                0: begin
                    sw <= 3'b110;
                    if (step_50us) sw_row1 <= ~col_in2;
                end
                1: begin
                    sw <= 3'b101;
                    if (step_50us) sw_row2 <= ~col_in2[11:6];
                end
                2: begin
                    sw <= 3'b011;
                    if (step_50us) sw_row3 <= ~col_in2[11:4];
                end
                3: begin
                    count_50us <= 0;
                    state <= COL_PAUSE;
                end
                //default: count_50us <= 0;
            endcase
        end
        COL_PAUSE: begin
            sw <= 3'b111;
            col_t <= 1'b1;
            if (count_50us == 1) begin
                count_50us <= 0;
                state <= LED_OUT;
            end
        end
    endcase

    if (rst) begin
        //step_50us <= 1'b0;
        cycle_counter <= 0;
        count_50us <= 0;
        state <= LED_OUT;
        cur_row <= 0;
        led <= 8'b1;
    end 
end

endmodule
