`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/02 10:49:26
// Design Name: 
// Module Name: ZCIP_array
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


module ZCIP_array(
    input wire clk,
    input wire rstn,
    input wire [895:0] index_vector,  // 每个ZCIP模块都有一个独立的index_vector输入，一共32 * 7bit
    output wire [383:0] shift_offset, // 每个ZCIP模块产生一个shift_offset输出，一共32 *3bit
    output wire [127:0]  valid,              // 每个ZCIP模块都有一个valid输出
    output wire [127:0]  done                // 每个ZCIP模块都有一个done输出
);

genvar i;
generate
    for (i = 0; i < 128; i = i + 1) begin : zcip_gen
        ZCIP zcip_inst (
            .clk          (clk),
            .rstn          (rstn),
            .index_vector (index_vector[i*7+6 : i*7]),  // 将对应的index_vector输入连接到ZCIP模块
            .shift_offset (shift_offset[i*3+2 : i*3]),  // 将ZCIP的shift_offset输出连接到数组中
            .valid        (valid[i]),         // 将ZCIP的valid输出连接到数组中
            .done         (done[i])           // 将ZCIP的done输出连接到数组中
        );
    end
endgenerate

endmodule

