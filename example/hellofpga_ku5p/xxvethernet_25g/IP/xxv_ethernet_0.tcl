

set xxv_ethernet_0 [create_ip -name xxv_ethernet -vendor xilinx.com -library ip -module_name xxv_ethernet_0]

# User Parameters
set_property -dict [list \
  CONFIG.BASE_R_KR {BASE-R} \
  CONFIG.GT_REF_CLK_FREQ {156.25} \
  CONFIG.LINE_RATE {25} \
] [get_ips xxv_ethernet_0]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $xxv_ethernet_0



