`timescale 1ns / 1ns

module top_tb();
reg a;
reg b;
wire c;

initial
begin
	a = 0;
	b = 0;
	forever
	begin
		#({$random}%100)
		a = ~a;
		#({$random}%100)
		b = ~b;
	end
end

top t0(
	.a(a),
	.b(b),
	.c(c)
);

initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0,top_tb);
end

initial begin
	#1000;
	$finish;
end

endmodule
