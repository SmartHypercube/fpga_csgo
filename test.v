`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:59:02 11/25/2016
// Design Name:   top
// Module Name:   C:/Users/fasds/Projects/fpga_csgo/test.v
// Project Name:  fpga_csgo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk;
	reg rst;
	reg [15:0] MemDB;
	reg [7:0] sw;
	reg [3:0] btn;

	// Outputs
	wire [2:0] vgaRed;
	wire [2:0] vgaGreen;
	wire [1:0] vgaBlue;
	wire vgaHsync;
	wire vgaVsync;
	wire MemOE;
	wire MemWR;
	wire FlashRp;
	wire FlashCS;
	wire [23:1] MemAdr;
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst), 
		.vgaRed(vgaRed), 
		.vgaGreen(vgaGreen), 
		.vgaBlue(vgaBlue), 
		.vgaHsync(vgaHsync), 
		.vgaVsync(vgaVsync), 
		.MemOE(MemOE), 
		.MemWR(MemWR), 
		.FlashRp(FlashRp), 
		.FlashCS(FlashCS), 
		.MemAdr(MemAdr), 
		.MemDB(MemDB), 
		.sw(sw), 
		.btn(btn), 
		.led(led)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		MemDB = 0;
		sw = 0;
		btn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst=1;
		#20;
		rst=0;
		#20;

	end
	always begin
	#10;
	clk = ~clk;
	end
	always @(posedge MemAdr[1] or negedge MemAdr[1])begin
	#18;
	MemDB = MemAdr;
	end
      
endmodule

