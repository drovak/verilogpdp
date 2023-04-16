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
    output [2:0] dataf,
    output [2:0] instf,
    output [11:0] pc,
    output [11:0] ma,
    output [11:0] mb,
    output [12:0] lac,
    output [4:0] sc,
    output [11:0] mq,
    input [7:0] data_to_pdp,
    input data_to_pdp_strobe,
    output data_to_pdp_ready,
    output [7:0] data_from_pdp,
    output data_from_pdp_strobe,

    output tp3,
    //output [11:0] dt_wc,
    //output [11:0] dt_ca,
    //output [11:0] dtsa,
    //output [11:0] dtsb,
    output [14:0] mem_addr,

    // TC08 timing track write switch
    input swtm,
    output [20:0] tape_pos,

    // TC08 diagnostic panel
    output [2:0] usr,
    output [1:0] mr,
    output [3:0] fr,
    output eni, 

    output ef, 
    output mktk, 
    output end_h, 
    output sel, 
    output par, 
    output tim, 
    output [2:0] mf,
    output dtf, 

    output df, 
    output wr_en,
    output wc, 
    output uts, 
    output st_blk_mk, 
    output st_rev_ck, 
    output data, 
    output st_final, 
    output st_ck, 
    output st_idle, 
    output [2:0] mc,

    output [11:0] dtb,
    output [2:0] wb,
    output [5:0] lpb,

    output [1:0] c,
    output mkt, 
    output [9:1] w,

    output ind_swtm
);

/* verilator lint_off UNUSED */

//assign dtsa = {usr, mr, fr, eni, 2'b0};
//assign dtsb = {ef, mktk, end_h, sel, par, tim, mf, 2'b0, dtf};

wire rx_data = !tx_pad;
wire tx_data;

wire rx_pad = !tx_data;
wire tx_pad;

pullup(i_o_0_to_ac_l);
pullup(i_o_brk_rq_l);
pullup(i_o_int_rq_l);
pullup(i_o_skp_rq_l);
pullup(i_o_data_in);
pullup(i_o_1_to_ca_inh_l);
pullup(ea_00_l);
pullup(ea_01_l);
pullup(ea_02_l);
pullup(db_00_l);
pullup(db_01_l);
pullup(db_02_l);
pullup(db_03_l);
pullup(db_04_l);
pullup(db_05_l);
pullup(db_06_l);
pullup(db_07_l);
pullup(db_08_l);
pullup(db_09_l);
pullup(db_10_l);
pullup(db_11_l);
pullup(im_00_l);
pullup(im_01_l);
pullup(im_02_l);
pullup(im_03_l);
pullup(im_04_l);
pullup(im_05_l);
pullup(im_06_l);
pullup(im_07_l);
pullup(im_08_l);
pullup(im_09_l);
pullup(im_10_l);
pullup(im_11_l);

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
wire i_o_0_to_ac_l;
wire i_o_1_to_ca_inh_l;
wire i_o_brk_rq_l;
wire i_o_data_in;
wire i_o_int_rq_l;
wire i_o_skp_rq_l;
wire
    db_00_l, db_01_l, db_02_l, db_03_l, db_04_l, db_05_l,
    db_06_l, db_07_l, db_08_l, db_09_l, db_10_l, db_11_l,
    ea_00_l, ea_01_l, ea_02_l,
    im_00_l, im_01_l, im_02_l, im_03_l, im_04_l, im_05_l,
    im_06_l, im_07_l, im_08_l, im_09_l, im_10_l, im_11_l;
wire [11:0] db_l = {db_00_l, db_01_l, db_02_l, db_03_l, db_04_l, db_05_l,
                    db_06_l, db_07_l, db_08_l, db_09_l, db_10_l, db_11_l};
wire [2:0] ea_l = {ea_00_l, ea_01_l, ea_02_l};
wire [11:0] im_l = {im_00_l, im_01_l, im_02_l, im_03_l, im_04_l, im_05_l,
                    im_06_l, im_07_l, im_08_l, im_09_l, im_10_l, im_11_l};

