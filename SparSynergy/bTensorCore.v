`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/08 10:43:57
// Design Name: 
// Module Name: bTensorCore
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


module bTensorCore(
    input wire          clk,
    input wire          rstn,
    input wire [1023:0] weight_data_in,
    input wire [255:0]  weight_sign_in,
    input wire [255:0]  weight_sel_level0,
    input wire [511:0]  weight_sel_level1,
    input wire [383:0]  shift_offset,
    input wire [1023:0] activation_in,
    input wire [511:0]  psum_data_in,
    input wire          weight_update,
    input wire          activation_update,
    input wire          psum_update,
    output wire [511:0] result_out
    );


    wire [255:0]  weight_data_in0;
    wire [63:0]   weight_sign_in0;
    wire [63:0]   weight_sel_level0_in0;
    wire [127:0]  weight_sel_level1_in0;
    wire [95:0]   shift_offset0;
    wire [255:0]  activation_in0;
    wire [127:0]  psum_data_in0;

    wire [255:0]  weight_data_in1;
    wire [63:0]   weight_sign_in1;
    wire [63:0]   weight_sel_level0_in1;
    wire [127:0]  weight_sel_level1_in1;
    wire [95:0]   shift_offset1;
    wire [255:0]  activation_in1;
    wire [127:0]  psum_data_in1;

    wire [255:0]  weight_data_in2;
    wire [63:0]   weight_sign_in2;
    wire [63:0]   weight_sel_level0_in2;
    wire [127:0]  weight_sel_level1_in2;
    wire [95:0]   shift_offset2;
    wire [255:0]  activation_in2;
    wire [127:0]  psum_data_in2;

    wire [255:0]  weight_data_in3;
    wire [63:0]   weight_sign_in3;
    wire [63:0]   weight_sel_level0_in3;
    wire [127:0]  weight_sel_level1_in3;
    wire [95:0]   shift_offset3;
    wire [255:0]  activation_in3;
    wire [127:0]  psum_data_in3;

    wire [127:0] result_out0;
    wire [127:0] result_out1;
    wire [127:0] result_out2;
    wire [127:0] result_out3;

    assign weight_data_in0 = weight_data_in[255:0];
    assign weight_data_in1 = weight_data_in[511:256];
    assign weight_data_in2 = weight_data_in[767:512];
    assign weight_data_in3 = weight_data_in[1023:768];
    
    assign weight_sign_in0 = weight_sign_in[63:0];
    assign weight_sign_in1 = weight_sign_in[127:64];
    assign weight_sign_in2 = weight_sign_in[191:128];
    assign weight_sign_in3 = weight_sign_in[255:192];

    assign weight_sel_level0_in0 = weight_sel_level0[63:0];
    assign weight_sel_level0_in1 = weight_sel_level0[127:64];
    assign weight_sel_level0_in2 = weight_sel_level0[191:128];
    assign weight_sel_level0_in3 = weight_sel_level0[255:192];

    assign weight_sel_level1_in0 = weight_sel_level1[127:0];
    assign weight_sel_level1_in1 = weight_sel_level1[255:128];
    assign weight_sel_level1_in2 = weight_sel_level1[383:256];
    assign weight_sel_level1_in3 = weight_sel_level1[511:384];
    
    assign shift_offset0 = shift_offset[95:0];
    assign shift_offset1 = shift_offset[191:96];
    assign shift_offset2 = shift_offset[287:192];
    assign shift_offset3 = shift_offset[383:288];

    assign activation_in0 = activation_in[255:0];
    assign activation_in1 = activation_in[511:256];
    assign activation_in2 = activation_in[767:512];
    assign activation_in3 = activation_in[1023:768];

    assign psum_data_in0 = psum_data_in[127:0];
    assign psum_data_in1 = psum_data_in[255:128];
    assign psum_data_in2 = psum_data_in[383:256];
    assign psum_data_in3 = psum_data_in[511:384];

    assign result_out = {result_out3, result_out2, result_out1, result_out0};

    // bOctet0 实例化
    bOctet bOctet0(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in0),
        .weight_sign_in     (weight_sign_in0),
        .weight_sel_level0  (weight_sel_level0_in0),
        .weight_sel_level1  (weight_sel_level1_in0),
        .shift_offset       (shift_offset0),
        .activation_in      (activation_in0),
        .psum_data_in       (psum_data_in0),
        .weight_update      (weight_update),
        .activation_update  (activation_update),
        .psum_update        (psum_update),
        .result_out         (result_out0)
    );

    // bOctet1 实例化
    bOctet bOctet1(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in1),
        .weight_sign_in     (weight_sign_in1),
        .weight_sel_level0  (weight_sel_level0_in1),
        .weight_sel_level1  (weight_sel_level1_in1),
        .shift_offset       (shift_offset1),
        .activation_in      (activation_in1),
        .psum_data_in       (psum_data_in1),
        .weight_update      (weight_update),
        .activation_update  (activation_update),
        .psum_update        (psum_update),
        .result_out         (result_out1)
    );

    // bOctet2 实例化
    bOctet bOctet2(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in2),
        .weight_sign_in     (weight_sign_in2),
        .weight_sel_level0  (weight_sel_level0_in2),
        .weight_sel_level1  (weight_sel_level1_in2),
        .shift_offset       (shift_offset2),
        .activation_in      (activation_in2),
        .psum_data_in       (psum_data_in2),
        .weight_update      (weight_update),
        .activation_update  (activation_update),
        .psum_update        (psum_update),
        .result_out         (result_out2)
    );

    // bOctet3 实例化
    bOctet bOctet3(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in3),
        .weight_sign_in     (weight_sign_in3),
        .weight_sel_level0  (weight_sel_level0_in3),
        .weight_sel_level1  (weight_sel_level1_in3),
        .shift_offset       (shift_offset3),
        .activation_in      (activation_in3),
        .psum_data_in       (psum_data_in3),
        .weight_update      (weight_update),
        .activation_update  (activation_update),
        .psum_update        (psum_update),
        .result_out         (result_out3)
    );



endmodule
