`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BME Simonyi Károly Szakkollégium Lego köre
// Engineer: Csókás Bence
// 
// Create Date:    11:53:38 10/31/2019 
// Design Name: DVI/HDMI csatornakódoló
// Module Name:    DVICoder 
// Project Name: 
// Description: 
//
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DVICoder(
    input [7:0] blue,
    input [7:0] green,
    input [7:0] red,
    input hsync,
    input vsync,
    input visible,
    input pxclk,
	 input rst,
    output [9:0] data0,
    output [9:0] data1,
    output [9:0] data2
);

TMDS_8b10b_enc channel0(
	 .rst(rst),
    .d(blue),
    .c({vsync, hsync}),
    .den(visible), 
    .clk(pxclk), 
    .q(data0)
);

TMDS_8b10b_enc channel1(
	 .rst(rst),
    .d(green),
    .c(2'b0),
    .den(visible), 
    .clk(pxclk), 
    .q(data1)
);

TMDS_8b10b_enc channel2(
	 .rst(rst),
    .d(red),
    .c(2'b0),
    .den(visible), 
    .clk(pxclk), 
    .q(data2)
);

endmodule
