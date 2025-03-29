`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/27 16:54:25
// Design Name: 
// Module Name: buffer
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


module buffer #(
    parameter DATA_WIDTH = 64,    // 数据位宽 (默认 8*8 位)
    parameter BUFFER_DEPTH = 64,  // 缓冲区深度 (默认 16)
    parameter ADDR_WIDTH = 64
)(
    input  wire                         clk,            // 时钟信号
    input  wire                         rstn,            // 复位信号，低电平有效
    input  wire                         wr_en,          // 写使能信号
    input  wire                         rd_en,          // 读使能信号
    input  wire [DATA_WIDTH-1:0]        data_in,        // 数据输入
    input  wire [ADDR_WIDTH-1:0]        rd_addr,      // 数据读地址
    input  wire [ADDR_WIDTH-1:0]        wr_addr,      // 数据写地址
    output wire [DATA_WIDTH-1:0]        data_out,       // 数据输出
    output reg                          ready           // 缓冲区数据准备好
);

    // 内部信号定义
    reg [DATA_WIDTH-1:0] buffer_mem [0:BUFFER_DEPTH-1]; // 缓冲区内存
    integer i;

    // 写操作
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ready <= 0;
            for (i=0; i<BUFFER_DEPTH; i = i+1) begin
                buffer_mem[i] <= 0;
            end
        end else if (wr_en) begin
            buffer_mem[wr_addr] <= data_in;
            ready <= 1;
        end
    end

    // 读操作
    assign data_out = (rd_en)? buffer_mem[rd_addr] : 0;

endmodule

