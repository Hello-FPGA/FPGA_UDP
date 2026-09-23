`timescale 1 ns/1 ps
    
module xxv_ethernet #
(
    parameter NEDD_ADJUST_LENTH = "TRUE"
)
(
    input   wire            dclk             ,
    input   wire            rst              ,

    output	wire 			tx_clk_out_0     ,
    output 	wire            user_tx_reset_0  ,
    output	wire            tx_axis_tready_0 ,
    input	wire            tx_axis_tvalid_0 ,
    input	wire [63 : 0]   tx_axis_tdata_0  ,
    input	wire            tx_axis_tlast_0  ,
    input	wire [7 : 0]    tx_axis_tkeep_0  ,
    input	wire            tx_axis_tuser_0  ,

    output	wire 			rx_clk_out_0 	 ,
    output	wire            user_rx_reset_0  ,
    output	wire            rx_axis_tvalid_0 ,
    output	wire [63 : 0]   rx_axis_tdata_0  ,
    output	wire            rx_axis_tlast_0  ,
    output	wire [7 : 0]    rx_axis_tkeep_0  ,
    output	wire            rx_axis_tuser_0  ,

    input   wire            gt_rxp_in_0      ,
    input   wire            gt_rxn_in_0      ,
    output  wire            gt_txp_out_0     ,
    output  wire            gt_txn_out_0     ,

    input   wire            gt_refclk_p      ,
    input   wire            gt_refclk_n      
    );

    
    
    wire rx_core_clk_0 ;
    wire gt_refclk_out ;

    assign rx_core_clk_0 = rx_clk_out_0;


    wire [2 : 0] txoutclksel_in_0;
    wire [2 : 0] rxoutclksel_in_0;

    wire gtwiz_reset_tx_datapath_0;
    wire gtwiz_reset_rx_datapath_0;

    assign txoutclksel_in_0 = 3'b101;    // this value should not be changed as per gtwizard 
    assign rxoutclksel_in_0 = 3'b101;    // this value should not be changed as per gtwizard

    assign gtwiz_reset_tx_datapath_0 = 1'b0; 
    assign gtwiz_reset_rx_datapath_0 = 1'b0; 


    wire gtpowergood_out_0;

    wire stat_tx_packet_small_0;


    wire            rx_reset_0       ;
    wire            tx_reset_0       ;


    assign rx_reset_0 = rst;
    assign tx_reset_0 = rst;

    wire            tx_adjust_axis_tready ;
    wire            tx_adjust_axis_tvalid ;
    wire [63 : 0]   tx_adjust_axis_tdata  ;
    wire            tx_adjust_axis_tlast  ;
    wire [7 : 0]    tx_adjust_axis_tkeep  ;
    wire            tx_adjust_axis_tuser  ;

    xxv_ethernet_0 inst_xxv_ethernet_0 (
        .gt_rxp_in_0(gt_rxp_in_0),                                            // input wire gt_rxp_in_0
        .gt_rxn_in_0(gt_rxn_in_0),                                            // input wire gt_rxn_in_0
        .gt_txp_out_0(gt_txp_out_0),                                          // output wire gt_txp_out_0
        .gt_txn_out_0(gt_txn_out_0),                                          // output wire gt_txn_out_0

        .gt_refclk_p(gt_refclk_p),                                            // input wire gt_refclk_p
        .gt_refclk_n(gt_refclk_n),                                            // input wire gt_refclk_n


        .rx_core_clk_0(rx_core_clk_0),                                        // input wire rx_core_clk_0
        .tx_clk_out_0 (tx_clk_out_0),                                         // output wire tx_clk_out_0
        .rx_clk_out_0 (rx_clk_out_0),                                         // output wire rx_clk_out_0
        .gt_refclk_out(gt_refclk_out),                                        // output wire gt_refclk_out

        .txoutclksel_in_0(txoutclksel_in_0),                                  // input wire [2 : 0] txoutclksel_in_0
        .rxoutclksel_in_0(rxoutclksel_in_0),                                  // input wire [2 : 0] rxoutclksel_in_0

        .gtwiz_reset_tx_datapath_0(gtwiz_reset_tx_datapath_0),                // input wire gtwiz_reset_tx_datapath_0
        .gtwiz_reset_rx_datapath_0(gtwiz_reset_rx_datapath_0),                // input wire gtwiz_reset_rx_datapath_0

        .rxrecclkout_0(),                                                     // output wire rxrecclkout_0

        .sys_reset(rst),                                                      // input wire sys_reset
        .dclk(dclk),                                                          // input wire dclk



        .gtpowergood_out_0(gtpowergood_out_0),                                // output wire gtpowergood_out_0

        .rx_reset_0      (rx_reset_0),                                        // input wire rx_reset_0
        .user_rx_reset_0 (user_rx_reset_0),                                   // output wire user_rx_reset_0
        .rx_axis_tvalid_0(rx_axis_tvalid_0),                                  // output wire rx_axis_tvalid_0
        .rx_axis_tdata_0 (rx_axis_tdata_0),                                   // output wire [63 : 0] rx_axis_tdata_0
        .rx_axis_tlast_0 (rx_axis_tlast_0),                                   // output wire rx_axis_tlast_0
        .rx_axis_tkeep_0 (rx_axis_tkeep_0),                                   // output wire [7 : 0] rx_axis_tkeep_0
        .rx_axis_tuser_0 (rx_axis_tuser_0),                                   // output wire rx_axis_tuser_0

        .ctl_rx_enable_0(1'b1),                                               // input wire ctl_rx_enable_0
        .ctl_rx_check_preamble_0(1'b1),                                       // input wire ctl_rx_check_preamble_0
        .ctl_rx_check_sfd_0(1'b1),                                            // input wire ctl_rx_check_sfd_0
        .ctl_rx_force_resync_0(1'b0),                                         // input wire ctl_rx_force_resync_0
        .ctl_rx_delete_fcs_0(1'b1),                                           // input wire ctl_rx_delete_fcs_0
        .ctl_rx_ignore_fcs_0(1'b0),                                           // input wire ctl_rx_ignore_fcs_0
        .ctl_rx_max_packet_len_0(15'd9600),                                   // input wire [14 : 0] ctl_rx_max_packet_len_0
        .ctl_rx_min_packet_len_0(8'd64),                                      // input wire [7 : 0] ctl_rx_min_packet_len_0
        .ctl_rx_process_lfi_0(1'b0),                                          // input wire ctl_rx_process_lfi_0
        .ctl_rx_test_pattern_0(1'b0),                                         // input wire ctl_rx_test_pattern_0
        .ctl_rx_data_pattern_select_0(1'b0),                                  // input wire ctl_rx_data_pattern_select_0
        .ctl_rx_test_pattern_enable_0(1'b0),                                  // input wire ctl_rx_test_pattern_enable_0
        .ctl_rx_custom_preamble_enable_0(1'b0),                               // input wire ctl_rx_custom_preamble_enable_0
        .stat_rx_framing_err_0(),                                             // output wire stat_rx_framing_err_0
        .stat_rx_framing_err_valid_0(),                                       // output wire stat_rx_framing_err_valid_0
        .stat_rx_local_fault_0(),                                             // output wire stat_rx_local_fault_0
        .stat_rx_block_lock_0(),                                              // output wire stat_rx_block_lock_0
        .stat_rx_valid_ctrl_code_0(),                                         // output wire stat_rx_valid_ctrl_code_0
        .stat_rx_status_0(),                                                  // output wire stat_rx_status_0
        .stat_rx_remote_fault_0(),                                            // output wire stat_rx_remote_fault_0
        .stat_rx_bad_fcs_0(),                                                 // output wire [1 : 0] stat_rx_bad_fcs_0
        .stat_rx_stomped_fcs_0(),                                             // output wire [1 : 0] stat_rx_stomped_fcs_0
        .stat_rx_truncated_0(),                                               // output wire stat_rx_truncated_0
        .stat_rx_internal_local_fault_0(),                                    // output wire stat_rx_internal_local_fault_0
        .stat_rx_received_local_fault_0(),                                    // output wire stat_rx_received_local_fault_0
        .stat_rx_hi_ber_0(),                                                  // output wire stat_rx_hi_ber_0
        .stat_rx_got_signal_os_0(),                                           // output wire stat_rx_got_signal_os_0
        .stat_rx_test_pattern_mismatch_0(),                                   // output wire stat_rx_test_pattern_mismatch_0
        .stat_rx_total_bytes_0(),                                             // output wire [3 : 0] stat_rx_total_bytes_0
        .stat_rx_total_packets_0(),                                           // output wire [1 : 0] stat_rx_total_packets_0
        .stat_rx_total_good_bytes_0(),                                        // output wire [13 : 0] stat_rx_total_good_bytes_0
        .stat_rx_total_good_packets_0(),                                      // output wire stat_rx_total_good_packets_0
        .stat_rx_packet_bad_fcs_0(),                                          // output wire stat_rx_packet_bad_fcs_0
        .stat_rx_packet_64_bytes_0(),                                         // output wire stat_rx_packet_64_bytes_0
        .stat_rx_packet_65_127_bytes_0(),                                     // output wire stat_rx_packet_65_127_bytes_0
        .stat_rx_packet_128_255_bytes_0(),                                    // output wire stat_rx_packet_128_255_bytes_0
        .stat_rx_packet_256_511_bytes_0(),                                    // output wire stat_rx_packet_256_511_bytes_0
        .stat_rx_packet_512_1023_bytes_0(),                                   // output wire stat_rx_packet_512_1023_bytes_0
        .stat_rx_packet_1024_1518_bytes_0(),                                  // output wire stat_rx_packet_1024_1518_bytes_0
        .stat_rx_packet_1519_1522_bytes_0(),                                  // output wire stat_rx_packet_1519_1522_bytes_0
        .stat_rx_packet_1523_1548_bytes_0(),                                  // output wire stat_rx_packet_1523_1548_bytes_0
        .stat_rx_packet_1549_2047_bytes_0(),                                  // output wire stat_rx_packet_1549_2047_bytes_0
        .stat_rx_packet_2048_4095_bytes_0(),                                  // output wire stat_rx_packet_2048_4095_bytes_0
        .stat_rx_packet_4096_8191_bytes_0(),                                  // output wire stat_rx_packet_4096_8191_bytes_0
        .stat_rx_packet_8192_9215_bytes_0(),                                  // output wire stat_rx_packet_8192_9215_bytes_0
        .stat_rx_packet_small_0(),                                            // output wire stat_rx_packet_small_0
        .stat_rx_packet_large_0(),                                            // output wire stat_rx_packet_large_0
        .stat_rx_unicast_0(),                                                 // output wire stat_rx_unicast_0
        .stat_rx_multicast_0(),                                               // output wire stat_rx_multicast_0
        .stat_rx_broadcast_0(),                                               // output wire stat_rx_broadcast_0
        .stat_rx_oversize_0(),                                                // output wire stat_rx_oversize_0
        .stat_rx_toolong_0(),                                                 // output wire stat_rx_toolong_0
        .stat_rx_undersize_0(),                                               // output wire stat_rx_undersize_0
        .stat_rx_fragment_0(),                                                // output wire stat_rx_fragment_0
        .stat_rx_vlan_0(),                                                    // output wire stat_rx_vlan_0
        .stat_rx_inrangeerr_0(),                                              // output wire stat_rx_inrangeerr_0
        .stat_rx_jabber_0(),                                                  // output wire stat_rx_jabber_0
        .stat_rx_bad_code_0(),                                                // output wire stat_rx_bad_code_0
        .stat_rx_bad_sfd_0(),                                                 // output wire stat_rx_bad_sfd_0
        .stat_rx_bad_preamble_0(),                                            // output wire stat_rx_bad_preamble_0


        .tx_reset_0(tx_reset_0),                                              // input wire tx_reset_0
        .user_tx_reset_0(user_tx_reset_0),                                    // output wire user_tx_reset_0
        .tx_axis_tready_0(tx_adjust_axis_tready),                                  // output wire tx_axis_tready_0
        .tx_axis_tvalid_0(tx_adjust_axis_tvalid),                                  // input wire tx_axis_tvalid_0
        .tx_axis_tdata_0(tx_adjust_axis_tdata),                                    // input wire [63 : 0] tx_axis_tdata_0
        .tx_axis_tlast_0(tx_adjust_axis_tlast),                                    // input wire tx_axis_tlast_0
        .tx_axis_tkeep_0(tx_adjust_axis_tkeep),                                    // input wire [7 : 0] tx_axis_tkeep_0
        .tx_axis_tuser_0(tx_adjust_axis_tuser),                                    // input wire tx_axis_tuser_0

        .tx_unfout_0(),                                                       // output wire tx_unfout_0
        .tx_preamblein_0(56'b0),                                              // input wire [55 : 0] tx_preamblein_0
        .rx_preambleout_0(),                                                  // output wire [55 : 0] rx_preambleout_0
        .stat_tx_local_fault_0(),                                             // output wire stat_tx_local_fault_0
        .stat_tx_total_bytes_0(),                                             // output wire [3 : 0] stat_tx_total_bytes_0
        .stat_tx_total_packets_0(),                                           // output wire stat_tx_total_packets_0
        .stat_tx_total_good_bytes_0(),                                        // output wire [13 : 0] stat_tx_total_good_bytes_0
        .stat_tx_total_good_packets_0(),                                      // output wire stat_tx_total_good_packets_0
        .stat_tx_bad_fcs_0(),                                                 // output wire stat_tx_bad_fcs_0
        .stat_tx_packet_64_bytes_0(),                                         // output wire stat_tx_packet_64_bytes_0
        .stat_tx_packet_65_127_bytes_0(),                                     // output wire stat_tx_packet_65_127_bytes_0
        .stat_tx_packet_128_255_bytes_0(),                                    // output wire stat_tx_packet_128_255_bytes_0
        .stat_tx_packet_256_511_bytes_0(),                                    // output wire stat_tx_packet_256_511_bytes_0
        .stat_tx_packet_512_1023_bytes_0(),                                   // output wire stat_tx_packet_512_1023_bytes_0
        .stat_tx_packet_1024_1518_bytes_0(),                                  // output wire stat_tx_packet_1024_1518_bytes_0
        .stat_tx_packet_1519_1522_bytes_0(),                                  // output wire stat_tx_packet_1519_1522_bytes_0
        .stat_tx_packet_1523_1548_bytes_0(),                                  // output wire stat_tx_packet_1523_1548_bytes_0
        .stat_tx_packet_1549_2047_bytes_0(),                                  // output wire stat_tx_packet_1549_2047_bytes_0
        .stat_tx_packet_2048_4095_bytes_0(),                                  // output wire stat_tx_packet_2048_4095_bytes_0
        .stat_tx_packet_4096_8191_bytes_0(),                                  // output wire stat_tx_packet_4096_8191_bytes_0
        .stat_tx_packet_8192_9215_bytes_0(),                                  // output wire stat_tx_packet_8192_9215_bytes_0
        .stat_tx_packet_small_0(stat_tx_packet_small_0),                                            // output wire stat_tx_packet_small_0
        .stat_tx_packet_large_0(),                                            // output wire stat_tx_packet_large_0
        .stat_tx_unicast_0(),                                                 // output wire stat_tx_unicast_0
        .stat_tx_multicast_0(),                                               // output wire stat_tx_multicast_0
        .stat_tx_broadcast_0(),                                               // output wire stat_tx_broadcast_0
        .stat_tx_vlan_0(),                                                    // output wire stat_tx_vlan_0
        .stat_tx_frame_error_0(),                                             // output wire stat_tx_frame_error_0
        .ctl_tx_enable_0(1'b1),                                               // input wire ctl_tx_enable_0
        .ctl_tx_send_rfi_0(1'b0),                                             // input wire ctl_tx_send_rfi_0
        .ctl_tx_send_lfi_0(1'b0),                                             // input wire ctl_tx_send_lfi_0
        .ctl_tx_send_idle_0(1'b0),                                            // input wire ctl_tx_send_idle_0
        .ctl_tx_fcs_ins_enable_0(1'b1),                                       // input wire ctl_tx_fcs_ins_enable_0
        .ctl_tx_ignore_fcs_0(1'b0),                                           // input wire ctl_tx_ignore_fcs_0
        .ctl_tx_test_pattern_0(1'b0),                                         // input wire ctl_tx_test_pattern_0
        .ctl_tx_test_pattern_enable_0(1'b0),                                  // input wire ctl_tx_test_pattern_enable_0
        .ctl_tx_test_pattern_select_0(1'b0),                                  // input wire ctl_tx_test_pattern_select_0
        .ctl_tx_data_pattern_select_0(1'b0),                                  // input wire ctl_tx_data_pattern_select_0
        .ctl_tx_test_pattern_seed_a_0(58'h0),                                 // input wire [57 : 0] ctl_tx_test_pattern_seed_a_0
        .ctl_tx_test_pattern_seed_b_0(58'h0),                                 // input wire [57 : 0] ctl_tx_test_pattern_seed_b_0
        .ctl_tx_ipg_value_0(4'd12),                                           // input wire [3 : 0] ctl_tx_ipg_value_0
        .ctl_tx_custom_preamble_enable_0(1'b0),                               // input wire ctl_tx_custom_preamble_enable_0
        .gt_loopback_in_0(1'b0),                                              // input wire [2 : 0] gt_loopback_in_0
        .qpllreset_in_0(1'b0)                                                 // input wire qpllreset_in_0
    );

    generate
        
        if (NEDD_ADJUST_LENTH == "TRUE") begin
            axis_frame_length_adjust #(
                .DATA_WIDTH(64)
            ) inst_axis_frame_length_adjust (
                .clk                          (tx_clk_out_0),
                .rst                          (user_tx_reset_0),

                .s_axis_tdata                 (tx_axis_tdata_0),
                .s_axis_tkeep                 (tx_axis_tkeep_0),
                .s_axis_tvalid                (tx_axis_tvalid_0),
                .s_axis_tready                (tx_axis_tready_0),
                .s_axis_tlast                 (tx_axis_tlast_0),
                .s_axis_tid                   (0),
                .s_axis_tdest                 (0),
                .s_axis_tuser                 (tx_axis_tuser_0),

                .m_axis_tdata                 (tx_adjust_axis_tdata),
                .m_axis_tkeep                 (tx_adjust_axis_tkeep),
                .m_axis_tvalid                (tx_adjust_axis_tvalid),
                .m_axis_tready                (tx_adjust_axis_tready),
                .m_axis_tlast                 (tx_adjust_axis_tlast),
                .m_axis_tid                   (),
                .m_axis_tdest                 (),
                .m_axis_tuser                 (tx_adjust_axis_tuser),

                .status_valid                 (),
                .status_ready                 (1'b1),
                .status_frame_pad             (),
                .status_frame_truncate        (),
                .status_frame_length          (),
                .status_frame_original_length (),
                .length_min                   (64),
                .length_max                   (9999)
            );
        end else begin
            assign tx_adjust_axis_tready = tx_axis_tready_0;
            assign tx_adjust_axis_tvalid = tx_axis_tvalid_0;
            assign tx_adjust_axis_tdata  = tx_axis_tdata_0;
            assign tx_adjust_axis_tlast  = tx_axis_tlast_0;
            assign tx_adjust_axis_tkeep  = tx_axis_tkeep_0;
            assign tx_adjust_axis_tuser  = tx_axis_tuser_0;
        end
        
    endgenerate


    // ila_mac inst_ila_xxv_tx
    // (
    //     .clk(tx_clk_out_0),

    //     .probe0 (tx_axis_tdata_0 ),
    //     .probe1 (tx_axis_tkeep_0 ),
    //     .probe2 (tx_axis_tvalid_0),
    //     .probe3 (tx_axis_tready_0),
    //     .probe4 (tx_axis_tlast_0 ),
    //     .probe5 (stat_tx_packet_small_0 )
    // );

    // ila_mac inst_ila_xxv_rx
    // (
    //     .clk(rx_clk_out_0),

    //     .probe0 (rx_axis_tdata_0 ),
    //     .probe1 (rx_axis_tkeep_0 ),
    //     .probe2 (rx_axis_tvalid_0),
    //     .probe3 (1'b0),
    //     .probe4 (rx_axis_tlast_0 ),
    //     .probe5 (rx_axis_tuser_0 )
    // );

endmodule
