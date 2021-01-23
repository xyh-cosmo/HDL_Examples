#!/bin/bash
iverilog -o tb-spi spi_master.v spi_master_tb.v 
vvp tb-spi
