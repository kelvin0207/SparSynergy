`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/07 16:55:38
// Design Name: 
// Module Name: bOctet
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


module bOctet(
    input wire          clk,
    input wire          rstn,
    input wire [255:0]  weight_data_in,
    input wire [63:0]   weight_sign_in,
    input wire [63:0]   weight_sel_level0,
    input wire [127:0]  weight_sel_level1,
    input wire [95:0]   shift_offset,
    input wire [255:0]  activation_in,
    input wire [127:0]  psum_data_in,
    input wire          weight_update,
    input wire          activation_update,
    input wire          psum_update,
    output wire [127:0] result_out
);

    reg [255:0]  weight_data_in_reg;
    reg [63:0]   weight_sign_in_reg;
    reg [63:0]   weight_sel_level0_reg;
    reg [127:0]  weight_sel_level1_reg;
    reg [95:0]   shift_offset_reg;
    reg [255:0]  activation_in_reg;
    reg [127:0]  psum_data_in_reg;

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            weight_data_in_reg      <= 0;
            weight_sign_in_reg      <= 0;
            weight_sel_level0_reg   <= 0;
            weight_sel_level1_reg   <= 0;
            shift_offset_reg        <= 0;
        end else if(weight_update) begin
            weight_data_in_reg      <= weight_data_in;
            weight_sign_in_reg      <= weight_sign_in;
            weight_sel_level0_reg   <= weight_sel_level0;
            weight_sel_level1_reg   <= weight_sel_level1;
            shift_offset_reg        <= shift_offset;
        end
    end

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            activation_in_reg       <= 0;
        end else if(activation_update)begin
            activation_in_reg       <= activation_in;
        end
    end

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            psum_data_in_reg       <= 0;
        end else if(psum_update)begin
            psum_data_in_reg       <= psum_data_in;
        end
    end
    
    wire        [7:0]  weight_sel0_level0;
    wire        [15:0] weight_sel0_level1;
    wire        [7:0]  weight_sel1_level0;
    wire        [15:0] weight_sel1_level1;
    wire        [7:0]  weight_sel2_level0;
    wire        [15:0] weight_sel2_level1;
    wire        [7:0]  weight_sel3_level0;
    wire        [15:0] weight_sel3_level1;

    wire        [7:0]  weight_sel4_level0;
    wire        [15:0] weight_sel4_level1;
    wire        [7:0]  weight_sel5_level0;
    wire        [15:0] weight_sel5_level1;
    wire        [7:0]  weight_sel6_level0;
    wire        [15:0] weight_sel6_level1;
    wire        [7:0]  weight_sel7_level0;
    wire        [15:0] weight_sel7_level1;

    assign weight_sel0_level0 = weight_sel_level0_reg[7:0];
    assign weight_sel1_level0 = weight_sel_level0_reg[15:8];
    assign weight_sel2_level0 = weight_sel_level0_reg[23:16];
    assign weight_sel3_level0 = weight_sel_level0_reg[31:24];

    assign weight_sel4_level0 = weight_sel_level0_reg[39:32];
    assign weight_sel5_level0 = weight_sel_level0_reg[47:40];
    assign weight_sel6_level0 = weight_sel_level0_reg[55:48];
    assign weight_sel7_level0 = weight_sel_level0_reg[63:56];

    assign weight_sel0_level1 = weight_sel_level1_reg[15:0];
    assign weight_sel1_level1 = weight_sel_level1_reg[31:16];
    assign weight_sel2_level1 = weight_sel_level1_reg[47:32];
    assign weight_sel3_level1 = weight_sel_level1_reg[63:48];

    assign weight_sel4_level1 = weight_sel_level1_reg[79:64];
    assign weight_sel5_level1 = weight_sel_level1_reg[95:80];
    assign weight_sel6_level1 = weight_sel_level1_reg[111:96];
    assign weight_sel7_level1 = weight_sel_level1_reg[127:112];

    bThreadgroup bthreadgroup0(
        .clk                (clk),
        .rstn                (rstn),
        .weight_column0     (weight_data_in_reg[31:0]),
        .weight_column1     (weight_data_in_reg[63:32]),
        .weight_column2     (weight_data_in_reg[95:64]),
        .weight_column3     (weight_data_in_reg[127:96]),
        .weight_sign        (weight_sign_in_reg[31:0]),
        .weight_sel0_level0 (weight_sel0_level0),
        .weight_sel0_level1 (weight_sel0_level1),
        .weight_sel1_level0 (weight_sel1_level0),
        .weight_sel1_level1 (weight_sel1_level1),
        .weight_sel2_level0 (weight_sel2_level0),
        .weight_sel2_level1 (weight_sel2_level1),
        .weight_sel3_level0 (weight_sel3_level0),
        .weight_sel3_level1 (weight_sel3_level1),
        .shift_offset       (shift_offset_reg[47:0]),
        .activation_group0  (activation_in_reg[63:0]),
        .activation_group1  (activation_in_reg[127:64]),
        .activation_group2  (activation_in_reg[191:128]),
        .activation_group3  (activation_in_reg[255:192]),
        .partial_sum0       (psum_data_in_reg[15:0]),
        .partial_sum1       (psum_data_in_reg[31:16]),
        .partial_sum2       (psum_data_in_reg[47:32]),
        .partial_sum3       (psum_data_in_reg[63:48]),
        .result0            (result_out[15:0]),
        .result1            (result_out[31:16]),
        .result2            (result_out[47:32]),
        .result3            (result_out[63:48])
    );

    bThreadgroup bthreadgroup1(
        .clk                (clk),
        .rstn                (rstn),
        .weight_column0     (weight_data_in_reg[159:128]),
        .weight_column1     (weight_data_in_reg[191:160]),
        .weight_column2     (weight_data_in_reg[223:192]),
        .weight_column3     (weight_data_in_reg[255:224]),
        .weight_sign        (weight_sign_in_reg[63:32]),
        .weight_sel0_level0 (weight_sel4_level0),
        .weight_sel0_level1 (weight_sel4_level1),
        .weight_sel1_level0 (weight_sel5_level0),
        .weight_sel1_level1 (weight_sel5_level1),
        .weight_sel2_level0 (weight_sel6_level0),
        .weight_sel2_level1 (weight_sel6_level1),
        .weight_sel3_level0 (weight_sel7_level0),
        .weight_sel3_level1 (weight_sel7_level1),
        .shift_offset       (shift_offset_reg[95:48]),
        .activation_group0  (activation_in_reg[63:0]),
        .activation_group1  (activation_in_reg[127:64]),
        .activation_group2  (activation_in_reg[191:128]),
        .activation_group3  (activation_in_reg[255:192]),
        .partial_sum0       (psum_data_in_reg[79:64]), // individual
        .partial_sum1       (psum_data_in_reg[95:80]),
        .partial_sum2       (psum_data_in_reg[111:96]),
        .partial_sum3       (psum_data_in_reg[127:112]),
        .result0            (result_out[79:64]), // individual
        .result1            (result_out[95:80]),
        .result2            (result_out[111:96]),
        .result3            (result_out[127:112])
    );


endmodule
