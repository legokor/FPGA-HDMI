`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BME Simonyi Károly Szakkollégium Lego köre
// Engineer: Csókás Bence
// 
// Create Date:    00:50:31 12/27/2019 
// Design Name: AXI4Stream-illeszthető Video RAM
// Module Name:    vram 
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
module vram(
	// AXI4S portok
	input axis_aclk,
	input axis_aresetn,
	input axis_tvalid,
	output axis_tready,
	input [7:0] axis_tdata,
	input [0:0] axis_tstrb,
	input [0:0] axis_tkeep,
	input axis_tlast,
//	input [0:0] axis_tid,
//	input [0:0] axis_tdest,

	// VRAM portok
   input [10:0] vram_col,
   input [ 9:0] vram_row,
	output [7:0] vram_red,
	output [7:0] vram_green,
	output [7:0] vram_blue
    );

// TODO: BRAM
reg [23:0] pixels [20:0];

reg [10:0] hcntr;
reg [ 9:0] vcntr;
reg [ 1:0] dcntr;

wire hend=&hcntr;
wire dend=dcntr==2'd2;

// TODO: TREADY
assign axis_tready=1'b1;

wire reset=!axis_aresetn;
wire valid=axis_tvalid && axis_tkeep && axis_tstrb;
wire [20:0] addr={vcntr, hcntr};

always @(posedge axis_aclk)
	if(reset) begin
		hcntr <= 11'b0;
		vcntr <= 10'b0;
		dcntr <= 2'b0;
	end else if(valid) begin
		pixels[addr] <= pixels[addr] | (axis_tdata<<{dcntr, 3'b0});
		if(axis_tlast) begin
			dcntr <= 2'b0;
			hcntr <= 11'b0;
			vcntr <= 10'b0;
		end else begin
			dcntr <= dcntr+2'b1;
			if(dend) begin
				hcntr <= hcntr+11'b1;
				if(hend)
					vcntr <= vcntr+10'b1;
			end
		end
	end

wire vram_addr={vram_row, vram_col};
assign {vram_red, vram_green, vram_blue}=pixels[vram_addr];

endmodule
