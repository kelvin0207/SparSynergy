`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/07 08:44:51
// Design Name: 
// Module Name: bFEDP
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


module bFEDP(
    input  wire             clk,          // 时钟信号
    input  wire             rstn,          // 复位信号，低电平有效
    input  wire [7:0]       weight_column0,      // 8位有符号权重输入
    input  wire [7:0]       weight_column1,
    input  wire [7:0]       weight_column2,
    input  wire [7:0]       weight_column3,
    input  wire [7:0]       weight_sign,
    input  wire [63:0]      activations,  // 8*8位有符号激活值输入
    input  wire [11:0]      shift_offset, // 4*3bit offset
    input  wire signed [15:0] partial_sum, // 16位有符号部分和输入
    output reg signed  [15:0] result        // 16位有符号结果输出
    );

    wire [15:0] product0;
    wire [15:0] product1;
    wire [15:0] product2;
    wire [15:0] product3;

    wire signed [15:0] product0_s;
    wire signed [15:0] product1_s;
    wire signed [15:0] product2_s;
    wire signed [15:0] product3_s;

    // 第一级：计算乘积
    reg signed [15:0] product0_stage1;
    reg signed [15:0] product1_stage1;
    reg signed [15:0] product2_stage1;
    reg signed [15:0] product3_stage1;
    reg signed [15:0] partial_sum_stage1;
    reg signed [15:0] partial_sum_reg0;
    reg signed [15:0] partial_sum_reg1;


    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            partial_sum_reg0 <= 0;
        end else begin
            partial_sum_reg0 <= partial_sum;
        end
    end

    bDP bDP0(
	    .clk            (clk),
        .rstn            (rstn),
	    .activations    (activations),
	    .weight_column  (weight_column0),
	    .weight_sign    (weight_sign), 
	    .shift_offset   (shift_offset[2:0]),
	    .result          (product0)
    );

    bDP bDP1(
	    .clk            (clk),
        .rstn            (rstn),
	    .activations    (activations),
	    .weight_column  (weight_column1),
	    .weight_sign    (weight_sign), 
	    .shift_offset   (shift_offset[5:3]),
	    .result          (product1)
    );

    bDP bDP2(
	    .clk            (clk),
        .rstn            (rstn),
	    .activations    (activations),
	    .weight_column  (weight_column2),
	    .weight_sign    (weight_sign), 
	    .shift_offset   (shift_offset[8:6]),
	    .result          (product2)
    );

    bDP bDP3(
	    .clk            (clk),
        .rstn            (rstn),
	    .activations    (activations),
	    .weight_column  (weight_column3),
	    .weight_sign    (weight_sign), 
	    .shift_offset   (shift_offset[11:9]),
	    .result          (product3)
    );

    assign product0_s = $signed(product0);
    assign product1_s = $signed(product1);
    assign product2_s = $signed(product2);
    assign product3_s = $signed(product3);

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            partial_sum_reg1 <= 0;
        end else begin
            partial_sum_reg1 <= partial_sum_reg0;
        end
    end
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            product0_stage1 <= 16'b0;
            product1_stage1 <= 16'b0;
            product2_stage1 <= 16'b0;
            product3_stage1 <= 16'b0;
            partial_sum_stage1 <= 0;
        end else begin
            product0_stage1 <= product0_s;
            product1_stage1 <= product1_s;
            product2_stage1 <= product2_s;
            product3_stage1 <= product3_s;
            partial_sum_stage1 <= partial_sum_reg1;
        end
    end

    // 第二级：累加乘积并加上部分和
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            result <= 16'b0;
        end else begin
            result <= partial_sum_stage1 + product0_stage1 + product1_stage1 + product2_stage1 + product3_stage1;
        end
    end

endmodule
