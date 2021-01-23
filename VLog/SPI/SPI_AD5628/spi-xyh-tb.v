`timescale 1ns / 1ps


module CLK_DIV_TB();

	reg clk;
	reg rst;
	reg [7:0] div;
	wire sclk0, sclk1, sclk2, sclk3;
	wire dout0, dout1, dout2, dout3;

    reg[31:0] din0;
    reg[15:0] din1;
	wire cs0, cs1, cs2,cs3;

	parameter clk_div = 16;

	CLK_DIV 
		#(
			.DATAWIDTH(32),
			.CNT_WIDTH(8),
            .CLKDIV(clk_div),
            .CPHA(0),
            .CPOL(0)
		)
		clk_div0 (
			.clk(clk),
			.rst(rst),
			.din(din0),
			.sclk(sclk0),
			.dout(dout0),
			.cs(cs0)
		);

	CLK_DIV 
		#(
			.DATAWIDTH(16),
			.CNT_WIDTH(8),
            .CLKDIV(clk_div),
            .CPHA(0),
            .CPOL(1)
		)
		clk_div1 (
			.clk(clk),
			.rst(rst),
			.din(din1),
			.sclk(sclk1),
			.dout(dout1),
			.cs(cs1)
		);

	CLK_DIV 
		#(
			.DATAWIDTH(32),
			.CNT_WIDTH(8),
            .CLKDIV(clk_div),
            .CPHA(1),
            .CPOL(0)
		)
		clk_div2 (
			.clk(clk),
			.rst(rst),
			.din(din0),
			.sclk(sclk2),
			.dout(dout2),
			.cs(cs2)
		);

	CLK_DIV 
		#(
			.DATAWIDTH(16),
			.CNT_WIDTH(8),
            .CLKDIV(clk_div),
            .CPHA(1),
            .CPOL(1)
		)
		clk_div3 (
			.clk(clk),
			.rst(rst),
			.din(din1),
			.sclk(sclk3),
			.dout(dout3),
			.cs(cs3)
		);

	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0,CLK_DIV_TB);
	end

	initial begin
		en0 = 0;
		en1 = 0;
		en2 = 0;
		en3 = 0;

        din0[31:0] <= 32'b10101010101010101010101010101010;
        // din0[31:0] <= 32'bxxxx1010101010101010101010101010;
        din1[15:0] <= 16'b1010101010101010;
        // din[31:0] <= 32'b10101010101010101000100010001000;

		rst = 0;
		#105;

		rst = ~rst;
		#5;
		rst = ~rst;

		#5 en0 = 1;

		#2500;
		$finish;
	end


	// define clock
	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

endmodule