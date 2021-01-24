`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2021 01:46:57 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input sys_clk,
    output sclk,
    output mosi,
    
    output A0,
    output A1,

    //  trigger SPI to work via PL_KEY(4)
    input PL_KEY
    );

//  clocks
    wire clk_150M;
    wire clk_50M;
    wire clk_25M;
    wire clk_10M;
    wire clk_5M;
    wire clk_locked;

//  generate clocks of different frequencies
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
        .clk_in1(sys_clk)
        );

//  ==========================================================================================
//  monitor state of PL_KEY, if there is any change in its state, then SPI is triggered
    reg state_pl_key        = 1'b0;
    reg state_pl_key_bak    = 1'b0;      
    always@( negedge PL_KEY ) begin
        state_pl_key <= ~state_pl_key;
    end
    
    (*mark_debug="true"*)reg rst_w;
    reg [31:0] rst_cn = 32'd0;
    localparam rst_start = 32'd1000000;
    
    always@(posedge sys_clk) begin
        if( state_pl_key != state_pl_key_bak ) begin
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

//  ==========================================================================================
//  状态机：
//  

//  ==========================================================================================
	SPI_SM spi_sm(
		.clk(clk_50M),
		.rst(rst_w),
		.sclk(sclk),
		.mosi(mosi),
		.A0(A0),
		.A1(A1)
		);

endmodule
