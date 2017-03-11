`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:25:44 12/01/2016 
// Design Name: 
// Module Name:    display 
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

module display(
	input clk,
	input [3:0]num3,
	input [3:0]num2,
	input [3:0]num1,
	input [3:0]num0,
	output reg [3:0]an=4'b1110,
	output reg [6:0]seg
);

	wire [15:0]clk25000;
	counter16 dc(clk, 0, 25000, clk25000);
	reg [1:0]c = 0;
	wire [3:0]num;
	assign num = c[1] ? (c[0] ? num3 : num2) : (c[0] ? num1 : num0);
	always@(posedge clk) if(clk25000 == 0) begin
		an<={an[2:0],an[3]};
		c<=c+1;
	end
	always@(*) case(num)
		0: seg = 7'b1000000;
		1: seg = 7'b1111001;
		2: seg = 7'b0100100;
		3: seg = 7'b0110000;
		4: seg = 7'b0011001;
		5: seg = 7'b0010010;
		6: seg = 7'b0000010;
		7: seg = 7'b1111000;
		8: seg = 7'b0000000;
		9: seg = 7'b0010000;
		10:seg = 7'b0001000;
		11:seg = 7'b0000011;
		12:seg = 7'b1000110;
		13:seg = 7'b0100001;
		14:seg = 7'b0000110;
		15:seg = 7'b0001110;
	endcase
endmodule
