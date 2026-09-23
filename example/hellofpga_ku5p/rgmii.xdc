set_property PACKAGE_PIN K22 [get_ports clk_200mhz_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports clk_200mhz_p]

create_clock -period 5.000 -name clk_200mhz_p -waveform {0.000 2.500} [get_ports clk_200mhz_p]


set_property PACKAGE_PIN V23 [get_ports phy_rx_clk]
set_property PACKAGE_PIN R26 [get_ports phy_rx_ctl]
set_property PACKAGE_PIN Y23 [get_ports phy_tx_clk]
set_property PACKAGE_PIN U21 [get_ports phy_tx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports phy_rx_clk]
set_property IOSTANDARD LVCMOS18 [get_ports phy_rx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports phy_tx_clk]
set_property IOSTANDARD LVCMOS18 [get_ports phy_tx_ctl]


set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {phy_txd[0]}]
set_property PACKAGE_PIN AA24 [get_ports {phy_txd[0]}]
set_property PACKAGE_PIN AA25 [get_ports {phy_txd[1]}]
set_property PACKAGE_PIN Y25 [get_ports {phy_txd[2]}]
set_property PACKAGE_PIN Y26 [get_ports {phy_txd[3]}]


set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {phy_rxd[0]}]
set_property PACKAGE_PIN R25 [get_ports {phy_rxd[0]}]
set_property PACKAGE_PIN R23 [get_ports {phy_rxd[1]}]
set_property PACKAGE_PIN P21 [get_ports {phy_rxd[2]}]
set_property PACKAGE_PIN P20 [get_ports {phy_rxd[3]}]


set_property PACKAGE_PIN AA23 [get_ports phy_rstn]
set_property IOSTANDARD LVCMOS18 [get_ports phy_rstn]