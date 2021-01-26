#!/bin/bash

iverilog -o top_tb spi_base.v spi_control.v clock_div.v top.v top_tb.v
vvp top_tb