wire i_o_bac_00 = io_bac[11];
wire i_o_bac_01 = io_bac[10];
wire i_o_bac_02 = io_bac[9];
wire i_o_bac_03 = io_bac[8];
wire i_o_bac_04 = io_bac[7];
wire i_o_bac_05 = io_bac[6];
wire i_o_bac_06 = io_bac[5];
wire i_o_bac_07 = io_bac[4];
wire i_o_bac_08 = io_bac[3];
wire i_o_bac_09 = io_bac[2];
wire i_o_bac_10 = io_bac[1];
wire i_o_bac_11 = io_bac[0];
wire i_o_bmb_00 = io_bmb[11];
wire i_o_bmb_01 = io_bmb[10];
wire i_o_bmb_02 = io_bmb[9];
wire i_o_bmb_03 = io_bmb[8];
wire i_o_bmb_04 = io_bmb[7];
wire i_o_bmb_05 = io_bmb[6];
wire i_o_bmb_06 = io_bmb[5];
wire i_o_bmb_07 = io_bmb[4];
wire i_o_bmb_08 = io_bmb[3];
wire i_o_bmb_09 = io_bmb[2];
wire i_o_bmb_10 = io_bmb[1];
wire i_o_bmb_11 = io_bmb[0];
wire i_o_bmb_03_l = io_bmb_l[8];
wire i_o_bmb_04_l = io_bmb_l[7];
wire i_o_bmb_05_l = io_bmb_l[6];
wire i_o_bmb_06_l = io_bmb_l[5];
wire i_o_bmb_07_l = io_bmb_l[4];
wire i_o_bmb_08_l = io_bmb_l[3];

assign mem_addr = {mem_ea, ma};
wire mem_start, mem_done_l, mem_strobe_l;
wire [2:0] mem_ea;
wire [11:0] mem;

mem core_mem(.clk(clk), .mem_start(mem_start), .mem_done_n(mem_done_l),
             .strobe_n(mem_strobe_l), .addr({mem_ea, ma}), 
             .data_in(mb), .data_out(mem));

/* verilator lint_off PINMISSING */
pdp8i pdp(clk, rst, dfsr, ifsr, sr, start, stop, load_addr, dep,
          exam, cont, step, sing_step, sing_inst, ion, pause, run,
          inst_and, inst_tad, inst_isz, inst_dca, inst_jms,
          inst_jmp, inst_iot, inst_opr, state_fetch, state_defer,
          state_execute, state_word_count, state_cur_addr, state_break,
          dataf, instf, pc, ma, mb, lac, sc, mq, tp3, rx_data, tx_data,
          mem_start, mem_done_l, mem_strobe_l, mem_ea, mem,
          iop_1, iop_2, iop_4, i_o_ts03, i_o_ts04, i_o_pwr_clr, i_o_addr_acc_l,
          i_o_bwc0_l, i_o_b_brk, i_o_b_run, io_bac, io_bmb, io_bmb_l, 
          1'b0, 1'b1, i_o_0_to_ac_l, i_o_1_to_ca_inh_l, i_o_brk_rq_l, 
          i_o_data_in, i_o_int_rq_l, i_o_skp_rq_l, ~12'o7754,
          db_l, ea_l, im_l);

wire t_single_unit_l = 1'b0;
wire t_write_ok_l;
wire t_00_l, t_01_l, t_02_l, t_03_l, t_04_l, t_05_l, t_06_l, t_07_l;
wire t_fwd_l, t_go_l, t_pwr_clr_l, t_rev_l, t_stop_l;
pullup(t_00_l);
pullup(t_01_l);
pullup(t_02_l);
pullup(t_03_l);
pullup(t_04_l);
pullup(t_05_l);
pullup(t_06_l);
pullup(t_07_l);
pullup(t_fwd_l);
pullup(t_go_l);
pullup(t_pwr_clr_l);
pullup(t_rev_l);
pullup(t_stop_l);
wire t_trk_rd_pos;
wire t_trk_rd_neg;
wire rdmk_rd_pos;
wire rdmk_rd_neg;
wire rdd_02_rd_pos;
wire rdd_02_rd_neg;
wire rdd_01_rd_pos;
wire rdd_01_rd_neg;
wire rdd_00_rd_pos;
wire rdd_00_rd_neg;
wire t_trk_wr_pos, t_trk_wr_neg, 
     rdmk_wr_pos, rdmk_wr_neg, 
     rdd_02_wr_pos, rdd_02_wr_neg, 
     rdd_01_wr_pos, rdd_01_wr_neg, 
     rdd_00_wr_pos, rdd_00_wr_neg;

