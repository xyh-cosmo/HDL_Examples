`timescale 1ns / 1ps

//	Created@2021-01-29
//	Author: Youhua Xu
//
//	This module is written to configure the working mode of AD9106.
//
//	SPI configuration:
//	CPOL = 1
//	CPHA = 1

// parameter SPI_AD5628	= 4'd1;
// parameter SPI_AD9106	= 4'd2;
// parameter SPI_2271A		= 4'd3;
// parameter SPI_2271B		= 4'd4;
// parameter SPI_DEFAULT	= SPI_AD5628;

//	配置过程说明：
//	1）配置SPI工作模式
//	2）

// `include "defs.v"

module SPI_AD9106_Config(
		input clk,    // 50M
		input rst,
		input en,
		
	//	输出用于AD9106配置的信号
	//	配置时只需要一个MOSI
		output sclk,
		output mosi,
		output cs,
	
	// 输出译码器CD74HC所需要的输入信号
		output A0,
		output A1,

	// when all configurations are finished, change status to 1
		output status
	);

//	SPI device name:
	parameter SPI_AD9106	= 4'd2;

	wire finished;

    reg[31:0] spi_data_r;
    wire[31:0] din_w;
    assign din_w 			= spi_data_r;

	parameter clk_div 		= 5;  // 对应频率为50M/5/2=5M

//	状态机变量（6-bits）：
	parameter SPI_IDLE		= 6'd0;
	parameter SPI_RESET		= 6'd1;
	parameter SPI_SEND		= 6'd2;
	parameter SPI_FINISHED	= 6'd3;

//	##########################################################
//	##########################################################
//	寄存器配置内容的标记（不是完整列表）：
	parameter REG_SPICONFIG		= 6'd0;
	parameter ADD_SPICONFIG		= 16'h00;
	parameter VAL_SPICONFIG		= 16'b0000_0000_0000_0000;

	parameter REG_POWERCONFIG	= 6'd1;
	parameter ADD_POWERCONFIG	= 16'h01;
	parameter VAL_POWERCONFIG	= 16'b0000_0000_0000_0000;

	parameter REG_CLOCKCONFIG	= 6'd2;
	parameter ADD_CLOCKCONFIG	= 16'h02;
	parameter VAL_CLOCKCONFIG	= 16'b0000_0000_0000_0000;
	
	parameter REG_REFADJ		= 6'd3;
	parameter ADD_REFADJ		= 16'h03;
	parameter VAL_REFADJ		= 16'b0000_0000_0000_0000;
	
	parameter REG_RAMUPDATE		= 6'd4;
	parameter ADD_RAMUPDATE		= 16'h1D;
	parameter VAL_RAMUPDATE		= 16'b0000_0000_0000_0000;
	
	parameter REG_PAT_STATUS	= 6'd5;
	parameter ADD_PAT_STATUS	= 16'h1E;
	parameter VAL_PAT_STATUS	= 16'b0000_0000_0000_0000;

	parameter REG_PAT_TYPE		= 6'd6;
	parameter ADD_PAT_TYPE		= 16'h1F;
	parameter VAL_PAT_TYPE		= 16'b0000_0000_0000_0000;

	parameter REG_PATTERN_DLY	= 6'd7;
	parameter ADD_PATTERN_DLY	= 16'h20;
	parameter VAL_PATTERN_DLY	= 16'b0000_0000_0000_0000;
	
	parameter REG_DAC4DOF		= 6'd8;
	parameter ADD_DAC4DOF		= 16'h22;
	parameter VAL_DAC4DOF		= 16'b0000_0000_0000_0000;

	parameter REG_DAC3DOF		= 6'd9;
	parameter ADD_DAC3DOF		= 16'h23;
	parameter VAL_DAC3DOF		= 16'b0000_0000_0000_0000;

	parameter REG_DAC2DOF		= 6'd10;
	parameter ADD_DAC2DOF		= 16'h24;
	parameter VAL_DAC2DOF		= 16'b0000_0000_0000_0000;

	parameter REG_DAC1DOF		= 6'd11;
	parameter ADD_DAC1DOF		= 16'h25;
	parameter VAL_DAC1DOF		= 16'b0000_0000_0000_0000;

	parameter REG_WAV4_3CONFIG	= 6'd12;
	parameter ADD_WAV4_3CONFIG	= 16'h26;
	parameter VAL_WAV4_3CONFIG	= 16'b0000_0000_0000_0000;

	parameter REG_WAV2_1CONFIG	= 6'd13;
	parameter ADD_WAV2_1CONFIG	= 16'h27;
	parameter VAL_WAV2_1CONFIG	= 16'b0000_0000_0000_0000;

	parameter REG_PAT_TIMEBASE	= 6'd14;
	parameter ADD_PAT_TIMEBASE	= 16'h28;
	parameter VAL_PAT_TIMEBASE	= 16'b0000_0000_0000_0000;

	parameter REG_PAT_PERIOD	= 6'd15;
	parameter ADD_PAT_PERIOD	= 16'h29;
	parameter VAL_PAT_PERIOD	= 16'b0000_0000_0000_0000;

	parameter REG_DAC4_3PATx	= 6'd16;
	parameter ADD_DAC4_3PATx	= 16'h2A;
	parameter VAL_DAC4_3PATx	= 16'b0000_0000_0000_0000;

	parameter REG_DAC2_1PATx	= 6'd17;
	parameter ADD_DAC2_1PATx	= 16'h2B;
	parameter VAL_DAC2_1PATx	= 16'b0000_0000_0000_0000;

