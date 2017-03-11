`timescale 1ns / 1ps

module vga(
	input clk,            // 50MHz时钟
	input rst,            // 复位
	output vgaclk,        // VGA信号时钟
	output [8:0]row,      // 当前行数
	output [9:0]column,   // 当前列数
	input [7:0]color,     // 当前颜色（BBGGGRR）
	output [2:0]vgaRed,   // VGA红色通道
	output [2:0]vgaGreen, // VGA绿色通道
	output [1:0]vgaBlue,  // VGA蓝色通道
	output vgaHsync,      // VGA水平同步
	output vgaVsync       // VGA垂直同步
);

	// 时序
	// 夏昊珺版 640x480@50Hz
	parameter CLKF = 25;      // 时钟频率（25或50）
	parameter H_SYNC = 96;    // 行同步信号（vgaclk周期数）
	parameter H_BEGIN = 144;  // 行数据起始点
	parameter H_END = 784;    // 行数据结束点+1
	parameter H_PERIOD = 800; // 行长度
	parameter V_SYNC = 2;     // 场同步信号（行数）
	parameter V_BEGIN = 31;   // 场数据起始行
	parameter V_END = 511;    // 场数据结束行+1
	parameter V_PERIOD = 521; // 场行数

	wire clk25;
	counter16 clk25c(clk, rst, 2, clk25);
	assign vgaclk = (CLKF == 50) ? clk : clk25;

	wire [9:0]hcount;
	counter16 hc(vgaclk, rst, H_PERIOD, hcount);
	assign vgaHsync = (hcount < H_SYNC) ? 0 : 1;
	assign column = hcount - H_BEGIN;

	wire [9:0]vcount;
	counter16 vc(~(hcount[9]), rst, V_PERIOD, vcount);
	assign vgaVsync = (vcount < V_SYNC) ? 0 : 1;
	assign row = vcount - V_BEGIN;

	wire de;
	assign de = (vcount >= V_BEGIN) && (vcount < V_END) && (hcount >= H_BEGIN) && (hcount < H_END);
	assign vgaRed = de ? color[2:0] : 0;
	assign vgaGreen = de ? color[5:3] : 0;
	assign vgaBlue = de ? color[7:6] : 0;

endmodule
