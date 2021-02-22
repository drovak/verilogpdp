// M220 - PDP-8 major registers
// Kyle Owen - 14 February 2021

module m220 (
	clk,
	AA1,
	AB1,
	AC1,
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
	AU1,
	AV1,
	//AA2,  // +5V
	AB2,
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
	BA1,
	BB1,
	BC1,
	BD1,
	BE1,
	BF1,
	BH1,
	BJ1,
	BK1,
	BL1,
	BM1,
	BN1,
	BP1,
	BR1,
	BS1,
	//BT1,  // ground
	BU1,
	BV1,
	//BA2,  // +5V
	BB2,
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

//inout AA2, AC2, AT1, BA2, BC2, BT1; // power and grounds

output BK2, AE2, AF1, AJ1, AK2, BB1, BA1, AV2, 
       AV1, AU2, AT2, AS1, AS2, AR2, AP1, AP2, 
	   AN1, AM1, AM2, AL1, AL2;

input clk;

input AA1, AB1, AB2, AC1, AD1, AD2, AE1, AF2, 
      AH1, AH2, AJ2, AK1, AN2, AR1, AU1, BB2, 
      BC1, BD1, BD2, BE1, BE2, BF1, BF2, BH1, 
      BH2, BJ1, BJ2, BK1, BL1, BL2, BM1, BM2, 
      BN1, BN2, BP1, BP2, BR1, BR2, BS1, BS2, 
      BT2, BU1, BU2, BV1, BV2;

// unused
//input BN2, BR2; 

reg [1:0] ac;
reg [1:0] mb;
reg [1:0] pc;
reg [1:0] ma;
wire [1:0] const_val = {1'b0, BE2};
wire [1:0] mq = {BH1, BN2};
wire [1:0] sr = {BE1, BD2};
wire [1:0] sc = {BD1, BN1};
wire [1:0] data = {BM2, BP2};
wire [1:0] io = {BK1, BM1};
wire [1:0] mem = {BR1, BV2};
wire [1:0] data_addr = {BS1, BU1};

wire [1:0] arg1;
wire [1:0] arg2;
wire [2:0] add;

wire [1:0] ac_en = {BH2, BH2};
wire [1:0] ac_n_en = {BJ2, BJ2};
wire [1:0] mq_en = {BF1, BF1};
wire [1:0] sr_en = {BC1, BC1};
wire [1:0] sc_en = {BF2, BF2};
wire [1:0] data_en = {BL1, BL1};
wire [1:0] io_en = {BL2, BL2};
wire [1:0] ma_en = {BP1, BR2};
wire [1:0] pc_en = {BS2, BS2};
wire [1:0] mem_en = {BU2, BV1};
wire [1:0] data_addr_en = {BT2, BT2};

assign arg1 = ~(const_val | (ac_en & ac) | (ac_n_en & ~ac) | 
                (mq_en & mq) | (sr_en & sr) | (sc_en & sc) |
				(data_en & data) | (io_en & io));

assign arg2 = ~((ma_en & ma) | (pc_en & pc) | (mem_en & mem) |
                (data_addr_en & data_addr));

assign add = arg1 + arg2 + {2'b0, BJ1};
assign BK2 = add[2];
assign AE2 = add[1];
assign AF1 = add[0];

wire [1:0] op_tt_line_sh = {!AB2, !AB2};
wire [1:0] op_and = {AA1, AA1};
wire [1:0] op_sr = {AD2, AD2};
wire [1:0] op_str = {AD1, AD1};
wire [1:0] op_nosh = {AE1, AE1};
wire [1:0] op_sl = {AF2, AF2};
wire [1:0] op_stl = {AH1, AH1};
wire [5:0] adder012345 = {AB1, AC1, add[1:0], AH2, AJ2};
wire [1:0] tt_line_sh_data = {BB2, add[0]};
wire [1:0] sh_out;

assign sh_out = ~((op_tt_line_sh & tt_line_sh_data) | (op_and & ~mb) | 
                  (op_sr & adder012345[4:3]) | (op_str & adder012345[5:4]) | 
				  (op_nosh & adder012345[3:2]) | (op_sl & adder012345[2:1]) | 
				  (op_stl & adder012345[1:0]));

assign AJ1 = sh_out[1];
assign AK2 = sh_out[0];

reg old_AK1, old_AN2, old_AR1, old_AU1;
reg [1:0] old_sh_out;
always @(posedge clk) begin
	old_sh_out <= sh_out;
	old_AK1 <= AK1;
	old_AN2 <= AN2;
	old_AR1 <= AR1;
	old_AU1 <= AU1;

	if (AK1 && !old_AK1) ma <= old_sh_out;
	if (AN2 && !old_AN2) pc <= old_sh_out;
	if (AR1 && !old_AR1) mb <= old_sh_out;
	if (AU1 && !old_AU1) ac <= old_sh_out;
end

assign BB1 = !ac[1];
assign BA1 = ac[1];
assign AV2 = !ac[0];
assign AV1 = ac[0];

assign AU2 = !mb[1];
assign AT2 = mb[1];
assign AS1 = !mb[0];
assign AS2 = mb[0];

assign AR2 = !pc[1];
assign AP1 = pc[1];
assign AP2 = !pc[0];
assign AN1 = pc[0];

assign AM1 = !ma[1];
assign AM2 = ma[1];
assign AL1 = !ma[0];
assign AL2 = ma[0];

//assign AA2 = 1'b1;
//assign AC2 = 1'b0;
//assign AT1 = 1'b0;
//assign BA2 = 1'b1;
//assign BC2 = 1'b0;
//assign BT1 = 1'b0;

endmodule