//	====================
//	增益的设置还存在一点疑问
//	====================
	parameter REG_DAC4_DGAIN	= 6'd18;
	parameter ADD_DAC4_DGAIN	= 16'h32;
	parameter VAL_DAC4_DGAIN	= 16'b0000_0000_0000_0000;

	parameter REG_DAC3_DGAIN	= 6'd19;
	parameter ADD_DAC3_DGAIN	= 16'h33;
	parameter VAL_DAC3_DGAIN	= 16'b0000_0000_0000_0000;

	parameter REG_DAC2_DGAIN	= 6'd20;
	parameter ADD_DAC2_DGAIN	= 16'h34;
	parameter VAL_DAC2_DGAIN	= 16'b0000_0000_0000_0000;

	parameter REG_DAC1_DGAIN	= 6'd21;
	parameter ADD_DAC1_DGAIN	= 16'h35;
	parameter VAL_DAC1_DGAIN	= 16'b0000_0000_0000_0000;

	parameter REG_TRIG_TW_SEL	= 6'd22;
	parameter ADD_TRIG_TW_SEL	= 16'h44;
	parameter VAL_TRIG_TW_SEL	= 16'b0000_0000_0000_0000;

	parameter REG_START_DLY4	= 6'd23;
	parameter ADD_START_DLY4	= 16'h50;
	parameter VAL_START_DLY4	= 16'b0000_0000_0000_0000;

	parameter REG_START_ADDR4	= 6'd24;
	parameter ADD_START_ADDR4	= 16'h51;
	parameter VAL_START_ADDR4	= 16'b0000_0000_0000_0000;
	
	parameter REG_STOP_ADDR4	= 6'd25;
	parameter ADD_STOP_ADDR4	= 16'h52;
	parameter VAL_STOP_ADDR4	= 16'b0000_0000_0000_0000;

	parameter REG_START_DLY3	= 6'd26;
	parameter ADD_START_DLY3	= 16'h54;
	parameter VAL_START_DLY3	= 16'b0000_0000_0000_0000;

	parameter REG_START_ADDR3	= 6'd27;
	parameter ADD_START_ADDR3	= 16'h55;
	parameter VAL_START_ADDR3	= 16'b0000_0000_0000_0000;
	
	parameter REG_STOP_ADDR3	= 6'd28;

	parameter REG_START_DLY2	= 6'd29;
	parameter REG_START_ADDR2	= 6'd30;
	parameter REG_STOP_ADDR2	= 6'd31;

	parameter REG_START_DLY1	= 6'd32;
	parameter REG_START_ADDR1	= 6'd33;
	parameter REG_STOP_ADDR1	= 6'd34;

//	一共需要配置34个寄存器
	parameter SPI_SEND_DONE_MAX = 6'd34;
//	##########################################################
//	##########################################################

	reg[5:0] SPI_DATA_OPT;
	reg[5:0] SPI_SEND_DONE;  	// 每次完成一次配置，其值就增加1，可以通过与SPI_SEND_DONE_MAX进行比较，
								// 确保发送完成之后状态机的工作状态停止跳转
//	##########################################################

	reg[6:0] state;			// defailt: SPI_IDLE

