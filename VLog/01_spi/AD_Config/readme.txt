This folder contains a small SPI project, which has been successfully
to configure AD5628.

// ================================
Logs:

@2021-01-29:
实际在Vivado环境下运行的verilog代码的顶层文件中已经做了一些修改，
DG636上的控制端A0,A1已经全部接入1MHz的驱动信号（这些1MHz信号是对50MHz
时钟进行分频后得到的）。

@2021-01-26:
Created a folder sim to store testbench verilog files. Also start to use 
directives to origanize the verilog codes.
