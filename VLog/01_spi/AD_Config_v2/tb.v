`timescale 1ns / 1ps

module top();

	//	inputs
	reg clk_50M;
	reg rst;
	reg[31:0] spi_data;
	reg spi_cpol;
	reg spi_cpha;
	reg ps_A0;
	reg ps_A1;

	// 	outputs
	wire A0, A1;
	wire sclk;
	wire mosi;
	wire status;

	// instalization of spi4adc

	SPI4ADC spi4adc(
		.clk(clk_50M),
		.rst(rst),
		.spi_data(spi_data),
		.spi_cpol(spi_cpol),
		.spi_cpha(spi_cpha),
		.ps_A0(ps_A0),
		.ps_A1(ps_A1),
		.A0(A0),
		.A1(A1),
		.sclk(sclk),
		.mosi(mosi),
		.status(status)
		);

	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,top);
	end

	initial begin
		rst = 0;
		ps_A0 = 0;
		ps_A1 = 1;
		spi_cpol = 1;
		spi_cpha = 0;
		// spi_data = 32'b1010_1010_1010_1010_1010_1010_1010_1010;
		spi_data = 32'b1111_1000_0000_0000_0000_0000_0000_0001;

		#10 rst = ~rst;
		#5	rst = ~rst;

		// first round
		#7000;

		ps_A0 = 1;
		ps_A1 = 0;
		spi_cpol = 1;
		spi_cpha = 0;
		// spi_data = 32'b0101_0101_0101_0101_0101_0101_0101_0101;
		spi_data = 32'b1111_0100_0000_0000_0000_0000_1111_1111;

		#10 rst = ~rst;
		#5	rst = ~rst;

		// second round
		#7000;

		$finish;
	end

	// generate 50MHz system clock signal
	initial begin
		clk_50M = 0;
		forever # 10 clk_50M = ~clk_50M;
	end

endmodule