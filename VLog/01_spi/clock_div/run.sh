#!/bin/bash

iverilog -o clock-tb clock_div.v clock_div_tb.v
vvp clock-tb
