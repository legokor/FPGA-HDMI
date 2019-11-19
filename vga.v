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
	 output visible
);

localparam HSIZE = HVISIBLE + HFPORCH + HSPULSE + HBPORCH;
localparam HSBEGIN = HVISIBLE + HFPORCH;
localparam HSEND = HVISIBLE + HFPORCH + HSPULSE;

localparam VSIZE = VVISIBLE + VFPORCH + VSPULSE + VBPORCH;
localparam VSBEGIN = VVISIBLE + VFPORCH;
localparam VSEND = VVISIBLE + VFPORCH + VSPULSE;

reg [HBITS-1 : 0] hcntr;
reg [VBITS-1 : 0] vcntr;

always @(posedge clk)
	if (rst | (hcntr == HSIZE-1)) 
		hcntr <= 10'b0;
	else
		hcntr <= hcntr + 1;
		
always @(posedge clk)
	if (rst | (vcntr == VSIZE-1 && hcntr == HSIZE - 1)) 
		vcntr <= 10'b0;
	else if (hcntr == HSIZE-1)
		vcntr <= vcntr + 1;

assign column_addr = hcntr;
assign row_addr = vcntr;



reg [HBITS-1 : 0] hcntr_prev;
reg [VBITS-1 : 0] vcntr_prev;

always @(posedge clk) begin
	hcntr_prev <= hcntr;
	vcntr_prev <= vcntr;
end


wire hsync;
wire vsync;

assign hsync = (hcntr_prev >= HSBEGIN) & (hcntr_prev < HSEND);
assign vsync = (vcntr_prev >= VSBEGIN) & (vcntr_prev < VSEND);

assign hsync_out = HSINVERT ? ~hsync : hsync;
assign vsync_out = VSINVERT ? ~vsync : vsync;

wire active_region;
assign active_region = (hcntr_prev < HVISIBLE) & (vcntr_prev < VVISIBLE);
assign visible=active_region;

assign red_out   = active_region ? red_in   : 1'b0;
assign blue_out  = active_region ? blue_in  : 1'b0;
assign green_out = active_region ? green_in : 1'b0;

endmodule
