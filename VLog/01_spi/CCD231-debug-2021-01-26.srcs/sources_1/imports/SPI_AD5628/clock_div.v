`timescale 1ns / 1ps

module CLOCK_DIV
	#(
		parameter DIV_FACTOR	= 2,
		parameter CNT_START	= 0,
		parameter CYCLES_MAX	= 10
	)
	(
		input clk_sys,
		input en,
		(*mark_debug="true"*) output clk_div,
		output status
	);

	reg[7:0] clk_cnt		= CNT_START;
	parameter clk_cnt_max	= DIV_FACTOR / 2;
	

	reg[31:0] cycle_cnt		= 32'd0;
	reg status_r			= 1'b0;
	assign status			= status_r;


	reg clk_div_r = 0;
	assign clk_div = clk_div_r;


	always@( posedge clk_sys ) begin
		if( en == 0 ) begin
			status_r	<= 1'b0;
			cycle_cnt	<= 32'd0;
		end
		else begin
			clk_cnt <= clk_cnt + 8'd1;
			
			if( clk_cnt >= clk_cnt_max-1 && status_r == 1'b0 ) begin
				clk_div_r	<= ~clk_div_r;
				clk_cnt		<= 8'd0;
				cycle_cnt	<= cycle_cnt + 32'd1;
			end

			if( CYCLES_MAX > 0 ) begin
				if( cycle_cnt >= CYCLES_MAX*2 )
					status_r	<= 1'b1;
			end
		end
	end

endmodule
