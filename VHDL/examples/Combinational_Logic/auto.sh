#!/bin/bash

ghdl -a comb_ckt.vhd
ghdl -a --ieee=synopsys tb_ckt.vhd
# ghdl -e driver_tb
ghdl -r --ieee=synopsys CKT_TB --vcd=ckt.vcd
