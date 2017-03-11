`timescale 1ns / 1ps

module mouse(
	input clk,         // 板载时钟信号
	input rst,         // 复位信号
	input PS2C_act,    // PS/2时钟信号
	input PS2D,        // PS/2数据信号
	output reg [9:0]x, // X坐标
	output reg [7:0]y, // Y坐标
	output btnl,       // 鼠标左键
	output btnr        // 鼠标右键
);

	// 对时钟信号取样，否则不知为何无法正常工作
	reg PS2C;
	always@(posedge clk) PS2C <= PS2C_act;

	// 鼠标发来的4个字节
	reg [7:0]w1;
	reg [7:0]w2;
	reg [7:0]w3;
	reg [7:0]w4;
	reg [12:0]idlec;
	always@(posedge clk or posedge rst) begin
		if(rst) idlec <= 1;
		else if(~PS2C) idlec <= 1;
		else if(idlec != 0) idlec <= idlec + 1;
	end
	assign idle = (idlec == 0);

	// 时钟信号的旧值
	reg oldps2c;
	always@(posedge clk) begin
		oldps2c <= PS2C;
	end

	wire [9:0]newx;
	wire [9:0]newy;
	assign newx = x + {w2[7], w2[7], w2};
	assign newy = {2'b00, y} - {w3[7], w3[7], w3};

	reg [2:0]state;
	reg [8:0]step;
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			w1 <= 0;
			w2 <= 0;
			w3 <= 0;
			w4 <= 0;
			x <= 349;
			y <= 114;
			state <= 7;
			step <= 0;
		end
		else if(idle && PS2C) state <= 0;
		else if(oldps2c & ~PS2C) case(state)
			0: if(~PS2D) begin
					state <= 1;
					step <= 0;
				end
			1: begin
				if(step[3] == 0) w1[step] <= PS2D;
				if(step == 10)	state <= 2;
				if(step == 10) step <= 0;
				else step <= step + 1;
			end
			2: begin
				if(step[3] == 0) w2[step] <= PS2D;
				if(step == 10)	state <= 3;
				if(step == 10) step <= 0;
				else step <= step + 1;
			end
			3: begin
				if(step[3] == 0) w3[step] <= PS2D;
				if(step == 10)	state <= 4;
				if(step == 10) step <= 0;
				else step <= step + 1;
			end
			4: begin
				if(step[3] == 0) w4[step] <= PS2D;
				if(step == 10)	state <= 5;
				if(step == 10) step <= 0;
				else step <= step + 1;
				if(step == 0) begin
					x <= newx > 861 ? 0 : newx > 698 ? 698 : newx;
					y <= (newy > 760) || (newy < 50) ? 50 : newy > 228 ? 228 : newy;
				end
			end
			5: begin
				state <= 6;
			end
			6: begin
				state <= 6;
			end
		endcase
	end

	assign btnl = w1[0];
	assign btnr = w1[1];

endmodule
