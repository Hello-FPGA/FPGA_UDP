`timescale 1 ns/1 ps
    
module ethernet_40g_wrapper (
	input	wire		    dclk			,
	input 	wire 			sys_reset		,
	input 	wire 			rx_reset_0 		, // assign rx_reset_0 = sys_reset;
	input 	wire 			tx_reset_0 		, // assign tx_reset_0 = sys_reset;

	output  wire 	 		clk_axis		,

	output	wire 			user_rx_reset_0 ,
	output	wire 			user_tx_reset_0 ,

	output	wire 			rx_axis_tvalid_0,
	output	wire [255:0] 	rx_axis_tdata_0 ,
	output	wire [0:0] 		rx_axis_tuser_0 ,
	output	wire [31:0] 	rx_axis_tkeep_0 ,
	output	wire 			rx_axis_tlast_0 ,

	output 	wire 			tx_axis_tready_0,
	input	wire 			tx_axis_tvalid_0,
	input	wire [255:0] 	tx_axis_tdata_0 ,
	input	wire [31:0] 	tx_axis_tkeep_0 ,
	input	wire [0:0] 		tx_axis_tuser_0 ,
	input	wire  			tx_axis_tlast_0 ,
	

	input 	wire            gt_refclk_p		,
    input 	wire            gt_refclk_n		,

	input  	wire 			gt_rxp_in_0		,
	input  	wire 			gt_rxn_in_0		,
	output 	wire 			gt_txp_out_0	,
	output 	wire 			gt_txn_out_0	,
	input  	wire 			gt_rxp_in_1		,
	input  	wire 			gt_rxn_in_1		,
	output 	wire 			gt_txp_out_1	,
	output 	wire 			gt_txn_out_1	,
	input  	wire 			gt_rxp_in_2		,
	input  	wire 			gt_rxn_in_2		,
	output 	wire 			gt_txp_out_2	,
	output 	wire 			gt_txn_out_2	,
	input  	wire 			gt_rxp_in_3		,
	input  	wire 			gt_rxn_in_3		,
	output 	wire 			gt_txp_out_3	,
	output 	wire 			gt_txn_out_3	


    );

	wire gt_refclk_out;

	wire 	gtwiz_reset_tx_datapath_0; 
	wire 	gtwiz_reset_rx_datapath_0; 
	assign 	gtwiz_reset_tx_datapath_0 = 1'b0; 
	assign 	gtwiz_reset_rx_datapath_0 = 1'b0; 

	wire 	rx_core_clk_0;
	wire 	rx_clk_out_0;
	wire 	tx_clk_out_0;
	//assign rx_core_clk_0 = tx_clk_out_0;
	assign 	rx_core_clk_0 = tx_clk_out_0;

	assign clk_axis = tx_clk_out_0;


	//// For other GT loopback options please change the value appropriately
	//// For example, for internal loopback gt_loopback_in[2:0] = 3'b010;
	//// For more information and settings on loopback, refer GT Transceivers user guide

	wire [11:0] gt_loopback_in_0;
	assign gt_loopback_in_0 = {4{3'b000}};



	//// RX_0 Signals
	//wire rx_reset_0;
	// wire user_rx_reset_0;


	wire [55:0] 	rx_preambleout_0;


	//// RX_0 Control Signals
	wire 			ctl_rx_test_pattern_0;
	wire 			ctl_rx_enable_0;
	wire 			ctl_rx_delete_fcs_0;
	wire 			ctl_rx_ignore_fcs_0;
	wire [14:0] 	ctl_rx_max_packet_len_0;
	wire [7:0] 		ctl_rx_min_packet_len_0;
	wire 			ctl_rx_check_sfd_0;
	wire 			ctl_rx_check_preamble_0;
	wire 			ctl_rx_process_lfi_0;
	wire 			ctl_rx_force_resync_0;


	//// RX_0 Stats Signals
	wire [3:0] 		stat_rx_block_lock_0;
	wire 			stat_rx_framing_err_valid_0_0;
	wire 			stat_rx_framing_err_0_0;
	wire 			stat_rx_framing_err_valid_1_0;
	wire 			stat_rx_framing_err_1_0;
	wire 			stat_rx_framing_err_valid_2_0;
	wire 			stat_rx_framing_err_2_0;
	wire 			stat_rx_framing_err_valid_3_0;
	wire 			stat_rx_framing_err_3_0;
	wire [3:0] 		stat_rx_vl_demuxed_0;
	wire [1:0] 		stat_rx_vl_number_0_0;
	wire [1:0] 		stat_rx_vl_number_1_0;
	wire [1:0] 		stat_rx_vl_number_2_0;
	wire [1:0] 		stat_rx_vl_number_3_0;
	wire [3:0] 		stat_rx_synced_0;
	wire 			stat_rx_misaligned_0;
	wire 			stat_rx_aligned_err_0;
	wire [3:0] 		stat_rx_synced_err_0;
	wire [3:0] 		stat_rx_mf_len_err_0;
	wire [3:0] 		stat_rx_mf_repeat_err_0;
	wire [3:0] 		stat_rx_mf_err_0;
	wire 			stat_rx_bip_err_0_0;
	wire 			stat_rx_bip_err_1_0;
	wire 			stat_rx_bip_err_2_0;
	wire 			stat_rx_bip_err_3_0;
	wire 			stat_rx_aligned_0;
	wire 			stat_rx_hi_ber_0;
	wire 			stat_rx_status_0;
	wire [1:0] 		stat_rx_bad_code_0;
	wire [1:0] 		stat_rx_total_packets_0;
	wire 			stat_rx_total_good_packets_0;
	wire [5:0] 		stat_rx_total_bytes_0;
	wire [13:0] 	stat_rx_total_good_bytes_0;
	wire [1:0] 		stat_rx_packet_small_0;
	wire 			stat_rx_jabber_0;
	wire 			stat_rx_packet_large_0;
	wire 			stat_rx_oversize_0;
	wire [1:0] 		stat_rx_undersize_0;
	wire 			stat_rx_toolong_0;
	wire [1:0] 		stat_rx_fragment_0;
	wire 			stat_rx_packet_64_bytes_0;
	wire 			stat_rx_packet_65_127_bytes_0;
	wire 			stat_rx_packet_128_255_bytes_0;
	wire 			stat_rx_packet_256_511_bytes_0;
	wire 			stat_rx_packet_512_1023_bytes_0;
	wire 			stat_rx_packet_1024_1518_bytes_0;
	wire 			stat_rx_packet_1519_1522_bytes_0;
	wire 			stat_rx_packet_1523_1548_bytes_0;
	wire [1:0] 		stat_rx_bad_fcs_0;
	wire 			stat_rx_packet_bad_fcs_0;
	wire [1:0] 		stat_rx_stomped_fcs_0;
	wire 			stat_rx_packet_1549_2047_bytes_0;
	wire 			stat_rx_packet_2048_4095_bytes_0;
	wire 			stat_rx_packet_4096_8191_bytes_0;
	wire 			stat_rx_packet_8192_9215_bytes_0;
	wire 			stat_rx_unicast_0;
	wire 			stat_rx_multicast_0;
	wire 			stat_rx_broadcast_0;
	wire 			stat_rx_vlan_0;
	wire 			stat_rx_inrangeerr_0;
	wire 			stat_rx_bad_preamble_0;
	wire 			stat_rx_bad_sfd_0;
	wire 			stat_rx_got_signal_os_0;
	wire [1:0] 		stat_rx_test_pattern_mismatch_0;
	wire 			stat_rx_truncated_0;
	wire 			stat_rx_local_fault_0;
	wire 			stat_rx_remote_fault_0;
	wire 			stat_rx_internal_local_fault_0;
	wire 			stat_rx_received_local_fault_0;


	//// TX_0 Signals
	// wire 			tx_reset_0;
	//wire 			user_tx_reset_0;

	//// TX_0 User Interface Signals
	wire 			tx_unfout_0;
	wire [55:0] 	tx_preamblein_0;


	//// TX_0 Control Signals
	wire 			ctl_tx_test_pattern_0;
	wire 			ctl_tx_enable_0;
	wire 			ctl_tx_fcs_ins_enable_0;
	wire [3:0] 		ctl_tx_ipg_value_0;
	wire 			ctl_tx_send_lfi_0;
	wire 			ctl_tx_send_rfi_0;
	wire 			ctl_tx_send_idle_0;
	wire 			ctl_tx_custom_preamble_enable_0;
	wire 			ctl_tx_ignore_fcs_0;


	//// TX_0 Stats Signals
	wire 		stat_tx_underflow_err_0;
	wire 		stat_tx_overflow_err_0;
	wire 		stat_tx_total_packets_0;
	wire [4:0] 	stat_tx_total_bytes_0;
	wire 		stat_tx_total_good_packets_0;
	wire [13:0] stat_tx_total_good_bytes_0;
	wire 		stat_tx_packet_64_bytes_0;
	wire 		stat_tx_packet_65_127_bytes_0;
	wire 		stat_tx_packet_128_255_bytes_0;
	wire 		stat_tx_packet_256_511_bytes_0;
	wire 		stat_tx_packet_512_1023_bytes_0;
	wire 		stat_tx_packet_1024_1518_bytes_0;
	wire 		stat_tx_packet_1519_1522_bytes_0;
	wire 		stat_tx_packet_1523_1548_bytes_0;
	wire 		stat_tx_packet_small_0;
	wire 		stat_tx_packet_large_0;
	wire 		stat_tx_packet_1549_2047_bytes_0;
	wire 		stat_tx_packet_2048_4095_bytes_0;
	wire 		stat_tx_packet_4096_8191_bytes_0;
	wire 		stat_tx_packet_8192_9215_bytes_0;
	wire 		stat_tx_unicast_0;
	wire 		stat_tx_multicast_0;
	wire 		stat_tx_broadcast_0;
	wire 		stat_tx_vlan_0;
	wire 		stat_tx_bad_fcs_0;
	wire 		stat_tx_frame_error_0;
	wire 		stat_tx_local_fault_0;


	wire [3:0] 	rxrecclkout_0;
	wire [3:0] 	gtpowergood_out_0;
	wire [11:0] txoutclksel_in_0;
	wire [11:0] rxoutclksel_in_0;

	assign 		txoutclksel_in_0 = {4{3'b101}};     // This value should not be changed as per gtwizard 
	assign 		rxoutclksel_in_0 = {4{3'b101}};    // This value should not be changed as per gtwizard


	l_ethernet_0 DUT
	(

		.gt_rxp_in_0 	(gt_rxp_in_0)			, // input wire gt_rxp_in_0
		.gt_rxn_in_0 	(gt_rxn_in_0)			, // input wire gt_rxn_in_0
		.gt_txp_out_0 	(gt_txp_out_0)			, // output wire gt_txp_out_0
		.gt_txn_out_0 	(gt_txn_out_0)			, // output wire gt_txn_out_0
		.gt_rxp_in_1 	(gt_rxp_in_1)			, // input wire gt_rxp_in_1
		.gt_rxn_in_1 	(gt_rxn_in_1)			, // input wire gt_rxn_in_1
		.gt_txp_out_1 	(gt_txp_out_1)			, // output wire gt_txp_out_1
		.gt_txn_out_1 	(gt_txn_out_1)			, // output wire gt_txn_out_1
		.gt_rxp_in_2 	(gt_rxp_in_2)			, // input wire gt_rxp_in_2
		.gt_rxn_in_2 	(gt_rxn_in_2)			, // input wire gt_rxn_in_2
		.gt_txp_out_2 	(gt_txp_out_2)			, // output wire gt_txp_out_2
		.gt_txn_out_2 	(gt_txn_out_2)			, // output wire gt_txn_out_2
		.gt_rxp_in_3 	(gt_rxp_in_3)			, // input wire gt_rxp_in_3
		.gt_rxn_in_3 	(gt_rxn_in_3)			, // input wire gt_rxn_in_3
		.gt_txp_out_3 	(gt_txp_out_3)			, // output wire gt_txp_out_3
		.gt_txn_out_3 	(gt_txn_out_3)			, // output wire gt_txn_out_3

		.tx_clk_out_0 	(tx_clk_out_0)			, // output wire tx_clk_out_0
		.rx_core_clk_0 	(rx_core_clk_0)			, // input wire rx_core_clk_0
		.rx_clk_out_0 	(rx_clk_out_0)			, // output wire rx_clk_out_0
		.rxrecclkout_0 	(rxrecclkout_0)			, // output wire [3 : 0] rxrecclkout_0

		.gt_loopback_in_0 	(gt_loopback_in_0)	, // input wire [11 : 0] gt_loopback_in_0
		.rx_reset_0 		(rx_reset_0)		, // input wire rx_reset_0
		.user_rx_reset_0 	(user_rx_reset_0)	, // output wire user_rx_reset_0


		//// RX User Interface Signals
		.rx_axis_tvalid_0 	(rx_axis_tvalid_0)	, // output wire rx_axis_tvalid_0
		.rx_axis_tdata_0 	(rx_axis_tdata_0)	, // output wire [255 : 0] rx_axis_tdata_0
		.rx_axis_tuser_0 	(rx_axis_tuser_0)	, // output wire [0 : 0] rx_axis_tuser_0
		.rx_axis_tkeep_0 	(rx_axis_tkeep_0)	, // output wire [31 : 0] rx_axis_tkeep_0
		.rx_axis_tlast_0 	(rx_axis_tlast_0)	, // output wire rx_axis_tlast_0
		.rx_preambleout_0 	(rx_preambleout_0)	, // output wire [55 : 0] rx_preambleout_0


		//// RX Control Signals
		.ctl_rx_test_pattern_0 				(ctl_rx_test_pattern_0)				, // input wire ctl_rx_test_pattern_0
		.ctl_rx_enable_0 					(ctl_rx_enable_0)					, // input wire ctl_rx_enable_0
		.ctl_rx_delete_fcs_0 				(ctl_rx_delete_fcs_0)				, // input wire ctl_rx_delete_fcs_0
		.ctl_rx_ignore_fcs_0 				(ctl_rx_ignore_fcs_0)				, // input wire ctl_rx_ignore_fcs_0
		.ctl_rx_max_packet_len_0 			(ctl_rx_max_packet_len_0)			, // input wire [14 : 0] ctl_rx_max_packet_len_0
		.ctl_rx_min_packet_len_0 			(ctl_rx_min_packet_len_0)			, // input wire [7 : 0] ctl_rx_min_packet_len_0
		.ctl_rx_custom_preamble_enable_0 	(ctl_rx_custom_preamble_enable_0)	, // input wire ctl_rx_custom_preamble_enable_0
		.ctl_rx_check_sfd_0 				(ctl_rx_check_sfd_0)				, // input wire ctl_rx_check_sfd_0
		.ctl_rx_check_preamble_0 			(ctl_rx_check_preamble_0)			, // input wire ctl_rx_check_preamble_0
		.ctl_rx_process_lfi_0 				(ctl_rx_process_lfi_0)				, // input wire ctl_rx_process_lfi_0
		.ctl_rx_force_resync_0 				(ctl_rx_force_resync_0)				, // input wire ctl_rx_force_resync_0



		//// RX Stats Signals
		.stat_rx_block_lock_0 				(stat_rx_block_lock_0)				, // output wire [3 : 0] stat_rx_block_lock_0
		.stat_rx_framing_err_valid_0_0 		(stat_rx_framing_err_valid_0_0)		, // output wire stat_rx_framing_err_valid_0_0
		.stat_rx_framing_err_0_0 			(stat_rx_framing_err_0_0)			, // output wire stat_rx_framing_err_0_0
		.stat_rx_framing_err_valid_1_0 		(stat_rx_framing_err_valid_1_0)		, // output wire stat_rx_framing_err_valid_1_0
		.stat_rx_framing_err_1_0 			(stat_rx_framing_err_1_0)			, // output wire stat_rx_framing_err_1_0
		.stat_rx_framing_err_valid_2_0 		(stat_rx_framing_err_valid_2_0)		, // output wire stat_rx_framing_err_valid_2_0
		.stat_rx_framing_err_2_0 			(stat_rx_framing_err_2_0)			, // output wire stat_rx_framing_err_2_0
		.stat_rx_framing_err_valid_3_0 		(stat_rx_framing_err_valid_3_0)		, // output wire stat_rx_framing_err_valid_3_0
		.stat_rx_framing_err_3_0 			(stat_rx_framing_err_3_0)			, // output wire stat_rx_framing_err_3_0	
		.stat_rx_vl_demuxed_0 				(stat_rx_vl_demuxed_0)				, // output wire [3 : 0] stat_rx_vl_demuxed_0
		.stat_rx_vl_number_0_0 				(stat_rx_vl_number_0_0)				, // output wire [1 : 0] stat_rx_vl_number_0_0
		.stat_rx_vl_number_1_0 				(stat_rx_vl_number_1_0)				, // output wire [1 : 0] stat_rx_vl_number_1_0
		.stat_rx_vl_number_2_0 				(stat_rx_vl_number_2_0)				, // output wire [1 : 0] stat_rx_vl_number_2_0
		.stat_rx_vl_number_3_0 				(stat_rx_vl_number_3_0)				, // output wire [1 : 0] stat_rx_vl_number_3_0
		.stat_rx_synced_0 					(stat_rx_synced_0)					, // output wire [3 : 0] stat_rx_synced_0
		.stat_rx_misaligned_0 				(stat_rx_misaligned_0)				, // output wire stat_rx_misaligned_0
		.stat_rx_aligned_err_0 				(stat_rx_aligned_err_0)				, // output wire stat_rx_aligned_err_0
		.stat_rx_synced_err_0 				(stat_rx_synced_err_0)				, // output wire [3 : 0] stat_rx_synced_err_0
		.stat_rx_mf_len_err_0 				(stat_rx_mf_len_err_0)				, // output wire [3 : 0] stat_rx_mf_len_err_0
		.stat_rx_mf_repeat_err_0 			(stat_rx_mf_repeat_err_0)			, // output wire [3 : 0] stat_rx_mf_repeat_err_0
		.stat_rx_mf_err_0 					(stat_rx_mf_err_0)					, // output wire [3 : 0] stat_rx_mf_err_0
		.stat_rx_bip_err_0_0 				(stat_rx_bip_err_0_0)				, // output wire stat_rx_bip_err_0_0
		.stat_rx_bip_err_1_0 				(stat_rx_bip_err_1_0)				, // output wire stat_rx_bip_err_1_0
		.stat_rx_bip_err_2_0 				(stat_rx_bip_err_2_0)				, // output wire stat_rx_bip_err_2_0
		.stat_rx_bip_err_3_0 				(stat_rx_bip_err_3_0)				, // output wire stat_rx_bip_err_3_0
		.stat_rx_aligned_0 					(stat_rx_aligned_0)					, // output wire stat_rx_aligned_0
		.stat_rx_hi_ber_0 					(stat_rx_hi_ber_0)					, // output wire stat_rx_hi_ber_0
		.stat_rx_status_0 					(stat_rx_status_0)					, // output wire stat_rx_status_0
		.stat_rx_bad_code_0 				(stat_rx_bad_code_0)				, // output wire [1 : 0] stat_rx_bad_code_0
		.stat_rx_total_packets_0 			(stat_rx_total_packets_0)			, // output wire [1 : 0] stat_rx_total_packets_0
		.stat_rx_total_good_packets_0 		(stat_rx_total_good_packets_0)		, // output wire stat_rx_total_good_packets_0
		.stat_rx_total_bytes_0 				(stat_rx_total_bytes_0)				, // output wire [5 : 0] stat_rx_total_bytes_0
		.stat_rx_total_good_bytes_0 		(stat_rx_total_good_bytes_0)		, // output wire [13 : 0] stat_rx_total_good_bytes_0
		.stat_rx_packet_small_0 			(stat_rx_packet_small_0)			, // output wire [1 : 0] stat_rx_packet_small_0
		.stat_rx_jabber_0 					(stat_rx_jabber_0)					, // output wire stat_rx_jabber_0
		.stat_rx_packet_large_0 			(stat_rx_packet_large_0)			, // output wire stat_rx_packet_large_0
		.stat_rx_oversize_0 				(stat_rx_oversize_0)				, // output wire stat_rx_oversize_0
		.stat_rx_undersize_0 				(stat_rx_undersize_0)				, // output wire [1 : 0] stat_rx_undersize_0
		.stat_rx_toolong_0 					(stat_rx_toolong_0)					, // output wire stat_rx_toolong_0
		.stat_rx_fragment_0 				(stat_rx_fragment_0)				, // output wire [1 : 0] stat_rx_fragment_0
		.stat_rx_packet_64_bytes_0 			(stat_rx_packet_64_bytes_0)			, // output wire stat_rx_packet_64_bytes_0
		.stat_rx_packet_65_127_bytes_0 		(stat_rx_packet_65_127_bytes_0)		, // output wire stat_rx_packet_65_127_bytes_0
		.stat_rx_packet_128_255_bytes_0 	(stat_rx_packet_128_255_bytes_0)	, // output wire stat_rx_packet_128_255_bytes_0
		.stat_rx_packet_256_511_bytes_0 	(stat_rx_packet_256_511_bytes_0)	, // output wire stat_rx_packet_256_511_bytes_0
		.stat_rx_packet_512_1023_bytes_0 	(stat_rx_packet_512_1023_bytes_0)	, // output wire stat_rx_packet_512_1023_bytes_0
		.stat_rx_packet_1024_1518_bytes_0 	(stat_rx_packet_1024_1518_bytes_0)	, // output wire stat_rx_packet_1024_1518_bytes_0
		.stat_rx_packet_1519_1522_bytes_0 	(stat_rx_packet_1519_1522_bytes_0)	, // output wire stat_rx_packet_1519_1522_bytes_0
		.stat_rx_packet_1523_1548_bytes_0 	(stat_rx_packet_1523_1548_bytes_0)	, // output wire stat_rx_packet_1523_1548_bytes_0
		.stat_rx_bad_fcs_0 					(stat_rx_bad_fcs_0)					, // output wire [1 : 0] stat_rx_bad_fcs_0
		.stat_rx_packet_bad_fcs_0 			(stat_rx_packet_bad_fcs_0)			, // output wire stat_rx_packet_bad_fcs_0
		.stat_rx_stomped_fcs_0 				(stat_rx_stomped_fcs_0)				, // output wire [1 : 0] stat_rx_stomped_fcs_0
		.stat_rx_packet_1549_2047_bytes_0 	(stat_rx_packet_1549_2047_bytes_0)	, // output wire stat_rx_packet_1549_2047_bytes_0
		.stat_rx_packet_2048_4095_bytes_0 	(stat_rx_packet_2048_4095_bytes_0)	, // output wire stat_rx_packet_2048_4095_bytes_0
		.stat_rx_packet_4096_8191_bytes_0 	(stat_rx_packet_4096_8191_bytes_0)	, // output wire stat_rx_packet_4096_8191_bytes_0
		.stat_rx_packet_8192_9215_bytes_0 	(stat_rx_packet_8192_9215_bytes_0)	, // output wire stat_rx_packet_8192_9215_bytes_0
		.stat_rx_unicast_0 					(stat_rx_unicast_0)					, // output wire stat_rx_unicast_0
		.stat_rx_multicast_0 				(stat_rx_multicast_0)				, // output wire stat_rx_multicast_0
		.stat_rx_broadcast_0 				(stat_rx_broadcast_0)				, // output wire stat_rx_broadcast_0
		.stat_rx_vlan_0 					(stat_rx_vlan_0) 					, // output wire stat_rx_vlan_0
		.stat_rx_inrangeerr_0 				(stat_rx_inrangeerr_0)				, // output wire stat_rx_inrangeerr_0
		.stat_rx_bad_preamble_0 			(stat_rx_bad_preamble_0)			, // output wire stat_rx_bad_preamble_0
		.stat_rx_bad_sfd_0 					(stat_rx_bad_sfd_0)					, // output wire stat_rx_bad_sfd_0
		.stat_rx_got_signal_os_0 			(stat_rx_got_signal_os_0)			, // output wire stat_rx_got_signal_os_0
		.stat_rx_test_pattern_mismatch_0 	(stat_rx_test_pattern_mismatch_0)	, // output wire [1 : 0] stat_rx_test_pattern_mismatch_0
		.stat_rx_truncated_0 				(stat_rx_truncated_0)				, // output wire stat_rx_truncated_0
		.stat_rx_local_fault_0 				(stat_rx_local_fault_0)				, // output wire stat_rx_local_fault_0
		.stat_rx_remote_fault_0 			(stat_rx_remote_fault_0)			, // output wire stat_rx_remote_fault_0
		.stat_rx_internal_local_fault_0 	(stat_rx_internal_local_fault_0)	, // output wire stat_rx_internal_local_fault_0
		.stat_rx_received_local_fault_0 	(stat_rx_received_local_fault_0)	, // output wire stat_rx_received_local_fault_0



		.tx_reset_0 						(tx_reset_0)						, // input wire tx_reset_0
		.user_tx_reset_0 					(user_tx_reset_0)					, // output wire user_tx_reset_0
		//// TX User Interface Signals
		.tx_axis_tready_0 					(tx_axis_tready_0)					, // output wire tx_axis_tready_0
		.tx_axis_tvalid_0 					(tx_axis_tvalid_0)					, // input wire tx_axis_tvalid_0
		.tx_axis_tdata_0 					(tx_axis_tdata_0)					, // input wire [255 : 0] tx_axis_tdata_0
		.tx_axis_tuser_0 					(tx_axis_tuser_0)					, // input wire [0 : 0] tx_axis_tuser_0
		.tx_unfout_0 						(tx_unfout_0)						, // output wire tx_unfout_0
		.tx_axis_tkeep_0 					(tx_axis_tkeep_0)					, // input wire [31 : 0] tx_axis_tkeep_0
		.tx_axis_tlast_0 					(tx_axis_tlast_0)					, // input wire tx_axis_tlast_0
		.tx_preamblein_0 					(tx_preamblein_0)					, // input wire [55 : 0] tx_preamblein_0


		//// TX Control Signals
		.ctl_tx_test_pattern_0 				(ctl_tx_test_pattern_0)				, // input wire ctl_tx_test_pattern_0
		.ctl_tx_enable_0 					(ctl_tx_enable_0)					, // input wire ctl_tx_enable_0
		.ctl_tx_fcs_ins_enable_0 			(ctl_tx_fcs_ins_enable_0)			, // input wire ctl_tx_fcs_ins_enable_0
		.ctl_tx_ipg_value_0 				(ctl_tx_ipg_value_0)				, // input wire [3 : 0] ctl_tx_ipg_value_0
		.ctl_tx_send_lfi_0 					(ctl_tx_send_lfi_0)					, // input wire ctl_tx_send_lfi_0
		.ctl_tx_send_rfi_0 					(ctl_tx_send_rfi_0)					, // input wire ctl_tx_send_rfi_0
		.ctl_tx_send_idle_0 				(ctl_tx_send_idle_0)				, // input wire ctl_tx_send_idle_0
		.ctl_tx_custom_preamble_enable_0 	(ctl_tx_custom_preamble_enable_0)	, // input wire ctl_tx_custom_preamble_enable_0
		.ctl_tx_ignore_fcs_0 				(ctl_tx_ignore_fcs_0) 				, // input wire ctl_tx_ignore_fcs_0


		//// TX Stats Signals
		.stat_tx_underflow_err_0 			(stat_tx_underflow_err_0)			, // output wire stat_tx_underflow_err_0
		.stat_tx_overflow_err_0  			(stat_tx_overflow_err_0)			, // output wire stat_tx_overflow_err_0
		.stat_tx_total_packets_0 			(stat_tx_total_packets_0)			, // output wire stat_tx_total_packets_0
		.stat_tx_total_bytes_0 				(stat_tx_total_bytes_0)				, // output wire [4 : 0] stat_tx_total_bytes_0
		.stat_tx_total_good_packets_0 		(stat_tx_total_good_packets_0)		, // output wire stat_tx_total_good_packets_0
		.stat_tx_total_good_bytes_0 		(stat_tx_total_good_bytes_0)		, // output wire [13 : 0] stat_tx_total_good_bytes_0
		.stat_tx_packet_64_bytes_0 			(stat_tx_packet_64_bytes_0)			, // output wire stat_tx_packet_64_bytes_0
		.stat_tx_packet_65_127_bytes_0 		(stat_tx_packet_65_127_bytes_0)		, // output wire stat_tx_packet_65_127_bytes_0
		.stat_tx_packet_128_255_bytes_0 	(stat_tx_packet_128_255_bytes_0)	, // output wire stat_tx_packet_128_255_bytes_0
		.stat_tx_packet_256_511_bytes_0 	(stat_tx_packet_256_511_bytes_0)	, // output wire stat_tx_packet_256_511_bytes_0
		.stat_tx_packet_512_1023_bytes_0 	(stat_tx_packet_512_1023_bytes_0)	, // output wire stat_tx_packet_512_1023_bytes_0
		.stat_tx_packet_1024_1518_bytes_0 	(stat_tx_packet_1024_1518_bytes_0)	, // output wire stat_tx_packet_1024_1518_bytes_0
		.stat_tx_packet_1519_1522_bytes_0 	(stat_tx_packet_1519_1522_bytes_0)	, // output wire stat_tx_packet_1519_1522_bytes_0
		.stat_tx_packet_1523_1548_bytes_0 	(stat_tx_packet_1523_1548_bytes_0)	, // output wire stat_tx_packet_1523_1548_bytes_0
		.stat_tx_packet_small_0 			(stat_tx_packet_small_0)			, // output wire stat_tx_packet_small_0
		.stat_tx_packet_large_0 			(stat_tx_packet_large_0)			, // output wire stat_tx_packet_large_0
		.stat_tx_packet_1549_2047_bytes_0 	(stat_tx_packet_1549_2047_bytes_0)	, // output wire stat_tx_packet_1549_2047_bytes_0
		.stat_tx_packet_2048_4095_bytes_0 	(stat_tx_packet_2048_4095_bytes_0)	, // output wire stat_tx_packet_2048_4095_bytes_0
		.stat_tx_packet_4096_8191_bytes_0 	(stat_tx_packet_4096_8191_bytes_0)	, // output wire stat_tx_packet_4096_8191_bytes_0
		.stat_tx_packet_8192_9215_bytes_0 	(stat_tx_packet_8192_9215_bytes_0)	, // output wire stat_tx_packet_8192_9215_bytes_0
		.stat_tx_unicast_0 					(stat_tx_unicast_0)					, // output wire stat_tx_unicast_0
		.stat_tx_multicast_0 				(stat_tx_multicast_0)				, // output wire stat_tx_multicast_0
		.stat_tx_broadcast_0 				(stat_tx_broadcast_0)				, // output wire stat_tx_broadcast_0
		.stat_tx_vlan_0 					(stat_tx_vlan_0)					, // output wire stat_tx_vlan_0
		.stat_tx_bad_fcs_0 					(stat_tx_bad_fcs_0)					, // output wire stat_tx_bad_fcs_0
		.stat_tx_frame_error_0 				(stat_tx_frame_error_0)				, // output wire stat_tx_frame_error_0
		.stat_tx_local_fault_0 				(stat_tx_local_fault_0)				, // output wire stat_tx_local_fault_0




		.gtwiz_reset_tx_datapath_0 			(gtwiz_reset_tx_datapath_0	)		, // input wire [0 : 0] gtwiz_reset_tx_datapath_0
		.gtwiz_reset_rx_datapath_0 			(gtwiz_reset_rx_datapath_0	)		, // input wire [0 : 0] gtwiz_reset_rx_datapath_0
		.gtpowergood_out_0 					(gtpowergood_out_0 			)		, // output wire [3 : 0] gtpowergood_out_0
		.txoutclksel_in_0 					(txoutclksel_in_0			)		, // input wire [11 : 0] txoutclksel_in_0
		.rxoutclksel_in_0 					(rxoutclksel_in_0			)		, // input wire [11 : 0] rxoutclksel_in_0
		.gt_refclk_p						(gt_refclk_p				)		, // input wire gt_refclk_p
		.gt_refclk_n						(gt_refclk_n				)		, // input wire gt_refclk_n
		.gt_refclk_out						(gt_refclk_out  			)		, // output wire gt_refclk_out
		.sys_reset 							(sys_reset 					)		, // input wire sys_reset
		.dclk 								(dclk 						)		  // input wire dclk
	);


	assign ctl_rx_test_pattern_0	= 1'b0;
	assign ctl_rx_enable_0 			= 1'b1;
	assign ctl_rx_delete_fcs_0		= 1'b1;
	assign ctl_rx_ignore_fcs_0		= 1'b0;
	assign ctl_rx_max_packet_len_0	= 15'h2580;
	assign ctl_rx_min_packet_len_0	= 8'h40;
	assign ctl_rx_check_sfd_0		= 1'b1;
	assign ctl_rx_check_preamble_0	= 1'b1;
	assign ctl_rx_process_lfi_0 	= 1'b0;
	assign ctl_rx_force_resync_0	= 1'b0;


	assign tx_preamblein_0 = {7{8'h55}} ;

	assign ctl_tx_test_pattern_0 			= 1'b0;
	assign ctl_tx_enable_0 					= 1'b1;
	assign ctl_tx_fcs_ins_enable_0 			= 1'b1;
	assign ctl_tx_ipg_value_0				= 4'hC;
	assign ctl_tx_send_lfi_0 				= 1'b0;
	assign ctl_tx_send_rfi_0 				= 1'b0;
	assign ctl_tx_send_idle_0				= 1'b0;
	assign ctl_tx_custom_preamble_enable_0 	= 1'b0;
	assign ctl_tx_ignore_fcs_0 				= 1'b0;


	// ila_axis inst_ila_axis_rx
	// (
	// 	.clk(clk_axis),
	
	// 	.probe0(rx_axis_tdata_0),
	// 	.probe1(rx_axis_tkeep_0),
	// 	.probe2(rx_axis_tlast_0),
	// 	.probe3(rx_axis_tuser_0),
	// 	.probe4(rx_axis_tvalid_0),
	// 	.probe5(1'b0)
	// );

	// ila_axis inst_ila_axis_tx
	// (
	// 	.clk(clk_axis),
	
	// 	.probe0(tx_axis_tdata_0),
	// 	.probe1(tx_axis_tkeep_0),
	// 	.probe2(tx_axis_tlast_0),
	// 	.probe3(tx_axis_tuser_0),
	// 	.probe4(tx_axis_tvalid_0),
	// 	.probe5(tx_axis_tready_0)
	// );

	// ila_512 inst_ila_status
	// (
	// 	.clk(clk_axis),
	
	// 	.probe0(
	// 		{
	// 			stat_rx_block_lock_0,
	// 			stat_rx_framing_err_valid_0_0,
	// 			stat_rx_framing_err_0_0,
	// 			stat_rx_framing_err_valid_1_0,
	// 			stat_rx_framing_err_1_0,
	// 			stat_rx_framing_err_valid_2_0,
	// 			stat_rx_framing_err_2_0,
	// 			stat_rx_framing_err_valid_3_0,
	// 			stat_rx_framing_err_3_0,
	// 			stat_rx_vl_demuxed_0,
	// 			stat_rx_vl_number_0_0,
	// 			stat_rx_vl_number_1_0,
	// 			stat_rx_vl_number_2_0,
	// 			stat_rx_vl_number_3_0,
	// 			stat_rx_synced_0,
	// 			stat_rx_misaligned_0,
	// 			stat_rx_aligned_err_0,
	// 			stat_rx_synced_err_0,
	// 			stat_rx_mf_len_err_0,
	// 			stat_rx_mf_repeat_err_0,
	// 			stat_rx_mf_err_0,
	// 			stat_rx_bip_err_0_0,
	// 			stat_rx_bip_err_1_0,
	// 			stat_rx_bip_err_2_0,
	// 			stat_rx_bip_err_3_0,
	// 			stat_rx_aligned_0,
	// 			stat_rx_hi_ber_0,
	// 			stat_rx_status_0,
	// 			stat_rx_bad_code_0,
	// 			stat_rx_total_packets_0,
	// 			stat_rx_total_good_packets_0,
	// 			stat_rx_total_bytes_0,
	// 			stat_rx_total_good_bytes_0,
	// 			stat_rx_packet_small_0,
	// 			stat_rx_jabber_0,
	// 			stat_rx_packet_large_0,
	// 			stat_rx_oversize_0,
	// 			stat_rx_undersize_0,
	// 			stat_rx_toolong_0,
	// 			stat_rx_fragment_0,
	// 			stat_rx_packet_64_bytes_0,
	// 			stat_rx_packet_65_127_bytes_0,
	// 			stat_rx_packet_128_255_bytes_0,
	// 			stat_rx_packet_256_511_bytes_0,
	// 			stat_rx_packet_512_1023_bytes_0,
	// 			stat_rx_packet_1024_1518_bytes_0,
	// 			stat_rx_packet_1519_1522_bytes_0,
	// 			stat_rx_packet_1523_1548_bytes_0,
	// 			stat_rx_bad_fcs_0,
	// 			stat_rx_packet_bad_fcs_0,
	// 			stat_rx_stomped_fcs_0,
	// 			stat_rx_packet_1549_2047_bytes_0,
	// 			stat_rx_packet_2048_4095_bytes_0,
	// 			stat_rx_packet_4096_8191_bytes_0,
	// 			stat_rx_packet_8192_9215_bytes_0,
	// 			stat_rx_unicast_0,
	// 			stat_rx_multicast_0,
	// 			stat_rx_broadcast_0,
	// 			stat_rx_vlan_0,
	// 			stat_rx_inrangeerr_0,
	// 			stat_rx_bad_preamble_0,
	// 			stat_rx_bad_sfd_0,
	// 			stat_rx_got_signal_os_0,
	// 			stat_rx_test_pattern_mismatch_0,
	// 			stat_rx_truncated_0,
	// 			stat_rx_local_fault_0,
	// 			stat_rx_remote_fault_0,
	// 			stat_rx_internal_local_fault_0,
	// 			stat_rx_received_local_fault_0,

	// 			stat_tx_underflow_err_0,
	// 			stat_tx_overflow_err_0,
	// 			stat_tx_total_packets_0,
	// 			stat_tx_total_bytes_0,
	// 			stat_tx_total_good_packets_0,
	// 			stat_tx_total_good_bytes_0,
	// 			stat_tx_packet_64_bytes_0,
	// 			stat_tx_packet_65_127_bytes_0,
	// 			stat_tx_packet_128_255_bytes_0,
	// 			stat_tx_packet_256_511_bytes_0,
	// 			stat_tx_packet_512_1023_bytes_0,
	// 			stat_tx_packet_1024_1518_bytes_0,
	// 			stat_tx_packet_1519_1522_bytes_0,
	// 			stat_tx_packet_1523_1548_bytes_0,
	// 			stat_tx_packet_small_0,
	// 			stat_tx_packet_large_0,
	// 			stat_tx_packet_1549_2047_bytes_0,
	// 			stat_tx_packet_2048_4095_bytes_0,
	// 			stat_tx_packet_4096_8191_bytes_0,
	// 			stat_tx_packet_8192_9215_bytes_0,
	// 			stat_tx_unicast_0,
	// 			stat_tx_multicast_0,
	// 			stat_tx_broadcast_0,
	// 			stat_tx_vlan_0,
	// 			stat_tx_bad_fcs_0,
	// 			stat_tx_frame_error_0,
	// 			stat_tx_local_fault_0
	// 		}
	// 	)
	// );

	// ila_stat_tx inst_ila_stat_tx
	// (
	//     .clk   (clk_axis),

	// 	.probe0  (stat_tx_underflow_err_0			 ),
	// 	.probe1  (stat_tx_overflow_err_0			 ),
	// 	.probe2  (stat_tx_total_packets_0 		 ),
	// 	.probe3  (stat_tx_total_bytes_0 			 ),
	// 	.probe4  (stat_tx_total_good_packets_0 	 ),
	// 	.probe5  (stat_tx_total_good_bytes_0 		 ),
	// 	.probe6  (stat_tx_packet_64_bytes_0 		 ),
	// 	.probe7  (stat_tx_packet_65_127_bytes_0 	 ),
	// 	.probe8  (stat_tx_packet_128_255_bytes_0   ),
	// 	.probe9  (stat_tx_packet_256_511_bytes_0   ),
	// 	.probe10 (stat_tx_packet_512_1023_bytes_0  ),
	// 	.probe11 (stat_tx_packet_1024_1518_bytes_0 ),
	// 	.probe12 (stat_tx_packet_1519_1522_bytes_0 ),
	// 	.probe13 (stat_tx_packet_1523_1548_bytes_0 ),
	// 	.probe14 (stat_tx_packet_small_0			 ),
	// 	.probe15 (stat_tx_packet_large_0			 ),
	// 	.probe16 (stat_tx_packet_1549_2047_bytes_0 ),
	// 	.probe17 (stat_tx_packet_2048_4095_bytes_0 ),
	// 	.probe18 (stat_tx_packet_4096_8191_bytes_0 ),
	// 	.probe19 (stat_tx_packet_8192_9215_bytes_0 ),
	// 	.probe20 (stat_tx_unicast_0   			 ),
	// 	.probe21 (stat_tx_multicast_0 			 ),
	// 	.probe22 (stat_tx_broadcast_0 			 ),
	// 	.probe23 (stat_tx_vlan_0 					 ),
	// 	.probe24 (stat_tx_bad_fcs_0 				 ),
	// 	.probe25 (stat_tx_frame_error_0			 ),
	// 	.probe26 (stat_tx_local_fault_0			 )
	// );

	// ila_stat_tx1 inst_ila_stat_tx1
	// (
	//     .clk   (clk_axis),

	// 	.probe0  (stat_rx_block_lock_0),
	// 	.probe1  (stat_rx_framing_err_valid_0_0),
	// 	.probe2  (stat_rx_framing_err_0_0),
	// 	.probe3  (stat_rx_framing_err_valid_1_0),
	// 	.probe4  (stat_rx_framing_err_1_0),
	// 	.probe5  (stat_rx_framing_err_valid_2_0),
	// 	.probe6  (stat_rx_framing_err_2_0),
	// 	.probe7  (stat_rx_framing_err_valid_3_0),
	// 	.probe8  (stat_rx_framing_err_3_0),
	// 	.probe9  (stat_rx_vl_demuxed_0),
	// 	.probe10 (stat_rx_vl_number_0_0),
	// 	.probe11 (stat_rx_vl_number_1_0),
	// 	.probe12 (stat_rx_vl_number_2_0),
	// 	.probe13 (stat_rx_vl_number_3_0),
	// 	.probe14 (stat_rx_synced_0),
	// 	.probe15 (stat_rx_misaligned_0),
	// 	.probe16 (stat_rx_aligned_err_0),
	// 	.probe17 (stat_rx_synced_err_0),
	// 	.probe18 (stat_rx_mf_len_err_0),
	// 	.probe19 (stat_rx_mf_repeat_err_0),
	// 	.probe20 (stat_rx_mf_err_0),
	// 	.probe21 (stat_rx_bip_err_0_0),
	// 	.probe22 (stat_rx_bip_err_1_0),
	// 	.probe23 (stat_rx_bip_err_2_0),
	// 	.probe24 (stat_rx_bip_err_3_0),
	// 	.probe25 (stat_rx_aligned_0),
	// 	.probe26 (stat_rx_hi_ber_0),
	// 	.probe27 (stat_rx_status_0),
	// 	.probe28 (stat_rx_bad_code_0),
	// 	.probe29 (stat_rx_total_packets_0)
	// );

	// ila_stat_tx2 inst_ila_stat_tx2
	// (
	//     .clk   (clk_axis),
	    
	// 	.probe0 (stat_rx_total_good_packets_0),
	// 	.probe1 (stat_rx_total_bytes_0),
	// 	.probe2 (stat_rx_total_good_bytes_0),
	// 	.probe3 (stat_rx_packet_small_0),
	// 	.probe4 (stat_rx_jabber_0),
	// 	.probe5 (stat_rx_packet_large_0),
	// 	.probe6 (stat_rx_oversize_0),
	// 	.probe7 (stat_rx_undersize_0),
	// 	.probe8 (stat_rx_toolong_0),
	// 	.probe9 (stat_rx_fragment_0),
	// 	.probe10 (stat_rx_packet_64_bytes_0),
	// 	.probe11 (stat_rx_packet_65_127_bytes_0),
	// 	.probe12 (stat_rx_packet_128_255_bytes_0),
	// 	.probe13 (stat_rx_packet_256_511_bytes_0),
	// 	.probe14 (stat_rx_packet_512_1023_bytes_0),
	// 	.probe15 (stat_rx_packet_1024_1518_bytes_0),
	// 	.probe16 (stat_rx_packet_1519_1522_bytes_0),
	// 	.probe17 (stat_rx_packet_1523_1548_bytes_0),
	// 	.probe18 (stat_rx_bad_fcs_0),
	// 	.probe19 (stat_rx_packet_bad_fcs_0),
	// 	.probe20 (stat_rx_stomped_fcs_0),
	// 	.probe21 (stat_rx_packet_1549_2047_bytes_0),
	// 	.probe22 (stat_rx_packet_2048_4095_bytes_0),
	// 	.probe23 (stat_rx_packet_4096_8191_bytes_0),
	// 	.probe24 (stat_rx_packet_8192_9215_bytes_0),
	// 	.probe25 (stat_rx_unicast_0),
	// 	.probe26 (stat_rx_multicast_0),
	// 	.probe27 (stat_rx_broadcast_0),
	// 	.probe28 (stat_rx_vlan_0),
	// 	.probe29 (stat_rx_inrangeerr_0),
	// 	.probe30 (stat_rx_bad_preamble_0),
	// 	.probe31 (stat_rx_bad_sfd_0),
	// 	.probe32 (stat_rx_got_signal_os_0),
	// 	.probe33 (stat_rx_test_pattern_mismatch_0),
	// 	.probe34 (stat_rx_truncated_0),
	// 	.probe35 (stat_rx_local_fault_0),
	// 	.probe36 (stat_rx_remote_fault_0),
	// 	.probe37 (stat_rx_internal_local_fault_0),
	// 	.probe38 (stat_rx_received_local_fault_0)
	// );
    

endmodule