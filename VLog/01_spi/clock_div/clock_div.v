`timescale 1ns / 1ps

module CLOCK_DIV
	#(
		parameter DIV_FACTOR = 2,
		parameter CNT_START = 0
	)
	(
		input clk_sys,
		output clk_div
	);

	reg[7:0] clk_cnt = CNT_START;
	parameter clk_cnt_max = DIV_FACTOR / 2;


	reg clk_div_r = 0;
	assign clk_div = clk_div_r;

	always@( posedge clk_sys ) begin
		clk_cnt <= clk_cnt + 8'd1;
		// $display("@ %d, clk_cnt_max = %d",DIV_FACTOR,clk_cnt_max);
		if( clk_cnt >= clk_cnt_max-1 ) begin
			clk_div_r	<= ~clk_div_r;
			clk_cnt		<= 8'd0;
		end
	end


endmodule
