`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2019 21:00:36
// Design Name: 
// Module Name: x4_oserdes10to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module x4_oserdes10to1(

input wire clk,
input wire clk_5x,
input wire rst,
input wire [9:0] tmds_one,
input wire [9:0] tmds_two,
input wire [9:0] tmds_three,

output wire dout_pone,
output wire dout_none,

output wire dout_ptwo,
output wire dout_ntwo,

output wire dout_pthree,
output wire dout_nthree,

output wire tmds_clock_out_p,
output wire tmds_clock_out_n

    );
    
    oserdes_10to1 one(
 //�rajel �s reset.
 .clk(clk), //1x �rajel bemenet.
 .clk_5x(clk_5x), //5x �rajel bemenet (DDR m�d).
 .rst(rst), //Aszinkron reset jel.

 //10 bites adat bemenet.
 .data_in(tmds_one),

 //Differenci�lis soros adat kimenet.
 .dout_p(dout_pone),
 .dout_n(dout_none)
);


    oserdes_10to1 two(
 //�rajel �s reset.
 .clk(clk), //1x �rajel bemenet.
 .clk_5x(clk_5x), //5x �rajel bemenet (DDR m�d).
 .rst(rst), //Aszinkron reset jel.

 //10 bites adat bemenet.
 .data_in(tmds_two),

 //Differenci�lis soros adat kimenet.
 .dout_p(dout_ptwo),
 .dout_n(dout_ntwo)
);


    oserdes_10to1 three(
 //�rajel �s reset.
 .clk(clk), //1x �rajel bemenet.
 .clk_5x(clk_5x), //5x �rajel bemenet (DDR m�d).
 .rst(rst), //Aszinkron reset jel.

 //10 bites adat bemenet.
 .data_in(tmds_three),

 //Differenci�lis soros adat kimenet.
 .dout_p(dout_pthree),
 .dout_n(dout_nthree)
);


wire clk_out;
ODDR #(
 .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE" vagy "SAME_EDGE".
 .INIT(1'b0), // A Q kimenet kezdeti �rt�ke.
 .SRTYPE("ASYNC") // "SYNC" vagy "ASYNC" be�ll�t�s/t�rl�s.
) ODDR_clk (
 .Q(clk_out), // 1 bites DDR kimenet.
 .C(clk), // 1 bites �rajel bemenet.
 .CE(1'b1), // 1 bites �rajel enged�lyez� bemenet.
 .D1(1'b1), // 1 bites adat bemenet (felfut� �l).
 .D2(1'b0), // 1 bites adat bemenet (lefut� �l).
 .R(rst), // 1 bites t�rl� bemenet.
 .S(1'b0) // 1 bites 1-be �ll�t� bemenet.
);

OBUFDS #(
 .IOSTANDARD("TMDS_33"),
 .SLEW("FAST")
) OBUFDS_clk (
 .I(clk_out),
 .O(tmds_clock_out_p),
 .OB(tmds_clock_out_n)
);
    
endmodule
