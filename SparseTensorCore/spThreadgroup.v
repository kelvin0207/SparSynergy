`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/04 23:00:30
// Design Name: 
// Module Name: spThreagroup
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


module spThreadgroup(
    input   wire              clk,
    input   wire              rstn,
    input   wire        [31:0] weight_group0, // 4w *8bit
    input   wire        [31:0] weight_group1, // distributed to each 2 FEDPs
    input   wire        [7:0]  weight_idx0, // weight idx for weight_group 0
    input   wire        [7:0]  weight_idx1,
    input   wire        [63:0] activation_group0,  // 2*4a *8bit for 4-2mux
    input   wire        [63:0] activation_group1,  // distributed to each 2 FEDPs
    input   wire signed [15:0] partial_sum0,  // each FEDP
    input   wire signed [15:0] partial_sum1,
    input   wire signed [15:0] partial_sum2,
    input   wire signed [15:0] partial_sum3,
    output  wire signed [15:0] result0,
    output  wire signed [15:0] result1,
    output  wire signed [15:0] result2,
    output  wire signed [15:0] result3
);

    wire [31:0] activation_sel0;
    wire [31:0] activation_sel1;
    wire [31:0] activation_sel2;
    wire [31:0] activation_sel3;

    mux8to4 mux0(
	    .activation_group  (activation_group0),
        .sel                (weight_idx0),
        .out                (activation_sel0)
    );

    mux8to4 mux1(
	    .activation_group  (activation_group1),
        .sel                (weight_idx0),
        .out                (activation_sel1)
    );

    mux8to4 mux2(
	    .activation_group  (activation_group0),
        .sel                (weight_idx1),
        .out                (activation_sel2)
    );

    mux8to4 mux3(
	    .activation_group  (activation_group1),
        .sel                (weight_idx1),
        .out                (activation_sel3)
    );

    wire signed [7:0] weight_group0_in0;
    wire signed [7:0] weight_group0_in1;
    wire signed [7:0] weight_group0_in2;
    wire signed [7:0] weight_group0_in3;

    wire signed [7:0] weight_group1_in0;
    wire signed [7:0] weight_group1_in1;
    wire signed [7:0] weight_group1_in2;
    wire signed [7:0] weight_group1_in3;

    wire signed [7:0] activation_sel0_in0;
    wire signed [7:0] activation_sel0_in1;
    wire signed [7:0] activation_sel0_in2;
    wire signed [7:0] activation_sel0_in3;

    wire signed [7:0] activation_sel1_in0;
    wire signed [7:0] activation_sel1_in1;
    wire signed [7:0] activation_sel1_in2;
    wire signed [7:0] activation_sel1_in3;

    wire signed [7:0] activation_sel2_in0;
    wire signed [7:0] activation_sel2_in1;
    wire signed [7:0] activation_sel2_in2;
    wire signed [7:0] activation_sel2_in3;

    wire signed [7:0] activation_sel3_in0;
    wire signed [7:0] activation_sel3_in1;
    wire signed [7:0] activation_sel3_in2;
    wire signed [7:0] activation_sel3_in3;

    assign weight_group0_in0 = $signed(weight_group0[ 7: 0]);
    assign weight_group0_in1 = $signed(weight_group0[15: 8]);
    assign weight_group0_in2 = $signed(weight_group0[23:16]);
    assign weight_group0_in3 = $signed(weight_group0[31:24]);

    assign weight_group1_in0 = $signed(weight_group1[ 7: 0]);
    assign weight_group1_in1 = $signed(weight_group1[15: 8]);
    assign weight_group1_in2 = $signed(weight_group1[23:16]);
    assign weight_group1_in3 = $signed(weight_group1[31:24]);

    assign activation_sel0_in0 = $signed(activation_sel0[ 7: 0]);
    assign activation_sel0_in1 = $signed(activation_sel0[15: 8]);
    assign activation_sel0_in2 = $signed(activation_sel0[23:16]);
    assign activation_sel0_in3 = $signed(activation_sel0[31:24]);

    assign activation_sel1_in0 = $signed(activation_sel1[ 7: 0]);
    assign activation_sel1_in1 = $signed(activation_sel1[15: 8]);
    assign activation_sel1_in2 = $signed(activation_sel1[23:16]);
    assign activation_sel1_in3 = $signed(activation_sel1[31:24]);

    assign activation_sel2_in0 = $signed(activation_sel2[ 7: 0]);
    assign activation_sel2_in1 = $signed(activation_sel2[15: 8]);
    assign activation_sel2_in2 = $signed(activation_sel2[23:16]);
    assign activation_sel2_in3 = $signed(activation_sel2[31:24]);

    assign activation_sel3_in0 = $signed(activation_sel3[ 7: 0]);
    assign activation_sel3_in1 = $signed(activation_sel3[15: 8]);
    assign activation_sel3_in2 = $signed(activation_sel3[23:16]);
    assign activation_sel3_in3 = $signed(activation_sel3[31:24]);


    FEDP DP0 (
        .clk        (clk),
        .rstn        (rstn),
        .weight0    (weight_group0_in0),
        .weight1    (weight_group0_in1),
        .weight2    (weight_group0_in2),
        .weight3    (weight_group0_in3),
        .activation0(activation_sel0_in0),
        .activation1(activation_sel0_in1),
        .activation2(activation_sel0_in2),
        .activation3(activation_sel0_in3),
        .partial_sum(partial_sum0),
        .result     (result0)
    );

    FEDP DP1 (
        .clk        (clk),
        .rstn        (rstn),
        .weight0    (weight_group0_in0), 
        .weight1    (weight_group0_in1),
        .weight2    (weight_group0_in2),
        .weight3    (weight_group0_in3),
        .activation0(activation_sel1_in0),
        .activation1(activation_sel1_in1),
        .activation2(activation_sel1_in2),
        .activation3(activation_sel1_in3),
        .partial_sum(partial_sum1),
        .result     (result1)
    );

    FEDP DP2 (
        .clk        (clk),
        .rstn        (rstn),
        .weight0    (weight_group1_in0),
        .weight1    (weight_group1_in1),
        .weight2    (weight_group1_in2),
        .weight3    (weight_group1_in3),
        .activation0(activation_sel2_in0),
        .activation1(activation_sel2_in1),
        .activation2(activation_sel2_in2),
        .activation3(activation_sel2_in3),
        .partial_sum(partial_sum2),
        .result     (result2)
    );

    FEDP DP3 (
        .clk        (clk),
        .rstn        (rstn),
        .weight0    (weight_group1_in0),
        .weight1    (weight_group1_in1),
        .weight2    (weight_group1_in2),
        .weight3    (weight_group1_in3),
        .activation0(activation_sel3_in0),
        .activation1(activation_sel3_in1),
        .activation2(activation_sel3_in2),
        .activation3(activation_sel3_in3),
        .partial_sum(partial_sum3),
        .result     (result3)
    );

endmodule
