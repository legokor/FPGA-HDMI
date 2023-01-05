`timescale 1ns / 1ps

module vga #(
    parameter HBITS    = 11,
    parameter HVISIBLE = 800,
    parameter HFPORCH  = 40,
    parameter HSPULSE  = 128,
    parameter HBPORCH  = 88,
    parameter HSINVERT = 0,

    parameter VBITS    = 10,
    parameter VVISIBLE = 600,
    parameter VFPORCH  = 1,
    parameter VSPULSE  = 4,
    parameter VBPORCH  = 23,
    parameter VSINVERT = 0
)(
    input clk,
    input rst,

    output [HBITS-1 : 0] column_addr,
    output [VBITS-1 : 0] row_addr,

    input [7:0] red_in,
    input [7:0] green_in,
    input [7:0] blue_in,
 
    output [7:0] red_out,
    output [7:0] green_out,
    output [7:0] blue_out,
    output vsync_out,
    output hsync_out,
    input frame_sync,
    output visible
);

localparam HSIZE = HVISIBLE + HFPORCH + HSPULSE + HBPORCH;
localparam HSBEGIN = HVISIBLE + HFPORCH;
localparam HSEND = HVISIBLE + HFPORCH + HSPULSE;

localparam VSIZE = VVISIBLE + VFPORCH + VSPULSE + VBPORCH;
localparam VSBEGIN = VVISIBLE + VFPORCH;
localparam VSEND = VVISIBLE + VFPORCH + VSPULSE;

(* mark_debug = "true" *)
reg [HBITS-1 : 0] hcntr;
(* mark_debug = "true" *)
reg [VBITS-1 : 0] vcntr;

wire enable = 1'b1;

wire hoverflow = hcntr == HSIZE - 1;
wire voverflow = vcntr == VSIZE - 1;

always @(posedge clk)
	if (rst)
		hcntr <= 10'b0;
	else if (frame_sync)
		hcntr <= HVISIBLE;
	else if(enable)
		if(hoverflow)
			hcntr <= 10'b0;
		else
			hcntr <= hcntr + 1;
		
always @(posedge clk)
	if (rst)
		vcntr <= 10'b0;
	else if (frame_sync)
		vcntr <= VVISIBLE;
	else if (enable & hoverflow)
		if(voverflow)
			vcntr <= 10'b0;
		else
			vcntr <= vcntr + 1;

assign column_addr = hcntr;
assign row_addr = vcntr;

wire hsync;
wire vsync;

assign hsync = (hcntr >= HSBEGIN) & (hcntr < HSEND);
assign vsync = (vcntr >= VSBEGIN) & (vcntr < VSEND);

assign hsync_out = HSINVERT ? ~hsync : hsync;
assign vsync_out = VSINVERT ? ~vsync : vsync;

wire active_region;
assign active_region = (hcntr < HVISIBLE) & (vcntr < VVISIBLE);
assign visible=active_region;

assign red_out   = active_region ? red_in   : 'b0;
assign blue_out  = active_region ? blue_in  : 'b0;
assign green_out = active_region ? green_in : 'b0;

endmodule
