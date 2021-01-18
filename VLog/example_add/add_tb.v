`timescale 1ns/1ns

module add_tb();

reg clk;
reg rst;
wire[3:0] res;
reg[15:0] cnt;

add_top at(
    .clk(clk),
    .rst(rst),
    .out(res)
);

initial
begin
	$dumpfile("wave.vcd");
	$dumpvars(0,add_tb);
end

initial
begin
    clk = 0;
    rst = 0;
    cnt = 0;
end
initial
begin
    #5;
    forever
    begin
        #1 clk = ~clk;
    end
end

always @(posedge clk) 
begin
    cnt <= cnt + 1;
end

initial 
begin
  #100;
  $finish;
end
endmodule