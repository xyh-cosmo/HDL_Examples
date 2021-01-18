`timescale 1ns / 1ns

module tb();

reg clk;
reg rstn;
output[3:0] cnt;
output cout;

counter10 cnt10(
	.clk(clk),
	.rstn(rstn),
	.cnt(cnt),
	.cout(cout)
);

// clock reverses every 10ns
initial begin
	clk = 0;
	forever begin
		#10 clk = ~clk;
	end
end

// dump file
initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,tb);
end

initial begin
	rstn = 0;
	#14 rstn = 1;
	#400;
	$finish;
end


endmodule
