`timescale 1 ns/1 ps
    
module icmp_checksum_gen (
    input   wire        clk         ,
    input   wire        rst         ,

    output reg          status_calc_data_checksum,

    output reg   [15:0] icmp_checksum,
    output reg          imcp_checksum_valid,

    input  wire  [7:0]  s_icmp_type,
    input  wire  [7:0]  s_icmp_code,
    input  wire  [15:0] s_icmp_identifier,
    input  wire  [15:0] s_icmp_squeence_num,
    input  wire         s_icmp_hdr_valid,
    input  wire         s_icmp_hdr_ready,

    input  wire  [7:0]  s_icmp_payload_axis_tdata,
    input  wire         s_icmp_payload_axis_tlast,
    input  wire         s_icmp_payload_axis_tvalid,
    input  wire         s_icmp_payload_axis_tready
);


    localparam IDLE = 0;
    localparam ICMP_HEAD1   = 1;
    localparam ICMP_HEAD2   = 2;
    localparam ICMP_HEAD3   = 3;
    localparam ICMP_DATA    = 4;

    reg  [7:0]  tmp_icmp_type        ;
    reg  [7:0]  tmp_icmp_code        ;
    reg  [15:0] tmp_icmp_identifier  ;
    reg  [15:0] tmp_icmp_squeence_num;
    
    reg [7:0] state_c;
    reg [7:0] state_n;
    
    wire idle2head1_start;
    wire head12head2_start;
    wire head22head3_start;
    wire head32data_start;
    wire data2idle_start;

    always  @(posedge clk)begin
        if(rst==1'b1)begin
            tmp_icmp_type         <= 'd0;
            tmp_icmp_code         <= 'd0;
            tmp_icmp_identifier   <= 'd0;
            tmp_icmp_squeence_num <= 'd0;
        end
        else if(s_icmp_hdr_valid && s_icmp_hdr_ready)begin
            tmp_icmp_type         <= s_icmp_type;
            tmp_icmp_code         <= s_icmp_code;
            tmp_icmp_identifier   <= s_icmp_identifier;
            tmp_icmp_squeence_num <= s_icmp_squeence_num;
        end
    end

    always@(posedge clk)begin
        if(rst)begin
            state_c <= IDLE;
        end
        else begin
            state_c <= state_n;
        end
    end
    
    //第二段：组合逻辑always模块，描述状态转移条件判断
    always@(*)begin
        case(state_c)
            IDLE:begin
                if(idle2head1_start)begin
                    state_n = ICMP_HEAD1;
                end
                else begin
                    state_n = state_c;
                end
            end
            ICMP_HEAD1:begin
                if(head12head2_start)begin
                    state_n = ICMP_HEAD2;
                end
                else begin
                    state_n = state_c;
                end
            end
            ICMP_HEAD2:begin
                if(head22head3_start)begin
                    state_n = ICMP_HEAD3;
                end
                else begin
                    state_n = state_c;
                end
            end
            ICMP_HEAD3:begin
                if(head32data_start)begin
                    state_n = ICMP_DATA;
                end
                else begin
                    state_n = state_c;
                end
            end
            ICMP_DATA:begin
                if(data2idle_start)begin
                    state_n = IDLE;
                end
                else begin
                    state_n = state_c;
                end
            end
            default:begin
                state_n = IDLE;
            end
        endcase
    end
    
    assign idle2head1_start  = state_c==IDLE       && s_icmp_hdr_valid && s_icmp_hdr_ready;
    assign head12head2_start = state_c==ICMP_HEAD1 && 1'b1;
    assign head22head3_start = state_c==ICMP_HEAD2 && 1'b1;
    assign head32data_start  = state_c==ICMP_HEAD3 && 1'b1;
    assign data2idle_start   = state_c==ICMP_DATA  && s_icmp_payload_axis_tlast && s_icmp_payload_axis_tvalid && s_icmp_payload_axis_tready;
    

    reg [15:0] icmp_checksum_reg;
    reg [15:0] icmp_checksum_next;
    reg        r_end_cnt;
    reg        r_s_icmp_payload_axis_tlast;
    reg        r1_end_cnt;
    reg        r1_s_icmp_payload_axis_tlast;

    function [15:0] add1c16b;
        input [15:0] a, b;
        reg [16:0] t;
        begin
            t = a+b;
            add1c16b = t[15:0] + t[16];
        end
    endfunction

    reg     [15:0]  cnt;
    wire            add_cnt;
    wire            end_cnt;
    
    always @(posedge clk)begin
        if(rst)begin
            cnt <= 0;
        end
        else if(add_cnt)begin
            if(end_cnt)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end
    
    assign add_cnt = state_c==ICMP_DATA && s_icmp_payload_axis_tvalid && s_icmp_payload_axis_tready;       
    assign end_cnt = add_cnt && ((cnt== 2-1) || s_icmp_payload_axis_tlast);

    always  @(posedge clk)begin
        if(rst==1'b1)begin
            r_end_cnt <= 1'b0;
            r_s_icmp_payload_axis_tlast <= 1'b0;
            r1_end_cnt <= 1'b0;
            r1_s_icmp_payload_axis_tlast <= 1'b0;
        end
        else begin
            r_end_cnt <= end_cnt;
            r_s_icmp_payload_axis_tlast <= s_icmp_payload_axis_tlast;

            r1_end_cnt <= r_end_cnt;
            r1_s_icmp_payload_axis_tlast <= r_s_icmp_payload_axis_tlast;
        end
    end

    reg [15:0] tmp_data;

    always  @(posedge clk)begin
        if(rst==1'b1)begin
            tmp_data <= 16'd0;
        end
        else if(add_cnt && cnt==1-1)begin
            tmp_data[7:0] <= s_icmp_payload_axis_tdata;
            tmp_data[15:8]  <= 8'd0;
        end
        else if(add_cnt && cnt==2-1)begin
            tmp_data[15:8] <= s_icmp_payload_axis_tdata;
        end
    end

    always  @(*)begin
        if(state_c==ICMP_HEAD1)begin
            icmp_checksum_next = add1c16b(16'd0, {tmp_icmp_code, tmp_icmp_type});
        end
        else if(state_c==ICMP_HEAD2)begin
            icmp_checksum_next = add1c16b(icmp_checksum_reg, {tmp_icmp_identifier[7:0], tmp_icmp_identifier[15:8]});
        end
        else if(state_c==ICMP_HEAD3)begin
            icmp_checksum_next = add1c16b(icmp_checksum_reg, {tmp_icmp_squeence_num[7:0], tmp_icmp_squeence_num[15:8]});
        end
        else begin
            icmp_checksum_next = add1c16b(icmp_checksum_reg, tmp_data);
        end
    end

    always  @(posedge clk)begin
        if(rst==1'b1)begin
            icmp_checksum_reg <= 16'd0;
        end
        else if(state_c==ICMP_HEAD1 || state_c==ICMP_HEAD2 || state_c==ICMP_HEAD3)begin
            icmp_checksum_reg <= icmp_checksum_next;
        end
        else if(r_end_cnt)begin
            icmp_checksum_reg <= icmp_checksum_next;
        end
    end


    always  @(posedge clk)begin
        if(rst==1'b1)begin
            icmp_checksum <= 16'd0;
            imcp_checksum_valid <= 1'b0;
        end
        else if(r1_end_cnt && r1_s_icmp_payload_axis_tlast)begin
            icmp_checksum <= ~icmp_checksum_reg;
            imcp_checksum_valid <= 1'b1;
        end
        else begin
            imcp_checksum_valid <= 1'b0;
        end
    end


    always  @(posedge clk)begin
        if(rst==1'b1)begin
            status_calc_data_checksum <= 1'b0;
        end
        else if(head32data_start)begin
            status_calc_data_checksum <= 1'b1;
        end
        else if(data2idle_start)begin
            status_calc_data_checksum <= 1'b0;
        end
    end

endmodule
