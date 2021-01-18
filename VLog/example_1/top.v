module top(din, a, b, c, clk);
	input din;
	input clk;
	output reg a,b,c;

	always @(posedge clk)
	begin
		// a = din;
		// b = a;
		// c = b;
		a <= din;
		b <= a;
		c <= b;
	end
endmodule
