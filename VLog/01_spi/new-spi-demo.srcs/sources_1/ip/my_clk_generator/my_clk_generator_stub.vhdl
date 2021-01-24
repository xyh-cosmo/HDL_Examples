-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
-- Date        : Thu Jan 21 15:32:58 2021
-- Host        : apple running 64-bit Ubuntu 20.04.1 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/xyh/NFS_Alinx/new-spi-demo/new-spi-demo.srcs/sources_1/ip/my_clk_generator/my_clk_generator_stub.vhdl
-- Design      : my_clk_generator
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z035ffg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity my_clk_generator is
  Port ( 
    clk_150M : out STD_LOGIC;
    clk_50M : out STD_LOGIC;
    clk_25M : out STD_LOGIC;
    clk_10M : out STD_LOGIC;
    clk_5M : out STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end my_clk_generator;

architecture stub of my_clk_generator is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_150M,clk_50M,clk_25M,clk_10M,clk_5M,locked,clk_in1";
begin
end;
