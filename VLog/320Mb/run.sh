#!/bin/bash
iverilog -o tb_ltc ltc2271_320M.v tb.v
vvp tb_ltc
