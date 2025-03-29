`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/27 15:28:06
// Design Name: 
// Module Name: PE
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


module PE(
    input   wire            clk,
    input   wire            rstn,
    input   wire    [255:0] activations,     // 4*8 activations *8bit
    input   wire            activation_valid,
    input   wire    [31:0]  weight_column,   // 4*1 weight col *8bit
    input   wire            weight_sign_en,
    input   wire            weight_valid,
    input   wire    [11:0]  shift_offset, // 4 shift * 3bit
    input   wire    [1:0]   acc_en,
    input   wire    [3:0]   zcip_done,
    output  wire    [63:0]  result, // 63bit for 1\2\4 results.
    // output  wire    [1:0]   status,
    output  wire            done
);

    wire BCE_valid0;
    wire BCE_valid1;
    wire BCE_valid2;
    wire BCE_valid3;

    wire BCE_done0;
    wire BCE_done1;
    wire BCE_done2;
    wire BCE_done3;

    wire [15:0] BCE_result0;
    wire [15:0] BCE_result1;
    wire [15:0] BCE_result2;
    wire [15:0] BCE_result3;

    assign BCE_done0 = zcip_done[0];
    assign BCE_done1 = zcip_done[1];
    assign BCE_done2 = zcip_done[2];
    assign BCE_done3 = zcip_done[3];

    BCE BCE0(
        .clk            (clk),
        .rstn            (rstn),
        .activations    (activations[63:0]), //8*8bit
        .weight_column  (weight_column[7:0]),  // 1*8bit
        .weight_sign_en (weight_sign_en),
        .shift_offset   (shift_offset[2:0]),
        .valid          (BCE_valid0),
	    .done           (BCE_done0),
        .result         (BCE_result0)
    );

    BCE BCE1(
        .clk            (clk),
        .rstn            (rstn),
        .activations    (activations[127:64]),    // 8*8bit
        .weight_column  (weight_column[15:8]),    // 1*8bit
        .weight_sign_en (weight_sign_en),
        .shift_offset   (shift_offset[5:3]),
        .valid          (BCE_valid1),
        .done           (BCE_done1),
        .result         (BCE_result1)
    );

    BCE BCE2(
        .clk            (clk),
        .rstn            (rstn),
        .activations    (activations[191:128]),   // 8*8bit
        .weight_column  (weight_column[23:16]),   // 1*8bit
        .weight_sign_en (weight_sign_en),
        .shift_offset   (shift_offset[8:6]),
        .valid          (BCE_valid2),
        .done           (BCE_done2),
        .result         (BCE_result2)
    );

    BCE BCE3(
        .clk            (clk),
        .rstn            (rstn),
        .activations    (activations[255:192]),   // 8*8bit
        .weight_column  (weight_column[31:24]),   // 1*8bit
        .weight_sign_en (weight_sign_en),
        .shift_offset   (shift_offset[11:9]),
        .valid          (BCE_valid3),
        .done           (BCE_done3),
        .result         (BCE_result3)
    );


    wire  ready;
    assign ready = BCE_done0 & BCE_done1 & BCE_done2 & BCE_done3 & weight_valid & activation_valid;

    Accumulator InterAcc(
        .clk        (clk),
        .rstn        (rstn),
        .en         (acc_en),
        .in0        (BCE_result0),
        .in1        (BCE_result1),
        .in2        (BCE_result2),
        .in3        (BCE_result3),
        .ready      (ready),
        .done       (done),
        // .status     (status),
        .final_out  (result)
    );

endmodule
