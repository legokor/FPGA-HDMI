`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BME Simonyi Károly Szakkollégium Lego köre
// Engineer: Csókás Bence
// 
// Create Date:    12:03:51 10/30/2019 
// Design Name: Aktív bit számláló
// Module Name:    BITADD8 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: d (8 bites) bemeneten megszámolja az 1-es biteket
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BITADD8(
	input [7:0] d,
	output [3:0] q
);

assign q=d[0]+d[1]+d[2]+d[3]+d[4]+d[5]+d[6]+d[7];

endmodule
