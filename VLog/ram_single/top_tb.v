`timescale 1ns/1ns

module top_tb();

reg [7:0] data;
reg [5:0] addr;
reg wr;
reg clk;
wire [7:0] q;
reg [7:0] tmp;

initial
begin
	data = 0;
	addr = 0;
	clk = 0;
	#35 wr = 1;
end

always #10 clk = ~clk;

always@(posedge clk)
begin
	data <= data + 1'b1;
	addr <= addr + 1'b1;
	tmp <= data;
end

top t0(
	.data(data),
	.addr(addr),
	.clk(clk),
	.wr(wr),
	.q(q)
);

initial
begin
	$dumpfile("ram.vcd");
	$dumpvars(0,top_tb);
end

initial
begin
	#510;
	$finish;
end

endmodule
