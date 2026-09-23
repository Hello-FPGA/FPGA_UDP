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
    input  wire       sys_clk_p,
    input  wire       sys_clk_n,
    
    /*
     * Ethernet: SFP+
     */
    input   wire gt_rxp_in_0    ,
    input   wire gt_rxn_in_0    ,
    output  wire gt_txp_out_0   ,
    output  wire gt_txn_out_0   ,

    input   wire gt_refclk_p    ,
    input   wire gt_refclk_n
);

    wire clk_100Mhz;
    wire mmcm_locked;

    wire rst;

    wire clk_390mhz_int;
    
    clk_wiz_0 inst_clk_wiz_0
    (

        .clk_out1(clk_100Mhz),
        .clk_out2(clk_390mhz_int),

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
    
    wire            rx_clk_out_0  ;
    wire            user_rx_reset_0  ;
    wire            rx_axis_tvalid_0 ;
    wire [63 : 0]   rx_axis_tdata_0  ;
    wire            rx_axis_tlast_0  ;
    wire [7 : 0]    rx_axis_tkeep_0  ;
    wire            rx_axis_tuser_0  ;

    wire            tx_clk_out_0  ;
    wire            user_tx_reset_0  ;
    wire            tx_axis_tready_0 ;
    wire            tx_axis_tvalid_0 ;
    wire [63 : 0]   tx_axis_tdata_0  ;
    wire            tx_axis_tlast_0  ;
    wire [7 : 0]    tx_axis_tkeep_0  ;
    wire            tx_axis_tuser_0  ;

    
    xxv_ethernet inst_xxv_ethernet
    (
        .dclk             (clk_100Mhz),
        .rst              (rst),

        .tx_clk_out_0     (tx_clk_out_0),
        .user_tx_reset_0  (user_tx_reset_0),
        .tx_axis_tready_0 (tx_axis_tready_0),
        .tx_axis_tvalid_0 (tx_axis_tvalid_0),
        .tx_axis_tdata_0  (tx_axis_tdata_0),
        .tx_axis_tlast_0  (tx_axis_tlast_0),
        .tx_axis_tkeep_0  (tx_axis_tkeep_0),
        .tx_axis_tuser_0  (tx_axis_tuser_0),

        .rx_clk_out_0     (rx_clk_out_0),
        .user_rx_reset_0  (user_rx_reset_0),
        .rx_axis_tvalid_0 (rx_axis_tvalid_0),
        .rx_axis_tdata_0  (rx_axis_tdata_0),
        .rx_axis_tlast_0  (rx_axis_tlast_0),
        .rx_axis_tkeep_0  (rx_axis_tkeep_0),
        .rx_axis_tuser_0  (rx_axis_tuser_0),

        .gt_rxp_in_0      (gt_rxp_in_0),
        .gt_rxn_in_0      (gt_rxn_in_0),
        .gt_txp_out_0     (gt_txp_out_0),
        .gt_txn_out_0     (gt_txn_out_0),
        .gt_refclk_p      (gt_refclk_p),
        .gt_refclk_n      (gt_refclk_n)
    );


    fpga_core
    core_inst (
        /*
         * Clock: 390.625 MHz
         * Synchronous reset
         */
        .clk(clk_390mhz_int),
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
        .sfp0_tx_clk        (tx_clk_out_0),
        .sfp0_tx_rst        (user_tx_reset_0),
        .tx_fifo_axis_tdata (tx_axis_tdata_0),
        .tx_fifo_axis_tkeep (tx_axis_tkeep_0),
        .tx_fifo_axis_tvalid(tx_axis_tvalid_0),
        .tx_fifo_axis_tready(tx_axis_tready_0),
        .tx_fifo_axis_tlast (tx_axis_tlast_0),
        .tx_fifo_axis_tuser (tx_axis_tuser_0),

        .sfp0_rx_clk        (rx_clk_out_0),
        .sfp0_rx_rst        (user_rx_reset_0),
        .rx_fifo_axis_tdata (rx_axis_tdata_0 ),
        .rx_fifo_axis_tkeep (rx_axis_tkeep_0 ),
        .rx_fifo_axis_tvalid(rx_axis_tvalid_0 ),
        .rx_fifo_axis_tlast (rx_axis_tlast_0 ),
        .rx_fifo_axis_tuser (rx_axis_tuser_0 )
    );




endmodule

`resetall
