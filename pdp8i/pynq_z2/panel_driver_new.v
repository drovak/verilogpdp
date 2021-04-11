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

wire col_t;
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
        bufif0 iobuf_col (col[i], col_out[i], col_t);
    end

    for (i = 0; i < 8; i=i+1) begin : gen_led
        bufif0 iobuf_led (led_row[i], led[i], col_t);
        pullup(led_row[i]);
    end

    for (i = 0; i < 3; i=i+1) begin : gen_sw
        bufif0 iobuf_sw (sw_row[i], sw[i], sw[i]);
        pullup(sw_row[i]);
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

reg [2:0] cur_row;
integer count;

parameter PAUSE_TIME = 500;
parameter DISPLAY_TIME = 100000;

assign col_out = ~led_row_out[cur_row];

assign col_t = ((count >                    PAUSE_TIME) && (count <     DISPLAY_TIME - PAUSE_TIME)) ||
               ((count >     DISPLAY_TIME + PAUSE_TIME) && (count < 2 * DISPLAY_TIME - PAUSE_TIME)) ||
               ((count > 2 * DISPLAY_TIME + PAUSE_TIME) && (count < 3 * DISPLAY_TIME - PAUSE_TIME)) ||
               ((count > 3 * DISPLAY_TIME + PAUSE_TIME) && (count < 4 * DISPLAY_TIME - PAUSE_TIME)) ||
               ((count > 4 * DISPLAY_TIME + PAUSE_TIME) && (count < 5 * DISPLAY_TIME - PAUSE_TIME)) ||
               ((count > 5 * DISPLAY_TIME + PAUSE_TIME) && (count < 6 * DISPLAY_TIME - PAUSE_TIME)) ||
               ((count > 6 * DISPLAY_TIME + PAUSE_TIME) && (count < 7 * DISPLAY_TIME - PAUSE_TIME)) ||
               ((count > 7 * DISPLAY_TIME + PAUSE_TIME) && (count < 8 * DISPLAY_TIME - PAUSE_TIME)) ? 1'b0 : 1'b1;

always @(posedge clk) begin
    col_in1 <= col;
    col_in2 <= col_in1;

    count <= count + 1;

    case (count)
        0: begin
            cur_row <= 0;
            led <= 8'h01;
        end
        DISPLAY_TIME: begin
            cur_row <= 1;
            led <= 8'h02;
        end
        2*DISPLAY_TIME: begin
            cur_row <= 2;
            led <= 8'h04;
        end
        3*DISPLAY_TIME: begin
            cur_row <= 3;
            led <= 8'h08;
        end
        4*DISPLAY_TIME: begin
            cur_row <= 4;
            led <= 8'h10;
        end
        5*DISPLAY_TIME: begin
            cur_row <= 5;
            led <= 8'h20;
        end
        6*DISPLAY_TIME: begin
            cur_row <= 6;
            led <= 8'h40;
        end
        7*DISPLAY_TIME: begin
            cur_row <= 7;
            led <= 8'h80;
        end
        8*DISPLAY_TIME: begin
            cur_row <= 0;
            led <= 8'hFF;
            sw <= 3'b110;
        end
        8*DISPLAY_TIME + PAUSE_TIME: begin
            sw <= 3'b101;
            sw_row1 <= ~col_in2;
        end
        8*DISPLAY_TIME + 2*PAUSE_TIME: begin
            sw <= 3'b011;
            sw_row2 <= ~col_in2[11:6];
        end
        8*DISPLAY_TIME + 3*PAUSE_TIME: begin
            sw <= 3'b111;
            sw_row3 <= ~col_in2[11:4];
            count <= 0;
        end
    endcase

    if (rst) begin
        count <= 0;
        cur_row <= 0;
        sw <= 3'b111;
    end
end

endmodule
