`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/08 13:00:44
// Design Name: 
// Module Name: BTC
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


module BTC_top(
    input wire              clk,
    input wire              rstn,
    input wire  [1023:0]    weight_data_in,
    input wire  [255:0]     weight_sign_in,
    input wire  [255:0]     weight_sel_level0,
    input wire  [511:0]     weight_sel_level1,
    input wire  [383:0]     shift_offset,
    input wire  [1023:0]    activation_in,
    input wire  [511:0]     psum_data_in,
    output reg  [511:0]     result_out
    );

    wire  [1023:0]    weight_data_in0;
    wire  [255:0]     weight_sign_in0;
    wire  [255:0]     weight_sel_level0_in0;
    wire  [511:0]     weight_sel_level1_in0;
    wire  [383:0]     shift_offset0;
    wire  [1023:0]    activation_in0;
    wire  [511:0]     psum_data_in0;
    wire  [511:0]     result_out0;
    wire              weight_update0;
    wire              activation_update0;
    wire              psum_update0;

    wire  [1023:0]    weight_data_in1;
    wire  [255:0]     weight_sign_in1;
    wire  [255:0]     weight_sel_level0_in1;
    wire  [511:0]     weight_sel_level1_in1;
    wire  [383:0]     shift_offset1;
    wire  [1023:0]    activation_in1;
    wire  [511:0]     psum_data_in1;
    wire  [511:0]     result_out1;
    wire              weight_update1;
    wire              activation_update1;
    wire              psum_update1;

    wire  [1023:0]    weight_data_in2;
    wire  [255:0]     weight_sign_in2;
    wire  [255:0]     weight_sel_level0_in2;
    wire  [511:0]     weight_sel_level1_in2;
    wire  [383:0]     shift_offset2;
    wire  [1023:0]    activation_in2;
    wire  [511:0]     psum_data_in2;
    wire  [511:0]     result_out2;
    wire              weight_update2;
    wire              activation_update2;
    wire              psum_update2;

    wire  [1023:0]    weight_data_in3;
    wire  [255:0]     weight_sign_in3;
    wire  [255:0]     weight_sel_level0_in3;
    wire  [511:0]     weight_sel_level1_in3;
    wire  [383:0]     shift_offset3;
    wire  [1023:0]    activation_in3;
    wire  [511:0]     psum_data_in3;
    wire  [511:0]     result_out3;
    wire              weight_update3;
    wire              activation_update3;
    wire              psum_update3;

    reg [1:0] state;

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= 0;
        end else begin
            state <= state + 2'b1;
        end
    end

    reg  [1023:0]    weight_data_in_reg;
    reg  [255:0]     weight_sign_in_reg;
    reg  [255:0]     weight_sel_level0_reg;
    reg  [511:0]     weight_sel_level1_reg;
    reg  [383:0]     shift_offset_reg;
    reg  [1023:0]    activation_in_reg;
    reg  [511:0]     psum_data_in_reg;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            weight_data_in_reg      <= 0;
            weight_sign_in_reg      <= 0;
            weight_sel_level0_reg   <= 0;
            weight_sel_level1_reg   <= 0;
            shift_offset_reg        <= 0;
            activation_in_reg       <= 0;
            psum_data_in_reg        <= 0;
        end else begin
            weight_data_in_reg      <= weight_data_in;
            weight_sign_in_reg      <= weight_sign_in;
            weight_sel_level0_reg   <= weight_sel_level0;
            weight_sel_level1_reg   <= weight_sel_level1;
            shift_offset_reg        <= shift_offset;
            activation_in_reg       <= activation_in;
            psum_data_in_reg        <= psum_data_in;
        end
    end

    reg  [511:0]     result_out_t;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            result_out <= 0;
        end else begin
            result_out <= result_out_t;
        end 
    end
    assign weight_data_in0          = (state == 2'b00)? weight_data_in_reg : 0;
    assign weight_sign_in0          = (state == 2'b00)? weight_sign_in_reg : 0;
    assign weight_sel_level0_in0    = (state == 2'b00)? weight_sel_level0_reg : 0;
    assign weight_sel_level1_in0    = (state == 2'b00)? weight_sel_level1_reg : 0;
    assign shift_offset0            = (state == 2'b00)? shift_offset_reg : 0;
    assign activation_in0           = (state == 2'b00)? activation_in_reg : 0;
    assign psum_data_in0            = (state == 2'b00)? psum_data_in_reg : 0;
    assign weight_update0           = (state == 2'b00)? 1 : 0;
    assign activation_update0       = (state == 2'b00)? 1 : 0;
    assign psum_update0             = (state == 2'b00)? 1 : 0;

    assign weight_data_in1          = (state == 2'b01)? weight_data_in_reg : 0;
    assign weight_sign_in1          = (state == 2'b01)? weight_sign_in_reg : 0;
    assign weight_sel_level0_in1    = (state == 2'b01)? weight_sel_level0_reg : 0;
    assign weight_sel_level1_in1    = (state == 2'b01)? weight_sel_level1_reg : 0;
    assign shift_offset1            = (state == 2'b01)? shift_offset_reg : 0;
    assign activation_in1           = (state == 2'b01)? activation_in_reg : 0;
    assign psum_data_in1            = (state == 2'b01)? psum_data_in_reg : 0;
    assign weight_update1           = (state == 2'b01)? 1 : 0;
    assign activation_update1       = (state == 2'b01)? 1 : 0;
    assign psum_update1             = (state == 2'b01)? 1 : 0;

    assign weight_data_in2          = (state == 2'b10)? weight_data_in_reg : 0;
    assign weight_sign_in2          = (state == 2'b10)? weight_sign_in_reg : 0;
    assign weight_sel_level0_in2    = (state == 2'b10)? weight_sel_level0_reg : 0;
    assign weight_sel_level1_in2    = (state == 2'b10)? weight_sel_level1_reg : 0;
    assign shift_offset2            = (state == 2'b10)? shift_offset_reg : 0;
    assign activation_in2           = (state == 2'b10)? activation_in_reg : 0;
    assign psum_data_in2            = (state == 2'b10)? psum_data_in_reg : 0;
    assign weight_update2           = (state == 2'b10)? 1 : 0;
    assign activation_update2       = (state == 2'b10)? 1 : 0;
    assign psum_update2             = (state == 2'b10)? 1 : 0;

    assign weight_data_in3          = (state == 2'b11)? weight_data_in_reg : 0;
    assign weight_sign_in3          = (state == 2'b11)? weight_sign_in_reg : 0;
    assign weight_sel_level0_in3    = (state == 2'b11)? weight_sel_level0_reg : 0;
    assign weight_sel_level1_in3    = (state == 2'b11)? weight_sel_level1_reg : 0;
    assign shift_offset3            = (state == 2'b11)? shift_offset_reg : 0;
    assign activation_in3           = (state == 2'b11)? activation_in_reg : 0;
    assign psum_data_in3            = (state == 2'b11)? psum_data_in_reg : 0;
    assign weight_update3           = (state == 2'b11)? 1 : 0;
    assign activation_update3       = (state == 2'b11)? 1 : 0;
    assign psum_update3             = (state == 2'b11)? 1 : 0;

    always@(*) begin
        case (state)
            2'b00: result_out_t = result_out2;
            2'b01: result_out_t = result_out3;
            2'b10: result_out_t = result_out0;
            2'b11: result_out_t = result_out1;
        endcase
    end

    bTensorCore bTensorCore0(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in0),
        .weight_sign_in     (weight_sign_in0),
        .weight_sel_level0  (weight_sel_level0_in0),
        .weight_sel_level1  (weight_sel_level1_in0),
        .shift_offset       (shift_offset0),
        .activation_in      (activation_in0),
        .psum_data_in       (psum_data_in0),
        .weight_update      (weight_update0),
        .activation_update  (activation_update0),
        .psum_update        (psum_update0),
        .result_out         (result_out0)
    );

    bTensorCore bTensorCore1(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in1),
        .weight_sign_in     (weight_sign_in1),
        .weight_sel_level0  (weight_sel_level0_in1),
        .weight_sel_level1  (weight_sel_level1_in1),
        .shift_offset       (shift_offset1),
        .activation_in      (activation_in1),
        .psum_data_in       (psum_data_in1),
        .weight_update      (weight_update1),
        .activation_update  (activation_update1),
        .psum_update        (psum_update1),
        .result_out         (result_out1)
    );

    bTensorCore bTensorCore2(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in2),
        .weight_sign_in     (weight_sign_in2),
        .weight_sel_level0  (weight_sel_level0_in2),
        .weight_sel_level1  (weight_sel_level1_in2),
        .shift_offset       (shift_offset2),
        .activation_in      (activation_in2),
        .psum_data_in       (psum_data_in2),
        .weight_update      (weight_update2),
        .activation_update  (activation_update2),
        .psum_update        (psum_update2),
        .result_out         (result_out2)
    );

    bTensorCore bTensorCore3(
        .clk                (clk),
        .rstn                (rstn),
        .weight_data_in     (weight_data_in3),
        .weight_sign_in     (weight_sign_in3),
        .weight_sel_level0  (weight_sel_level0_in3),
        .weight_sel_level1  (weight_sel_level1_in3),
        .shift_offset       (shift_offset3),
        .activation_in      (activation_in3),
        .psum_data_in       (psum_data_in3),
        .weight_update      (weight_update3),
        .activation_update  (activation_update3),
        .psum_update        (psum_update3),
        .result_out         (result_out3)
    );


endmodule
