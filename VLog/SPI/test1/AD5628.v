`timescale 1ns / 1ps

// 将用于配置AD5628的各种数据全部一一列出。
// 在对AD5628进行配置的时候，通过一个状态机进行控制，按照顺序一步一步对每一个LDAC进行配置

module AD5628(
	input clk,
	input clk_dvi,
	input rst,
	output sclk,
	output dout 
	);

wire[7:0] clk_div;	// max value = 0'b11111111 = 255
reg[7:0] sclk_cnt;
reg sclk_r;	// 用于生成驱动SPI设备工作的时钟

assign sclk = sclk_r;

//	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			sclk 		<= 1'b0;	// 这里应该根据时钟极性来设定！！！！
			sclk_cnt	<=	8'b0;
		end
		else if () begin
			
		end
	end

//	根据给定的clk_div生成驱动SPI设备的时钟
	always @(posedge clk) begin
		if( sclk_cnt 	>= clk_div ) begin
			sclk_cnt 	<= 8'b0;
			sclk_r		<= ~sclk_r;

		end
		else 
			sclk_cnt 	<= sclk_cnt + 1;
	end

endmodule