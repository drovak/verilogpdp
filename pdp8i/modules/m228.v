// M228 - Mark Track Decoder (TC08)
// Kyle Owen - 7 March 2021

module m228 (
	clk,
	//AA1,
	//AB1,
	//AC1,
	//AD1,
	//AE1,
	AF1,
	AH1,
	AJ1,
	AK1,
	AL1,
	AM1,
	AN1,
	//AP1,
	//AR1,
	//AS1,
	//AT1,  // ground
	AU1,
	//AV1,
	//AA2,  // +5V
	//AB2,
	//AC2,  // ground
	AD2,
	AE2,
	AF2,
	AH2,
	AJ2,
	AK2,
	//AL2,
	AM2,
	AN2,
	AP2,
	AR2,
	AS2,
	AT2,
	AU2,
	AV2,
	//BA1,
	//BB1,
	BC1,
	//BD1,
	//BE1,
	BF1,
	BH1,
	//BJ1,
	//BK1,
	//BL1,
	//BM1,
	//BN1,
	//BP1,
	BR1,
	BS1,
	//BT1,  // ground
	BU1,
	BV1,
	//BA2,  // +5V
	//BB2,
	//BC2,  // ground
	BD2,
	BE2,
	BF2,
	BH2,
	BJ2,
	BK2,
	BL2,
	BM2,
	BN2,
	BP2,
	BR2,
	BS2,
	BT2,
	BU2,
	BV2
	);

output BJ2, BE2, BV2, BF2, AK2, AL1, AK1, AM2, 
       AM1, AU1, AF1, AH2, BM2, AJ1, AU2, BU1,
       AD2, BT2, BU2, AJ2, AT2, AF2, BN2, AH1,
       BP2, BV1, AE2, BS2, BK2, BS1, AR2, AN2,
       BL2, BR1; 

input clk;

input AP2, AV2, BH2, AS2, BD2, BR2, BC1, AN1, BF1, BH1;

