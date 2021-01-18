module tb();

reg clk;
reg rst_n;
wire red,green,yellow;

led uut(
    .clk(clk),
    .rst_n(rst_n),
    .red(red),
    .green(green),
    .yellow(yellow)
    );

// generate clock
initial begin
    clk = 0;
    forever begin
        #10 clk = ~clk;
    end
end

// dump wave
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,tb);
end

initial begin
    rst_n = 0;
    #25 rst_n = 1;
    #1000;
    $finish;
end

endmodule