`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/02 08:50:52
// Design Name: 
// Module Name: accumulator
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


module Accumulator(
    input wire clk,
    input wire rstn,
    input wire [1:0]  en,         // 控制信号，决定是否进行累加与累加形式
    input wire [15:0] in0,        // 第一个输入数据
    input wire [15:0] in1,        // 第二个输入数据
    input wire [15:0] in2,        // 第三个输入数据
    input wire [15:0] in3,        // 第四个输入数据
    input wire        ready,
    output reg        done,
    // output reg [1:0]  status,     // 输出的状态
    output reg [63:0] final_out   // 最终累加输出（四个16位数据的和）
);

    reg [15:0] sum1;
    reg [15:0] sum2;
    reg [15:0] sum3;

    reg [63:0] tmp_out;

    // 第一层：两两相加
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sum1 <= 16'd0;
            sum2 <= 16'd0;
        end else if (en[0]&ready) begin
            sum1 <= in0 + in1;
            sum2 <= in2 + in3;
        end
    end

    // 第二层：相加sum1和sum2
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sum3 <= 16'd0;
        end else if (en[1]&ready) begin
            sum3 <= sum1 + sum2;
        end
    end

    always@(*) begin
        case(en)
            2'b00: tmp_out = {in0, in1, in2, in3};
            2'b01: tmp_out = {32'b0, sum1, sum2};
            2'b11: tmp_out = {48'b0, sum3};
            default: tmp_out = 64'b0;
        endcase
    end
    
    // 输出控制
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            final_out <= 16'd0;
            done <= 0;
        end else begin
            final_out <= tmp_out;
            done <= 1;
        end
    end

endmodule

