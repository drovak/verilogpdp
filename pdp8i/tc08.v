module tc08 (
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

/* verilator lint_off UNUSED */

input clk;
input rst;

input i_o_bac_00;
input i_o_bac_01;
input i_o_bac_02;
input i_o_bac_03;
input i_o_bac_04;
input i_o_bac_05;
input i_o_bac_06;
input i_o_bac_07;
input i_o_bac_08;
input i_o_bac_09;
input i_o_bac_10;
input i_o_bac_11;
input iop_1;
input iop_2;
input iop_4;
input i_o_ts03;
input i_o_ts04;
input i_o_pwr_clr;

input i_o_bmb_00;
input i_o_bmb_01;
input i_o_bmb_02;
input i_o_bmb_03;
input i_o_bmb_03_l;
input i_o_bmb_04;
input i_o_bmb_04_l;
input i_o_bmb_05;
input i_o_bmb_05_l;
input i_o_bmb_06;
input i_o_bmb_06_l;
input i_o_bmb_07;
input i_o_bmb_07_l;
input i_o_bmb_08;
input i_o_bmb_08_l;
input i_o_bmb_09;
input i_o_bmb_10;
input i_o_bmb_11;

output im_00_l;
output im_01_l;
output im_02_l;
output im_03_l;
output im_04_l;
output im_05_l;
output im_06_l;
output im_07_l;
output im_08_l;
output im_09_l;
output im_10_l = 1'bz;
output im_11_l;
output i_o_skp_rq_l;
output i_o_int_rq_l;
output i_o_0_to_ac_l;
input i_o_b_run;

output i_o_brk_rq_l;
output i_o_data_in;
input i_o_b_brk;
input i_o_addr_acc_l;

output db_00_l;
output db_01_l;
output db_02_l;
output db_03_l;
output db_04_l;
output db_05_l;
output db_06_l;
output db_07_l;
output db_08_l;
output db_09_l;
output db_10_l;
output db_11_l;
output i_o_1_to_ca_inh_l;
input i_o_bwc0_l;
output ea_00_l;
output ea_01_l;
output ea_02_l;

output c00;
output c01;
output data;
output df;
output dtb_00;
output dtb_01;
output dtb_02;
output dtb_03;
output dtb_04;
output dtb_05;
output dtb_06;
output dtb_07;
output dtb_08;
output dtb_09;
output dtb_10;
output dtb_11;
output dtf;
output ef;
output eni;
output fr_00;
output fr_01;
output fr_02;
output fr_03;
output lpb_00;
output lpb_01;
output lpb_02;
output lpb_03;
output lpb_04;
output lpb_05;
output mc00;
output mc01;
output mc02;
output mkt;
output mr00;
output mr01;
output st_blk_mk;
output st_ck;
output st_final;
output st_rev_ck;
output usr_00;
output usr_01;
output usr_02;
output uts;
output wb00;
output wb01;
output wb02;
output wc;
output wr_en;
output st_idle;
output end_h;
output mf00;
output mf01;
output mf02;
output mktk;
output par;
output sel;
output tim;
output w01;
output w02;
output w03;
output w04;
output w05;
output w06;
output w07;
output w08;
output w09;

input swtm;
output ind_swtm = swtm;

output t_trk_wr_pos;
output t_trk_wr_neg;
output rdmk_wr_pos;
output rdmk_wr_neg;
output rdd_02_wr_pos;
output rdd_02_wr_neg;
output rdd_01_wr_pos;
output rdd_01_wr_neg;
output rdd_00_wr_pos;
output rdd_00_wr_neg;

input t_trk_rd_pos;
input t_trk_rd_neg;
input rdmk_rd_pos;
input rdmk_rd_neg;
input rdd_02_rd_pos;
input rdd_02_rd_neg;
input rdd_01_rd_pos;
input rdd_01_rd_neg;
input rdd_00_rd_pos;
input rdd_00_rd_neg;

input t_single_unit_l;
input t_write_ok_l;

output t_00_l;
output t_01_l;
output t_02_l;
output t_03_l;
output t_04_l;
output t_05_l;
output t_06_l;
output t_07_l;
output t_fwd_l;
output t_go_l;
output t_pwr_clr_l;
output t_rev_l;
output t_stop_l;

wire b10j2;
wire d16f2;
wire addr_acc;
wire addr_acc_l;
wire b_brk;
wire b_brk_l;
wire b_run;
wire b_xsta;
wire bac_00;
wire bac_00_l;
wire bac_01;
wire bac_01_l;
wire bac_02;
wire bac_02_l;
wire bac_03;
wire bac_03_l;
wire bac_04;
wire bac_04_l;
wire bac_05;
wire bac_05_l;
wire bac_06;
wire bac_06_l;
wire bac_07;
wire bac_07_l;
wire bac_08;
wire bac_08_l;
wire bac_09;
wire bac_09_l;
wire bac_10;
wire bac_10_l;
wire bac_11;
wire bac_11_l;
wire blk_in_sync;
wire blk_in_sync_l;
wire bmb_00;
wire bmb_00_l;
wire bmb_01;
wire bmb_01_l;
wire bmb_02;
wire bmb_02_l;
wire bmb_03;
wire bmb_03_l;
wire bmb_04;
wire bmb_04_l;
wire bmb_05;
wire bmb_05_l;
wire bmb_06;
wire bmb_06_l;
wire bmb_07;
wire bmb_07_l;
wire bmb_08;
wire bmb_08_l;
wire bmb_09;
wire bmb_09_l;
wire bmb_10;
wire bmb_10_l;
wire bmb_11;
wire bmb_11_l;
wire bmb_to_dtb;
wire bmr00;
wire bmr00_l;
wire bmr01;
wire bmr01_l;
wire c00;
wire c00_l;
wire c01;
wire c01_l;
wire ck00;
wire ck00_l;
wire ck01;
wire ck01_l;
wire clr_df_l;
wire clr_dtf_l;
wire comp_or_sh;
wire csta;
wire csta_l;
wire data;
wire data_l;
wire df;
wire df_l;
wire dtb_00;
wire dtb_00_l;
wire dtb_01;
wire dtb_01_l;
wire dtb_02;
wire dtb_02_l;
wire dtb_03;
wire dtb_03_l;
wire dtb_04;
wire dtb_04_l;
wire dtb_05;
wire dtb_05_l;
wire dtb_06;
wire dtb_06_l;
wire dtb_07;
wire dtb_07_l;
wire dtb_08;
wire dtb_08_l;
wire dtb_09;
wire dtb_09_l;
wire dtb_10;
wire dtb_10_l;
wire dtb_11;
wire dtb_11_l;
wire dtf;
wire dtf_l;
wire dtsf;
wire dtsf_l;
wire ef;
wire ef_l;
wire end_h;
wire end_l;
wire eni;
wire eni_l;
wire fr_00;
wire fr_00_l;
wire fr_01;
wire fr_01_l;
wire fr_02;
wire fr_02_l;
wire fr_03;
wire fr_03_l;
wire int_rq_l;
wire ldmf;
wire ldmf_l;
wire lpb_00;
wire lpb_00_l;
wire lpb_01;
wire lpb_01_l;
wire lpb_02;
wire lpb_02_l;
wire lpb_03;
wire lpb_03_l;
wire lpb_04;
wire lpb_04_l;
wire lpb_05;
wire lpb_05_l;
wire lpb_not_eq_1;
wire lpb_to_dtb;
wire m_stop_l;
wire mb_to_dtb_l;
wire mc00;
wire mc00_l;
wire mc01;
wire mc01_l;
wire mc02;
wire mc02_l;
wire mf00;
wire mf00_l;
wire mf01;
wire mf01_l;
wire mf02;
wire mf02_l;
wire mk_blk_end;
wire mk_blk_end_l;
wire mk_blk_mk;
wire mk_blk_mk_l;
wire mk_blk_start;
wire mk_blk_start_l;
wire mk_blk_sync;
wire mk_blk_sync_l;
wire mk_data;
wire mk_data_l;
wire mk_data_sync;
wire mk_data_sync_l;
wire mk_end;
wire mk_end_l;
wire mkt;
wire mkt_l;
wire mktk;
wire mktk_l;
wire move;
wire move_l;
wire mr00;
wire mr00_l;
wire mr01;
wire mr01_l;
wire n00;
wire n00_l;
wire n01;
wire n01_l;
wire n02;
wire n02_l;
wire n03;
wire n03_l;
wire n04;
wire n04_l;
wire n05;
wire n05_l;
wire n06;
wire n06_l;
wire n07;
wire n07_l;
wire n0_to_ac_l;
wire n0_to_dtb;
wire n0_to_dtb_l;
wire n0_to_ef;
wire n0_to_ef_l;
wire n0_to_lpb_l;
wire n0_to_sta;
wire n0_to_sta_l;
wire n0_to_state_l;
wire n0_to_w_l;
wire n1_to_df;
wire n1_to_dtf;
wire n3v_a09u1 = 1'b1;
wire n3v_b12u1 = 1'b1;
wire n3v_c08u1 = 1'b1;
wire n3v_c15u1 = 1'b1;
wire n3v_d09u1 = 1'b1;
wire n3v_d10u1 = 1'b1;
wire n76;
wire n76_l;
wire n76_or_77;
wire n77;
wire n77_l;
wire n_t_1x;
wire n_t_2x;
wire n_t_3x;
wire n_t_5x;
wire n_t_6x;
wire n_t_7x;
wire n_t_8x;
wire n_t_10x;
wire n_t_11x;
wire n_t_13x;
wire n_t_15x;
wire n_t_16x;
wire n_t_17x;
wire n_t_18x;
wire n_t_22x;
wire n_t_23x;
wire n_t_24x;
wire n_t_28x;
wire n_t_30x;
wire n_t_31x;
wire n_t_32x;
wire n_t_33x;
wire n_t_34x;
wire n_t_35x;
wire n_t_36x;
wire n_t_38x;
wire n_t_39x;
wire n_t_42x;
wire n_t_43x;
wire n_t_44x;
wire n_t_45x;
wire n_t_46x;
wire n_t_47x;
wire n_t_48x;
wire n_t_49x;
wire n_t_50x;
wire n_t_51x;
wire n_t_52x;
wire n_t_53x;
wire n_t_54x;
wire n_t_55x;
wire n_t_56x;
wire n_t_58x;
wire n_t_59x;
wire n_t_60x;
wire n_t_61x;
wire n_t_62x;
wire n_t_63x;
wire n_t_64x;
wire n_t_65x;
wire n_t_66x;
wire n_t_67x;
wire n_t_70x;
wire n_t_71x;
wire n_t_72x;
wire n_t_73x;
wire n_t_76x;
wire n_t_77x;
wire n_t_78x;
wire n_t_79x;
wire n_t_81x;
wire n_t_82x;
wire n_t_83x;
wire n_t_84x;
/* verilator lint_off UNOPTFLAT */
wire n_t_85x;
/* lint_on */
wire n_t_86x;
wire n_t_91x;
wire n_t_92x;
wire n_t_93x;
wire n_t_94x;
wire n_t_95x;
wire n_t_96x;
wire n_t_97x;
wire n_t_99x;
wire n_t_100x;
wire n_t_101x;
wire n_t_103x;
wire n_t_104x;
wire n_t_105x;
wire n_t_106x;
wire n_t_107x;
wire n_t_108x;
wire n_t_109x;
wire n_t_111x;
wire n_t_112x;
wire n_t_113x;
wire n_t_114x;
wire n_t_115x;
wire n_t_116x;
wire n_t_117x;
wire n_t_118x;
wire n_t_119x;
wire n_t_124x;
wire n_t_125x;
wire n_t_128x;
wire n_t_129x;
wire n_t_132x;
wire n_t_137x;
wire n_t_138x;
wire n_t_139x;
wire n_t_142x;
wire n_t_146x;
wire n_t_147x;
wire n_t_148x;
wire n_t_153x;
wire n_t_155x;
wire n_t_161x;
wire n_t_162x;
wire n_t_185x;
wire n_t_193x;
wire par;
wire par_l;
wire pc_or_es;
wire pc_or_es_l;
wire pwr_clr;
wire pwr_clr_l;
wire rd_en;
wire rd_en_lpb_00_02;
wire rd_en_lpb_03_05;
wire rd_or_wd;
wire rdd_00;
wire rdd_00_l;
wire rdd_01;
wire rdd_01_l;
wire rdd_02;
wire rdd_02_l;
wire rdmk;
wire rdmk_l;
wire read_all;
wire read_all_l;
wire read_data;
wire read_data_l;
wire rsta;
wire rsta_l;
wire rstb;
wire rstb_l;
wire se;
wire se_l;
wire search;
wire search_l;
wire sel;
wire sel_l;
wire sh_dtb;
wire sh_en;
wire sh_en_l;
wire sh_st;
wire sh_st_b;
wire shift_ck;
wire single_unit = !t_single_unit_l;
wire skp_rq_l;
wire sp_dy;
wire sp_dy_l;
wire st_blk_mk;
wire st_blk_mk_l;
wire st_ck;
wire st_ck_0p;
wire st_ck_0p_l;
wire st_ck_l;
wire st_data;
wire st_data_l;
wire st_final;
wire st_final_l;
wire st_idle;
wire st_idle_l;
wire st_rev_ck;
wire st_rev_ck_l;
wire swtm;
wire swtm_l;
wire sync;
wire sync_en;
wire sync_l;
wire sync_p_l;
wire t3;
wire t_00_l;
wire t_01_l;
wire t_02_l;
wire t_03_l;
wire t_04_l;
wire t_05_l;
wire t_06_l;
wire t_07_l;
wire t_fwd_l;
wire t_go_l;
wire t_pwr_clr_l;
wire t_rev_l;
wire t_single_unit_l;
wire t_stop_l;
wire t_trk;
wire t_trk_l;
wire t_write_ok_l;
wire tim;
wire tim_l;
wire tm_en;
wire tm_en_l;
wire tp00;
wire tp00_a;
wire tp00_a_l;
wire tp00_l;
wire tp01;
wire tp01_a;
wire tp01_a_l;
wire tp01_l;
wire tp0_xtlk_dy_l;
wire tp1_xtlk_dy_l;
wire ts03_l;
wire u_or_m_dy;
wire u_or_m_dy_l;
wire usr_00;
wire usr_00_l;
wire usr_01;
wire usr_01_l;
wire usr_02;
wire usr_02_l;
wire uts;
wire uts_l;
wire w01;
wire w01_w05;
wire w02;
wire w03;
wire w04;
wire w05;
wire w06;
wire w07;
wire w08;
wire w09;
wire w_inh;
wire w_inh_l;
wire w_or_uts;
wire wb00;
wire wb00_l;
wire wb01;
wire wb01_l;
wire wb02;
wire wb02_l;
wire wc0;
wire wc0_l;
wire wc;
wire wc_l;
wire wr_en;
wire wr_en_l;
wire write_all;
wire write_all_l;
wire write_data;
wire write_data_l;
wire write_ok = !t_write_ok_l;
wire write_ok_l;
wire write_ok_or_uts;
wire wrtm;
wire wrtm_l;
wire wrtm_or_fr03;
wire xor_to_lpb;
wire xsa_dy;
wire xsad;
wire xsad_l;
wire xsta;
wire xsta_l;

/*
m903 a02(
	.B1(i_o_bac_00), .D1(i_o_bac_01), .D2(i_o_bac_09), .E1(i_o_bac_02), 
	.E2(i_o_bac_10), .H1(i_o_bac_03), .H2(i_o_bac_11), .J1(i_o_bac_04), 
	.K2(iop_1), .L1(i_o_bac_05), .M1(i_o_bac_06), .M2(iop_2), 
	.P1(i_o_bac_07), .P2(iop_4), .S1(i_o_bac_08), .S2(i_o_ts03), 
	.T2(i_o_ts04), .V2(i_o_pwr_clr));
m903 a03(.B1(i_o_bmb_00), .D1(i_o_bmb_01), 
	.D2(i_o_bmb_06_l), .E1(i_o_bmb_02), .E2(i_o_bmb_06), .H1(i_o_bmb_03_l), 
	.H2(i_o_bmb_07_l), .J1(i_o_bmb_03), .K2(i_o_bmb_07), .L1(i_o_bmb_04_l), 
	.M1(i_o_bmb_04), .M2(i_o_bmb_08_l), .P1(i_o_bmb_05_l), .P2(i_o_bmb_08), 
	.S1(i_o_bmb_05), .S2(i_o_bmb_09), .T2(i_o_bmb_10), .V2(i_o_bmb_11));
m903 a04(
	.B1(im_00_l), .D1(im_01_l), .D2(im_09_l), .E1(im_02_l), 
	.E2(im_10_l), .H1(im_03_l), .H2(im_11_l), .J1(im_04_l), 
	.K2(i_o_skp_rq_l), .L1(im_05_l), .M1(im_06_l), .M2(i_o_int_rq_l), 
	.P1(im_07_l), .P2(i_o_0_to_ac_l), .S1(im_08_l), .S2(i_o_b_run));
m903 a05(
	.B1(1'b0), .D1(1'b0), .D2(1'b0), .E1(1'b0), 
	.H1(1'b0), .J1(1'b0), .K2(i_o_brk_rq_l), .L1(1'b0), 
	.M1(1'b0), .M2(i_o_data_in), .P1(1'b0), .P2(i_o_b_brk), 
	.S1(1'b0), .S2(i_o_addr_acc_l));
m903 a06(.B1(db_00_l), .D1(db_01_l), 
	.D2(db_09_l), .E1(db_02_l), .E2(db_10_l), .H1(db_03_l), 
	.H2(db_11_l), .J1(db_04_l), .K2(1'b0), .L1(db_05_l), 
	.M1(db_06_l), .M2(i_o_1_to_ca_inh_l), .P1(db_07_l), .P2(i_o_bwc0_l), 
	.S1(db_08_l), .S2(ea_02_l), .T2(ea_01_l), .V2(ea_00_l));
*/
/* verilator lint_off PINMISSING */
m161 a07(
	.D1(n00_l), .D2(n00), .E1(n01_l), .E2(n01), 
	.F1(n04_l), .F2(n04), .H1(n06_l), .H2(n06), 
	.J1(n02_l), .J2(n02), .L1(n07_l), .L2(n07), 
	.M1(n05_l), .M2(n05), .N1(n03_l), .N2(n03), 
	.S1(n3v_a09u1), .S2(n3v_a09u1), .T2(n3v_a09u1), .U1(1'b0), 
	.U2(usr_01), .V1(usr_02), .V2(usr_00));
m206 a08(.clk(clk), .A1(n0_to_ef_l), 
	.B1(tp00), .C1(mk_end), .D1(n3v_a09u1), .D2(xsa_dy), 
	.E1(end_h), .E2(n_t_83x), .F1(end_l), .F2(n3v_a09u1), 
	.H1(n1_to_df), .H2(sel), .J1(dtf), .J2(sel_l), 
	.K1(n_t_132x), .K2(n3v_a09u1), .L1(tim), .L2(mc01), 
	.M1(tim_l), .M2(n_t_107x), .N1(n_t_128x), .N2(n0_to_ef_l), 
	.P1(n_t_125x), .P2(mktk_l), .R1(n0_to_ef_l), .R2(mktk), 
	.S1(par_l), .S2(write_all), .T2(1'b0), .U1(par), 
	.U2(n_t_33x), .V1(w_inh), .V2(w_inh_l));
m117 a09(.A1(mk_blk_start_l), 
	.B1(mk_data_l), .C1(mk_blk_end_l), .D1(mk_end_l), .D2(st_blk_mk_l), 
	.E1(n_t_105x), .E2(st_idle_l), .F1(n_t_35x), .F2(move_l), 
	.H1(se_l), .H2(n_t_106x), .J1(n_t_46x), .J2(n_t_107x), 
	.K1(single_unit), .K2(mktk_l), .L1(n_t_83x), .L2(tim_l), 
	.M1(st_blk_mk_l), .M2(end_l), .N1(st_idle_l), .N2(sel_l), 
	.P1(rd_or_wd), .P2(n_t_161x), .R1(xsad), .R2(write_data), 
	.S1(n_t_138x), .S2(st_final), .T2(mk_blk_end), .U2(n_t_111x), 
	.V2(n_t_114x));
m113 a10(.A1(blk_in_sync_l), .B1(n_t_85x), .C1(n_t_84x), 
	.D1(n_t_84x), .D2(bac_10_l), .E1(uts), .E2(b_xsta), 
	.F1(n_t_85x), .F2(n_t_153x), .H1(fr_01), .H2(pwr_clr_l), 
	.J1(write_ok_l), .J2(n_t_153x), .K1(n_t_46x), .K2(n0_to_ef), 
	.L1(read_data), .L2(csta_l), .M1(lpb_not_eq_1), .M2(pwr_clr_l), 
	.N1(n_t_125x), .N2(n0_to_sta), .P1(st_ck), .P2(df), 
	.R1(mc00_l), .R2(sh_dtb), .S1(n_t_124x), .S2(n_t_139x), 
	.T2(n_t_139x), .U2(n_t_138x), .V2(n_t_137x));
m111 a11(.A1(n_t_105x), 
	.B1(n_t_106x), .C1(n_t_124x), .D1(n_t_137x), .D2(n_t_128x), 
	.E1(n_t_132x), .E2(n0_to_ef), .F1(n_t_161x), .F2(n0_to_ef_l), 
	.H1(n_t_162x), .H2(pc_or_es), .J1(ef), .J2(pc_or_es_l), 
	.K1(ef_l), .K2(xsad_l), .L1(n0_to_dtb_l), .L2(xsad), 
	.M1(n0_to_dtb), .M2(sh_en_l), .N1(n0_to_sta), .N2(sh_en), 
	.P1(n0_to_sta_l), .P2(n_t_23x), .R1(n_t_3x), .R2(tp0_xtlk_dy_l), 
	.S1(m_stop_l), .S2(n_t_114x), .T2(lpb_to_dtb), .U1(clr_df_l), 
	.U2(n_t_22x), .V1(n_t_58x), .V2(tp1_xtlk_dy_l));
m113 a12(.A1(pwr_clr_l), 
	.B1(n_t_162x), .C1(pc_or_es), .D1(n_t_162x), .D2(comp_or_sh), 
	.E1(par_l), .E2(sh_en), .F1(ef), .F2(n_t_66x), 
	.H1(eni), .H2(fr_01_l), .J1(n_t_7x), .J2(tp01), 
	.K1(int_rq_l), .K2(n_t_64x), .L1(ef_l), .L2(c00), 
	.M1(dtf_l), .M2(c01), .N1(n_t_7x), .N2(n_t_43x), 
	.P1(n_t_7x), .P2(c00_l), .R1(dtsf), .R2(c01_l), 
	.S1(skp_rq_l), .S2(n_t_45x), .T2(n_t_43x), .U2(n_t_45x), 
	.V2(sh_en_l));
m302 #(.DELAY_COUNT_F2(1000), .DELAY_COUNT_T2(1000)) a14(.clk(clk), .F2(n_t_23x), .H2(n_t_13x), .J2(n_t_13x), 
	.K2(n_t_13x), .M2(n_t_18x), .N2(n_t_18x), .P2(n_t_18x), 
	.T2(n_t_22x));
m627 a15(.A1(w_or_uts), .B1(tp1_xtlk_dy_l), .C1(n_t_16x), 
	.D1(n_t_16x), .D2(n_t_31x), .E1(tp00_l), .E2(n_t_31x), 
	.F1(tp00_l), .F2(tp0_xtlk_dy_l), .H1(tp00_l), .H2(w_or_uts), 
	.J1(tp00_l), .J2(tp01_l), .K1(tp00_l), .K2(tp01_l), 
	.L1(tp00), .L2(tp01_l), .M1(tp00_a_l), .M2(tp01_l), 
	.N1(tp00_a_l), .N2(tp01_l), .P1(tp00_a_l), .P2(tp01), 
	.R1(tp00_a_l), .R2(tp01_a_l), .S1(tp00_a), .S2(tp01_a_l), 
	.T2(tp01_a_l), .U2(tp01_a_l), .V2(tp01_a));
m602 a16(.clk(clk), .F2(n_t_15x), 
	.H2(n_t_5x), .J2(tp0_xtlk_dy_l), .K2(tp0_xtlk_dy_l), .L2(tp00_a_l), 
	.M2(tp00), .N2(tp00), .P2(tp00));
g888 a18(.clk(clk), .D2(t_trk_rd_pos), 
	.E2(t_trk_rd_neg), .J2(t_trk_wr_pos), .K2(t_trk_wr_neg), .N2(ck00_l), 
	.P2(ck00), .R2(tm_en), .U2(t_trk), .V2(t_trk_l));
g888 a20(.clk(clk), 
	.D2(rdd_02_rd_pos), .E2(rdd_02_rd_neg), .J2(rdd_02_wr_pos), .K2(rdd_02_wr_neg), 
	.N2(wb02), .P2(wb02_l), .R2(wr_en), .U2(rdd_02), 
	.V2(rdd_02_l));
g888 a21(.clk(clk), .D2(rdd_00_rd_pos), .E2(rdd_00_rd_neg), .J2(rdd_00_wr_pos), 
	.K2(rdd_00_wr_neg), .N2(wb00), .P2(wb00_l), .R2(wr_en), 
	.U2(rdd_00), .V2(rdd_00_l));
/*
m502 a22(.D2(write_ok), .H2(t_write_ok_l));
*/
m633 a23(
	.A1(bmr01_l), .B1(bmr01), .C1(1'b0), .D1(t_go_l), 
	.D2(n02_l), .E1(t_stop_l), .E2(n03_l), .F1(bmr00), 
	.F2(1'b0), .H1(bmr00_l), .H2(t_02_l), .J1(1'b0), 
	.J2(t_03_l), .K1(t_fwd_l), .K2(n04_l), .L1(t_rev_l), 
	.L2(n05_l), .M1(pwr_clr_l), .M2(1'b0), .N1(n01_l), 
	.N2(t_04_l), .P1(1'b0), .P2(t_05_l), .R1(t_pwr_clr_l), 
	.R2(n06_l), .S1(t_01_l), .S2(n07_l), .T2(1'b0), 
	.U2(t_06_l), .V2(t_07_l));
/*
g821 ab01(.AF1(1'b1), .AH1(1'b1), 
	.AJ1(1'b1), .AK1(1'b1));
*/
m623 b02(.A1(dtb_00_l), .B1(dtb_01_l), 
	.C1(b_brk_l), .D1(db_00_l), .D2(dtb_06_l), .E1(db_01_l), 
	.E2(dtb_07_l), .F1(dtb_02_l), .F2(b_brk_l), .H1(dtb_03_l), 
	.H2(db_06_l), .J1(b_brk_l), .J2(db_07_l), .K1(db_02_l), 
	.K2(dtb_08_l), .L1(db_03_l), .L2(dtb_09_l), .M1(dtb_04_l), 
	.M2(b_brk_l), .N1(dtb_05_l), .N2(db_08_l), .P1(b_brk_l), 
	.P2(db_09_l), .R1(db_04_l), .R2(dtb_10_l), .S1(db_05_l), 
	.S2(dtb_11_l), .T2(b_brk_l), .U2(db_10_l), .V2(db_11_l));
m623 b03(
	.A1(usr_00_l), .B1(usr_01_l), .C1(rsta_l), .D1(im_00_l), 
	.D2(fr_01_l), .E1(im_01_l), .E2(fr_02_l), .F1(usr_02_l), 
	.F2(rsta_l), .H1(mr00_l), .H2(im_06_l), .J1(rsta_l), 
	.J2(im_07_l), .K1(im_02_l), .K2(fr_03_l), .L1(im_03_l), 
	.L2(eni_l), .M1(mr01_l), .M2(rsta_l), .N1(fr_00_l), 
	.N2(im_08_l), .P1(rsta_l), .P2(im_09_l), .R1(im_04_l), 
	.S1(im_05_l));
m623 b04(.A1(ef_l), .B1(mktk_l), .C1(rstb_l), 
	.D1(im_00_l), .D2(mf00_l), .E1(im_01_l), .E2(mf01_l), 
	.F1(end_l), .F2(rstb_l), .H1(sel_l), .H2(im_06_l), 
	.J1(rstb_l), .J2(im_07_l), .K1(im_02_l), .K2(mf02_l), 
	.L1(im_03_l), .L2(dtf_l), .M1(par_l), .M2(rstb_l), 
	.N1(tim_l), .N2(im_08_l), .P1(rstb_l), .P2(im_11_l), 
	.R1(im_04_l), .S1(im_05_l));
m623 b05(.A1(df_l), .B1(int_rq_l), 
	.C1(1'b0), .D1(i_o_brk_rq_l), .D2(mf02_l), .E1(i_o_int_rq_l), 
	.E2(fr_01_l), .F1(skp_rq_l), .F2(1'b0), .H1(n0_to_ac_l), 
	.H2(ea_02_l), .J1(1'b0), .J2(i_o_data_in), .K1(i_o_skp_rq_l), 
	.K2(search_l), .L1(i_o_0_to_ac_l), .M1(mf00_l), .M2(1'b0), 
	.N1(mf01_l), .N2(i_o_1_to_ca_inh_l), .P1(1'b0), .R1(ea_00_l), 
	.S1(ea_01_l));
m111 b06(.A1(bac_00_l), .B1(bac_00), .C1(bac_08_l), 
	.D1(bac_01_l), .D2(bac_08), .E1(bac_01), .E2(bac_09_l), 
	.F1(bac_02_l), .F2(bac_09), .H1(bac_02), .H2(bac_10_l), 
	.J1(bac_03_l), .J2(bac_10), .K1(bac_03), .K2(bac_11_l), 
	.L1(bac_04_l), .L2(bac_11), .M1(bac_04), .N1(bac_05_l), 
	.P1(bac_05), .P2(swtm), .R1(bac_06_l), .R2(swtm_l), 
	.S1(bac_06), .S2(n_t_1x), .T2(n0_to_ac_l), .U1(bac_07), 
	.V1(bac_07_l));
m207 b07(.clk(clk), .rst(rst), .A1(n0_to_sta_l), .B1(xsta), .C1(bac_00), 
	.D1(bac_00), .D2(xsta), .E1(usr_00), .E2(bac_01), 
	.F1(usr_00_l), .F2(bac_01), .H1(xsta), .H2(usr_01), 
	.J1(bac_02), .J2(usr_01_l), .K1(bac_02), .K2(n0_to_sta_l), 
	.L1(usr_02), .L2(xsta), .M1(usr_02_l), .M2(bac_03), 
	.N1(xsta), .N2(bac_03), .P1(bac_05), .P2(mr00), 
	.R1(bac_05), .R2(mr00_l), .S1(fr_00), .S2(xsta), 
	.T2(bac_06), .U1(fr_00_l), .U2(bac_06), .V1(fr_01_l), 
	.V2(fr_01));
m113 b08(.A1(bmb_to_dtb), .B1(bmb_06), .C1(n_t_97x), 
	.D1(bmb_to_dtb), .D2(bmb_to_dtb), .E1(bmb_07), .E2(bmb_08), 
	.F1(n_t_112x), .F2(n_t_113x), .H1(bmb_to_dtb), .H2(wrtm_l), 
	.J1(bmb_11), .J2(fr_03_l), .K1(n_t_92x), .K2(wrtm_or_fr03), 
	.L1(bmb_to_dtb), .L2(read_data_l), .M1(bmb_09), .M2(write_data_l), 
	.N1(n_t_73x), .N2(rd_or_wd), .P1(bmb_to_dtb), .P2(ldmf_l), 
	.R1(bmb_10), .R2(xsta_l), .S1(n_t_91x), .S2(n_t_1x), 
	.T2(addr_acc_l), .U2(pwr_clr_l), .V2(n_t_58x));
m206 b09(.clk(clk), .A1(n0_to_dtb_l), 
	.B1(sh_dtb), .C1(dtb_09), .D1(n_t_97x), .D2(sh_dtb), 
	.E1(dtb_06), .E2(rdd_02), .F1(dtb_06_l), .F2(n_t_92x), 
	.H1(sh_dtb), .H2(dtb_11), .J1(dtb_11), .J2(dtb_11_l), 
	.K1(n_t_113x), .K2(n0_to_dtb_l), .L1(dtb_08), .L2(sh_dtb), 
	.M1(dtb_08_l), .M2(rdd_00), .N1(sh_dtb), .N2(n_t_73x), 
	.P1(rdd_01), .P2(dtb_09), .R1(n_t_91x), .R2(dtb_09_l), 
	.S1(dtb_10), .S2(sh_dtb), .T2(dtb_10), .U1(dtb_10_l), 
	.U2(n_t_112x), .V1(dtb_07_l), .V2(dtb_07));
m627 b10(.A1(n_t_66x), 
	.B1(n_t_66x), .C1(n_t_64x), .D1(n_t_64x), .D2(sync), 
	.E1(sh_dtb), .E2(sync), .F1(n_t_77x), .F2(tp00), 
	.H1(tp00_a), .H2(tp00), .J1(c01), .J2(b10j2), 
	.K1(n_t_78x), .L1(n0_to_dtb_l), .M1(wc), .N1(tp00), 
	.P1(c01_l), .R1(mkt_l), .R2(b_brk), .S1(n_t_33x), 
	.S2(b_brk), .T2(b_brk), .U2(b_brk), .V2(b_brk_l));
m115 b11(
	.A1(wrtm), .B1(swtm), .C1(write_ok), .D1(n_t_56x), 
	.D2(n_t_55x), .E1(n_t_70x), .E2(n_t_49x), .F1(wr_en_l), 
	.F2(n_t_56x), .H1(n_t_72x), .H2(n_t_47x), .J1(n_t_77x), 
	.J2(read_data_l), .K1(wc), .K2(search_l), .L1(w_inh_l), 
	.L2(n_t_86x), .M1(write_all), .M2(sync_en), .N1(n_t_72x), 
	.N2(b_run), .P1(mc01_l), .P2(n0_to_sta_l), .R1(write_data), 
	.R2(pc_or_es_l), .S1(st_rev_ck), .S2(n_t_3x), .T2(mc00_l), 
	.U1(n_t_70x), .U2(mc02), .V1(n_t_82x), .V2(c01));
m117 b12(
	.A1(st_data), .B1(write_data), .C1(dtf_l), .D1(write_ok_or_uts), 
	.D2(rd_or_wd), .E1(n_t_55x), .E2(fr_00), .F1(write_all), 
	.F2(wc_l), .H1(w_inh_l), .H2(st_ck_0p), .J1(df_l), 
	.J2(n_t_62x), .K1(write_ok_or_uts), .K2(n_t_60x), .L1(n_t_49x), 
	.L2(n_t_28x), .M1(n_t_10x), .M2(n_t_61x), .N1(data_l), 
	.N2(n_t_62x), .P1(write_data), .P2(n1_to_dtf), .R1(n_t_11x), 
	.R2(c00), .S1(n_t_48x), .S2(mkt), .T2(tp01_a), 
	.U2(n_t_44x), .V2(n_t_51x));
m206 b13(.clk(clk), .A1(sync_p_l), .B1(tp00), 
	.C1(mc02_l), .D1(n3v_b12u1), .D2(tp00), .E1(mc00), 
	.E2(mc00), .F1(mc00_l), .F2(n3v_b12u1), .H1(tp00), 
	.H2(mc01), .J1(mc01), .J2(mc01_l), .K1(n3v_b12u1), 
	.K2(sync_p_l), .L1(mc02), .L2(tp01_l), .M1(mc02_l), 
	.M2(c01_l), .N1(tp00_l), .N2(n_t_63x), .P1(c00_l), 
	.P2(c01), .R1(n3v_a09u1), .R2(c01_l), .S1(c00), 
	.S2(c00_l), .T2(mkt_l), .U1(c00_l), .U2(n3v_a09u1), 
	.V1(mkt_l), .V2(mkt));
m206 b14(.clk(clk), .A1(n3v_b12u1), .B1(xsa_dy), 
	.C1(mr01_l), .D1(m_stop_l), .E1(bmr01_l), .F1(bmr01), 
	.K2(n3v_b12u1), .L2(xsa_dy), .M2(mr00), .N1(n_t_17x), 
	.N2(n3v_b12u1), .P1(ck01), .P2(bmr00), .R1(n3v_b12u1), 
	.R2(bmr00_l), .S1(ck00), .S2(n_t_17x), .T2(ck00_l), 
	.U1(ck00_l), .U2(n3v_b12u1), .V1(ck01_l), .V2(ck01));
m113 b15(
	.D1(tm_en_l), .D2(tm_en_l), .E1(t_trk_l), .E2(t_trk), 
	.F1(n_t_13x), .F2(n_t_18x), .H1(c00_l), .J1(tp00), 
	.K1(n_t_63x), .L1(mkt), .M1(fr_01), .N1(n_t_71x), 
	.P1(uts), .P2(n_t_85x), .R1(write_ok), .R2(fr_03), 
	.S1(n_t_32x), .S2(n_t_86x));
m602 b16(.clk(clk), .F2(n_t_30x), .H2(tp1_xtlk_dy_l), 
	.J2(tp1_xtlk_dy_l), .K2(n_t_24x), .L2(tp01_a_l), .M2(tp01), 
	.N2(tp01), .P2(tp01));
g888 b18(.clk(clk), .D2(rdmk_rd_pos), .E2(rdmk_rd_neg), 
	.J2(rdmk_wr_pos), .K2(rdmk_wr_neg), .N2(wb00), .P2(wb00_l), 
	.R2(tm_en), .U2(rdmk), .V2(rdmk_l));
g888 b20(.clk(clk), .D2(rdd_01_rd_pos), 
	.E2(rdd_01_rd_neg), .J2(rdd_01_wr_pos), .K2(rdd_01_wr_neg), .N2(wb01), 
	.P2(wb01_l), .R2(wr_en), .U2(rdd_01), .V2(rdd_01_l));
/*
g879 b21(
	.T2(t_single_unit_l), .U2(single_unit));
*/
m633 b22(.S2(n00_l), .T2(1'b0), 
	.V2(t_00_l));
m101 c01_(.A1(i_o_b_run), .B1(b_run), .C1(n3v_c08u1), 
	.D1(i_o_b_brk), .E1(b_brk), .F1(i_o_bwc0_l), .H1(wc0));
m101 c02(
	.A1(i_o_bmb_00), .B1(bmb_00_l), .C1(n3v_c08u1), .D1(i_o_bmb_01), 
	.E1(bmb_01_l), .E2(i_o_bmb_08), .F1(i_o_bmb_02), .F2(bmb_08_l), 
	.H1(bmb_02_l), .H2(i_o_bmb_09), .J1(i_o_bmb_03), .J2(bmb_09_l), 
	.K1(bmb_03_l), .K2(i_o_bmb_10), .L1(i_o_bmb_04), .L2(bmb_10_l), 
	.M1(bmb_04_l), .M2(i_o_bmb_11), .N1(i_o_bmb_05), .N2(bmb_11_l), 
	.P1(bmb_05_l), .R1(i_o_bmb_06), .S1(bmb_06_l), .U1(bmb_07_l), 
	.U2(i_o_addr_acc_l), .V1(i_o_bmb_07), .V2(addr_acc));
m101 c03(.A1(i_o_bac_00), 
	.B1(bac_00_l), .C1(n76_or_77), .D1(i_o_bac_01), .E1(bac_01_l), 
	.E2(i_o_bac_08), .F1(i_o_bac_02), .F2(bac_08_l), .H1(bac_02_l), 
	.H2(i_o_bac_09), .J1(i_o_bac_03), .J2(bac_09_l), .K1(bac_03_l), 
	.K2(i_o_bac_10), .L1(i_o_bac_04), .L2(bac_10_l), .M1(bac_04_l), 
	.M2(i_o_bac_11), .N1(i_o_bac_05), .N2(bac_11_l), .P1(bac_05_l), 
	.R1(i_o_bac_06), .S1(bac_06_l), .U1(bac_07_l), .V1(i_o_bac_07));
m103 c04(
	.A1(rsta), .B1(rsta_l), .C1(csta), .D1(csta_l), 
	.D2(i_o_bmb_03), .E1(xsta), .E2(i_o_bmb_04), .F1(xsta_l), 
	.F2(i_o_bmb_05), .H1(i_o_ts03), .H2(i_o_bmb_06), .J1(n3v_c08u1), 
	.J2(i_o_bmb_07), .K1(ts03_l), .K2(i_o_bmb_08_l), .L2(n3v_c08u1), 
	.N2(n3v_c08u1), .P2(iop_1), .R2(iop_2), .S2(iop_4), 
	.U2(n3v_c08u1), .V2(n76));
m103 c05(.A1(dtsf), .B1(dtsf_l), 
	.C1(rstb), .D1(rstb_l), .D2(i_o_bmb_03), .E1(ldmf), 
	.E2(i_o_bmb_04), .F1(ldmf_l), .F2(i_o_bmb_05), .H1(i_o_pwr_clr), 
	.H2(i_o_bmb_06), .J1(n3v_c08u1), .J2(i_o_bmb_07), .K1(pwr_clr_l), 
	.K2(i_o_bmb_08), .L2(n3v_c08u1), .N2(n3v_c08u1), .P2(iop_1), 
	.R2(iop_2), .S2(iop_4), .U2(n3v_c08u1), .V2(n77));
m111 c06(
	.A1(bmb_00_l), .B1(bmb_00), .C1(bmb_08_l), .D1(bmb_01_l), 
	.D2(bmb_08), .E1(bmb_01), .E2(bmb_09_l), .F1(bmb_02_l), 
	.F2(bmb_09), .H1(bmb_02), .H2(bmb_10_l), .J1(bmb_03_l), 
	.J2(bmb_10), .K1(bmb_03), .K2(bmb_11_l), .L1(bmb_04_l), 
	.L2(bmb_11), .M1(bmb_04), .M2(wc0), .N1(bmb_05_l), 
	.N2(wc0_l), .P1(bmb_05), .P2(pwr_clr_l), .R1(bmb_06_l), 
	.R2(pwr_clr), .S1(bmb_06), .S2(n76), .T2(n76_l), 
	.U1(bmb_07), .U2(n77), .V1(bmb_07_l), .V2(n77_l));
m207 c07(.clk(clk), .rst(rst),
	.A1(n0_to_sta_l), .B1(xsta), .C1(bac_07), .D1(bac_07), 
	.D2(xsta), .E1(fr_02), .E2(bac_08), .F1(fr_02_l), 
	.F2(bac_08), .H1(xsta), .H2(fr_03), .J1(bac_09), 
	.J2(fr_03_l), .K1(bac_09), .K2(m_stop_l), .L1(eni), 
	.L2(xsta), .M1(eni_l), .M2(bac_04), .N2(bac_04), 
	.P2(mr01), .R2(mr01_l));
m121 c08(.A1(bmb_to_dtb), .B1(bmb_00), 
	.C1(lpb_to_dtb), .D1(lpb_00), .D2(bmb_to_dtb), .E1(n_t_146x), 
	.E2(bmb_03), .F1(bmb_to_dtb), .F2(lpb_to_dtb), .H1(bmb_01), 
	.H2(lpb_03), .J1(lpb_to_dtb), .J2(n_t_104x), .K1(lpb_01), 
	.K2(bmb_to_dtb), .L1(n_t_147x), .L2(bmb_04), .M1(bmb_to_dtb), 
	.M2(lpb_to_dtb), .N1(bmb_02), .N2(lpb_04), .P1(lpb_to_dtb), 
	.P2(n_t_142x), .R1(lpb_02), .R2(bmb_to_dtb), .S1(n_t_148x), 
	.S2(bmb_05), .T2(lpb_to_dtb), .U2(lpb_05), .V2(n_t_129x));
m206 c09(.clk(clk),
	.A1(n0_to_dtb_l), .B1(sh_dtb), .C1(dtb_03), .D1(n_t_146x), 
	.D2(sh_dtb), .E1(dtb_00), .E2(dtb_04), .F1(dtb_00_l), 
	.F2(n_t_147x), .H1(sh_dtb), .H2(dtb_01), .J1(dtb_05), 
	.J2(dtb_01_l), .K1(n_t_148x), .K2(n0_to_dtb_l), .L1(dtb_02), 
	.L2(sh_dtb), .M1(dtb_02_l), .M2(dtb_06), .N1(sh_dtb), 
	.N2(n_t_104x), .P1(dtb_07), .P2(dtb_03), .R1(n_t_142x), 
	.R2(dtb_03_l), .S1(dtb_04), .S2(sh_dtb), .T2(dtb_08), 
	.U1(dtb_04_l), .U2(n_t_129x), .V1(dtb_05_l), .V2(dtb_05));
m121 c10(
	.A1(sh_en), .B1(dtb_00), .C1(sh_en_l), .D1(wb00_l), 
	.D2(rd_en_lpb_00_02), .E1(n_t_185x), .E2(xor_to_lpb), .F1(sh_en), 
	.F2(xor_to_lpb), .H1(dtb_01), .H2(wr_en), .J1(sh_en_l), 
	.J2(n_t_108x), .K1(wb01_l), .K2(wrtm), .L1(n_t_155x), 
	.L2(swtm_l), .M1(sh_en), .M2(wrtm_l), .N1(dtb_02), 
	.N2(swtm), .P1(sh_en_l), .P2(n_t_35x), .R1(wb02_l), 
	.R2(rd_en_lpb_03_05), .S1(n_t_193x), .S2(xor_to_lpb), .T2(xor_to_lpb), 
	.U2(wr_en), .V2(n_t_109x));
m113 c11(.A1(st_rev_ck), .B1(mc01_l), 
	.C1(n_t_10x), .D1(st_final), .D2(search), .E1(mc01), 
	.E2(blk_in_sync), .F1(n_t_11x), .F2(n_t_54x), .H1(read_data), 
	.H2(wr_en_l), .J1(rd_en), .J2(tp01), .K1(n_t_42x), 
	.K2(n_t_118x), .L1(n_t_42x), .L2(data_l), .M1(read_all_l), 
	.M2(st_final_l), .N1(n_t_44x), .N2(rd_en), .P1(n_t_48x), 
	.P2(b_xsta), .R1(n0_to_dtb), .R2(bac_11_l), .S1(n_t_52x), 
	.S2(n_t_65x), .T2(n_t_65x), .U2(pwr_clr_l), .V2(n_t_59x));
m115 c12(
	.A1(u_or_m_dy_l), .B1(mr01), .C1(tm_en_l), .D1(n_t_81x), 
	.D2(wr_en), .E1(n_t_52x), .E2(tp00_a), .F1(n_t_51x), 
	.F2(c01_l), .H1(n_t_54x), .H2(n_t_117x), .J1(n1_to_df), 
	.J2(wr_en_l), .K1(fr_00_l), .K2(tm_en_l), .L1(n1_to_df), 
	.L2(uts_l), .M1(wrtm_or_fr03), .M2(w_or_uts), .N1(n_t_60x), 
	.N2(wrtm), .P1(fr_00_l), .P2(swtm), .R1(rd_or_wd), 
	.R2(u_or_m_dy_l), .S1(st_ck_0p), .S2(n_t_50x), .T2(wc_l), 
	.U1(n_t_28x), .U2(fr_00), .V1(n_t_61x), .V2(wrtm_or_fr03));
m111 c13(
	.A1(st_ck_0p_l), .B1(st_ck_0p), .C1(n_t_47x), .D1(st_rev_ck), 
	.D2(n_t_36x), .E1(st_rev_ck_l), .E2(st_blk_mk), .F1(data), 
	.F2(st_blk_mk_l), .H1(data_l), .H2(st_data), .J1(st_ck), 
	.J2(st_data_l), .K1(st_ck_l), .K2(st_idle), .L1(st_final), 
	.L2(st_idle_l), .M1(st_final_l), .M2(n_t_81x), .N1(tm_en), 
	.N2(n_t_79x), .P1(tm_en_l), .P2(n_t_119x), .R1(blk_in_sync_l), 
	.R2(rd_en_lpb_03_05), .S1(blk_in_sync), .S2(n_t_116x), .T2(rd_en_lpb_00_02), 
	.U1(clr_dtf_l), .V1(n_t_59x));
m206 c14(.clk(clk), .A1(n3v_c15u1), .B1(comp_or_sh), 
	.C1(n_t_185x), .D1(n3v_c15u1), .D2(comp_or_sh), .E1(wb00_l), 
	.E2(n_t_155x), .F1(wb00), .F2(n3v_c15u1), .H1(comp_or_sh), 
	.H2(wb01_l), .J1(n_t_193x), .J2(wb01), .K1(n3v_c15u1), 
	.K2(n3v_c15u1), .L1(wb02_l), .L2(n_t_76x), .M1(wb02), 
	.M2(sp_dy_l), .N1(mkt_l), .N2(n_t_79x), .P1(n_t_36x), 
	.P2(uts_l), .R1(pwr_clr_l), .R2(uts), .S1(wr_en_l), 
	.U1(wr_en));
m113 c15(.A1(wr_en), .B1(tp01), .C1(n_t_38x), 
	.D1(fr_01), .D2(wr_en_l), .E1(tp00), .E2(c00), 
	.F1(n_t_39x), .F2(n_t_119x), .H1(n_t_38x), .H2(wr_en_l), 
	.J1(n_t_39x), .J2(c00_l), .K1(comp_or_sh), .K2(n_t_116x), 
	.L1(swtm), .L2(mkt), .M1(wr_en), .M2(tp01_a), 
	.N1(n_t_53x), .N2(n_t_115x), .P1(n_t_50x), .P2(uts_l), 
	.R1(n_t_53x), .R2(t_trk), .S1(tm_en), .S2(n_t_76x));
m627 c16(
	.A1(uts_l), .B1(uts_l), .C1(uts_l), .D1(uts_l), 
	.D2(data_l), .E1(n0_to_w_l), .E2(st_ck_l), .F1(uts_l), 
	.F2(st_final_l), .H1(uts_l), .H2(n3v_c15u1), .J1(uts_l), 
	.J2(st_data), .K1(uts_l), .K2(n_t_2x), .L1(n0_to_state_l), 
	.L2(n_t_2x), .M1(tm_en), .M2(n_t_2x), .N1(ck01), 
	.N2(n_t_2x), .P1(ck01), .P2(sh_st_b), .R1(ck01), 
	.R2(tm_en), .S1(n_t_24x), .S2(ck01_l), .T2(ck01_l), 
	.U2(ck01_l), .V2(n_t_5x));
m111 c17(.A1(sh_st), .B1(n_t_2x), 
	.C1(n_t_15x), .D2(n_t_16x), .E2(n_t_30x), .F1(n_t_71x), 
	.F2(n_t_31x), .H1(n_t_78x), .H2(write_ok), .J1(n_t_82x), 
	.J2(write_ok_l), .K1(shift_ck), .L1(n_t_32x), .M1(write_ok_or_uts), 
	.M2(n_t_108x), .N1(addr_acc), .N2(n_t_103x), .P1(addr_acc_l), 
	.P2(n_t_115x), .R1(n_t_8x), .R2(n_t_111x), .S1(t3), 
	.S2(n_t_34x), .T2(xsa_dy), .U1(n_t_101x), .V1(n_t_109x),
    .U2(d16f2), .V2(sync_p_l));
m228 cd18(.clk(clk), .AN2(st_idle),
	.AD2(mk_blk_mk_l), .AE2(mk_blk_mk), .AF1(mk_blk_start_l), .AF2(mk_end), 
	.AH1(mk_data_sync), .AH2(mk_end_l), .AJ1(mk_data_sync_l), .AJ2(mk_blk_start), 
	.AK1(w01_w05), .AK2(w07), .AL1(w08), .AM1(sh_st), 
	.AM2(w06), .AN1(tp00_l), .AP2(blk_in_sync), .AR2(st_blk_mk), 
	.AS2(rdmk), .AT2(w04), .AU2(mk_data_l), .AV2(n0_to_state_l), 
	.BC1(sh_st_b), .BD2(st_idle), .BE2(w03), .BF1(tp01), 
	.BF2(w09), .BH1(sync_en), .BH2(n0_to_w_l), .BJ2(w01), 
	.BK2(data), .BL2(st_final), .BM2(sync_l), .BN2(sync), 
	.BP2(mk_data), .BR1(st_ck), .BR2(shift_ck), .BS1(st_rev_ck), 
	.BS2(mk_blk_sync), .BT2(mk_blk_sync_l), .BU1(mk_blk_end), .BU2(w05), 
	.BV1(mk_blk_end_l), .BV2(w02));
/*
m903 d02(.B1(i_o_bac_00), .D1(i_o_bac_01), 
	.D2(i_o_bac_09), .E1(i_o_bac_02), .E2(i_o_bac_10), .H1(i_o_bac_03), 
	.H2(i_o_bac_11), .J1(i_o_bac_04), .K2(iop_1), .L1(i_o_bac_05), 
	.M1(i_o_bac_06), .M2(iop_2), .P1(i_o_bac_07), .P2(iop_4), 
	.S1(i_o_bac_08), .S2(i_o_ts03), .T2(i_o_ts04), .V2(i_o_pwr_clr));
m903 d03(
	.B1(i_o_bmb_00), .D1(i_o_bmb_01), .D2(i_o_bmb_06_l), .E1(i_o_bmb_02), 
	.E2(i_o_bmb_06), .H1(i_o_bmb_03_l), .H2(i_o_bmb_07_l), .J1(i_o_bmb_03), 
	.K2(i_o_bmb_07), .L1(i_o_bmb_04_l), .M1(i_o_bmb_04), .M2(i_o_bmb_08_l), 
	.P1(i_o_bmb_05_l), .P2(i_o_bmb_08), .S1(i_o_bmb_05), .S2(i_o_bmb_09), 
	.T2(i_o_bmb_10), .V2(i_o_bmb_11));
m903 d04(.B1(im_00_l), .D1(im_01_l), 
	.D2(im_09_l), .E1(im_02_l), .E2(im_10_l), .H1(im_03_l), 
	.H2(im_11_l), .J1(im_04_l), .K2(i_o_skp_rq_l), .L1(im_05_l), 
	.M1(im_06_l), .M2(i_o_int_rq_l), .P1(im_07_l), .P2(i_o_0_to_ac_l), 
	.S1(im_08_l), .S2(i_o_b_run));
m903 d05(.B1(1'b0), .D1(1'b0), 
	.D2(1'b0), .E1(1'b0), .H1(1'b0), .J1(1'b0), 
	.K2(i_o_brk_rq_l), .L1(1'b0), .M1(1'b0), .M2(i_o_data_in), 
	.P1(1'b0), .P2(i_o_b_brk), .S1(1'b0), .S2(i_o_addr_acc_l));
m903 d06(
	.B1(db_00_l), .D1(db_01_l), .D2(db_09_l), .E1(db_02_l), 
	.E2(db_10_l), .H1(db_03_l), .H2(db_11_l), .J1(db_04_l), 
	.K2(1'b0), .L1(db_05_l), .M1(db_06_l), .M2(i_o_1_to_ca_inh_l), 
	.P1(db_07_l), .P2(i_o_bwc0_l), .S1(db_08_l), .S2(ea_02_l), 
	.T2(ea_01_l), .V2(ea_00_l));
*/
m161 d07(.D1(move_l), .D2(move), 
	.E1(search_l), .E2(search), .F1(write_data_l), .F2(write_data), 
	.H1(wrtm_l), .H2(wrtm), .J1(read_data_l), .J2(read_data), 
	.L1(se_l), .L2(se), .M1(write_all_l), .M2(write_all), 
	.N1(read_all_l), .N2(read_all), .S1(n3v_d09u1), .S2(n3v_d09u1), 
	.T2(n3v_d09u1), .U1(1'b0), .U2(fr_02), .V1(fr_03), 
	.V2(fr_01));
m207 d08(.clk(clk), .rst(rst), .A1(n0_to_lpb_l), .B1(n_t_103x), .C1(n_t_93x), 
	.D1(n_t_93x), .D2(n_t_101x), .E1(lpb_00), .E2(n_t_94x), 
	.F1(lpb_00_l), .F2(n_t_94x), .H1(n_t_103x), .H2(lpb_03), 
	.J1(n_t_95x), .J2(lpb_03_l), .K1(n_t_95x), .K2(n0_to_lpb_l), 
	.L1(lpb_01), .L2(n_t_101x), .M1(lpb_01_l), .M2(n_t_100x), 
	.N1(n_t_103x), .N2(n_t_100x), .P1(n_t_96x), .P2(lpb_04), 
	.R1(n_t_96x), .R2(lpb_04_l), .S1(lpb_02), .S2(n_t_101x), 
	.T2(n_t_99x), .U1(lpb_02_l), .U2(n_t_99x), .V1(lpb_05_l), 
	.V2(lpb_05));
m121 d09(.A1(wb00), .B1(wr_en), .C1(rdd_00), 
	.D1(rd_en_lpb_00_02), .D2(dtb_00), .E1(n_t_93x), .E2(wr_en), 
	.F1(wb01), .F2(rdd_00), .H1(wr_en), .H2(rd_en_lpb_03_05), 
	.J1(rdd_01), .J2(n_t_94x), .K1(rd_en_lpb_00_02), .K2(dtb_01), 
	.L1(n_t_95x), .L2(wr_en), .M1(wb02), .M2(rdd_01), 
	.N1(wr_en), .N2(rd_en_lpb_03_05), .P1(rdd_02), .P2(n_t_100x), 
	.R1(rd_en_lpb_00_02), .R2(dtb_02), .S1(n_t_96x), .S2(wr_en), 
	.T2(rdd_02), .U2(rd_en_lpb_03_05), .V2(n_t_99x));
m119 d10(.A1(mk_blk_mk), 
	.B1(mk_blk_mk), .C1(c00), .D1(c01_l), .D2(mc00), 
	.E2(mc01_l), .F1(bac_00_l), .F2(mc02_l), .H1(bac_01_l), 
	.H2(mkt_l), .J1(bac_02_l), .J2(blk_in_sync_l), .K1(bac_03_l), 
	.K2(bac_04_l), .L2(n3v_d10u1), .M1(lpb_00), .M2(n3v_d10u1), 
	.N1(lpb_01), .N2(n3v_d10u1), .P1(lpb_02), .P2(n_t_67x), 
	.R1(lpb_03), .R2(lpb_04), .S2(lpb_05), .T2(lpb_05), 
	.U2(lpb_05), .V2(lpb_not_eq_1));
m206 d11(.clk(clk), .A1(pwr_clr_l), .B1(ldmf), 
	.C1(bac_06), .D1(n3v_d10u1), .D2(ldmf), .E1(mf00), 
	.E2(bac_07), .F1(mf00_l), .F2(n3v_d10u1), .H1(ldmf), 
	.H2(mf01), .J1(bac_08), .J2(mf01_l), .K1(n3v_d10u1), 
	.K2(n3v_d10u1), .L1(mf02), .L2(n1_to_df), .M1(mf02_l), 
	.M2(wc_l), .N1(xsta), .N2(clr_df_l), .P1(1'b0), 
	.P2(df_l), .R1(wc0_l), .R2(df), .S1(wc_l), 
	.S2(n1_to_dtf), .T2(1'b0), .U1(wc), .U2(clr_dtf_l), 
	.V1(dtf), .V2(dtf_l));
m627 d12(.A1(n_t_6x), .B1(n_t_6x), 
	.C1(n_t_6x), .D1(n_t_6x), .D2(mc02), .E1(b_xsta), 
	.E2(mc02), .F1(mb_to_dtb_l), .F2(st_rev_ck), .H1(mb_to_dtb_l), 
	.H2(st_rev_ck), .J1(mb_to_dtb_l), .J2(n0_to_lpb_l), .K1(mb_to_dtb_l), 
	.K2(n_t_118x), .L1(bmb_to_dtb), .L2(n_t_118x), .M1(b_brk), 
	.M2(n_t_117x), .N1(t3), .N2(n_t_117x), .P1(t3), 
	.P2(xor_to_lpb), .R1(fr_01), .R2(n76_l), .S1(mb_to_dtb_l), 
	.S2(n76_l), .T2(n77_l), .U2(n77_l), .V2(n76_or_77));
m602 d13(.clk(clk), 
	.F2(n_t_6x), .H2(xsta_l), .J2(xsta_l), .K2(xsta_l), 
	.L2(xsad_l), .M2(xsta), .N2(xsta), .P2(xsta));
m307 #(.DELAY_COUNT_E2_K1(12000000), .DELAY_COUNT_F2_H2(7000)) d14(.clk(clk), 
	.E2(u_or_m_dy_l), .F2(sp_dy_l), .H2(sp_dy), .J2(n_t_67x), 
	.K1(u_or_m_dy), .K2(xsta_l), .L1(m_stop_l), .L2(xsta_l), 
	.M1(n3v_d10u1), .N1(u_or_m_dy_l), .S1(t_trk), .U1(t_trk));
m401 #(.FREQ(120000)) d15(.clk(clk), 
	.D2(n_t_17x), .J2(tm_en_l), .K2(tm_en_l));
m302 #(.DELAY_COUNT_F2(20), .DELAY_COUNT_T2(500)) d16(.clk(clk), .M2(xsta_l), 
	.N2(xsta_l), .P2(csta), .T2(n_t_34x),
    .H2(b10j2), .J2(b10j2), .K2(b10j2), .F2(d16f2));
m602 d17(.clk(clk), .F2(n_t_8x), 
	.H2(ts03_l), .J2(ts03_l), .K2(ts03_l), .L2(st_ck_0p_l), 
	.M2(st_ck), .N2(st_ck), .P2(st_ck));
/* lint_on */
endmodule
