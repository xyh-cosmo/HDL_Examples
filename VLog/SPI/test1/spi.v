`timescale 1ns / 1ps


//	SPI_Master：根据当前的状态“调用”相应的模块，并向对应的模块写入数据

module SPI_Master(
	input sys_rst,
	input sys_clk,
	output sclk,
	output[7:0] mosi,
	input[7:0] miso,
	output	A0,
	output	A1
	};

	always@( posedge sys_clk or posedge sys_rst ) begin
		if(!sys_clk) begin
			A0 <= 1'b0;
			A1 <= 1'b0;
			mosi <= 8'b0;
		end
	end




endmodule