//  模拟一次RST脉冲
	reg[7:0]  reset_cnt;
	reg       reset_r;
	reg		  en_r;

	SPI_BASE
		#(
			.DATAWIDTH(32),	// 前16位为命令位，后16位为要写入的数据
			.CNT_WIDTH(8),
            .CLKDIV(clk_div),
            .CPHA(1),
            .CPOL(1),
            .SPINAME(SPI_AD9106)
		)
		spi (
			.clk(clk),
			// .rst(rst),
			.rst(reset_r),   // 之前这里连接的是系统的rst信号，所以工作流程没能按照预期的方式实现
			.din(din_w),
			.n_bits(8'd32),
			.en(en_r),

			.sclk(sclk),
			.dout(mosi),
			.cs(cs),
			.A0(A0),
			.A1(A1),

			.finished(finished)
		);

    reg status_r = 1'b0;
	assign status = status_r;

//	状态机
	always @(posedge clk or posedge rst) begin
		if (rst || en==1'b0 ) begin
			// reset
			state		    <= SPI_IDLE;
			en_r		    <= 0;
			reset_r		    <= 0;
			reset_cnt	    <= 8'b0;

			SPI_DATA_OPT	<= 4'b0;
			SPI_SEND_DONE   <= 4'b0;
			status_r		<= 1'b0;
		end
		else begin
			case(state)
				SPI_IDLE:
				begin
				//	需要修改为根据外部的“指示信号”进行状态跳转
				//	在跳转至SPI_RESET之后，再根据“信号”--SPI_DATA_OPT--选择初始化spi_data_r
				    if(SPI_SEND_DONE < SPI_SEND_DONE_MAX) begin
                        state 		<= SPI_RESET;
                        en_r		<= 0;
                        reset_r		<= 0;
                        reset_cnt	<= 8'b0;
						status_r	<= 1'b0;
					end
					else begin
						state       <= SPI_IDLE;
						status_r	<= 1'b1;
					end
				end
				
				SPI_RESET:
				//	每次reset，SPI_BASE都会初始化状态
				begin
					if( reset_cnt <= 5 ) begin
						reset_r		<= 0;
						reset_cnt	<= reset_cnt + 1;
					end
					else if( reset_cnt <= 7 ) begin
						reset_r 	<= 1;
						reset_cnt	<= reset_cnt + 1;
					end
					else if( reset_cnt >= 8 ) begin
						reset_r		<= 0;
						en_r		<= 1;
						state		<= SPI_SEND;
					end

					//	准备将要发送的数据
                    case(`)
                    	// 1)
                    	4'b0000:   // 设置内部REF寄存器 1000_
                    	begin
                    		spi_data_r 	<= 32'b1111_1000_0000_0000_0000_0000_0000_0001;
                    	end

                    	// 2)
                    	4'b0001:   // 设置DB9=0,Db8=0,进入正常工作模式（上电）
                    	begin
                    		spi_data_r 	<= 32'b1111_0100_0000_0000_0000_0000_1111_1111;
                    	end

                    	// 3)
                    	4'b0010:   //  开启DAC所有通道，对所有DAC通道上电
                    	begin
//                    		spi_data_r 	<= 32'b1111_0110_0000_0000_0000_0000_1111_1111;
                    		spi_data_r 	<= 32'b1111_0110_0000_0000_0000_0000_0000_0000;
                    	end

                    	//###############################################################
                    	// 4)
                    	4'b0011:   //  设置通道A输出电压值3.57V
                    	begin
                    		// 正常电压 3.57V
                    		// spi_data_r 	<= 32'b1111_0011_0000_1011_0110_1100_0000_0000;
                    		// 测试电压 1.5V
                    		spi_data_r 	<= 32'b1111_0011_0000_0100_1100_1100_0000_0000;
                    	end

                    	// 5)
                        4'b0100:   //  设置通道B输出电压值0.357V
                        begin
                            spi_data_r  <= 32'b1111_0011_0000_0001_0010_0100_0000_0000;
                        end

                        // 6)
                        4'b0101:   //  设置通道C输出电压值4.25V
                        begin
                        	// 正常电压 4.25V
                            // spi_data_r     <= 32'b1111_0011_0000_1101_1001_1001_0000_0000;
                            // 测试电压 2.0V
                            spi_data_r  <= 32'b1111_0011_0000_0110_0110_0110_0000_0000;
                        end

                        // 7)
                        4'b0110:   //  设置通道D输出电压值0.833V
                        begin
                            spi_data_r  <= 32'b1111_0011_0000_0010_1010_1010_0000_0000;
                        end

                        // 8)
                        4'b0111:	// 设置通道E输出电压值2.5V（测试）
                        begin
                        	spi_data_r  <= 32'b1111_0011_0000_1000_0000_0000_0000_0000;
                        end

                        // 9)
                        4'b1000:	// 设置通道F输出电压值2.5V（测试）
                        begin
                        	spi_data_r  <= 32'b1111_0011_0000_1000_0000_0000_0000_0000;
                        end

                        // 10)
                        4'b1001:	// 设置通道G输出电压值2.5V（测试）
                        begin
                        	spi_data_r  <= 32'b1111_0011_0000_1000_0000_0000_0000_0000;
                        end

                        // 11)
                        4'b1010:	// 设置通道H输出电压值1.0V
                        begin
                        	spi_data_r  <= 32'b1111_0011_0000_0011_0011_0011_0000_0000;
                        end
                    endcase
				end

				SPI_SEND:
				begin
					if( finished == 1'b1 ) begin
						state		<= SPI_FINISHED;
						en_r		<= 0;
					end
					// else begin
					// 计数，记录传送byte数目的变化
						// $display("SPI_SEND_DONE ++> %d",SPI_SEND_DONE);
					// end
				end

				SPI_FINISHED:
				begin
					state	       <= SPI_IDLE;
					SPI_SEND_DONE  <= SPI_SEND_DONE + 1'b1;
					SPI_DATA_OPT   <= SPI_DATA_OPT + 1'b1;
				end

				default:
					state	<= SPI_IDLE;
			endcase
		end
	end

endmodule
