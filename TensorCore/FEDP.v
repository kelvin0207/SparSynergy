`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/03 11:13:01
// Design Name: 
// Module Name: FEDP
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


module FEDP(
    input  wire clk,                       // 时钟信号
    input  wire rstn,                       // 复位信号，低电平有效
    input  wire signed [7:0] weight0,      // 8位有符号权重输入
    input  wire signed [7:0] weight1,
    input  wire signed [7:0] weight2,
    input  wire signed [7:0] weight3,
    input  wire signed [7:0] activation0,  // 8位有符号激活值输入
    input  wire signed [7:0] activation1,
    input  wire signed [7:0] activation2,
    input  wire signed [7:0] activation3,
    input  wire signed [15:0] partial_sum, // 32位有符号部分和输入
    output reg signed [15:0] result        // 32位有符号结果输出
);

    // 第一级：计算乘积
    reg signed [15:0] product0_stage1;
    reg signed [15:0] product1_stage1;
    reg signed [15:0] product2_stage1;
    reg signed [15:0] product3_stage1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            product0_stage1 <= 16'b0;
            product1_stage1 <= 16'b0;
            product2_stage1 <= 16'b0;
            product3_stage1 <= 16'b0;
        end else begin
            product0_stage1 <= weight0 * activation0;
            product1_stage1 <= weight1 * activation1;
            product2_stage1 <= weight2 * activation2;
            product3_stage1 <= weight3 * activation3;
        end
    end

    // 第二级：累加乘积并加上部分和
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            result <= 16'b0;
        end else begin
            result <= partial_sum + product0_stage1 + product1_stage1 + product2_stage1 + product3_stage1;
        end
    end

endmodule
