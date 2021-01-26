`timescale 1ns / 1ps

//	Created @2021-01-26
//	Author: Youhua Xu
//	
//	This testbench file contains the following simulations:
//	1) simulates the process of AD5628 configuration
//	2) after AD5628 been configured, start to send square waves (f=1MHz) to DG636
//	   

module TOP(
	input clk_sys,
	input rst_sys,

	//	SPI outputs
	output sclk,
	output mosi,
	output A0,
	output A1,
	output cs,

	//  squre waves, which can also be viewed as clock signals
	output sq_wave
	);

	//	states of the STATE MACHINE
	reg[3:0] state;
	parameter S_IDLE	= 4'd0;
	parameter S_SPI		= 4'd1;
	parameter S_SQ		= 4'd2;

	reg en_spi = 1'b0;
	reg en_sq  = 1'b0;

	wire spi_status;
	wire sq_status;

	SPI_CONTROL spi_control(
		.clk(clk_sys),
		.rst(rst_sys),
		.en(en_spi),
		.sclk(sclk),
		.mosi(mosi),
		.cs(cs),
		.A0(A0),
		.A1(A1),
		.status(spi_status)
		);

	CLOCK_DIV
		#(
			.DIV_FACTOR(25),
			.CNT_START(0)
		)
		clk_div
		(
			.clk_sys(clk_sys),
			.en(en_sq),
			.clk_div(sq_wave),
			.status(sq_status)
		);

	always@( posedge clk_sys or rst_sys ) begin
		if( rst_sys ) begin
			state	<= S_IDLE;
			en_spi	<= 1'b0;
			en_sq	<= 1'b0;
		end
		else begin
			case( state )
				S_IDLE:
				begin
					if( en_spi == 1'b0 && spi_status == 1'b0 ) begin
						en_spi	<= 1'b1;
						state	<= S_SPI;
					end
/*
					else if( en_sq == 1'b0 and sq_status == 1'b0 ) begin
						en_sq	<= 1'b1;
						state	<= S_SQ;
					end
					else
						state <= S_IDLE;
*/
				end

				S_SPI:
				begin
					if( spi_status == 1'b1 ) begin
						en_spi	<= 1'b0;
						state	<= S_SQ;
					end
				end

				S_SQ:
				begin
					if( sq_status == 1'b1 ) begin
						en_sq	<= 1'b0;
						state	<= S_IDLE;
					end
				end

				default:
					state	<= S_IDLE;
			endcase
		end
	end

endmodule
