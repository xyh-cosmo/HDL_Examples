`timescale 1ns / 1ps

module SPI_CONTROL(
		input clk,    // 50M
		input rst,
		input en,
		(*mark_debug="true"*)output sclk,
		(*mark_debug="true"*)output mosi,
		(*mark_debug="true"*)output cs,
	
	// 输出译码器CD74HC所需要的输入信号
		(*mark_debug="true"*) output    A0,
		(*mark_debug="true"*) output    A1,

	// when all configurations are finished, change status to 1
		(*mark_debug="true"*) output	status
	);

	wire finished;

    reg[31:0] spi_data_r;
    wire[31:0] din_w;
    assign din_w 			= spi_data_r;

	parameter clk_div 		= 5;  // 对应频率为50M/5/2=5M   
//    parameter clk_div 		= 2;  // 注意：设置成2只是为了测试

//	状态机：
	parameter SPI_IDLE		= 4'd0;
	parameter SPI_RESET		= 4'd1;
	parameter SPI_SEND		= 4'd2;
	parameter SPI_FINISHED	= 4'd3;

	reg[3:0] SPI_DATA_OPT;
	reg[3:0] SPI_SEND_DONE;  	// 确保发送完成之后状态机的工作状态停止跳转
	// parameter SPI_SEND_DONE_MAX	= 4'd7;	//	最多发送7个32bit数据
	parameter SPI_SEND_DONE_MAX = 4'd11;	// 发送11次32bit数据

	reg[3:0] state;			// defailt: SPI_IDLE

//  模拟一次RST脉冲
	reg[7:0]  reset_cnt;
	reg       reset_r;
	reg		  en_r;

	SPI_BASE
		#(
			.DATAWIDTH(32),	// 需要修改一下，与要发送的数据位数保持一致
			.CNT_WIDTH(8),
            .CLKDIV(clk_div),
            .CPHA(0),
            .CPOL(1)
		)
		spi0 (
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
                    case(SPI_DATA_OPT)
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
