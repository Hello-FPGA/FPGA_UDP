/*

Copyright (c) 2020-2021 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * FPGA top-level module
 */
module fpga (
    /*
     * Clock: 200MHz LVDS
     */
    input  wire                 sys_clk_p       ,
    input  wire                 sys_clk_n       ,
    
    /*
     * Ethernet: SFP+
     */
    input   wire    [3:0]       gt_rxp_in       ,
    input   wire    [3:0]       gt_rxn_in       ,
    output  wire    [3:0]       gt_txp_out      ,
    output  wire    [3:0]       gt_txn_out      ,

    input   wire                gt_refclk_p     ,
    input   wire                gt_refclk_n     ,

    output  wire				qsfp_lpmode	    ,
	output  wire				qsfp_resetn	
);

    assign qsfp_lpmode=1'b0;
    assign qsfp_resetn=1'b1;

    wire clk_100Mhz;
    wire mmcm_locked;

    wire rst;

    wire clk_312mhz_int;
    
    clk_wiz_0 inst_clk_wiz_0
    (

        .clk_out1(clk_100Mhz),
        .clk_out2(clk_312mhz_int),

        .reset(1'b0),
        .locked(mmcm_locked),

        .clk_in1_p(sys_clk_p),
        .clk_in1_n(sys_clk_n)
    );

    sync_reset #(
        .N(4)
    ) inst_sync_reset (
        .clk(clk_100Mhz), 
        .rst(~mmcm_locked), 
        .out(rst)
    );


    wire 	 		clk_axis		;

    wire 			user_rx_reset_0 ;
    wire 			user_tx_reset_0 ;

    wire 			rx_axis_tvalid_0;
    wire [255:0] 	rx_axis_tdata_0 ;
    wire [0:0] 		rx_axis_tuser_0 ;
    wire [31:0] 	rx_axis_tkeep_0 ;
    wire 			rx_axis_tlast_0 ;

    wire 			tx_axis_tready_0;
    wire 			tx_axis_tvalid_0;
    wire [255:0] 	tx_axis_tdata_0 ;
    wire [31:0] 	tx_axis_tkeep_0 ;
    wire [0:0] 		tx_axis_tuser_0 ;
    wire  			tx_axis_tlast_0 ;

    wire 			udp_rx_axis_tvalid;
    wire [63:0] 	udp_rx_axis_tdata ;
    wire [0:0] 		udp_rx_axis_tuser ;
    wire [7:0 ] 	udp_rx_axis_tkeep ;
    wire 			udp_rx_axis_tlast ;

    wire 			udp_tx_axis_tready;
    wire 			udp_tx_axis_tvalid;
    wire [63:0] 	udp_tx_axis_tdata ;
    wire [7:0 ] 	udp_tx_axis_tkeep ;
    wire [0:0] 		udp_tx_axis_tuser ;
    wire  			udp_tx_axis_tlast ;
    
    ethernet_40g_wrapper inst_ethernet_40g_wrapper(
        .dclk             ( clk_100Mhz       ),

        .sys_reset        ( rst              ),
        .rx_reset_0       ( rst              ),
        .tx_reset_0       ( rst              ),

        .clk_axis         ( clk_axis         ),

        .user_rx_reset_0  ( user_rx_reset_0  ),
        .user_tx_reset_0  ( user_tx_reset_0  ),

        .rx_axis_tvalid_0 ( rx_axis_tvalid_0 ),
        .rx_axis_tdata_0  ( rx_axis_tdata_0  ),
        .rx_axis_tuser_0  ( rx_axis_tuser_0  ),
        .rx_axis_tkeep_0  ( rx_axis_tkeep_0  ),
        .rx_axis_tlast_0  ( rx_axis_tlast_0  ),

        .tx_axis_tready_0 ( tx_axis_tready_0 ),
        .tx_axis_tvalid_0 ( tx_axis_tvalid_0 ),
        .tx_axis_tdata_0  ( tx_axis_tdata_0  ),
        .tx_axis_tkeep_0  ( tx_axis_tkeep_0  ),
        .tx_axis_tuser_0  ( tx_axis_tuser_0  ),
        .tx_axis_tlast_0  ( tx_axis_tlast_0  ),

        .gt_refclk_p      ( gt_refclk_p      ),
        .gt_refclk_n      ( gt_refclk_n      ),
        .gt_rxp_in_0      ( gt_rxp_in[0]     ),
        .gt_rxn_in_0      ( gt_rxn_in[0]     ),
        .gt_txp_out_0     ( gt_txp_out[0]    ),
        .gt_txn_out_0     ( gt_txn_out[0]    ),
        .gt_rxp_in_1      ( gt_rxp_in[1]     ),
        .gt_rxn_in_1      ( gt_rxn_in[1]     ),
        .gt_txp_out_1     ( gt_txp_out[1]    ),
        .gt_txn_out_1     ( gt_txn_out[1]    ),
        .gt_rxp_in_2      ( gt_rxp_in[2]     ),
        .gt_rxn_in_2      ( gt_rxn_in[2]     ),
        .gt_txp_out_2     ( gt_txp_out[2]    ),
        .gt_txn_out_2     ( gt_txn_out[2]    ),
        .gt_rxp_in_3      ( gt_rxp_in[3]     ),
        .gt_rxn_in_3      ( gt_rxn_in[3]     ),
        .gt_txp_out_3     ( gt_txp_out[3]    ),
        .gt_txn_out_3     ( gt_txn_out[3]    )
    );


    ethernet_adapter inst_ethernet_adapter (
        //-------------------------------------------------------------------------
        // Ethernet adapter
        //  . Clock and Reset
        .clk         (clk_axis),
        .rst         (rst),

        .user_rx_reset_0 (user_rx_reset_0),
        .user_tx_reset_0 (user_tx_reset_0),
        //-------------------------------------------------------------------------
        // MAC AXIS Interface
        //  . RX
        .rx_axis_tvalid_0 (rx_axis_tvalid_0),
        .rx_axis_tdata_0  (rx_axis_tdata_0  ),
        .rx_axis_tuser_0  (rx_axis_tuser_0  ),
        .rx_axis_tkeep_0  (rx_axis_tkeep_0),
        .rx_axis_tlast_0  (rx_axis_tlast_0),
        //  . TX
        .tx_axis_tready_0 (tx_axis_tready_0),
        .tx_axis_tvalid_0 (tx_axis_tvalid_0),
        .tx_axis_tdata_0  (tx_axis_tdata_0  ),
        .tx_axis_tkeep_0  (tx_axis_tkeep_0  ),
        .tx_axis_tuser_0  (tx_axis_tuser_0  ),
        .tx_axis_tlast_0  (tx_axis_tlast_0  ),

        //-------------------------------------------------------------------------
        // Axis 64bit data
        // . RX
        .udp_rx_axis_tvalid(udp_rx_axis_tvalid),
        .udp_rx_axis_tdata(udp_rx_axis_tdata),
        .udp_rx_axis_tuser(udp_rx_axis_tuser),
        .udp_rx_axis_tkeep(udp_rx_axis_tkeep),
        .udp_rx_axis_tlast(udp_rx_axis_tlast), 
        // . TX
        .udp_tx_axis_tready(udp_tx_axis_tready),
        .udp_tx_axis_tvalid(udp_tx_axis_tvalid),
        .udp_tx_axis_tdata(udp_tx_axis_tdata),
        .udp_tx_axis_tkeep(udp_tx_axis_tkeep),
        .udp_tx_axis_tuser(udp_tx_axis_tuser),
        .udp_tx_axis_tlast(udp_tx_axis_tlast)
    
    );



    fpga_core
    core_inst (
        /*
         * Clock: 312.5 MHz
         * Synchronous reset
         */
        .clk(clk_312mhz_int),
        .rst(rst),
        /*
         * GPIO
         */
        // .btnu(btnu_int),
        // .btnl(btnl_int),
        // .btnd(btnd_int),
        // .btnr(btnr_int),
        // .btnc(btnc_int),
        // .sw(sw_int),
        // .led(led),
        /*
         * UART: 115200 bps, 8N1
         */
        // .uart_rxd(uart_rxd_int),
        // .uart_txd(uart_txd),
        // .uart_rts(uart_rts_int),
        // .uart_cts(uart_cts),
        /*
         * Ethernet: SFP+
         */
        .sfp0_tx_clk        (clk_axis),
        .sfp0_tx_rst        (user_tx_reset_0),
        .tx_fifo_axis_tdata (udp_tx_axis_tdata),
        .tx_fifo_axis_tkeep (udp_tx_axis_tkeep),
        .tx_fifo_axis_tvalid(udp_tx_axis_tvalid),
        .tx_fifo_axis_tready(udp_tx_axis_tready),
        .tx_fifo_axis_tlast (udp_tx_axis_tlast),
        .tx_fifo_axis_tuser (udp_tx_axis_tuser),

        .sfp0_rx_clk        (clk_axis),
        .sfp0_rx_rst        (user_rx_reset_0),
        .rx_fifo_axis_tdata (udp_rx_axis_tdata ),
        .rx_fifo_axis_tkeep (udp_rx_axis_tkeep ),
        .rx_fifo_axis_tvalid(udp_rx_axis_tvalid ),
        .rx_fifo_axis_tlast (udp_rx_axis_tlast ),
        .rx_fifo_axis_tuser (udp_rx_axis_tuser )
    );




endmodule

`resetall
