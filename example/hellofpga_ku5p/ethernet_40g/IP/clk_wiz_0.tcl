

set clk_wiz_0 [create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name clk_wiz_0]

# User Parameters
set_property -dict [list \
  CONFIG.CLKIN1_JITTER_PS {50.0} \
  CONFIG.CLKOUT1_JITTER {91.819} \
  CONFIG.CLKOUT1_PHASE_ERROR {74.580} \
  CONFIG.CLKOUT2_JITTER {71.892} \
  CONFIG.CLKOUT2_PHASE_ERROR {74.580} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {390.625} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {15.625} \
  CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
  CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {15.625} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
  CONFIG.MMCM_DIVCLK_DIVIDE {2} \
  CONFIG.NUM_OUT_CLKS {2} \
  CONFIG.PRIM_IN_FREQ {200.000} \
  CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
] [get_ips clk_wiz_0]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $clk_wiz_0



