`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/04 23:00:30
// Design Name: 
// Module Name: spTensorCore
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


module spTensorCore #(
    parameter A_DATA_WIDTH    = 128,
    parameter A_BUFFER_SIZE   = 32,
    parameter A_BUFFER_DEPTH  = 2,
    parameter A_ADDR_WIDTH    = 1,
    parameter B_DATA_WIDTH    = 128,
    parameter B_BUFFER_SIZE   = 32,
    parameter B_BUFFER_DEPTH  = 2,
    parameter B_ADDR_WIDTH    = 1,
    parameter C_DATA_WIDTH    = 128,
    parameter C_BUFFER_SIZE   = 128,
    parameter C_BUFFER_DEPTH  = 8,
    parameter C_ADDR_WIDTH    = 3
    )(
        input wire                      clk,
        input wire                      rstn,
        input wire                      start,
        input wire                      fetch_done,
        input wire [A_DATA_WIDTH*4-1:0] a_data_in,
        input wire [B_DATA_WIDTH*4-1:0] b_data_in,
        input wire [127:0]              weight_idx_in,
        input wire [C_DATA_WIDTH*4-1:0] c_data_in,
        output wire                     idle_out,
        output wire                     fetch_out,
        output wire                     compute_out,
        output wire                     write_back_out,
        output wire [C_DATA_WIDTH*4-1:0]result_out
    );

    wire [3:0] idle;
    wire [3:0] fetch;
    wire [3:0] compute;
    wire [3:0] write_back;

    wire [A_DATA_WIDTH-1:0] a_data_in0;
    wire [B_DATA_WIDTH-1:0] b_data_in0;
    wire [C_DATA_WIDTH-1:0] c_data_in0;

    wire [A_DATA_WIDTH-1:0] a_data_in1;
    wire [B_DATA_WIDTH-1:0] b_data_in1;
    wire [C_DATA_WIDTH-1:0] c_data_in1;

    wire [A_DATA_WIDTH-1:0] a_data_in2;
    wire [B_DATA_WIDTH-1:0] b_data_in2;
    wire [C_DATA_WIDTH-1:0] c_data_in2;

    wire [A_DATA_WIDTH-1:0] a_data_in3;
    wire [B_DATA_WIDTH-1:0] b_data_in3;
    wire [C_DATA_WIDTH-1:0] c_data_in3;

    wire [C_DATA_WIDTH-1:0] result_out0;
    wire [C_DATA_WIDTH-1:0] result_out1;
    wire [C_DATA_WIDTH-1:0] result_out2;
    wire [C_DATA_WIDTH-1:0] result_out3;

    wire [31:0] weight_idx_in0;
    wire [31:0] weight_idx_in1;
    wire [31:0] weight_idx_in2;
    wire [31:0] weight_idx_in3;

    assign a_data_in0 = a_data_in[A_DATA_WIDTH-1    : 0];
    assign a_data_in1 = a_data_in[A_DATA_WIDTH*2-1  : A_DATA_WIDTH*1];
    assign a_data_in2 = a_data_in[A_DATA_WIDTH*3-1  : A_DATA_WIDTH*2];
    assign a_data_in3 = a_data_in[A_DATA_WIDTH*4-1  : A_DATA_WIDTH*3];

    assign b_data_in0 = b_data_in[B_DATA_WIDTH-1      : 0];
    assign b_data_in1 = b_data_in[B_DATA_WIDTH*2-1    : B_DATA_WIDTH*1];
    assign b_data_in2 = b_data_in[B_DATA_WIDTH*3-1    : B_DATA_WIDTH*2];
    assign b_data_in3 = b_data_in[B_DATA_WIDTH*4-1    : B_DATA_WIDTH*3];

    assign c_data_in0 = c_data_in[C_DATA_WIDTH-1      : 0];
    assign c_data_in1 = c_data_in[C_DATA_WIDTH*2-1    : C_DATA_WIDTH*1];
    assign c_data_in2 = c_data_in[C_DATA_WIDTH*3-1    : C_DATA_WIDTH*2];
    assign c_data_in3 = c_data_in[C_DATA_WIDTH*4-1    : C_DATA_WIDTH*3];

    assign weight_idx_in0 = weight_idx_in[31:0];
    assign weight_idx_in1 = weight_idx_in[63:32];
    assign weight_idx_in2 = weight_idx_in[95:64];
    assign weight_idx_in3 = weight_idx_in[127:96];

    assign idle_out = &idle;
    assign fetch_out = &fetch;
    assign compute_out = &compute;
    assign write_back_out = &write_back;
    
    assign result_out = {result_out3, result_out2, result_out1, result_out0};

    spOctet#(
        .A_DATA_WIDTH    (A_DATA_WIDTH ),
        .A_BUFFER_SIZE   (A_BUFFER_SIZE),
        .A_BUFFER_DEPTH  (A_BUFFER_DEPTH),
        .A_ADDR_WIDTH    (A_ADDR_WIDTH),
        .B_DATA_WIDTH    (B_DATA_WIDTH ),
        .B_BUFFER_SIZE   (B_BUFFER_SIZE),
        .B_BUFFER_DEPTH  (B_BUFFER_DEPTH),
        .B_ADDR_WIDTH    (B_ADDR_WIDTH),
        .C_DATA_WIDTH    (C_DATA_WIDTH ),
        .C_BUFFER_SIZE   (C_BUFFER_SIZE),
        .C_BUFFER_DEPTH  (C_BUFFER_DEPTH),
        .C_ADDR_WIDTH    (C_ADDR_WIDTH)
    )spOctet0(
        .clk        (clk),
        .rstn        (rstn),
        .start      (start),
        .fetch_done (fetch_done),
        .a_data_in  (a_data_in0),
        .b_data_in  (b_data_in0),
        .weight_idx_in(weight_idx_in0),
        .c_data_in  (c_data_in0),
        .idle       (idle[0]),
        .fetch      (fetch[0]),
        .compute    (compute[0]),
        .write_back (write_back[0]),
        .result_out (result_out0)
    );

    spOctet#(
        .A_DATA_WIDTH    (A_DATA_WIDTH ),
        .A_BUFFER_SIZE   (A_BUFFER_SIZE),
        .A_BUFFER_DEPTH  (A_BUFFER_DEPTH),
        .A_ADDR_WIDTH    (A_ADDR_WIDTH),
        .B_DATA_WIDTH    (B_DATA_WIDTH ),
        .B_BUFFER_SIZE   (B_BUFFER_SIZE),
        .B_BUFFER_DEPTH  (B_BUFFER_DEPTH),
        .B_ADDR_WIDTH    (B_ADDR_WIDTH),
        .C_DATA_WIDTH    (C_DATA_WIDTH ),
        .C_BUFFER_SIZE   (C_BUFFER_SIZE),
        .C_BUFFER_DEPTH  (C_BUFFER_DEPTH),
        .C_ADDR_WIDTH    (C_ADDR_WIDTH)
    )spOctet1(
        .clk        (clk),
        .rstn        (rstn),
        .start      (start),
        .fetch_done (fetch_done),
        .a_data_in  (a_data_in1),
        .b_data_in  (b_data_in1),
        .weight_idx_in(weight_idx_in1),
        .c_data_in  (c_data_in1),
        .idle       (idle[1]),
        .fetch      (fetch[1]),
        .compute    (compute[1]),
        .write_back (write_back[1]),
        .result_out (result_out1)
    );

    spOctet#(
        .A_DATA_WIDTH    (A_DATA_WIDTH ),
        .A_BUFFER_SIZE   (A_BUFFER_SIZE),
        .A_BUFFER_DEPTH  (A_BUFFER_DEPTH),
        .A_ADDR_WIDTH    (A_ADDR_WIDTH),
        .B_DATA_WIDTH    (B_DATA_WIDTH ),
        .B_BUFFER_SIZE   (B_BUFFER_SIZE),
        .B_BUFFER_DEPTH  (B_BUFFER_DEPTH),
        .B_ADDR_WIDTH    (B_ADDR_WIDTH),
        .C_DATA_WIDTH    (C_DATA_WIDTH ),
        .C_BUFFER_SIZE   (C_BUFFER_SIZE),
        .C_BUFFER_DEPTH  (C_BUFFER_DEPTH),
        .C_ADDR_WIDTH    (C_ADDR_WIDTH)
    )spOctet2(
        .clk        (clk),
        .rstn        (rstn),
        .start      (start),
        .fetch_done (fetch_done),
        .a_data_in  (a_data_in2),
        .b_data_in  (b_data_in2),
        .weight_idx_in(weight_idx_in2),
        .c_data_in  (c_data_in2),
        .idle       (idle[2]),
        .fetch      (fetch[2]),
        .compute    (compute[2]),
        .write_back (write_back[2]),
        .result_out (result_out2)
    );

    spOctet#(
        .A_DATA_WIDTH    (A_DATA_WIDTH ),
        .A_BUFFER_SIZE   (A_BUFFER_SIZE),
        .A_BUFFER_DEPTH  (A_BUFFER_DEPTH),
        .A_ADDR_WIDTH    (A_ADDR_WIDTH),
        .B_DATA_WIDTH    (B_DATA_WIDTH ),
        .B_BUFFER_SIZE   (B_BUFFER_SIZE),
        .B_BUFFER_DEPTH  (B_BUFFER_DEPTH),
        .B_ADDR_WIDTH    (B_ADDR_WIDTH),
        .C_DATA_WIDTH    (C_DATA_WIDTH ),
        .C_BUFFER_SIZE   (C_BUFFER_SIZE),
        .C_BUFFER_DEPTH  (C_BUFFER_DEPTH),
        .C_ADDR_WIDTH    (C_ADDR_WIDTH)
    )spOctet3(
        .clk        (clk),
        .rstn        (rstn),
        .start      (start),
        .fetch_done (fetch_done),
        .a_data_in  (a_data_in3),
        .weight_idx_in(weight_idx_in3),
        .b_data_in  (b_data_in3),
        .c_data_in  (c_data_in3),
        .idle       (idle[3]),
        .fetch      (fetch[3]),
        .compute    (compute[3]),
        .write_back (write_back[3]),
        .result_out (result_out3)
    );

endmodule
