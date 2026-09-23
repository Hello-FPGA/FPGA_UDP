create_project -force -part xcku5p-ffvb676-2-i -dir prj udp_10g

set obj [get_filesets sources_1]
set files [list \
	[file normalize "../../../../lib/axis/rtl/sync_reset.v"] \
	[file normalize "../../../../lib/axis/rtl/axis_frame_length_adjust.v"] \
	[file normalize "../../../../lib/axis/rtl/axis_async_fifo_adapter.v"] \
	[file normalize "../../../../lib/axis/rtl/axis_async_fifo.v"] \
	[file normalize "../../../../lib/axis/rtl/axis_fifo.v"] \
	[file normalize "../../../../lib/axis/rtl/axis_adapter.v"] \
	[file normalize "../../../../lib/axis/rtl/arbiter.v"] \
	[file normalize "../../../../lib/axis/rtl/priority_encoder.v"] \
	[file normalize "../../../../lib/lib_axis/axis_to_vec.sv"] \
	[file normalize "../../../../lib/lib_axis/vec_to_axis.sv"] \
	[file normalize "../../../../rtl/eth_axis_rx.v"] \
	[file normalize "../../../../rtl/eth_axis_tx.v"] \
	[file normalize "../../../../rtl/udp_complete_64.v"] \
	[file normalize "../../../../rtl/ip_arb_mux.v"] \
	[file normalize "../../../../rtl/ip_complete_64.v"] \
	[file normalize "../../../../rtl/eth_arb_mux.v"] \
	[file normalize "../../../../rtl/ip_64.v"] \
	[file normalize "../../../../rtl/ip_eth_rx_64.v"] \
	[file normalize "../../../../rtl/ip_eth_tx_64.v"] \
	[file normalize "../../../../rtl/arp.v"] \
	[file normalize "../../../../rtl/arp_eth_rx.v"] \
	[file normalize "../../../../rtl/arp_eth_tx.v"] \
	[file normalize "../../../../rtl/arp_cache.v"] \
	[file normalize "../../../../rtl/lfsr.v"] \
	[file normalize "../../../../rtl/udp_64.v"] \
	[file normalize "../../../../rtl/udp_ip_rx_64.v"] \
	[file normalize "../../../../rtl/udp_ip_tx_64.v"] \
	[file normalize "../../../../rtl/udp_checksum_gen_64.v"] \
	[file normalize "../../../../rtl/icmp.v"] \
]
add_files -norecurse -fileset $obj $files

read_verilog [glob ../RTL/*.v]

set_property top fpga [current_fileset]



read_xdc "../../sfp.xdc"


source ../IP/clk_wiz_0_10g.tcl
source ../IP/xxv_ethernet_10g.tcl
# source ../IP/ila_mac.tcl




