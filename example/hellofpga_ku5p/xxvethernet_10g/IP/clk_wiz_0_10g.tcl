

##################################################################
# CREATE IP clk_wiz_0
##################################################################

set clk_wiz clk_wiz_0
create_ip -name clk_wiz -vendor xilinx.com -library ip  -module_name $clk_wiz

set_property -dict { 
  CONFIG.PRIM_IN_FREQ {200.000}
  CONFIG.CLKIN1_JITTER_PS {50.0}
  CONFIG.CLKOUT2_USED {true}
  CONFIG.NUM_OUT_CLKS {2}
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {156.25}
  CONFIG.PRIM_SOURCE {Differential_clock_capable_pin}
  CONFIG.MMCM_DIVCLK_DIVIDE {1}
  CONFIG.MMCM_CLKFBOUT_MULT_F {6.250}
  CONFIG.MMCM_CLKIN1_PERIOD {5.000}
  CONFIG.MMCM_CLKIN2_PERIOD {10.0}
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.500}
  CONFIG.MMCM_CLKOUT1_DIVIDE {8}
  CONFIG.CLKOUT1_JITTER {103.903}
  CONFIG.CLKOUT1_PHASE_ERROR {80.662}
  CONFIG.CLKOUT2_JITTER {95.359}
  CONFIG.CLKOUT2_PHASE_ERROR {80.662}
} [get_ips $clk_wiz]

##################################################################

