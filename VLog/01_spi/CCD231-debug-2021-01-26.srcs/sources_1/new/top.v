`timescale 1ns / 1ps

//	Created @2021-01-26
//	Author: Youhua Xu
//	
//	This testbench file contains the following simulations:
//	1) simulates the process of AD5628 configuration
//	2) after AD5628 been configured, start to send square waves (f=1MHz) to DG636
//	   

module TOP(
//  与PS交互部分
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,

    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
//    gpio_tri_o,
    
//  =================
	clk_sys,
	// rst_sys,

//	SPI outputs
	sclk,
	mosi,
	A0,
	A1,
//	cs,

    RST_SIG_CTR,
    RPHI1_CTR,
    RPHI2_CTR,
    RPHI3_CTR,
    
//  LEDs
    leds,
	
	PL_KEY
	);

  output [3:0] leds;
  wire [3:0] leds;

// ==========================================================================
// ==========================================================================
//  与PS交互部分
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
//  output FCLK_CLK0;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  
//  input [0:0]gpio_in_tri_i;
//  output [31:0]gpio2_tri_o;
//  output [3:0]gpio_tri_o;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
//  wire FCLK_CLK0;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [31:0] gpio2_tri_o;
//  wire [0:0] gpio_in_tri_i;
  wire [3:0] gpio_tri_o;

  wire fclk_clk0;
  
  reg pl_status = 1'b0;
  

  
  CCD231_wrapper CCD231
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK0(fclk_clk0),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .gpio_in_tri_i(pl_status),
        .gpio2_tri_o(gpio2_tri_o),
        .gpio_tri_o(gpio_tri_o)
        );

// ==========================================================================
// ==========================================================================

// ==========================================================================
    input clk_sys;
//	SPI outputs
	output sclk;
	output mosi;
	output A0;
	output A1;

    output RST_SIG_CTR;
    output RPHI1_CTR;
    output RPHI2_CTR;
    output RPHI3_CTR;
    

	
	input PL_KEY;
// ==========================================================================

//  生成50MHz的时钟（也包括其他频率的时钟） 
    (*mark_debug="true"*) wire clk_150M;
    (*mark_debug="true"*) wire clk_50M;
    (*mark_debug="true"*) wire clk_25M;
    (*mark_debug="true"*) wire clk_10M;
    (*mark_debug="true"*) wire clk_5M;
    wire clk_locked;

    my_clk_generator  my_clock (
        // Clock out ports  
        .clk_150M(clk_150M),
        .clk_50M(clk_50M),
        .clk_25M(clk_25M),
        .clk_10M(clk_10M),
        .clk_5M(clk_5M),
        // Status and control signals               
        .locked(clk_locked),
        // Clock in ports
        .clk_in1(clk_sys)
        );


	//	states of the STATE MACHINE
	reg[3:0] state;
	parameter S_IDLE	= 4'd0;
	parameter S_SPI	= 4'd1;
	parameter S_CTR	= 4'd2;

	reg en_spi = 1'b0;
	reg en_ctr = 1'b0;
	reg spi_done = 1'b0;
	reg ctr_done  = 1'b0;

	wire spi_status;
	wire ctr_status;
	reg rst_w;

    wire cs;    // not used actually ...
	SPI_CONTROL spi_control(
		.clk(clk_50M),
		.rst(rst_w),
		.en(en_spi),
		.sclk(sclk),
		.mosi(mosi),
		.cs(cs),
		.A0(A0),
		.A1(A1),
		.status(spi_status)
		);

//  分频时钟
//    parameter cycles_max = 20;
    parameter cycles_max = 0;  // set to zero so that the divided clocks runs forever!
	CLOCK_DIV
		#(
			.DIV_FACTOR(50),
			.CNT_START(0),
			.CYCLES_MAX(cycles_max)
		)
		clk_div_0
		(
			.clk_sys(clk_50M),
			.en(en_ctr),
			.clk_div(RST_SIG_CTR),
			.status(ctr_status)
		);
		
	CLOCK_DIV
        #(
            .DIV_FACTOR(50),
            .CNT_START(0),
            .CYCLES_MAX(cycles_max)
        )
        clk_div_1
        (
            .clk_sys(clk_50M),
            .en(en_ctr),
            .clk_div(RPHI1_CTR),
            .status()
        );

    CLOCK_DIV
		#(
			.DIV_FACTOR(50),
			.CNT_START(0),
			.CYCLES_MAX(cycles_max)
		)
		clk_div_2
		(
			.clk_sys(clk_50M),
			.en(en_ctr),
			.clk_div(RPHI2_CTR),
			.status()
		);

    CLOCK_DIV
		#(
			.DIV_FACTOR(50),
			.CNT_START(0),
			.CYCLES_MAX(cycles_max)
		)
		clk_div_3
		(
			.clk_sys(clk_50M),
			.en(en_ctr),
			.clk_div(RPHI3_CTR),
			.status()
		);
// =============================
	
//	通过PL按键来触发一个复位reset
    reg state_pl_key        = 1'b0;
    reg state_pl_key_bak    = 1'b0;      
    always@( negedge PL_KEY ) begin
        state_pl_key <= ~state_pl_key;
    end
    
    reg [31:0] rst_cn = 32'd0;
    localparam rst_start = 32'd1000000;
    reg[3:0] leds_r = 4'd0;
    assign leds = leds_r;
    
    always@(posedge clk_sys) begin
        if( state_pl_key != state_pl_key_bak ) begin
            pl_status <= ~pl_status;
            
            if( rst_cn < rst_start ) begin
                rst_w <= 1'b0;
                rst_cn <= rst_cn + 32'd1;
            end
            else if( rst_cn < rst_start+10 ) begin
                rst_w <= 1'b1;
                rst_cn <= rst_cn + 32'd1;
            end
            else if( rst_cn >= rst_start + 10 ) begin
                rst_w <= 1'b0;
                rst_cn <= 32'd0;
                state_pl_key_bak <= ~state_pl_key_bak;
            end
        end
    end

	always@( posedge clk_sys or posedge rst_w ) begin
		if( rst_w ) begin
			state	<= S_IDLE;
			en_spi	<= 1'b0;
			en_ctr  <= 1'b0;
			spi_done <= 1'b0;
			ctr_done <= 1'b0;
		end
		else begin
			case( state )
				S_IDLE:
				begin
					if( spi_status == 1'b0 && spi_done == 1'b0 ) begin
						en_spi	<= 1'b1;
						en_ctr  <= 1'b0;
						state	<= S_SPI;
					end
				end

				S_SPI:
				begin
					if( spi_status == 1'b1 ) begin
						en_spi	<= 1'b0;
						spi_done <= 1'b1;

						if( ctr_status == 1'b0 && ctr_done == 1'b0 ) begin
							en_ctr  <= 1'b1;
							state	<= S_CTR;
						end
					end
				end

				S_CTR:
				begin
					if( ctr_status == 1'b1 ) begin
						en_ctr	 <= 1'b0;
						ctr_done <= 1'b1;
						state	 <= S_IDLE;
					end
				end

				default:
					state	<= S_IDLE;
			endcase
		end
	end

// 利用LED灯进行测试：
    reg[31:0] cnt = 32'd0;
    wire ps_clk;
    
//    assign ps_clk = gpio_tri_o[3];
    assign ps_clk = gpio2_tri_o[3];
    
    assign leds = leds_r;
       
    always@( posedge ps_clk ) begin
//        if( cnt >= 32'd9999 ) begin
        if( cnt >= 32'd999_999 ) begin
            leds_r <= ~leds_r;
            cnt <= 32'd0;
//            pl_status <= ~pl_status;
        end
        else
            cnt <= cnt + 32'd1;
    end
    

// 添加逻辑分析仪

endmodule
