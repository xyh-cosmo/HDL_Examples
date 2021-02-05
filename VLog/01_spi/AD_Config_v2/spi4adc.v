`timescale 1ns / 1ps

module SPI4ADC(
//	inputs
	input				clk,
	input				rst,
	input wire[31:0] 	spi_data,
	input 				spi_cpol,
	input				spi_cpha,
	input				ps_A0,
	input				ps_A1,

//	outputs:
	output				A0,
	output				A1,
	output				sclk,
	output				mosi,
	output				status
	);

	assign A0 = ps_A0;
	assign A1 = ps_A1;

//  模拟一次RST脉冲，用于初始化SPI_BASE
	reg[7:0]  reset_cnt;
	reg       reset_r;
	reg		  en_r;

//	finished:连接SPI_BASE的finished
	wire finished;
	parameter clk_div = 5; // 如果输入时钟为50M，那么在spi_base内部分频的时钟为50M/5/2=5M

//	状态机：
	parameter SPI_IDLE		= 4'd0;
	parameter SPI_RESET		= 4'd1;
	parameter SPI_SEND		= 4'd2;
	parameter SPI_FINISHED	= 4'd3;
	reg[3:0] state;			// defailt: SPI_IDLE

//	SPI_BASE 例化
	SPI_BASE#(
			.DATAWIDTH(32),	// 需要修改一下，与要发送的数据位数保持一致
            .CLKDIV(clk_div)
		) spi (
			.clk(clk),
			.rst(reset_r),
			.din(spi_data),
			.en(en_r),
			.CPOL(spi_cpol),
			.CPHA(spi_cpha),
			.sclk(sclk),
			.dout(mosi),
			.finished(finished)
		);

//	status 表示当前32bit是否传输完成
	reg status_r = 1'b0;
	assign status = status_r;

	always @(posedge clk or posedge rst) begin
		if ( rst ) begin
			// reset
			state			<= SPI_IDLE;
			en_r			<= 0;
			reset_r			<= 0;
			reset_cnt		<= 8'b0;
			status_r		<= 1'b0;			
		end
		else begin
			case(state)
				SPI_IDLE:
				begin
					if( status_r == 1'b0 ) begin
						state		<= SPI_RESET;
						en_r		<= 0;
	                    reset_r		<= 0;
	                    reset_cnt	<= 8'b0;
						status_r	<= 1'b0;
					end
				end

				SPI_RESET:
				begin
					if( reset_cnt <= 5 ) begin
						reset_r		<= 0;
						reset_cnt	<= reset_cnt + 1;
					end
					else if( reset_cnt <= 7 ) begin
						reset_r		<= 1;
						reset_cnt	<= reset_cnt + 1;
					end
					else if( reset_cnt >= 8 ) begin
						reset_r		<= 0;
						en_r		<= 1;
						state		<= SPI_SEND;
					end
				end

				SPI_SEND:
				begin
					if( finished == 1'b1 ) begin
						state	<= SPI_FINISHED;
						// disable SPI_BASE
						en_r	<= 0;
					end
				end

				SPI_FINISHED:
				begin
					state		<= SPI_IDLE;
					status_r	<= 1'b1;
				end

				default:
					state 	<= SPI_IDLE;
			endcase
		end
	end
endmodule