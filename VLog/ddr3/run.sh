#!/bin/bash

iverilog -o tb mem_test.v mem_test_tb.v
vvp tb

