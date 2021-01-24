// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Thu Jan 21 15:32:58 2021
// Host        : apple running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/xyh/NFS_Alinx/new-spi-demo/new-spi-demo.srcs/sources_1/ip/my_clk_generator/my_clk_generator_stub.v
// Design      : my_clk_generator
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z035ffg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module my_clk_generator(clk_150M, clk_50M, clk_25M, clk_10M, clk_5M, 
  locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_150M,clk_50M,clk_25M,clk_10M,clk_5M,locked,clk_in1" */;
  output clk_150M;
  output clk_50M;
  output clk_25M;
  output clk_10M;
  output clk_5M;
  output locked;
  input clk_in1;
endmodule
