// M302 - Dual Delay Multivibrator
// Kyle Owen - 10 March 2021

module m302 #(
    parameter DELAY_COUNT_F2 = 1000,
    parameter DELAY_COUNT_T2 = 1000) (
	clk, // 100 MHz
	//A1,
	//B1,
	//C1,
	//D1,
	//E1,
	//F1,
	//H1,
	//J1,
	//K1,
	//L1,
	//M1,
	//N1,
	//P1,
	//R1,
	//S1,
	//T1,  // ground
	//U1,
	//V1,
	//A2,  // +5V
	//B2,
	//C2,  // ground
	//D2,
	//E2,
	F2,
	H2,
	J2,
	K2,
	//L2,
	M2,
	N2,
	P2,
	//R2,
	//S2,
	T2
	//U2,
	//V2
	);
// power and grounds
//inout A2, C2, T1; 

// main inputs
input clk, H2, J2, K2, M2, N2, P2;

// main outputs
output F2, T2;

wire f2_en = !(H2 & J2 & K2);
wire t2_en = !(M2 & N2 & P2);

reg [26:0] f2_count;
reg [26:0] t2_count;

assign F2 = f2_count > 0 ? 1'b1 : 1'b0;
assign T2 = t2_count > 0 ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if ((f2_count == 0) && f2_en) f2_count <= 'b1;
    if (f2_count > 0) begin
        if (f2_count < DELAY_COUNT_F2) f2_count <= f2_count + 'b1;
        else f2_count <= 0;
    end

    if ((t2_count == 0) && t2_en) t2_count <= 'b1;
    if (t2_count > 0) begin
        if (t2_count < DELAY_COUNT_T2) t2_count <= t2_count + 'b1;
        else t2_count <= 0;
    end
end
endmodule
