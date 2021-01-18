`timescale 1ns/1ns

module top_tb();

reg din;
reg clk;
wire a,b,c;

top t0(
	.din(din),
	.a(a),
	.b(b),
	.c(c),
	.clk(clk)
	);

initial
begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
	$dumpvars(0, top_tb);    		//tb模块名称
end

initial
begin
	din = 0;
	clk = 0;
	forever
	begin
		#({$random}%100)
		din = ~din;
	end
end

always #10 clk = ~clk;

initial begin
	#1000;
	$finish;
end




endmodule
