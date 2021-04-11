module top
(
    input clk_125,
    //input clk,
    input rst_btn,
    input disp_sel,
    output rx_led,
    output tx_led,
    output pll_led,
    //input clk_sel,
    //input break_cont_btn,
    //input halt_dis_btn,

    input write_enable,

    input rx_data,
    output tx_data,

    output [7:0] led_row,
    output [2:0] sw_row,
    inout [11:0] col
);

design_1_wrapper zynq ();

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

wire rx_data_int, tx_data_int;

assign rx_data_int = !rx_data;
assign tx_data = !tx_data_int;

assign rx_led = !rx_data;
assign tx_led = !tx_data_int;
/*
assign rx_data_int = pol_sel ? rx_data : !rx_data;
assign tx_data = pol_sel ? tx_data_int : !tx_data_int;

assign rx_led = rx_data_int;
assign tx_led = pol_sel ? tx_data_int : !tx_data_int;
*/

wire clk;
wire pll_lock;
wire rst;

clk_wiz_100MHz clk_wiz (.clk_out1(clk), .locked(pll_lock), .clk_in1(clk_125));
debounce db_rst (.clk(clk), .rst(1'b0), .in(rst_btn), .out(rst));


assign pll_led = (pll_count > 0) ? 1'b1 : 1'b0;

integer pll_count;
always @(posedge clk) begin
    if (!pll_lock) begin
        pll_count <= 1;
    end
    if (pll_count > 0) pll_count <= pll_count + 1;
    if (pll_count >= 9999999) pll_count <= 0;
end


/*
wire break_cont;
wire halt_dis;
wire clk_10, sys_clk, sys_clk2;
reg clk_slow;

debounce db_break_cont (.clk(clk), .rst(1'b0), .in(break_cont_btn), .out(break_cont));
debounce db_halt_dis (.clk(clk), .rst(1'b0), .in(halt_dis_btn), .out(halt_dis));

//assign clk_slow = clk_10;

BUFGMUX bufgmux_inst (.O(sys_clk2), .I0(clk), .I1(clk_slow), .S(clk_sel));
BUFGMUX bufgmux_inst2 (.O(sys_clk), .I0(sys_clk2), .I1(1'b0), .S(halt));

reg halt, old_state_break, old_break_cont;

integer clk_div;
always @(posedge clk) begin
    old_state_break <= state_break;
    old_break_cont <= break_cont;
    if (!halt_dis && state_break && !old_state_break) begin
        halt <= 1'b1;
    end
    if (rst || (break_cont && !old_break_cont)) begin
        halt <= 1'b0;
    end
    if (clk_div >= 99) begin
        clk_div <= 0;
        clk_slow <= 1'b1;
    end else begin
        clk_div <= clk_div + 1;
        clk_slow <= 1'b0;
    end
end

wire [14:0] last_break_addr;
wire [11:0] last_break_data;
*/
wire [2:0] instf_disp;
wire [11:0] pc_disp;
wire [11:0] ma_disp;
wire [11:0] mb_disp;

//assign instf_disp = disp_sel ? {m707_stop2, m707_stop15, m707_stop1} : instf;
//assign pc_disp = disp_sel ? {m707_flag, m707_active, m707_freq_div, m707_enable_q, m707_srbit} : pc;
//assign ma_disp = disp_sel ? {11'b0, m707_line} : ma;

assign pc_disp = disp_sel ? hr : pc;
assign ma_disp = disp_sel ? min : ma;
assign mb_disp = disp_sel ? sec : ma;

wire m707_flag;
wire m707_active;
wire m707_stop2;
wire m707_stop15;
wire m707_stop1;
wire m707_freq_div;
wire m707_line;
wire [7:0] m707_srbit;
wire m707_enable_q;

reg [11:0] hr;
reg [11:0] min;
reg [11:0] sec;
integer count;
always @(posedge clk) begin
    count <= count + 1;
    if (count >= 99999999) begin
        count <= 0;
        sec <= sec + 1;
        if (sec >= 12'd59) begin
            sec <= 0;
            min <= min + 1;
            if (min >= 12'd59) begin
                min <= 0;
                hr <= hr + 1;
            end
        end
    end
    if (rst) begin
        hr <= 0;
        min <= 0;
        sec <= 0;
    end
end

system sys (
    .clk(clk),
    .rst(rst),

    .write_enable(write_enable),

    .rx_data(rx_data_int),
    .tx_data(tx_data_int),

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

    .last_break_addr(last_break_addr),
    .last_break_data(last_break_data),
    
    .swtm(1'b0),
    
    .m707_flag(m707_flag),
    .m707_active(m707_active),
    .m707_stop2(m707_stop2),
    .m707_stop15(m707_stop15),
    .m707_stop1(m707_stop1),
    .m707_freq_div(m707_freq_div),
    .m707_line(m707_line),
    .m707_srbit(m707_srbit),
    .m707_enable_q(m707_enable_q)
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
    /*
    .pc(pc),
    .ma(ma),
    .mb(mb),
    */
    //.instf(instf_disp),
    .pc(pc_disp),
    .ma(ma_disp),
    .mb(mb_disp),

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
