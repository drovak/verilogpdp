// M307 - Integrating One-Shot
// Kyle Owen - 10 March 2021

module m307 #(
    parameter DELAY_COUNT_E2_K1 = 1000,
    parameter DELAY_COUNT_F2_H2 = 1000) (
	clk, // 100 MHz
	//A1,
	//B1,
	//C1,
	//D1,
	//E1,
	//F1,
	//H1,
	//J1,
	K1,
	L1,
	M1,
	N1,
	//P1,
	R1,
	S1,
	//T1,  // ground
	U1,
	//V1,
	//A2,  // +5V
	//B2,
	//C2,  // ground
	//D2,
	E2,
	F2,
	H2,
	J2,
	K2,
	L2
	//M2,
	//N2,
	//P2,
	//R2,
	//S2,
	//T2,
	//U2,
	//V2
	);
// power and grounds
//inout A2, C2, T1; 

// main inputs
input clk, L1, K2, L2, J2, M1, U1, S1, N1;

// main outputs
output E2, K1, F2, H2, R1;

assign R1 = 1'b1;

wire en1 = !(K2 & L2) & J2;
wire en2 = !(U1 & S1) & N1;

reg old_en1, old_en2;

reg [26:0] count1;
reg [26:0] count2;

assign K1 = count1 > 0 ? 1'b1 : 1'b0;
assign E2 = count1 > 0 ? 1'b0 : 1'b1;
assign H2 = count2 > 0 ? 1'b1 : 1'b0;
assign F2 = count2 > 0 ? 1'b0 : 1'b1;

always @(posedge clk) begin
    old_en1 <= en1;
    old_en2 <= en2;

    if (!L1) count1 <= 'b1;
    else if (!old_en1 && en1) count1 <= 'b1;
    else if (count1 > 0) begin
        if (count1 < DELAY_COUNT_E2_K1) count1 <= count1 + 'b1;
        else count1 <= 0;
    end

    if (!M1) count2 <= 'b1;
    else if (!old_en2 && en2) count2 <= 'b1;
    else if (count2 > 0) begin
        if (count2 < DELAY_COUNT_F2_H2) count2 <= count2 + 'b1;
        else count2 <= 0;
    end
end

endmodule
