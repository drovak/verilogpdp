module top
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

pynq_z2 pynq (
    clk,
    rst,

    led_row,
    sw_row,
    col,

    ion,
    pause,
    run,
    inst_and,
    inst_tad,
    inst_isz,
    inst_dca,
    inst_jms,
    inst_jmp,
    inst_iot,
    inst_opr,
    state_fetch,
    state_defer,
    state_execute,
    state_word_count,
    state_cur_addr,
    state_break,
    dataf,
    instf,
    pc,
    ma,
    mb,
    lac,
    sc,
    mq,

    dfsr,
    ifsr,
    sr,
    start,
    load_addr,
    dep,
    exam,
    cont,
    stop,
    sing_step,
    sing_inst
);

endmodule
