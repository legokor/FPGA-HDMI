`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BME Simonyi Károly Szakkollégium Lego köre
// Engineer: Csókás Bence
// 
// Create Date:    11:32:31 10/30/2019 
// Design Name: TMDS 8b-ből 10b-be kódoló
// Module Name:    TMDS_8b10b_enc 
// Project Name: 
// Description: d (8 bites) bemenetet és c (2 bites) vezérlőjel-vektort kódolja a (10 bites) q-ba
//				den = Data Enable / ~Control Enable
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TMDS_8b10b_enc(
	input rst,
	input [7:0] d,
	input [1:0] c,
	input den,
	input clk,
	output [9:0] q
);

// I. fázis: q_m kiszámítása invert_d_m alapján
reg [7:0] d_m;
wire [8:0] q_m;
wire invert_d_m;

assign q_m={~invert_d_m, d_m[7:0]};

always @(*)
begin
	if(rst)
		d_m <= 8'b0;
	else begin
		d_m[0]<=d[0];
		d_m[1]<=d_m[0]^d[1]^invert_d_m;
		d_m[2]<=d_m[1]^d[2]^invert_d_m;
		d_m[3]<=d_m[2]^d[3]^invert_d_m;
		d_m[4]<=d_m[3]^d[4]^invert_d_m;
		d_m[5]<=d_m[4]^d[5]^invert_d_m;
		d_m[6]<=d_m[5]^d[6]^invert_d_m;
		d_m[7]<=d_m[6]^d[7]^invert_d_m;
	end
end

// bitszámlálók
wire [3:0] d_1s;
wire [3:0] q_m_1s;
wire [3:0] q_m_0s=8-q_m_1s;

BITADD8 d_bitadd(.d(d), .q(d_1s));
BITADD8 q_m_bitadd(.d(q_m[7:0]), .q(q_m_1s));
//BITADD8 q_m_n_bitadd(.d(~q_m), .q(q_m_0s));

// invert_d_m kiszámolása
assign invert_d_m=d_1s>4||(d_1s==4&~d[0]);

// Stream disparity számláló
reg [9:0] cnt;

// kimenet előállítása
// q[9] = invertálva van-e q[7:0]
// q[8] = invert_d_m
reg [9:0] q_out;
assign q=q_out;

always @(posedge clk)
begin
	if(rst) begin
		cnt <= 10'b0;
		q_out <= 10'b0;
	end else if(den)
		if((~&cnt)||(q_m_1s==q_m_0s)) begin
			// ki van súlyozva
			q_out[9]<=~q_m[8];
			q_out[8]<=q_m[8];
			if(q_m[8]) begin
				q_out[7:0]<=q_m[7:0];
				cnt <= cnt+q_m_1s-q_m_0s;
			end else begin
				q_out[7:0]<=~q_m[7:0];
				cnt <= cnt+q_m_0s-q_m_1s;
			end
		end else begin
			if(
				// túl sok egyes, invertálandó
				(cnt>0&&q_m_1s>q_m_0s) ||
				// túl sok nullás, invertálandó
				(cnt<0&&q_m_1s<q_m_0s)
			) begin
				q_out[9]<=1'b1;
				q_out[8]<=q_m[8];
				q_out[7:0]<=~q_m[7:0];
				cnt <= cnt+(q_m[8]<<1)+q_m_0s-q_m_1s;
			end else begin
				q_out[9]<=1'b0;
				q_out[8]<=q_m[8];
				q_out[7:0]<=q_m[7:0];
				cnt <= cnt+(~q_m[8]<<1)+q_m_1s-q_m_0s;
			end
		end
	else
		case (c)
			2'b00: q_out <= 10'b1101010100;
			2'b01: q_out <= 10'b0010101011;
			2'b10: q_out <= 10'b0101010100;
			2'b11: q_out <= 10'b1010101011;
		endcase
end

endmodule
