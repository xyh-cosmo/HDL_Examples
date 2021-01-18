#!/bin/bash

ghdl -a port_map.vhd
ghdl -a port_map2.vhd
# ghdl -e driver_tb
# ghdl -r driver_tb --vcd=a.vcd
# ghdl -r Driver --vcd=a.vcd