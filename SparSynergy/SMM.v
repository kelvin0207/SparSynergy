`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yang Jingkui
// 
// Create Date: 2024/08/27 12:15:18
// Design Name: Sign-magnitude bit-serial multiplier
// Module Name: SMM
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


module SMM(
    input   wire    [7:0]   act,
    input   wire            weight_bit,
    input   wire            weight_sign,
    output  wire    [7:0]   product
    );

    wire [7:0]  act_minus;
    wire [7:0]  act_s;

    assign act_minus = ~act + 7'b1;
    // if weight sign==1, act need to multiply -1, else keep original value
    // the output is a signed int 8
    assign act_s = weight_sign? act_minus : act;

    assign product = weight_bit? act_s : 0;

endmodule
