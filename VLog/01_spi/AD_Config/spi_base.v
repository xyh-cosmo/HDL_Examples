//	Created@2021-01-26
//	Author: Youhua Xu
//


`timescale 1ns / 1ps

// SPI Master (不含MISO)
// NOTE:数据时钟频率是SCLK的一半，计数器一定要数清楚！
// TODO：进行规范化，改为每次发送固定长度的bit数（8位）
// Note added @2021-01-26: 作为“基模块”，还是设计成可以发送任意长度bits比较好，
// 这样一来在更高一层的模块中可以更加灵活地进行实例化。

module SPI_BASE
	#(
		parameter DATAWIDTH = 32,			// SPI数据宽度
		parameter CNT_WIDTH	= 8,			// 计数器宽度
        parameter CPOL      = 0,			// 时钟极性
        parameter CPHA      = 1,			// 时钟相位
        parameter CLKDIV    = 16,			// 时钟分频倍率
		parameter SPINAME	= SPI_DEFAULT	// SPI_DEFAULT = SPI_AD5628
	)
	(
    //  inputs:
		input                       clk,
		input                       rst,	// active high
		input wire[DATAWIDTH-1:0]   din,	// data to be send to slave-SPI devices
		input wire[7:0]				n_bits,	// bit number to the data to be sent
		input 						en,

    //  outputs:
		output                      sclk,
		output                      dout,	// MOSI
		output                      cs, 	// chip-selection
		output                      A0,
		output                      A1,

		output reg					finished	// 1 means finished transmission
	);

//	内部寄存器，可以改变状态
	reg			sclk_r;      // 分频时钟
	reg[7:0] 	clk_cnt;     // 分频时钟的计数器
    reg[7:0]    dat_cnt;     // 数据计数器（循环）
	reg[7:0]	d_cnt;		 // 数据的“位”指示器
	reg			dout_r;      // MOSI寄存器
	reg			cs_r,A0_r,A1_r;
	reg[7:0]	delay_cnt;
	reg			sclk_rdy;

//	SPI device names:
	parameter SPI_AD5628	= 4'd1;
	parameter SPI_AD9106	= 4'd2;
	parameter SPI_2271A		= 4'd3;
	parameter SPI_2271B		= 4'd4;
	parameter SPI_DEFAULT	= SPI_AD5628;
	reg[3:0]	spi_name 	= SPINAME;

//	将输出引脚信号连接到对应的内部寄存器
	assign dout     = dout_r;
	assign sclk     = sclk_r;
	assign cs       = cs_r;
	assign A0       = A0_r;
	assign A1       = A1_r;

	localparam	DAT_CNT_MAX = 2*CLKDIV-1;

//	==================
//	处理数据的发送
	always@( posedge clk or posedge rst ) begin
		if(rst) begin
		//	根据时钟相位设置“数据准备”的时机
   			if( CPHA == 0)
				// dat_cnt <= 2*CLKDIV-1;
				dat_cnt <= DAT_CNT_MAX-1;
            else if( CPHA == 1 )
            	dat_cnt <= CLKDIV;

        	d_cnt        <= DATAWIDTH;
			cs_r         <= 1'b0;
//			A0_r         <= 1'b1;
//			A1_r         <= 1'b1;
			finished     <= 1'b0;

			// case(spi_name)
			case(SPINAME)
				SPI_AD5628:
				begin
					A0_r	<= 1'b1;
					A1_r	<= 1'b1;
				end

				SPI_AD9106:
				begin
					A0_r	<= 1'b1;
					A1_r	<= 1'b0;
				end

				SPI_2271A:
				begin
					A0_r	<= 1'd0;
					A1_r	<= 1'd1;
				end

				SPI_2271B:
				begin
					A0_r	<= 1'd0;
					A1_r	<= 1'd0;
				end

				default:
				begin
				//	enable AD5628 by default ...
					A0_r	<= 1'b1;
					A1_r	<= 1'b1;
				end
			endcase

		end
		else begin
			if(en == 1) begin
				// if( dat_cnt == 2*CLKDIV-1 ) begin
				if( dat_cnt == DAT_CNT_MAX ) begin
					dat_cnt <= 0;
					dout_r  <= din[d_cnt-1];
					d_cnt   <= d_cnt-1;
					if( d_cnt == 0 ) begin
						cs_r		<= 1'b1;
						A0_r        <= 1'b0;
						A1_r        <= 1'b0;
						finished	<= 1'b1;
					end
				end
				else begin
					dat_cnt <= dat_cnt + 1;
				end

				// 注意：
				// 如果在这里进行判断，时钟周期会少1个，剩下31个时钟周期
				// if( d_cnt == 0 ) begin
				// 	cs_r		<= 1'b1;
				// 	finished	<= 1'b1;
				// end
			end
		end
	end

//	=================
//	分频时钟延时
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			if( CPHA == 0 ) begin
				delay_cnt <= 0;
				sclk_rdy <= 1'b0;
			end
            else if( CPHA == 1 ) begin
            	delay_cnt <= CLKDIV;
            	sclk_rdy  <= 1'b1;
            end
		end
		else begin
			if( en==1 ) begin
				if(delay_cnt == CLKDIV)
					sclk_rdy <= 1'b1;
				else begin
					delay_cnt <= delay_cnt + 8'b1;
				end
			end
		end
	end

//	=================
//	分频时钟sclk
	always@( posedge clk or posedge rst ) begin
		if(rst) begin
		//	根据时钟极性设置空闲状态下的SCLK
			if( CPOL == 0 )
				sclk_r	<= 1'b0;
			else if( CPOL == 1)
				sclk_r  <= 1'b1;

		//	根据时钟相位设置时钟分频计数器初始值
			if( CPHA == 0 )
            	clk_cnt <= CLKDIV-1;
            else if( CPHA == 1 )
            	clk_cnt <= 0;
		end
		else begin
			if( en==1 ) begin
				if (sclk_rdy && cs_r ==0) begin
					if( clk_cnt == CLKDIV-1 ) begin
						sclk_r <= ~sclk_r;
						clk_cnt <= 8'b0;
					end
					else
						clk_cnt <= clk_cnt + 8'b1;
				end
			end
		end
	end

endmodule
