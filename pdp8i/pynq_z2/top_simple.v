module top
(
    input clk_125,
    input rst_btn,

    input rx_data,
    output tx_data,

    output [7:0] led_row,
    output [2:0] sw_row,
    inout [11:0] col
);

wire ion;
wire pause;
wire run;
wire inst_and;
wire inst_tad;
wire inst_isz;
wire inst_dca;
wire inst_jms;
wire inst_jmp;
wire inst_iot;
wire inst_opr;
wire state_fetch;
wire state_defer;
wire state_execute;
wire state_word_count;
wire state_cur_addr;
wire state_break;
wire [2:0] dataf;
wire [2:0] instf;
wire [11:0] pc;
wire [11:0] ma;
wire [11:0] mb;
wire [12:0] lac;
wire [4:0] sc;
wire [11:0] mq;

wire [2:0] dfsr;
wire [2:0] ifsr;
wire [11:0] sr;
wire start;
wire stop;
wire load_addr;
wire dep;
wire exam;
wire cont;
wire sing_step;
wire sing_inst;

wire clk, rst;

clk_wiz_100MHz clk_wiz (.clk_out1(clk), .clk_in1(clk_125));
debounce db_rst (.clk(clk), .rst(1'b0), .in(rst_btn), .out(rst));

base sys (
    .clk(clk),
    .rst(rst),

    .rx_data(rx_data),
    .tx_data(tx_data),

    .dfsr(dfsr),
    .ifsr(ifsr),
    .sr(sr),
    .start(start),
    .stop(stop),
    .load_addr(load_addr),
    .dep(dep),
    .exam(exam),
    .cont(cont),
    .step(step),
    .sing_step(sing_step),
    .sing_inst(sing_inst),

    .ion(ion),
    .pause(pause),
    .run(run),
    .inst_and(inst_and),
    .inst_tad(inst_tad),
    .inst_isz(inst_isz),
    .inst_dca(inst_dca),
    .inst_jms(inst_jms),
    .inst_jmp(inst_jmp),
    .inst_iot(inst_iot),
    .inst_opr(inst_opr),
    .state_fetch(state_fetch),
    .state_defer(state_defer),
    .state_execute(state_execute),
    .state_word_count(state_word_count),
    .state_cur_addr(state_cur_addr),
    .state_break(state_break),
    .dataf(dataf),
    .instf(instf),
    .pc(pc),
    .ma(ma),
    .mb(mb),
    .lac(lac),
    .sc(sc),
    .mq(mq)
);

panel_driver panel (
    .clk(clk),
    .rst(rst),

    .led_row(led_row),
    .sw_row(sw_row),
    .col(col),

    .ion(ion),
    .pause(pause),
    .run(run),
    .inst_and(inst_and),
    .inst_tad(inst_tad),
    .inst_isz(inst_isz),
    .inst_dca(inst_dca),
    .inst_jms(inst_jms),
    .inst_jmp(inst_jmp),
    .inst_iot(inst_iot),
    .inst_opr(inst_opr),
    .state_fetch(state_fetch),
    .state_defer(state_defer),
    .state_execute(state_execute),
    .state_word_count(state_word_count),
    .state_cur_addr(state_cur_addr),
    .state_break(state_break),
    .dataf(dataf),
    .instf(instf),
    .pc(pc),
    .ma(ma),
    .mb(mb),
    .lac(lac),
    .sc(sc),
    .mq(mq),

    .dfsr(dfsr),
    .ifsr(ifsr),
    .sr(sr),
    .start(start),
    .load_addr(load_addr),
    .dep(dep),
    .exam(exam),
    .cont(cont),
    .stop(stop),
    .sing_step(sing_step),
    .sing_inst(sing_inst)
);

endmodule
