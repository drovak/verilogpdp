// M700 - Manual timing generator
// Kyle Owen - 15 February 2021

module m700 (
	clk, // 100 MHz
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
// power and ground
//inout AA2, BA2, AC2, BC2; 

// main inputs
input clk, AS2, AR2, AP2, AL2;

// main outputs
output AN2, AK2, AJ2, AM2, AT2, AH2, AF2, AE2, BD2;

// unused
/* verilator lint_off UNUSED */
input AB2, AD2, AU2, AV2, BB2, BE2, BF2, BH2, BJ2, 
	BK2, BL2, BM2, BN2, BP2, BR2, BS2, BT2, BU2, BV2;
/* lint_on */

// power assignments
//assign AA2 = 1'b1;
//assign BA2 = 1'b1;
//assign AC2 = 1'b0;
//assign BC2 = 1'b0;

// main time counter
reg [8:0] timer;

wire mftp0, mftp1, mftp2;
assign mftp0 = ((timer > 0) && (timer < 10)) ? 1'b1 : 1'b0;
assign mftp1 = ((timer > 9'd200) && (timer < 9'd210)) ? 1'b1 : 1'b0;
assign mftp2 = ((timer > 9'd400) && (timer < 9'd410)) ? 1'b1 : 1'b0;
assign AT2 = mftp0;
assign AE2 = mftp1;
assign BD2 = mftp2;

wire mfts0 = (AP2 & !(AR2 & !AS2));
reg old_mfts0;
assign AM2 = mfts0;
assign AN2 = !mfts0;

reg mfts1;
assign AJ2 = mfts1;
assign AK2 = !mfts1;

reg mfts2;
assign AF2 = mfts2;
assign AH2 = !mfts2;

wire mfts1_rst = !(AL2 & !mfts2);
wire mfts2_rst = !(AL2 & !mftp2);

reg old_mftp1;

always @(posedge clk) begin
	old_mftp1 <= mftp1;
	old_mfts0 <= mfts0;

	if (mfts1_rst) mfts1 <= 1'b0;
	else if (mfts0 && !old_mfts0) mfts1 <= 1'b1;

	if (mfts2_rst) mfts2 <= 1'b0;
	else if (mftp1 && !old_mftp1) mfts2 <= 1'b1;

	if (mfts0 && !old_mfts0 && (timer == 0)) timer <= 1;

	if (timer > 0) begin
		if (timer < 9'd420) timer <= timer + 1;
		else timer <= 0;
	end
end
endmodule
