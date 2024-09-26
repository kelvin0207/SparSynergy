`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/06 10:16:59
// Design Name: 
// Module Name: mux8to4
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


module mux8to4(
    input   wire [63:0]     activation_group,
    input   wire [7:0]      sel,
    output  wire [31:0]     out
);

    wire [7:0] out0;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;

    mux4to2 mux0(
	    .in0    (activation_group[7:0]),     
        .in1    (activation_group[15:8]),    
        .in2    (activation_group[23:16]),   
        .in3    (activation_group[31:24]),   
        .sel    (sel[3:0]),                  
	    .out0   (out0),    //  
	    .out1   (out1)
    );

    mux4to2 mux1(
	    .in0    (activation_group[39:32]),    // 
        .in1    (activation_group[47:40]),    // 
        .in2    (activation_group[55:48]),    // 
        .in3    (activation_group[63:56]),    // 
        .sel    (sel[7:4]),                 //  
	    .out0   (out2),    //  
	    .out1   (out3)
    );

    assign out = {out0, out1, out2, out3};
endmodule
