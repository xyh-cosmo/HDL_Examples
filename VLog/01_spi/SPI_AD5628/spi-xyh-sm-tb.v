`timescale 1ns / 1ps


module SPI_SM_TB();

	reg clk;
	reg rst;
	wire sclk;
	wire mosi;
	wire cs;
	wire A0,A1;

	SPI_SM spi_sm(
		.clk(clk),
		.rst(rst),
		.sclk(sclk),
		.mosi(mosi),
		.cs(cs),
		.A0(A0),
		.A1(A1)
		);

	initial begin
		$dumpfile("wave-sm.vcd");
		$dumpvars(0,SPI_SM_TB);
	end

	initial begin
		rst = 0;
		#10;
		rst = ~rst;
		#5;
		rst = ~rst;

		#6000;

		// rst = 0;
		// #10;
		// rst = ~rst;
		// #5;
		// rst = ~rst;

		// #600;

		$finish;
	end


	// define clock
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

endmodule