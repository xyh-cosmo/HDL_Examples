`timescale 1ns / 1ps

`ifndef _DEBUG_
	`define _DEBUG_
`endif

`include "../spi_base.v"
`include "../spi_control.v"
`include "../clock_div.v"
`include "./top.v"

//	Created @2021-01-26
//	Author: Youhua Xu
//	
//	This testbench file contains the following simulations:
//	1) simulates the process of AD5628 configuration
//	2) after AD5628 been configured, start to send square waves (f=1MHz) to DG636
//	   

module TOP_TB();

	reg clk_sys_50M;
	reg rst_sys;

	wire sclk;
	wire mosi;
	wire cs;
	wire A0;
	wire A1;
	wire sq_wave;

	TOP top(
		.clk_sys(clk_sys_50M),
		.rst_sys(rst_sys),
		.sclk(sclk),
		.mosi(mosi),
		.A0(A0),
		.A1(A1),
		.cs(cs),
		.sq_wave(sq_wave)
		);


	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,TOP_TB);
	end

	// define the time domain of the simulation
	initial begin
		rst_sys = 0;
		
		#10;
		rst_sys = ~rst_sys;
		
		#5;
		rst_sys = ~rst_sys;

		#100000;

		$finish;
	end


	// generate the system clock: clk_sys, f = 50MHz
	initial begin
		clk_sys_50M = 0;
		forever #10 clk_sys_50M = ~clk_sys_50M;
	end

endmodule
