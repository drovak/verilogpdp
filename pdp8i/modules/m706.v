// M706 - Teletype receiver
// Kyle Owen - 1 March 2021

module m706 (
	clk,
	//AA1,
	//AB1,
	//AC1,
	AD1,
	AE1,
	AF1,
	AH1,
	AJ1,
	AK1,
	AL1,
	AM1,
	AN1,
	AP1,
	AR1,
	AS1,
	//AT1,  // ground
	//AU1,
	AV1,
	//AA2,  // +5V
	//AB2,
	//AC2,  // ground
	AD2,
	AE2,
	AF2,
	AH2,
	AJ2,
	AK2,
	AL2,
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
	//BC1,
	BD1,
	//BE1,
	//BF1,
	//BH1,
	//BJ1,
	//BK1,
	//BL1,
	BM1,
	BN1,
	BP1,
	BR1,
	BS1,
	//BT1,  // ground
	BU1,
	//BV1,
	//BA2,  // +5V
	//BB2,
	//BC2,  // ground
	BD2,
	BE2,
	BF2,
	BH2,
	BJ2,
	//BK2,
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

//inout AA2, AC2, AT1, BA2, BC2, BT1; // power and grounds

output AU2, BL2, BH2, AF2, BE2, AE2, BN2, AN2,
       AT2, AP2, AM1, AL1, AS2, AR2, AK2, BU2,
       BV2, BS1, BT2, AM2, AK1, BN1, AV1, BS2,
       AS1;

output AD1; // +3V output
assign AD1 = 1'b1;

input clk;

input AL2, AD2, AE1, AF1, AH1, AH2, AJ1, BJ2, 
      BD1, BF2, BU1, BR2, BP2, AN1, BM2, BR1, 
      AJ2, AR1, BM1, AV2, BD2, AP1, BP1; 

// unused
//input 

wire read_buf = AL2;
wire clr_f1 = BJ2;
wire clr_f2 = BD1;
wire clr_f1_en = !(dev_sel_en & clr_f1);
assign BE2 = clr_f1_en;
wire clr_flag_n = clr_f1_en & !clr_f2 & !io_clr;
assign AE2 = clr_flag_n;
wire [5:0] dev_sel = {AD2, AE1, AF1, AH1, AH2, AJ1};
wire io_clr = BF2;
wire clk_8baud = AN1;
wire ser_in = BM2;
assign AM2 = !ser_in;
wire en = BR1;
wire skp_strobe = BD2;

//wire dev_sel_en = !(!&dev_sel & AP1);
wire dev_sel_en = !(!(dev_sel == 6'o77) & AP1);
wire buffer_strobe = dev_sel_en & read_buf;
assign AV1 = buffer_strobe;
assign BN1 = !(buffer_strobe & BM1);

wire io_skp = !(skp_strobe & dev_sel_en & flag);
assign BH2 = io_skp;

assign AF2 = flag_n;

wire [8:1] srbit;
/* verilator lint_off UNUSED */
wire [8:1] srbit_n;
/* lint_on */
assign {AK2, AR2, AS2, AL1, AM1, AP2, AT2, AN2} = buffer_strobe ? ~srbit : ~0;

wire flag, flag_n;
sn7474 flag_ff (.mclk(clk), .clk(shift), .clr_n(clr_flag_n), .pre_n(1'b1),
                .d(srbit_n[1]), .q(flag), .q_n(flag_n));

wire active, active_n;
wire active_pre = !(ser_in & !clk_div_clr & en & clk_8baud);
wire active_clr = !io_clr & !(shift & !ser_in & spike);
wire active_clk = spike_clk & in_last;
sn7474 active_ff (.mclk(clk), .clk(active_clk), .clr_n(active_clr), .pre_n(active_pre),
                  .d(1'b0), .q(active), .q_n(active_n));
assign BN2 = active_n;

wire spike_clk = !(BU1 & active);
wire spike;
/* verilator lint_off UNUSED */
wire spike_n;
/* lint_on */
sn7474 spike_ff (.mclk(clk), .clk(spike_clk), .clr_n(!io_clr), .pre_n(preset),
                 .d(1'b0), .q(spike), .q_n(spike_n));

wire stop1, stop1_n;
sn7474 stop1_ff (.mclk(clk), .clk(BP2), .clr_n(preset), .pre_n(BP1),
                 .d(active_n), .q(stop1), .q_n(stop1_n));
/* verilator lint_off UNUSED */
wire stop2;
/* lint_on */
wire stop2_n;
sn7474 stop2_ff (.mclk(clk), .clk(BP2), .clr_n(preset), .pre_n(BP1),
                 .d(stop1), .q(stop2), .q_n(stop2_n));
assign BU2 = stop1_n;
assign BV2 = stop2_n;

wire in_last, in_last_n;
sn7474 in_last_ff (.mclk(clk), .clk(shift), .clr_n(BR2), .pre_n(1'b1),
                   .d(srbit_n[1]), .q(in_last), .q_n(in_last_n));

wire reader_en_low;
sn7474 reader_run_ff (.mclk(clk), .clk(1'b0), .clr_n(preset), .pre_n(AV2),
                      .d(1'b0), .q(BL2), .q_n(reader_en_low));
assign AU2 = !reader_en_low;

sn7474 bit1_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(srbit[2]), .q(srbit[1]), .q_n(srbit_n[1]));
sn7474 bit2_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(srbit[3]), .q(srbit[2]), .q_n(srbit_n[2]));
sn7474 bit3_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(srbit[4]), .q(srbit[3]), .q_n(srbit_n[3]));
sn7474 bit4_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(srbit[5]), .q(srbit[4]), .q_n(srbit_n[4]));
sn7474 bit5_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(AJ2),      .q(srbit[5]), .q_n(srbit_n[5]));
sn7474 bit6_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(srbit[7]), .q(srbit[6]), .q_n(srbit_n[6]));
sn7474 bit7_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(srbit[8]), .q(srbit[7]), .q_n(srbit_n[7]));
sn7474 bit8_ff (.mclk(clk), .clk(shift), .clr_n(1'b1), .pre_n(preset), 
                .d(AR1),      .q(srbit[8]), .q_n(srbit_n[8]));
assign AK1 = srbit[6];

wire clk_div_clr = !(in_last_n & active_n);
wire clk_div0, clk_div0_n;
sn7474 clk_div0_ff (.mclk(clk), .clk(clk_8baud), .clr_n(1'b1), .pre_n(1'b1), 
                    .d(!(clk_div0 & clk_div_clr)), .q(clk_div0), .q_n(clk_div0_n));
/* verilator lint_off UNUSED */
wire clk_div1;
/* lint_on */
wire clk_div1_n;
sn7474 clk_div1_ff (.mclk(clk), .clk(clk_div0_n), .clr_n(clk_div_clr), .pre_n(1'b1), 
                    .d(clk_div1_n), .q(clk_div1), .q_n(clk_div1_n));
wire clk_div2, clk_div2_n;
sn7474 clk_div2_ff (.mclk(clk), .clk(clk_div1_n), .clr_n(clk_div_clr), .pre_n(1'b1), 
                    .d(clk_div2_n), .q(clk_div2), .q_n(clk_div2_n));
assign BS1 = clk_div2_n;
assign BT2 = clk_div2;

reg old_spike_clk;
reg [1:0] shift_cnt;
wire shift = (shift_cnt > 0) ? 1'b1 : 1'b0;
assign AS1 = shift;

reg old_active_n;
reg [1:0] preset_cnt;
wire preset = (preset_cnt > 0) ? 1'b0 : 1'b1;
assign BS2 = preset;

always @(posedge clk) begin
    old_spike_clk <= spike_clk;
    if (!spike_clk && old_spike_clk) shift_cnt <= 'b1;
    if (shift_cnt > 0) shift_cnt <= shift_cnt + 1;

    old_active_n <= active_n;
    if (!active_n && old_active_n) preset_cnt <= 'b1;
    if (preset_cnt > 0) preset_cnt <= preset_cnt + 1;
end

//assign AA2 = 1'b1;
//assign AC2 = 1'b0;
//assign AT1 = 1'b0;
//assign BA2 = 1'b1;
//assign BC2 = 1'b0;
//assign BT1 = 1'b0;

endmodule
