#!/bin/bash
iverilog -o test fsm.v tb.v
vvp test
