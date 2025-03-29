`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/05 12:43:38
// Design Name: 
// Module Name: mux4to1
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

module mux4to1 (
    input [7:0] in0,    // 输入 activation 0
    input [7:0] in1,    // 输入 activation 1
    input [7:0] in2,    // 输入 activation 2
    input [7:0] in3,    // 输入 activation 3
    input [1:0] sel,    // 选择信号
    output reg [7:0] out  // 输出 activation
);

always @(*) begin
    case (sel)
        2'b00: out = in0;  // sel 为 00 时选择 in0
        2'b01: out = in1;  // sel 为 01 时选择 in1
        2'b10: out = in2;  // sel 为 10 时选择 in2
        2'b11: out = in3;  // sel 为 11 时选择 in3
        default: out = 8'b0;  // 默认输出为0
    endcase
end

endmodule