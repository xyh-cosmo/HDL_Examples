#!/bin/bash

iverilog -o tb tb.v spi_base.v spi4adc.v
vvp tb
