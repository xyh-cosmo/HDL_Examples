#!/bin/bash

iverilog -o tb top.v spi_base.v spi4adc.v
vvp tb