assign usr = { usr_00, usr_01, usr_02 };
assign mr = { mr00, mr01 };
assign fr = { fr_00, fr_01, fr_02, fr_03 };
assign mf = { mf00, mf01, mf02 };
assign mc = { mc00, mc01, mc02 };
assign dtb = {
    dtb_00, dtb_01, dtb_02, dtb_03, dtb_04, dtb_05, 
    dtb_06, dtb_07, dtb_08, dtb_09, dtb_10, dtb_11 };
assign wb = { wb00, wb01, wb02 };
assign lpb = { lpb_00, lpb_01, lpb_02, lpb_03, lpb_04, lpb_05 };
assign c = { c00, c01 };
assign w = { w01, w02, w03, w04, w05, w06, w07, w08, w09 };

wire
    usr_00, usr_01, usr_02, 
    mr00, mr01, 
    fr_00, fr_01, fr_02, fr_03, 
    mf00, mf01, mf02, 
    mc00, mc01, mc02, 
    dtb_00, dtb_01, dtb_02, dtb_03, dtb_04, dtb_05, 
    dtb_06, dtb_07, dtb_08, dtb_09, dtb_10, dtb_11, 
    wb00, wb01, wb02, 
    lpb_00, lpb_01, lpb_02, lpb_03, lpb_04, lpb_05, 
    c00, c01, 
    w01, w02, w03, w04, w05, w06, w07, w08, w09;
/* lint_on */

