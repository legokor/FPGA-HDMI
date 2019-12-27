`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:20 10/31/2019 
// Design Name: 
// Module Name:    dvi 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dvi(
	// Pixel órajel
    input clk,
	 // 5x-ös órajel
    input clk5x,
	 // AXI4S órajel
	input axis_aclk,
	// AXI4S portok
	input axis_aresetn,
	input axis_tvalid,
	output axis_tready,
	input [7:0] axis_tdata,
	input [0:0] axis_tstrb,
	input [0:0] axis_tkeep,
	input axis_tlast,
//	input [0:0] axis_tid,
//	input [0:0] axis_tdest,
	 // 0. (kék) csatorna
    output dout0_p,
    output dout0_n,
	 // 1. (zöld) csatorna
    output dout1_p,
    output dout1_n,
	 // 2. (vörös) csatorna
    output dout2_p,
    output dout2_n,
	 // 3. (órajel) csatorna
    output dout3_p,
    output dout3_n
);

wire [7:0] red_in, green_in, blue_in;
wire rst=!axis_aresetn;
wire [10:0] column_addr;
wire [9:0] row_addr;
wire [7:0] red, green, blue;
wire [9:0] data0, data1, data2;
wire vsync, hsync, visible;

vram videoram (
    .axis_aclk(axis_aclk), 
    .axis_aresetn(axis_aresetn), 
    .axis_tvalid(axis_tvalid), 
    .axis_tready(axis_tready), 
    .axis_tdata(axis_tdata), 
    .axis_tstrb(axis_tstrb), 
    .axis_tkeep(axis_tkeep), 
    .axis_tlast(axis_tlast), 
    .vram_col(column_addr), 
    .vram_row(row_addr), 
    .vram_red(red_in), 
    .vram_green(green_in), 
    .vram_blue(blue_in)
    );

vga view(
    .clk(clk), 
    .rst(rst), 
    .column_addr(column_addr), 
    .row_addr(row_addr), 
    .red_in(red_in), 
    .green_in(green_in), 
    .blue_in(blue_in), 
    .red_out(red), 
    .green_out(green), 
    .blue_out(blue), 
    .vsync_out(vsync), 
    .hsync_out(hsync), 
    .visible(visible)
);

DVICoder coder(
	 .rst(rst),
    .blue(blue), 
    .green(green), 
    .red(red), 
    .hsync(hsync), 
    .vsync(vsync), 
    .visible(visible), 
    .pxclk(clk), 
    .data0(data0), 
    .data1(data1), 
    .data2(data2)
);

x4_oserdes10to1 serdes (
    .clk(clk), 
    .clk_5x(clk5x), 
    .rst(rst), 
    .tmds_one(data0), 
    .tmds_two(data1), 
    .tmds_three(data2), 
    .dout_pone(dout0_p), 
    .dout_none(dout0_n), 
    .dout_ptwo(dout1_p), 
    .dout_ntwo(dout1_n), 
    .dout_pthree(dout2_p), 
    .dout_nthree(dout2_n), 
    .tmds_clock_out_p(dout3_p), 
    .tmds_clock_out_n(dout3_n)
    );

endmodule
