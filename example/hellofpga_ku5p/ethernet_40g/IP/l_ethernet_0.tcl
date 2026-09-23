

set l_ethernet_0 [create_ip -name l_ethernet -vendor xilinx.com -library ip -module_name l_ethernet_0]

# User Parameters
set_property -dict [list \
  CONFIG.BASE_R_KR {BASE-KR} \
  CONFIG.DATA_PATH_INTERFACE {256-bit Regular AXI4-Stream} \
  CONFIG.LINE_RATE {40} \
  CONFIG.INCLUDE_FEC_LOGIC {1} \
] [get_ips l_ethernet_0]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $l_ethernet_0

##################################################################