tu55 tu55_1 (.clk(clk), .rst(rst), .t_fwd_l(t_fwd_l), .t_go_l(t_go_l),
    .write_enable(1'b1), .t_write_ok_l(t_write_ok_l),
    .tape_pos(tape_pos),

    .t_trk_wr_pos(t_trk_wr_pos), 
    .t_trk_wr_neg(t_trk_wr_neg), 
    .rdmk_wr_pos(rdmk_wr_pos),
    .rdmk_wr_neg(rdmk_wr_neg), 
    .rdd_02_wr_pos(rdd_02_wr_pos),
    .rdd_02_wr_neg(rdd_02_wr_neg), 
    .rdd_01_wr_pos(rdd_01_wr_pos),
    .rdd_01_wr_neg(rdd_01_wr_neg), 
    .rdd_00_wr_pos(rdd_00_wr_pos),
    .rdd_00_wr_neg(rdd_00_wr_neg),

    .t_trk_rd_pos(t_trk_rd_pos),
    .t_trk_rd_neg(t_trk_rd_neg),
    .rdmk_rd_pos(rdmk_rd_pos),
    .rdmk_rd_neg(rdmk_rd_neg),
    .rdd_02_rd_pos(rdd_02_rd_pos),
    .rdd_02_rd_neg(rdd_02_rd_neg),
    .rdd_01_rd_pos(rdd_01_rd_pos),
    .rdd_01_rd_neg(rdd_01_rd_neg),
    .rdd_00_rd_pos(rdd_00_rd_pos),
    .rdd_00_rd_neg(rdd_00_rd_neg)
);
    
tc08 tc (
    clk,
    rst,

    /***** from Posibus *****/
    iop_1, iop_2, iop_4,
    i_o_pwr_clr,
    i_o_ts03, i_o_ts04,
    i_o_addr_acc_l,
    i_o_bwc0_l,
    i_o_b_brk,
    i_o_b_run,
    i_o_bac_00, i_o_bac_01, i_o_bac_02, i_o_bac_03, i_o_bac_04, i_o_bac_05,
    i_o_bac_06, i_o_bac_07, i_o_bac_08, i_o_bac_09, i_o_bac_10, i_o_bac_11,
    i_o_bmb_00, i_o_bmb_01, i_o_bmb_02, i_o_bmb_03, i_o_bmb_04, i_o_bmb_05,
    i_o_bmb_06, i_o_bmb_07, i_o_bmb_08, i_o_bmb_09, i_o_bmb_10, i_o_bmb_11,
    i_o_bmb_03_l, i_o_bmb_04_l, i_o_bmb_05_l,
    i_o_bmb_06_l, i_o_bmb_07_l, i_o_bmb_08_l,

    /***** to Posibus *****/
    db_00_l, db_01_l, db_02_l, db_03_l, db_04_l, db_05_l,
    db_06_l, db_07_l, db_08_l, db_09_l, db_10_l, db_11_l,
    ea_00_l, ea_01_l, ea_02_l,
    i_o_0_to_ac_l,
    i_o_1_to_ca_inh_l,
    i_o_brk_rq_l,
    i_o_data_in,
    i_o_int_rq_l,
    i_o_skp_rq_l,
    im_00_l, im_01_l, im_02_l, im_03_l, im_04_l, im_05_l,
    im_06_l, im_07_l, im_08_l, im_09_l, im_10_l, im_11_l,

    /***** timing mark write switch *****/
    swtm,

    /***** to DECtape transport *****/
    t_00_l, t_01_l, t_02_l, t_03_l, t_04_l, t_05_l, t_06_l, t_07_l, // unit selector
    t_fwd_l, t_go_l, t_pwr_clr_l, t_rev_l, t_stop_l, // transport control

    /***** from DECtape transport *****/
    t_single_unit_l, t_write_ok_l, 

    /***** tape heads *****/
    t_trk_rd_pos, t_trk_rd_neg, 
    rdmk_rd_pos, rdmk_rd_neg, 
    rdd_02_rd_pos, rdd_02_rd_neg, 
    rdd_01_rd_pos, rdd_01_rd_neg, 
    rdd_00_rd_pos, rdd_00_rd_neg,
    t_trk_wr_pos, t_trk_wr_neg, 
    rdmk_wr_pos, rdmk_wr_neg, 
    rdd_02_wr_pos, rdd_02_wr_neg, 
    rdd_01_wr_pos, rdd_01_wr_neg, 
    rdd_00_wr_pos, rdd_00_wr_neg,

    /***** front panel lights *****/
    usr_00, usr_01, usr_02, 
    mr00, mr01, 
    fr_00, fr_01, fr_02, fr_03, 
    eni, 

    ef, 
    mktk, 
    end_h, 
    sel, 
    par, 
    tim, 
    mf00, mf01, mf02, 
    dtf, 

    df, 
    wr_en,
    wc, 
    uts, 
    st_blk_mk, 
    st_rev_ck, 
    data, 
    st_final, 
    st_ck, 
    st_idle, 
    mc00, mc01, mc02, 

    dtb_00, dtb_01, dtb_02, dtb_03, dtb_04, dtb_05, 
    dtb_06, dtb_07, dtb_08, dtb_09, dtb_10, dtb_11, 
    wb00, wb01, wb02, 
    lpb_00, lpb_01, lpb_02, lpb_03, lpb_04, lpb_05, 

    c00, c01, 
    mkt, 
    w01, w02, w03, w04, w05, w06, w07, w08, w09, 

    ind_swtm 
);
/* lint_on */

uart_tx #(.CLK_FREQ(100000000), .BAUD_RATE(9600)) tx(.clk(clk), .pad(tx_pad), 
          .data(data_to_pdp), .strobe(data_to_pdp_strobe), .ready(data_to_pdp_ready));

uart_rx #(.CLK_FREQ(100000000), .BAUD_RATE(9600)) rx(.clk(clk), .pad(rx_pad), 
          .data(data_from_pdp), .strobe(data_from_pdp_strobe));

endmodule

