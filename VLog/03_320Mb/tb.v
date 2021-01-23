`timescale 1ns/1ps

//`define _DEBUG_320M_
`include "defs.v"

module test_ltc2271_320M;


reg rst;
reg clk_sys;	// System Clock
reg clk_320m;	// 320MHz Clock
reg ch0;
reg ch1;
reg ch2;
reg ch3;
wire [127:0] test_data;

`ifdef _DEBUG_320M_
wire [4:0] cnt;
wire f_clk;
wire p_clk;
`endif

//	instantilize
ltc2271_320M ltc(
	.rst(rst),
	.clk_sys(clk_sys),
	.clk_320m(clk_320m),
	.ch0(ch0),
	.ch1(ch1),
	.ch2(ch2),

`ifdef _DEBUG_320M_
	.ch3(ch3),
	.dout(test_data),
	.debug_cnt(cnt),
	.debug_f_clk(f_clk),
	.debug_p_clk(p_clk)
`else
	.ch3(ch3)
`endif
);

///////////////////////////////////////////////

initial
begin
	rst = 0;
	clk_sys = 0;
	clk_320m= 0;
	ch0 = 0;
	ch1 = 0;
	ch2 = 0;
	ch3 = 0;
end


always clk_sys = #1 ~clk_sys;	// generate system clock
always clk_320m = #2 ~clk_320m;	// generate 320MHz clock

// generate signals, just 0 or 1
always begin
ch0 = #1 ~ch0;
ch1 = #3 ~ch1;
ch2 = #5 ~ch2;
ch3 = #7 ~ch3;
end

// setup simulation output files
initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0,test_ltc2271_320M);
end

// setup simulation time domain
initial
begin
	#7;
	rst = 1;
	#1;
	rst = 0;
	#500;
	$finish;
end

endmodule
