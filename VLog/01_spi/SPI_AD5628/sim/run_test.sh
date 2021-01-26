#!/bin/bash

iverilog -o tb top_tb.v
vvp tb
