`timescale 1ns / 1ps

module CLOCK_DIV_TB();

reg clk_sys;


wire clk_div_2_w;
wire clk_div_4_w;
wire clk_dic_8_w;


////////////////////////////////////////////////
//	instantiations
CLOCK_DIV 
	#(
		.DIV_FACTOR(2)
	)
	clk_div_2 (
		.clk_sys(clk_sys),
		.clk_div(clk_div_2_w)
	);

CLOCK_DIV
	#(
		.DIV_FACTOR(4),
		.CNT_START(1)
	)
	clk_div_4 (
		.clk_sys(clk_sys),
		.clk_div(clk_div_4_w)
	);

CLOCK_DIV
	#(
		.DIV_FACTOR(8),
		.CNT_START(2)
	)
	clk_div_8 (
		.clk_sys(clk_sys),
		.clk_div(clk_div_8_w)
	);

////////////////////////////////////////////////

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,CLOCK_DIV_TB);
end


initial begin
	
	#100;
	$finish;
end

// generate system clock
initial begin
	clk_sys = 0;
	forever #1 clk_sys = ~clk_sys;
end

endmodule