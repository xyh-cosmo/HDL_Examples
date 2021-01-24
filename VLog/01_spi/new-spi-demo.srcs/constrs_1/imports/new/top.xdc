# system clock J14 直接链接到50M的晶振
set_property PACKAGE_PIN J14 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS18 [get_ports sys_clk]

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

set_property IOSTANDARD LVCMOS18 [get_ports mosi]
set_property IOSTANDARD LVCMOS18 [get_ports sclk]
#set_property IOSTANDARD LVCMOS18 [get_ports cs]
set_property IOSTANDARD LVCMOS18 [get_ports A0]
set_property IOSTANDARD LVCMOS18 [get_ports A1]

#create_clock -period 5.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]









create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list my_clock/inst/clk_150M]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list spi_sm/A0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list spi_sm/A1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list spi_sm/cs]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list spi_sm/mosi]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list rst_w]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list spi_sm/sclk]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_150M]
