#!/bin/bash

ghdl -a driver.vhd
ghdl -a driver_tb.vhd
# ghdl -e driver_tb
ghdl -r driver_tb --vcd=a.vcd
# ghdl -r Driver --vcd=a.vcd