#!/bin/bash

iverilog -o spi clk_div.v clk_div-tb.v
vvp spi
