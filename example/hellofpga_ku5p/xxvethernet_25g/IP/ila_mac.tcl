

set ila_mac [create_ip -name ila -vendor xilinx.com -library ip -module_name ila_mac]

# User Parameters
set_property -dict [list \
  CONFIG.C_DATA_DEPTH {4096} \
  CONFIG.C_NUM_OF_PROBES {6} \
  CONFIG.C_PROBE0_WIDTH {64} \
  CONFIG.C_PROBE1_WIDTH {8} \
] [get_ips ila_mac]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $ila_mac


