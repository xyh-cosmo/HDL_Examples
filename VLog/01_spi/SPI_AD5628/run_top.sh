#!/bin/bash

iverilog -o tb spi_base.v spi_control.v clock_div.v top.v top_tb.v
vvp tb
