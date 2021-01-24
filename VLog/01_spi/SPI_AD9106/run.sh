#!/bin/bash

iverilog -o spi-sm spi-xyh.v spi_state_machine.v spi-xyh-sm-tb.v
vvp spi-sm
