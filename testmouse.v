`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:28:37 11/30/2016
// Design Name:   mouse
// Module Name:   C:/Users/fasds/Projects/fpga_csgo/testmouse.v
// Project Name:  fpga_csgo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mouse
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testmouse;

	// Inputs
	reg clk;
	reg rst;
	reg PS2C;
	reg PS2D;

	// Outputs
	wire [9:0] x;
	wire [7:0] y;
	wire btnl;
	wire btnr;
	wire [7:0]led;

	// Instantiate the Unit Under Test (UUT)
	mouse uut (
		.clk(clk), 
		.rst(rst), 
		.PS2C(PS2C), 
		.PS2D(PS2D), 
		.x(x), 
		.y(y), 
		.btnl(btnl), 
		.btnr(btnr),
		.led(led)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		PS2C = 0;
		PS2D = 0;

		// Wait 100 ns for global reset to finish
		#107;
        
		// Add stimulus here
		rst = 1;
		#10;
		rst = 0;
		#10;
		
		PS2C = 1;
		PS2D = 1;
		#100000;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#100000;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#100000;
		PS2C = 0;
		#100000;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#100000;
		PS2C = 0;
		#100000;

		PS2C = 1;
		PS2D = 0;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;

		PS2C = 1;
		PS2D = 1;
		#10;
		PS2C = 0;
		#10;


	end
	always begin
	#2;
	clk=~clk;
	end
      
endmodule

