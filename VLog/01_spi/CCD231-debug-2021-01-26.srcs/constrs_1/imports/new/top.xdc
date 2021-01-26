# system clock J14 直接链接到50M的晶振
set_property PACKAGE_PIN J14 [get_ports clk_sys]
set_property IOSTANDARD LVCMOS18 [get_ports clk_sys]

# PL_KEY4
set_property PACKAGE_PIN J8 [get_ports PL_KEY]
set_property IOSTANDARD LVCMOS15 [get_ports PL_KEY]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets PL_KEY_IBUF]

#set_property PACKAGE_PIN AE22 [get_ports mosi]
set_property PACKAGE_PIN AB21 [get_ports mosi]
set_property PACKAGE_PIN AB22 [get_ports sclk]

#暂时把cs接到一个空闲的FMC引脚
#set_property PACKAGE_PIN AC26 [get_ports cs]
set_property PACKAGE_PIN AD19 [get_ports A0]
set_property PACKAGE_PIN AD18 [get_ports A1]

#########################################################
#==== 1MHz的方波 ====#
# RST.SIG-CTR-1-2
#set_property PACKAGE_PIN AE18 [get_ports sq_wave]

#==== RPhi1-CTR-1-2
#set_property PACKAGE_PIN AF18 [get_ports sq_wave]

# RPhi2-CTR-1-2
set_property PACKAGE_PIN AB25 [get_ports sq_wave]

#==== RPhi3-CTR-1-2
#set_property PACKAGE_PIN AA25 [get_ports sq_wave]
#########################################################

set_property IOSTANDARD LVCMOS18 [get_ports mosi]
set_property IOSTANDARD LVCMOS18 [get_ports sclk]
#set_property IOSTANDARD LVCMOS18 [get_ports cs]
set_property IOSTANDARD LVCMOS18 [get_ports A0]
set_property IOSTANDARD LVCMOS18 [get_ports A1]
set_property IOSTANDARD LVCMOS18 [get_ports sq_wave]

#create_clock -period 5.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 16384 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list my_clock/inst/clk_150M]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list spi_control/A0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list clk_5M]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list clk_10M]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list clk_25M]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list clk_150M]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list clk_div/clk_div]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list spi_control/cs]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list spi_control/mosi]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list rst_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list spi_control/sclk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list spi_control/status]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_150M]
