module top
(
    input clk,
    input rst,
    input wire [2:0] dfsr,
    input wire [2:0] ifsr,
    input wire [11:0] sr,
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
    output wire [2:0] dataf,
    output wire [2:0] instf,
    output wire [11:0] pc,
    output wire [11:0] ma,
    output wire [11:0] mb,
    output wire [12:0] lac,
    output wire [4:0] sc,
    output wire [11:0] mq,
    input [7:0] data_to_pdp,
    input data_to_pdp_strobe,
    output data_to_pdp_ready,
    output [7:0] data_from_pdp,
    output data_from_pdp_strobe
);

wire rx_data = !tx_pad;
wire tx_data;

wire rx_pad = !tx_data;
wire tx_pad;

pdp8i pdp(clk, rst, dfsr, ifsr, sr, start, stop, load_addr, dep,
          exam, cont, step, sing_step, sing_inst, ion, pause, run,
          inst_and, inst_tad, inst_isz, inst_dca, inst_jms,
          inst_jmp, inst_iot, inst_opr, state_fetch, state_defer,
          state_execute, state_word_count, state_cur_addr, state_break,
          dataf, instf, pc, ma, mb, lac, sc, mq, rx_data, tx_data);

uart_tx #(.CLK_FREQ(100000000), .BAUD_RATE(230400)) tx(.clk(clk), .pad(tx_pad), 
          .data(data_to_pdp), .strobe(data_to_pdp_strobe), .ready(data_to_pdp_ready));

uart_rx #(.CLK_FREQ(100000000), .BAUD_RATE(230400)) rx(.clk(clk), .pad(rx_pad), 
          .data(data_from_pdp), .strobe(data_from_pdp_strobe));

endmodule
