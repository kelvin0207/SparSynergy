`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/07 16:08:27
// Design Name: 
// Module Name: mux16to4
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


module mux16to4(
    input wire [127:0]  in, // 4*4*8b = 128b
    input wire [3:0]    sel_level0,
    input wire [7:0]    sel_level1,
    output wire [31:0]  out // 4*8b
    );

    wire [31:0] in0_level0;
    wire [31:0] in1_level0;
    wire [31:0] in2_level0;
    wire [31:0] in3_level0;

    assign in0_level0 = in[31:0];
    assign in1_level0 = in[63:32];
    assign in2_level0 = in[95:64];
    assign in3_level0 = in[127:96];

    // level 0 selection
    reg [31:0] in0_level1;
    reg [31:0] in1_level1;

    always@(*) begin
        case(sel_level0[1:0])
            2'b00: in0_level1 = in0_level0;
            2'b01: in0_level1 = in1_level0;
            2'b10: in0_level1 = in2_level0;
            2'b11: in0_level1 = in3_level0;
        endcase
    end

    always@(*) begin
        case(sel_level0[3:2])
            2'b00: in1_level1 = in0_level0;
            2'b01: in1_level1 = in1_level0;
            2'b10: in1_level1 = in2_level0;
            2'b11: in1_level1 = in3_level0;
        endcase
    end

    wire [7:0] out0;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;

    mux4to2 mux0(
	    .in0    (in0_level1[7:0]),
        .in1    (in0_level1[15:8]),
        .in2    (in0_level1[23:16]),
        .in3    (in0_level1[31:24]),
        .sel    (sel_level1[3:0]),
	    .out0   (out0),
	    .out1   (out1)
    );

    mux4to2 mux1(
	    .in0    (in1_level1[7:0]),
        .in1    (in1_level1[15:8]),
        .in2    (in1_level1[23:16]),
        .in3    (in1_level1[31:24]),
        .sel    (sel_level1[7:4]),
	    .out0   (out2),
	    .out1   (out3)
    );

    assign out = {out3, out2, out1, out0};

endmodule
