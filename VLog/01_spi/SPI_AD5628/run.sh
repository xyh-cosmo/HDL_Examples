#!/bin/bash

iverilog -o spi-tb spi_base.v spi_control.v spi_control_tb.v
vvp spi-tb
