`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/06 09:57:05
// Design Name: 
// Module Name: mux4to2
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


module mux4to2(
	input wire [7:0] in0,    // 输入 activation 0
    input wire [7:0] in1,    // 输入 activation 1
    input wire [7:0] in2,    // 输入 activation 2
    input wire [7:0] in3,    // 输入 activation 3
    input wire [3:0] sel,    // 选择信号
	output wire [7:0] out0, // 输出 activation
	output wire [7:0] out1
    );

	mux4to1 mux0(
    	.in0	(in0),    // 输入 activation 0
    	.in1	(in1),    // 输入 activation 1
    	.in2	(in2),    // 输入 activation 2
    	.in3	(in3),    // 输入 activation 3
    	.sel	(sel[1:0]),    // 选择信号
    	.out	(out0)  // 输出 activation
	);

	mux4to1 mux1(
    	.in0	(in0),    // 输入 activation 0
    	.in1	(in1),    // 输入 activation 1
    	.in2	(in2),    // 输入 activation 2
    	.in3	(in3),    // 输入 activation 3
    	.sel	(sel[3:2]),    // 选择信号
    	.out	(out1)  // 输出 activation
	);

endmodule
