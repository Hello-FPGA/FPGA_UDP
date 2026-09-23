set_property PACKAGE_PIN K22 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]

set_property PACKAGE_PIN K7 [get_ports gt_refclk_p]

set_property PACKAGE_PIN C4 [get_ports gt_rxp_in_0]


create_clock -period 5.000 -name sys_clk_p -waveform {0.000 2.500} [get_ports sys_clk_p]