module basys3
(
    input clk,
    input rst,
	input [15:0] sw,
	output [15:0] led,
	input btn_t,
	input btn_b,
	input btn_l,
	input btn_r,
	input btn_m,
	output [3:0] seg7_an,
	output [6:0] seg7_cath,
	output seg7_dp,
	input rx_data,
	output tx_data
);

/*
use rotary encoder for display select
start = btn_b
stop = btn_t
load_addr = btn_l
dep = btn_r
exam = btn_m
*/

wire [2:0] dfsr,
wire [2:0] ifsr,
wire [11:0] sr,
wire start,
wire stop,
wire load_addr,
wire dep,
wire exam,
wire cont,
wire step,
wire sing_step,
wire sing_inst,
wire ion,
wire pause,
wire run,
wire inst_and,
wire inst_tad,
wire inst_isz,
wire inst_dca,
wire inst_jms,
wire inst_jmp,
wire inst_iot,
wire inst_opr,
wire state_fetch,
wire state_defer,
wire state_execute,
wire state_word_count,
wire state_cur_addr,
wire state_break,
wire [2:0] dataf,
wire [2:0] instf,
wire [11:0] pc,
wire [11:0] ma,
wire [11:0] mb,
wire [12:0] lac,
wire [4:0] sc,
wire [11:0] mq,

pdp8i pdp(clk, rst, dfsr, ifsr, sr, start, stop, load_addr, dep,
          exam, cont, step, sing_step, sing_inst, ion, pause, run,
          inst_and, inst_tad, inst_isz, inst_dca, inst_jms,
          inst_jmp, inst_iot, inst_opr, state_fetch, state_defer,
          state_execute, state_word_count, state_cur_addr, state_break,
          dataf, instf, pc, ma, mb, lac, sc, mq, rx_data, tx_data);

/*
wire rx_data = !tx_pad;
wire tx_data;

wire rx_pad = !tx_data;
wire tx_pad;

uart_tx #(.CLK_FREQ(100000000), .BAUD_RATE(230400)) tx(.clk(clk), .pad(tx_pad), 
          .data(data_to_pdp), .strobe(data_to_pdp_strobe), .ready(data_to_pdp_ready));

uart_rx #(.CLK_FREQ(100000000), .BAUD_RATE(230400)) rx(.clk(clk), .pad(rx_pad), 
          .data(data_from_pdp), .strobe(data_from_pdp_strobe));
*/

endmodule
