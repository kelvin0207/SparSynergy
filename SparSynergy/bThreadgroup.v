`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/07 08:31:40
// Design Name: 
// Module Name: bThreadgroup
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


module bThreadgroup(
    input   wire              clk,
    input   wire              rstn,
    input   wire        [31:0] weight_column0, // 4col *8bit
    input   wire        [31:0] weight_column1, // distributed to each 2 FEDPs
    input   wire        [31:0] weight_column2, // used in 1/8 mode
    input   wire        [31:0] weight_column3,
    input   wire        [31:0] weight_sign, // weight_sign 4 * 8b
    input   wire        [7:0]  weight_sel0_level0, // 4行，每行4-2 
    input   wire        [15:0] weight_sel0_level1, // 4*2个4数，4-2需要4bit
    input   wire        [7:0]  weight_sel1_level0,
    input   wire        [15:0] weight_sel1_level1,
    input   wire        [7:0]  weight_sel2_level0,
    input   wire        [15:0] weight_sel2_level1,
    input   wire        [7:0]  weight_sel3_level0,
    input   wire        [15:0] weight_sel3_level1,
    input   wire        [47:0] shift_offset, //4 * 12 bit offset
    input   wire        [63:0] activation_group0,  // 8a *8bit
    input   wire        [63:0] activation_group1,
    input   wire        [63:0] activation_group2, //idle in 1/4 sparsity mode
    input   wire        [63:0] activation_group3, 
    input   wire signed [15:0] partial_sum0,  // each FEDP
    input   wire signed [15:0] partial_sum1,
    input   wire signed [15:0] partial_sum2,
    input   wire signed [15:0] partial_sum3,
    output  wire signed [15:0] result0,
    output  wire signed [15:0] result1,
    output  wire signed [15:0] result2,
    output  wire signed [15:0] result3
    );

    // MUX logic
    wire [127:0] activations0;
    wire [127:0] activations1;

    assign activations0 = {activation_group1, activation_group0};
    assign activations1 = {activation_group3, activation_group2};

    // 0
    wire [31:0] activations_out00;
    wire [31:0] activations_out01;

    wire [63:0] activations_in0;

    mux16to4 mux00(
        .in          (activations0),
        .sel_level0  (weight_sel0_level0[3:0]),
        .sel_level1  (weight_sel0_level1[7:0]),
        .out         (activations_out00)
    );

    mux16to4 mux01(
        .in          (activations1),
        .sel_level0  (weight_sel0_level0[7:4]),
        .sel_level1  (weight_sel0_level1[15:8]),
        .out         (activations_out01)
    );

    assign activations_in0 = {activations_out01, activations_out00};

    bFEDP bFEDP0(
        .clk            (clk),
        .rstn            (rstn),
        .weight_column0 (weight_column0[7:0]),
        .weight_column1 (weight_column0[15:8]),
        .weight_column2 (weight_column0[23:16]),
        .weight_column3 (weight_column0[31:24]),
        .weight_sign    (weight_sign[7:0]),
        .activations    (activations_in0), 
        .shift_offset   (shift_offset[11:0]),
        .partial_sum    (partial_sum0),
        .result         (result0)
    );


    // 1
    wire [31:0] activations_out10;
    wire [31:0] activations_out11;

    wire [63:0] activations_in1;

    mux16to4 mux10(
        .in          (activations0),
        .sel_level0  (weight_sel1_level0[3:0]),
        .sel_level1  (weight_sel1_level1[7:0]),
        .out         (activations_out10)
    );

    mux16to4 mux11(
        .in          (activations1),
        .sel_level0  (weight_sel1_level0[7:4]),
        .sel_level1  (weight_sel1_level1[15:8]),
        .out         (activations_out11)
    );

    assign activations_in1 = {activations_out11, activations_out10};

    bFEDP bFEDP1(
        .clk            (clk),
        .rstn            (rstn),
        .weight_column0 (weight_column1[7:0]),
        .weight_column1 (weight_column1[15:8]),
        .weight_column2 (weight_column1[23:16]),
        .weight_column3 (weight_column1[31:24]),
        .weight_sign    (weight_sign[15:8]),
        .activations    (activations_in1), 
        .shift_offset   (shift_offset[23:12]),
        .partial_sum    (partial_sum1),
        .result         (result1)
    );

    // 2
    wire [31:0] activations_out20;
    wire [31:0] activations_out21;

    wire [63:0] activations_in2;

    mux16to4 mux20(
        .in          (activations0),
        .sel_level0  (weight_sel2_level0[3:0]),
        .sel_level1  (weight_sel2_level1[7:0]),
        .out         (activations_out20)
    );

    mux16to4 mux21(
        .in          (activations1),
        .sel_level0  (weight_sel2_level0[7:4]),
        .sel_level1  (weight_sel2_level1[15:8]),
        .out         (activations_out21)
    );

    assign activations_in2 = {activations_out21, activations_out20};

    bFEDP bFEDP2(
        .clk            (clk),
        .rstn            (rstn),
        .weight_column0 (weight_column2[7:0]),
        .weight_column1 (weight_column2[15:8]),
        .weight_column2 (weight_column2[23:16]),
        .weight_column3 (weight_column2[31:24]),
        .weight_sign    (weight_sign[23:16]),
        .activations    (activations_in2), 
        .shift_offset   (shift_offset[35:24]),
        .partial_sum    (partial_sum2),
        .result         (result2)
    );

    // 3
    wire [31:0] activations_out30;
    wire [31:0] activations_out31;

    wire [63:0] activations_in3;

    mux16to4 mux30(
        .in          (activations0),
        .sel_level0  (weight_sel3_level0[3:0]),
        .sel_level1  (weight_sel3_level1[7:0]),
        .out         (activations_out30)
    );

    mux16to4 mux31(
        .in          (activations1),
        .sel_level0  (weight_sel3_level0[7:4]),
        .sel_level1  (weight_sel3_level1[15:8]),
        .out         (activations_out31)
    );

    assign activations_in3 = {activations_out31, activations_out30};

    bFEDP bFEDP3(
        .clk            (clk),
        .rstn            (rstn),
        .weight_column0 (weight_column3[7:0]),
        .weight_column1 (weight_column3[15:8]),
        .weight_column2 (weight_column3[23:16]),
        .weight_column3 (weight_column3[31:24]),
        .weight_sign    (weight_sign[31:24]),
        .activations    (activations_in3), 
        .shift_offset   (shift_offset[47:36]),
        .partial_sum    (partial_sum3),
        .result         (result3)
    );

endmodule
