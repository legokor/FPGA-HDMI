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
    input clk,
    input rst,
    input [7:0] red_in,
    input [7:0] green_in,
    input [7:0] blue_in,
    output [10:0] column_addr,
    output [9:0] row_addr,
    output [9:0] data0,
    output [9:0] data1,
    output [9:0] data2
);

wire [7:0] red, green, blue;
wire vsync, hsync, visible;

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

endmodule
