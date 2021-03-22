module dw08b (
    //positive to negative (M051, inverting 0 to 3 -> 0 to -3)
    input [11:0] pb_ac_l,
    output [11:0] nb_ac_h,
    input pb_skip_l,
    output nb_skip_h,
    input pb_int_rq_l,
    output nb_int_rq_h,
    input pb_ac_clr_cont_l,
    output nb_ac_clr_cont_h,
    input pb_line_mux_l,
    output nb_line_mux_h,
    input pb_brk_rq_l,
    output nb_brk_rq_h,
    input pb_data_in_l,
    output nb_data_in_h,
    input pb_mb_inc_l,
    output nb_mb_inc_h,
    input pb_3_cycle_l,
    output nb_3_cycle_h,
    input pb_ca_inc_h,
    output nb_ca_inc_l,
    input [2:0] pb_ea_l,
    output [2:0] nb_ea_l,

    input [11:0] pb_da_l,
    output [11:0] nb_da_h,
    input [11:0] pb_d_l,
    output [11:0] nb_d_h,

    //negative to positive (M508, non-inverting OC, -3 to 0 -> 0 to 3)
    input [11:0] nb_bac_h,
    output [11:0] pb_bac_h,
    input [11:0] nb_bmb_h,
    output [11:0] pb_bmb_h,
    input [8:3] nb_bmb_l,
    output [8:3] pb_bmb_l,
    input nb_run_l,
    output pb_run_l,
    input nb_tt_inst_h,
    output pb_tt_inst_h,
    input nb_break_l,
    output pb_break_l,
    input nb_add_accept_l,
    output pb_add_accept_l,
    input nb_wc_overflow_l,
    output pb_wc_overflow_l,

    //negative to positive (M508 with M660, inverting, -3 to 0 -> 3 to 0)
    input nb_iop1_l,
    output pb_iop1_h,
    input nb_iop2_l,
    output pb_iop2_h,
    input nb_iop4_l,
    output pb_iop4_h,
    input nb_ts3_l,
    output pb_ts3_h,
    input nb_ts1_l,
    output pb_ts1_h,
    input nb_init_l,
    output pb_init_h
);

assign pb_iop1_h = !nb_iop1_l;
assign pb_iop2_h = !nb_iop2_l;
assign pb_iop4_h = !nb_iop4_l;
assign pb_ts3_h = !nb_ts3_l;
assign pb_ts1_h = !nb_ts1_l;
assign pb_init_h = !nb_init_l;

assign pb_bac_h = nb_bac_h;
assign pb_bmb_h = nb_bmb_h;
assign pb_bmb_l = nb_bmb_l;
assign pb_run_l = nb_run_l;
assign pb_tt_inst_h = nb_tt_inst_h;
assign pb_break_l = nb_break_l;
assign pb_add_accept_l = nb_add_accept_l;
assign pb_wc_overflow_l = nb_wc_overflow_l;

assign nb_ac_h = ~pb_ac_l;
assign nb_skip_h = !pb_skip_l;
assign nb_int_rq_h = !pb_int_rq_l;
assign nb_ac_clr_cont_h = !pb_ac_clr_cont_l;
assign nb_line_mux_h = !pb_line_mux_l;
assign nb_brk_rq_h = !pb_brk_rq_l;
assign nb_data_in_h = !pb_data_in_l;
assign nb_mb_inc_h = !pb_mb_inc_l;
assign nb_3_cycle_h = !pb_3_cycle_l;
assign nb_ca_inc_l = !pb_ca_inc_h;
assign nb_ea_l = ~pb_ea_l;

assign nb_da_h = ~pb_da_l;
assign nb_d_h = ~pb_d_l;

endmodule
