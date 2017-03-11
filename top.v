`timescale 1ns / 1ps

module top(
	input clk,
	input rst,
	output [2:0]vgaRed,
	output [2:0]vgaGreen,
	output [1:0]vgaBlue,
	output vgaHsync,
	output vgaVsync,
	output MemOE,
	output MemWR,
	output FlashRp,
	output FlashCS,
	output reg [23:1]MemAdr,
	input [15:0]MemDB,
	input [7:0]sw,
	input [3:0]btn,
	output [7:0]led,
	input PS2C,
	input PS2D,
	output [3:0]an,
	output [6:0]seg
);

	// 敌人的坐标，测量出来后要减去(320, 240)
	parameter E1L = 38;
	parameter E1R = 55;
	parameter E1T = 145;
	parameter E1B = 205;
	parameter E2L = 230;
	parameter E2R = 259;
	parameter E2T = 168;
	parameter E2B = 233;
	parameter E3L = 362;
	parameter E3R = 383;
	parameter E3T = 162;
	parameter E3B = 237;
	parameter E4L = 466;
	parameter E4R = 488;
	parameter E4T = 99;
	parameter E4B = 146;

	wire vgaclk;
	wire [8:0]row;
	wire [9:0]column;
	wire [7:0]color;
	vga myvga(clk, rst, vgaclk, row, column, color, vgaRed, vgaGreen, vgaBlue, vgaHsync, vgaVsync);

	wire [9:0]x;
	wire [7:0]my;
	wire btnl;
	wire btnr;
	mouse mymouse(clk, rst, PS2C, PS2D, x, my, btnl, btnr);

	reg [3:0]score3;
	reg [3:0]score2;
	reg [3:0]score1;
	reg [3:0]score0;
	display scoredisplay(clk, score3, score2, score1, score0, an, seg);

	reg [6:0]yoffset; // 枪口上扬，是正数
	wire [7:0]y;
	assign y = my - yoffset;

	reg [3:0]ammo; // 剩余子弹数量
	assign led = 255 << (8-ammo);

	reg [6:0]hp;
	reg [3:0]enemy; // 四个点是否有敌人

	wire [10:0]rr;
	wire [10:0]rc;
	assign rr = y - 240 + row;
	assign rc = x - 320 + column;

	// 背景
	assign MemOE = 0;
	assign MemWR = 0;
	assign FlashRp = 1;
	assign FlashCS = 0;
	reg [15:0]cachebg;
	wire picture;
	assign picture = rc < 130 ? enemy[0] : rc < 290 ? enemy[1] : rc < 410 ? enemy[2] : rc < 670 ? enemy[3] : enemy[0];
	always@(posedge vgaclk or posedge rst) begin
		if(rst) begin
			cachebg <= 0;
			MemAdr <= 0;
		end
		// 如果下周期要显示偶数列，就读出已经准备好的数据，并预取之后的数据
		else if(column[0]) begin
			cachebg <= MemDB;
			MemAdr <= ({picture, 21'd0} | (((y + row) << 11) + ((column + 3) & 11'b01111111111) + x)) >> 1;
		end
	end
	wire [7:0]background;
	assign background = column[0] ? cachebg[15:8] : cachebg[7:0];
	//assign led = (column[2:0]==6) ? ~(cachebg[7:0]) : (column[2:0]==7?~(cachebg[15:8]):0);

	// 准星
	wire [7:0]hud;
	assign hud = ((column == 320 && row >= 237 && row <= 243) || (row == 240 && column >= 317 && column <= 323)) ? 255 :
		((column == 320 && row >= 230 && row <= 250) || (row == 240 && column >= 310 && column <= 330)) ? 0 :
		192;

	// HP显示
	wire [7:0]hpdisplay;
	assign hpdisplay = (row >= 465 && row < 475 && column > 5 && column <= 5 + (hp << 1)) ? 7 : 192;

	// 子弹数量显示
	wire [7:0]ammodisplay;
	assign ammodisplay = (column >= 605 && column < 635 && row < 475 && row >= 475 - (ammo << 4)) ? 8'b00111111 : 192;

	wire [7:0]e1display;
	assign e1display = (enemy[0] && rc >= E1L && rc < E1R && rr >= E1T && rr < E1B) ? 7 : 192;
	wire [7:0]e2display;
	assign e2display = (enemy[1] && rc >= E2L && rc < E2R && rr >= E2T && rr < E2B) ? 7 : 192;
	wire [7:0]e3display;
	assign e3display = (enemy[2] && rc >= E3L && rc < E3R && rr >= E3T && rr < E3B) ? 7 : 192;
	wire [7:0]e4display;
	assign e4display = (enemy[3] && rc >= E4L && rc < E4R && rr >= E4T && rr < E4B) ? 7 : 192;

	// 结束画面
	wire [7:0]theend;
	assign theend = (hp == 0) ? 7 : 192;

	// 合成最终图形
	assign color = (theend != 192) ? theend :
		(hud != 192) ? hud :
		(hpdisplay != 192) ? hpdisplay :
		(ammodisplay != 192) ? ammodisplay :
		background;

	// 枪的射速是11.9Hz
	reg [21:0]shoot;
	reg lastshoot21;
	reg [21:0]offreset;
	reg lastors21;
	reg [26:0]reload;
	always@(posedge clk or posedge rst) begin
		if(rst) shoot <= 22'b1111111111111111111111;
		else if(btnl) shoot <= shoot + 1;
		else shoot <= 22'b1111111111111111111111;
	end
	always@(posedge clk or posedge rst) begin
		if(rst) offreset <= 22'b1111111111111111111111;
		else offreset <= offreset + 1;
	end
	always@(posedge clk or posedge rst) begin
		if(rst) lastshoot21 <= 0;
		else lastshoot21 <= shoot[21];
	end
	always@(posedge clk or posedge rst) begin
		if(rst) lastors21 <= 0;
		else lastors21 <= offreset[21];
	end
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			ammo <= 8;
			reload <= 0;
		end
		else begin
			if(&reload) ammo <= 8;
			if(|reload) reload <= reload + 1;
			else if(lastshoot21 & ~(shoot[21])) begin
				if(ammo == 1) reload <= 1;
				ammo <= ammo - 1;
			end
			if(~(|reload) && (lastshoot21 & ~(shoot[21]))) yoffset <= yoffset + 5;
			else if((lastors21 & ~(offreset[21])) && yoffset != 0) yoffset <= yoffset - 1;
		end
	end

	reg [26:0]enemytimer;
	wire [3:0]enemycount;
	assign enemycount = {3'b000, enemy[0]} + {3'b000, enemy[1]} + {3'b000, enemy[2]} + {3'b000, enemy[3]};
	always@(posedge clk or posedge rst) begin
		if(rst) enemytimer <= 0;
		else enemytimer <= enemytimer + 1;
	end
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			enemy <= 0;
			hp <= 100;
			score3 <= 0;
			score2 <= 0;
			score1 <= 0;
			score0 <= 0;
		end
		else begin
			if(~(|reload) && (lastshoot21 & ~(shoot[21]))) begin
				if(enemy[0] && x >= E1L && x < E1R && y >= E1T && y < E1B) begin
					enemy[0] <= 0;
					if(score0 == 9) begin
						if(score1 == 9) begin
							if(score2 == 9) begin
								score3 <= score3 + 1;
								score2 <= 0;
							end else score2 <= score2 + 1;
							score1 <= 0;
						end else score1 <= score1 + 1;
						score0 <= 0;
					end else score0 <= score0 + 1;
				end
				else if(enemy[1] && x >= E2L && x < E2R && y >= E2T && y < E2B) begin
					enemy[1] <= 0;
					if(score0 == 9) begin
						if(score1 == 9) begin
							if(score2 == 9) begin
								score3 <= score3 + 1;
								score2 <= 0;
							end else score2 <= score2 + 1;
							score1 <= 0;
						end else score1 <= score1 + 1;
						score0 <= 0;
					end else score0 <= score0 + 1;
				end
				else if(enemy[2] && x >= E3L && x < E3R && y >= E3T && y < E3B) begin
					enemy[2] <= 0;
					if(score0 == 9) begin
						if(score1 == 9) begin
							if(score2 == 9) begin
								score3 <= score3 + 1;
								score2 <= 0;
							end else score2 <= score2 + 1;
							score1 <= 0;
						end else score1 <= score1 + 1;
						score0 <= 0;
					end else score0 <= score0 + 1;
				end
				else if(enemy[3] && x >= E4L && x < E4R && y >= E4T && y < E4B) begin
					enemy[3] <= 0;
					if(score0 == 9) begin
						if(score1 == 9) begin
							if(score2 == 9) begin
								score3 <= score3 + 1;
								score2 <= 0;
							end else score2 <= score2 + 1;
							score1 <= 0;
						end else score1 <= score1 + 1;
						score0 <= 0;
					end else score0 <= score0 + 1;
				end
			end
			else if(enemytimer == 0) enemy[{x[0]^hp[0], y[0]^ammo[0]}] <= 1;
			if(enemytimer[22:0] == 0) begin
				if(hp < enemycount) hp <= 0;
				else if(~(sw[7]))hp <= hp - enemycount;
			end
		end
	end

endmodule