/* verilator lint_off UNUSED */
wire st_blk_mk_1_h, st_blk_mk_0_h;
/* lint_on */
sn7474 st_blk_mk_ff(.mclk(clk), .q(st_blk_mk_1_h), .q_n(st_blk_mk_0_h), .d(BD2),           .pre_n(1'b1), .clr_n(zero_to_state_l), .clk(BC1));
assign AR2 = st_blk_mk_1_h;

/* verilator lint_off UNUSED */
wire st_rev_ck_1_h, st_rev_ck_0_h;
/* lint_on */
sn7474    st_rev_ff(.mclk(clk), .q(st_rev_ck_1_h), .q_n(st_rev_ck_0_h), .d(st_blk_mk_1_h), .pre_n(1'b1), .clr_n(zero_to_state_l), .clk(BC1));
assign BS1 = st_rev_ck_1_h;

/* verilator lint_off UNUSED */
wire data_1_h, data_0_h;
/* lint_on */
sn7474      data_ff(.mclk(clk), .q(data_1_h),      .q_n(data_0_h),      .d(st_rev_ck_1_h), .pre_n(1'b1), .clr_n(zero_to_state_l), .clk(BC1));
assign BK2 = data_1_h;

/* verilator lint_off UNUSED */
wire st_final_1_h, st_final_0_h;
/* lint_on */
sn7474  st_final_ff(.mclk(clk), .q(st_final_1_h), .q_n(st_final_0_h),   .d(data_1_h),      .pre_n(1'b1), .clr_n(zero_to_state_l), .clk(BC1));
assign BL2 = st_final_1_h;

/* verilator lint_off UNUSED */
wire st_ck_1_h, st_ck_0_h;
/* lint_on */
sn7474     st_ck_ff(.mclk(clk), .q(st_ck_1_h),    .q_n(st_ck_0_h),      .d(st_final_1_h),  .pre_n(1'b1), .clr_n(zero_to_state_l), .clk(BC1));
assign BR1 = st_ck_1_h;

/* verilator lint_off UNUSED */
wire st_idle_1_h, st_idle_0_h;
/* lint_on */
sn7474   st_idle_ff(.mclk(clk), .q(st_idle_1_h),  .q_n(st_idle_0_h),    .d(st_ck_1_h),     .pre_n(zero_to_state_l), .clr_n(1'b1), .clk(BC1));
assign AN2 = st_idle_1_h;

wire sh_st_h = !(AN1 | !((st_idle_1_h & AP2) | ((st_blk_mk_1_h & mk_blk_start_h) | (mk_blk_start_h & st_rev_ck_1_h) | 
                                                (data_1_h & mk_blk_end_h) | (mk_blk_end_h & st_final_1_h) | 
                                                (st_ck_1_h & BR2))));
assign AM1 = sh_st_h;

wire zero_to_w_l = BH2;
wire zero_to_state_l = AV2;

wire w9_1_h, w9_0_h;
sn7474 w9_ff(.mclk(clk), .clk(BF1),    .d(AS2),    .q(w9_1_h), .q_n(w9_0_h), .pre_n(1'b1), .clr_n(zero_to_w_l));
assign BF2 = w9_1_h;

wire w8_1_h, w8_0_h;
sn7474 w8_ff(.mclk(clk), .clk(BF1),    .d(w9_1_h), .q(w8_1_h), .q_n(w8_0_h), .pre_n(1'b1), .clr_n(zero_to_w_l));
assign AL1 = w8_1_h;

wire w7_1_h, w7_0_h;
sn7474 w7_ff(.mclk(clk), .clk(BF1),    .d(w8_1_h), .q(w7_1_h), .q_n(w7_0_h), .pre_n(1'b1), .clr_n(zero_to_state_l));
assign AK2 = w7_1_h;

wire w6_1_h, w6_0_h;
sn7474 w6_ff(.mclk(clk), .clk(BF1),    .d(w7_1_h), .q(w6_1_h), .q_n(w6_0_h), .pre_n(1'b1), .clr_n(zero_to_state_l));
assign AM2 = w6_1_h;

wire w5_1_h, w5_0_h;
sn7474 w5_ff(.mclk(clk), .clk(BF1),    .d(w6_1_h), .q(w5_1_h), .q_n(w5_0_h), .pre_n(1'b1), .clr_n(zero_to_w_l));
assign BU2 = w5_1_h;
wire w1_w5_h = !(w5_0_h | w1_0_h);
assign AK1 = w1_w5_h;

wire w4_1_h, w4_0_h;
sn7474 w4_ff(.mclk(clk), .clk(BF1),    .d(w5_1_h), .q(w4_1_h), .q_n(w4_0_h), .pre_n(1'b1), .clr_n(zero_to_state_l));
assign AT2 = w4_1_h;

wire w3_1_h, w3_0_h;
sn7474 w3_ff(.mclk(clk), .clk(BF1),    .d(w4_1_h), .q(w3_1_h), .q_n(w3_0_h), .pre_n(1'b1), .clr_n(zero_to_w_l));
assign BE2 = w3_1_h;

wire w2_1_h, w2_0_h;
sn7474 w2_ff(.mclk(clk), .clk(BF1),    .d(w3_1_h), .q(w2_1_h), .q_n(w2_0_h), .pre_n(1'b1), .clr_n(zero_to_w_l));
assign BV2 = w2_1_h;

wire w1_1_h, w1_0_h;
sn7474 w1_ff(.mclk(clk), .clk(w2_1_h), .d(1'b1),   .q(w1_1_h), .q_n(w1_0_h), .pre_n(1'b1), .clr_n(zero_to_w_l));
assign BJ2 = w1_1_h;

wire mk_blk_start_h = !mk_blk_start_l;
assign AJ2 = mk_blk_start_h;
wire mk_blk_start_l = !(w1_1_h & w3_0_h & w4_0_h & w5_0_h & w6_1_h & w7_0_h & w8_0_h & w9_0_h);
assign AF1 = mk_blk_start_l;

wire mk_end_h = !mk_end_l;
assign AF2 = mk_end_h;
wire mk_end_l = !(w1_w5_h & w2_1_h & w3_0_h & w4_0_h & w6_0_h & w7_0_h & w8_1_h & w9_0_h); // 110010010 = 622
assign AH2 = mk_end_l;

wire sync_h = !sync_l;
assign BN2 = sync_h;
wire sync_l = !(w1_w5_h & w3_1_h & w4_0_h & w6_0_h & w7_1_h & w8_0_h & w9_1_h & BH1);
assign BM2 = sync_l;

wire mk_data_sync_h = !mk_data_sync_l;
assign AH1 = mk_data_sync_h;
wire mk_data_sync_l = !(w1_w5_h & w2_1_h & w3_0_h & w4_0_h & w6_1_h & w7_0_h & w8_1_h & w9_0_h);
assign AJ1 = mk_data_sync_l;

wire mk_data_h = !mk_data_l;
assign BP2 = mk_data_h;
wire mk_data_l = !(w1_w5_h & w2_0_h & w3_0_h & w4_1_h & w6_1_h & w7_0_h & w8_0_h & w9_0_h);
assign AU2 = mk_data_l;

wire mk_blk_end_h = !mk_blk_end_l;
assign BU1 = mk_blk_end_h;
wire mk_blk_end_l = !(w1_1_h & w4_1_h & w5_1_h & w6_1_h & w7_0_h & w8_1_h & w9_1_h);
assign BV1 = mk_blk_end_l;

wire mk_blk_mk_h = !mk_blk_mk_l;
assign AE2 = mk_blk_mk_h;
wire mk_blk_mk_l = !(w1_w5_h & w2_0_h & w3_1_h & w4_0_h & w6_0_h & w7_1_h & w8_1_h & w9_0_h);
assign AD2 = mk_blk_mk_l;

wire w8_w9 = !(w8_1_h | w9_0_h);
assign AU1 = w8_w9;
wire mk_blk_sync_h = !mk_blk_sync_l;
assign BS2 = mk_blk_sync_h;
wire mk_blk_sync_l = !(w1_1_h & w2_1_h & w3_1_h & w4_1_h & w5_0_h & w6_1_h & w7_0_h & w8_w9);
assign BT2 = mk_blk_sync_l;

endmodule
