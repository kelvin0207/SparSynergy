`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/02 10:55:12
// Design Name: 
// Module Name: Dispatcher
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


module Dispatcher(
    input wire          clk,
    input wire          rstn,
    input wire [1:0]    a_mode,         // 控制器配置激活分发模式
    input wire [1:0]    w_mode,         // 控制器配置权重分发模式
    input wire [5:0]    w_read_address,    // 选择要读取的片上缓冲区
    input wire [5:0]    a_read_address,    // 要读取的地址
    input wire          en,               // 开始读取信号
    input wire [5:0]    w_write_address,
    input wire [5:0]    a_write_address,
    input wire          wen,            
    input wire [1023:0] w_in,
    input wire [1023:0] a_in,          // 权重和激活(部分和结果）的输入
    output reg [1023:0] activations,  // 分发到每行 PE 的激活数据
    output reg          activation_valid,          // 激活信号有效
    output reg [1023:0] weight_columns,
    output reg          weight_valid,
    output reg          empty,
    output reg          index_en,
    output reg          done                       // 分发完成信号
);

    reg [1023:0] w_buffer [0:1];   // 假设每个缓冲区有64个1024位的数据
    reg [1023:0] a_buffer [0:1];
    integer i;
    
    reg [1023:0] w_in_buffer;           // 来自 data buffer 的数据
    reg [1023:0] a_in_buffer;           // 来自 data buffer 的数据
    reg          data_valid;
    reg [1:0]    a_mode_reg;
    reg [1:0]    w_mode_reg;
    reg          update_index;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            w_in_buffer <= 1024'b0;
            a_in_buffer <= 1024'b0;
            data_valid  <= 1'b0;
            a_mode_reg  <= 2'b0;
            w_mode_reg  <= 2'b0;
            empty       <= 1;
            index_en    <= 0;
            update_index <= 0;
            for (i = 0; i < 2; i = i + 1) begin
                w_buffer[i] <= 1024'b0;
                a_buffer[i] <= 1024'b0;
            end
        end else begin
            if (wen) begin
                w_buffer[w_write_address] <= w_in;
                a_buffer[a_write_address] <= a_in;
                data_valid  <= 1'b0;
                empty <= 0;
                update_index <= 1;
            end else if (en) begin
                w_in_buffer <= w_buffer[w_read_address];
                a_in_buffer <= a_buffer[a_read_address];
                data_valid  <= 1'b1;
                a_mode_reg  <= a_mode;
                w_mode_reg  <= w_mode;
            end else if (update_index) begin
                index_en <= 1;
                update_index <= 0;
            end else begin
                data_valid  <= 1'b0;
            end
        end
    end

    // always @(posedge clk or negedge rstn) begin
    //     if (!rstn) begin
    //         w_in_buffer <= 1024'b0;
    //         a_in_buffer <= 1024'b0;
    //         data_valid  <= 1'b0;
    //         a_mode_reg  <= 2'b0;
    //         w_mode_reg  <= 2'b0;
    //         empty       <= 1;
    //         index_en    <= 0;
    //         update_index <= 0;
    //     end else if (wen) begin
    //         w_buffer[w_write_address]<= w_in;
    //         a_buffer[a_write_address]<= a_in;
    //         data_valid  <= 1'b0;
    //         empty <= 0;
    //         update_index <= 1;
    //     end else if (en) begin
    //         w_in_buffer <= w_buffer[w_read_address];
    //         a_in_buffer <= a_buffer[a_read_address];
    //         data_valid  <= 1'b1;
    //         a_mode_reg  <= a_mode;
    //         w_mode_reg  <= w_mode;
    //     end else if(update_index) begin
    //         index_en <= 1;
    //         update_index <= 0;
    //     end else begin
    //         data_valid  <= 1'b0;
    //     end
    // end
    
// a_mode说明：BitWave中激活水平方向广播，有两级一共4*4组，每组8个数
// 所以带宽最大为 4*4*8act * 8bit / cycle = 1024 bit/cycle
// 两级分组（成为PE内和PE间），根据是否共享可分为
// 00: 均不共享，每周期需要1024bit
// 01: PE内共享，每周期需要256bit
// 10: PE间共享，每周期需要256bit
// 11: 均共享，每周期需要64bit

// w_mode说明：同理，BitWave中权重沿着垂直方向广播，两级一共32*4组，每组8bit
// 所以最大带宽为 32*4*8 bit/cycle = 1024bit/cycle.
// 根据PE内和PE间是否共享，通向分为四种，与a_mode相同

    reg [1023:0]   activations_t;
    reg [1023:0]   weight_columns_t;

    always@(*) begin
        case (a_mode_reg)
            2'b00: activations_t = a_in_buffer;
            2'b01: activations_t = {{4{a_in_buffer[255:192]}}, {4{a_in_buffer[191:128]}}, {4{a_in_buffer[127:64]}}, {4{a_in_buffer[63:0]}}};
            2'b10: activations_t = {4{a_in_buffer[255:0]}};
            2'b11: activations_t = {16{a_in_buffer[63:0]}};
        endcase

        case (w_mode_reg)
            2'b00: weight_columns_t = w_in_buffer;
            2'b01: weight_columns_t = {{4{w_in_buffer[255:192]}}, {4{w_in_buffer[191:128]}}, {4{w_in_buffer[127:64]}}, {4{w_in_buffer[63:0]}}};
            2'b10: weight_columns_t = {4{w_in_buffer[255:0]}};
            2'b11: weight_columns_t = {16{w_in_buffer[63:0]}};
        endcase
    end

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            activations         <= 0;
            activation_valid    <= 0;
            weight_columns      <= 0;
            weight_valid        <= 0;
            done                <= 0;
        end
        else begin
            activations         <= activations_t;
            activation_valid    <= data_valid;
            weight_columns      <= weight_columns_t;
            weight_valid        <= data_valid;
            done                <= data_valid;
        end
    end

endmodule
