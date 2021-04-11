module base
(
    input clk,
    input rst,

    input rx_data,
    output tx_data,

    input [2:0] dfsr,
    input [2:0] ifsr,
    input [11:0] sr,
    input start,
    input stop,
    input load_addr,
    input dep,
    input exam,
    input cont,
    input step,
    input sing_step,
    input sing_inst,

    output ion,
    output pause,
    output run,
    output inst_and,
    output inst_tad,
    output inst_isz,
    output inst_dca,
    output inst_jms,
    output inst_jmp,
    output inst_iot,
    output inst_opr,
    output state_fetch,
    output state_defer,
    output state_execute,
    output state_word_count,
    output state_cur_addr,
    output state_break,
    output [2:0] dataf,
    output [2:0] instf,
    output [11:0] pc,
    output [11:0] ma,
    output [11:0] mb,
    output [12:0] lac,
    output [4:0] sc,
    output [11:0] mq
);

/* verilator lint_off UNUSED */

wire iop_1;
wire iop_2;
wire iop_4;
wire i_o_pwr_clr;
wire i_o_ts03; 
wire i_o_ts04;
wire i_o_addr_acc_l;
wire i_o_bwc0_l;
wire i_o_b_brk;
wire i_o_b_run;
wire [11:0] io_bac;
wire [11:0] io_bmb;
wire [8:3] io_bmb_l;

wire i_o_0_to_ac_l = 1'b1;
wire i_o_1_to_ca_inh_l = 1'b1;
wire i_o_brk_rq_l = 1'b1;
wire i_o_data_in = 1'b1;
wire i_o_int_rq_l = 1'b1;
wire i_o_skp_rq_l = 1'b1;
wire i_o_3_cycle_l = 1'b1;
wire i_o_mb_inc_l = 1'b1;
wire [11:0] db_l = 12'o7777;
wire [2:0] ea_l = 3'o7;
wire [11:0] im_l = 12'o7777;
wire [11:0] da_l = 12'o7777;

pdp8i pdp(
    .clk(clk),
    .rst(rst),
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
    .mq(mq),
    .rx_data(rx_data),
    .tx_data(tx_data),
    .iop_1(iop_1),
    .iop_2(iop_2),
    .iop_4(iop_4),
    .i_o_ts03(i_o_ts03),
    .i_o_ts04(i_o_ts04),
    .i_o_pwr_clr(i_o_pwr_clr),
    .i_o_addr_acc_l(i_o_addr_acc_l),
    .i_o_bwc0_l(i_o_bwc0_l),
    .i_o_b_brk(i_o_b_brk),
    .i_o_b_run(i_o_b_run),
    .io_bac(io_bac),
    .io_bmb(io_bmb),
    .io_bmb_l(io_bmb_l),
    .i_o_3_cycle_l(i_o_3_cycle_l),
    .i_o_mb_inc_l(i_o_mb_inc_l),
    .i_o_0_to_ac_l(i_o_0_to_ac_l),
    .i_o_1_to_ca_inh_l(i_o_1_to_ca_inh_l),
    .i_o_brk_rq_l(i_o_brk_rq_l),
    .i_o_data_in(i_o_data_in),
    .i_o_int_rq_l(i_o_int_rq_l),
    .i_o_skp_rq_l(i_o_skp_rq_l),
    .da_l(da_l),
    .db_l(db_l),
    .ea_l(ea_l),
    .im_l(im_l)
);
/* lint_on */

endmodule

