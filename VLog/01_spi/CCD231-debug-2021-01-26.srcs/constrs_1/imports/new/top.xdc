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
set_property PACKAGE_PIN AE18 [get_ports RST_SIG_CTR]

#==== RPhi1-CTR-1-2
set_property PACKAGE_PIN AF18 [get_ports RPHI1_CTR]

# RPhi2-CTR-1-2
set_property PACKAGE_PIN AB25 [get_ports RPHI2_CTR]

#==== RPhi3-CTR-1-2
set_property PACKAGE_PIN AA25 [get_ports RPHI3_CTR]
#########################################################

set_property IOSTANDARD LVCMOS18 [get_ports mosi]
set_property IOSTANDARD LVCMOS18 [get_ports sclk]
#set_property IOSTANDARD LVCMOS18 [get_ports cs]
set_property IOSTANDARD LVCMOS18 [get_ports A0]
set_property IOSTANDARD LVCMOS18 [get_ports A1]
set_property IOSTANDARD LVCMOS18 [get_ports RST_SIG_CTR]
set_property IOSTANDARD LVCMOS18 [get_ports RPHI1_CTR]
set_property IOSTANDARD LVCMOS18 [get_ports RPHI2_CTR]
set_property IOSTANDARD LVCMOS18 [get_ports RPHI3_CTR]

#create_clock -period 5.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]