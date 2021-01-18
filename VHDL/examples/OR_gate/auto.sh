#!/bin/bash

ghdl -a OR_gate.vhd
ghdl -a OR_gate_tb.vhd
# ghdl -e driver_tb
ghdl -r OR_gate_tb --vcd=a.vcd
# ghdl -r Driver --vcd=a.vcd