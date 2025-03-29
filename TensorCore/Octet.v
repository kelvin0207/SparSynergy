`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/03 11:13:01
// Design Name: 
// Module Name: Octet
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Octet#(
    parameter A_DATA_WIDTH    = 128,
    parameter A_BUFFER_SIZE   = 32,
    parameter A_BUFFER_DEPTH  = 2,
    parameter A_ADDR_WIDTH    = 1,
    parameter B_DATA_WIDTH    = 64,
    parameter B_BUFFER_SIZE   = 32,
    parameter B_BUFFER_DEPTH  = 4,
    parameter B_ADDR_WIDTH    = 2,
    parameter C_DATA_WIDTH    = 128,
    parameter C_BUFFER_SIZE   = 128,
    parameter C_BUFFER_DEPTH  = 8,
    parameter C_ADDR_WIDTH    = 3
)(
    input wire                        clk,
    input wire                        rstn,
    input wire                        start,
    input wire                        fetch_done,
    input wire [A_DATA_WIDTH-1:0]     a_data_in,
    input wire [B_DATA_WIDTH-1:0]     b_data_in,
    input wire [C_DATA_WIDTH-1:0]     c_data_in,
    output wire                       idle,
    output wire                       fetch,
    output wire                       compute,
    output wire                       write_back,
    output wire [C_DATA_WIDTH-1:0]    result_out
);

    wire                        a_wr_en;
    wire                        a_rd_en;
    wire [A_DATA_WIDTH-1:0]     a_data_out;
    wire [A_ADDR_WIDTH-1:0]     a_rd_addr;
    wire [A_ADDR_WIDTH-1:0]     a_wr_addr;
    wire                        a_ready;

    wire                        b_wr_en;
    wire                        b_rd_en;
    wire [B_DATA_WIDTH-1:0]     b_data_out;
    wire [B_ADDR_WIDTH-1:0]     b_rd_addr;
    wire [B_ADDR_WIDTH-1:0]     b_wr_addr;
    wire                        b_ready;

    wire                        c_wr_en;
    wire                        c_rd_en;
    wire [C_DATA_WIDTH-1:0]     c_data_out;
    wire [C_ADDR_WIDTH-1:0]     c_rd_addr;
    wire [C_ADDR_WIDTH-1:0]     c_wr_addr;
    wire                        c_ready;

    wire [C_DATA_WIDTH-1:0]     psum;
    wire [C_DATA_WIDTH-1:0]     result;
    wire [C_DATA_WIDTH-1:0]     c_data_in_buffer;

    Octet_controller #(
        .A_ADDR_WIDTH(A_ADDR_WIDTH),
        .B_ADDR_WIDTH(B_ADDR_WIDTH),
        .C_ADDR_WIDTH(C_ADDR_WIDTH)
    ) Octet_controller (
        .clk            (clk),
        .rstn            (rstn),
        // TC提供的信号
        .start          (start),
        .fetch_done     (fetch_done),
        // buffer提供的信号
        .buffer_ready   (a_ready & b_ready & c_ready),
        // 输出给TC控制器
        .idle           (idle),
        .fetch          (fetch),
        .compute        (compute),
        .write_back     (write_back),
        // 输出给Octet内部
        .a_wr_en        (a_wr_en),
        .a_rd_en        (a_rd_en),
        .a_rd_addr      (a_rd_addr),
        .a_wr_addr      (a_wr_addr),
        .b_wr_en        (b_wr_en),
        .b_rd_en        (b_rd_en),
        .b_rd_addr      (b_rd_addr),
        .b_wr_addr      (b_wr_addr),
        .c_wr_en        (c_wr_en),
        .c_rd_en        (c_rd_en),
        .c_rd_addr      (c_rd_addr),
        .c_wr_addr      (c_wr_addr)
    );

    buffer #(
        .DATA_WIDTH(A_DATA_WIDTH), 
        .BUFFER_DEPTH(A_BUFFER_DEPTH),
        .ADDR_WIDTH(A_ADDR_WIDTH)
    ) A_buffer(
        .clk        (clk),
        .rstn        (rstn),
        .wr_en      (a_wr_en),
        .rd_en      (a_rd_en),
        .data_in    (a_data_in),
        .data_out   (a_data_out),
        .rd_addr    (a_rd_addr),
        .wr_addr    (a_wr_addr),
        .ready      (a_ready) 
    );

    buffer  #(
        .DATA_WIDTH(B_DATA_WIDTH), 
        .BUFFER_DEPTH(B_BUFFER_DEPTH),
        .ADDR_WIDTH(B_ADDR_WIDTH)
    )B_buffer(
        .clk        (clk),
        .rstn        (rstn),
        .wr_en      (b_wr_en),
        .rd_en      (b_rd_en),
        .data_in    (b_data_in),
        .data_out   (b_data_out),
        .rd_addr    (b_rd_addr),
        .wr_addr    (b_wr_addr),
        .ready      (b_ready) 
    );

    buffer  #(
        .DATA_WIDTH(C_DATA_WIDTH), 
        .BUFFER_DEPTH(C_BUFFER_DEPTH),
        .ADDR_WIDTH(C_ADDR_WIDTH)
    )C_buffer(
        .clk        (clk),
        .rstn        (rstn),
        .wr_en      (c_wr_en),
        .rd_en      (c_rd_en),
        .data_in    (c_data_in_buffer),
        .data_out   (c_data_out),
        .rd_addr    (c_rd_addr),
        .wr_addr    (c_wr_addr),
        .ready      (c_ready) 
    );

    assign psum = compute? c_data_out : 0;
    assign c_data_in_buffer = fetch? c_data_in: result;
    assign result_out = write_back? result : 0;

    threadgroup threadgroup0(
        .clk                (clk),
        .rstn                (rstn),
        .weight_group0      (a_data_out[31:0]),
        .weight_group1      (a_data_out[63:32]),
        .activation_group0  (b_data_out[31:0]),
        .activation_group1  (b_data_out[63:32]),
        .partial_sum0       (psum[15:0]),
        .partial_sum1       (psum[31:16]),
        .partial_sum2       (psum[47:32]),
        .partial_sum3       (psum[63:48]),
        .result0            (result[15:0]),
        .result1            (result[31:16]),
        .result2            (result[47:32]),
        .result3            (result[63:48])
    );

    threadgroup threadgroup1(
        .clk                (clk),
        .rstn                (rstn),
        .weight_group0      (a_data_out[95:64]), // individual
        .weight_group1      (a_data_out[127:96]),
        .activation_group0  (b_data_out[31:0]), // shared
        .activation_group1  (b_data_out[63:32]),
        .partial_sum0       (psum[79:64]), // individual
        .partial_sum1       (psum[95:80]),
        .partial_sum2       (psum[111:96]),
        .partial_sum3       (psum[127:112]),
        .result0            (result[79:64]), // individual
        .result1            (result[95:80]),
        .result2            (result[111:96]),
        .result3            (result[127:112])
    );

endmodule
