`timescale 1ns / 1ps

module counter16(
	input clk,             // 时钟
	input rst,             // 复位
	input [15:0]range,     // 计数范围
	output reg [15:0]value // 当前计数值
);

	always@(posedge clk or posedge rst) begin
		if(rst) value <= 0;
		else if(value == range - 1) value <= 0;
		else value <= value + 1;
	end

endmodule
