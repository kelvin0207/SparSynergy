`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/03 20:27:26
// Design Name: 
// Module Name: Octet_controller
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


module Octet_controller #(
    parameter A_ADDR_WIDTH = 1,
    parameter B_ADDR_WIDTH = 2,
    parameter C_ADDR_WIDTH = 3
)(
    input  wire          clk,          // 时钟信号
    input  wire          rstn,          // 复位信号，低电平有效
    // TC提供的信号
    input  wire          start,
    input  wire          fetch_done,
    // buffer提供的信号
    input  wire          buffer_ready, // a/b/c buffer 是否准备好
    // 输出给TC控制器
    output reg           idle,      // 告诉上一级控制器状态
    output reg           fetch,
    output reg           compute,
    output reg           write_back,
    // 输出给Octet内部
    output reg                      a_wr_en,
    output reg                      a_rd_en,
    output reg [A_ADDR_WIDTH-1:0]   a_rd_addr,
    output reg [A_ADDR_WIDTH-1:0]   a_wr_addr,
    output reg                      b_wr_en,
    output reg                      b_rd_en,
    output reg [B_ADDR_WIDTH-1:0]   b_rd_addr,
    output reg [B_ADDR_WIDTH-1:0]   b_wr_addr,
    output reg                      c_wr_en,
    output reg                      c_rd_en,
    output reg [C_ADDR_WIDTH-1:0]   c_rd_addr,
    output reg [C_ADDR_WIDTH-1:0]   c_wr_addr
);

    localparam   IDLE        = 2'b00; // 空闲状态
    localparam   FETCH_DATA  = 2'b01; // 数据获取状态
    localparam   COMPUTE     = 2'b10; // 计算状态
    localparam   WRITE_BACK  = 2'b11; // 写回状态

    reg [1:0]   current_state;
    reg [1:0]   next_state;

    reg [4:0]   counter;
    wire [2:0]  step_cnt;
    wire [1:0]  set_cnt;
    wire        compute_done;

    // 地址生成逻辑，根据set和step状态决定；
    assign compute_done = (counter == 5'b1_1111);
    assign step_cnt = counter[2:0];
    assign set_cnt = counter[4:3];

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            counter <= 0;
        end else if (current_state==IDLE) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    // 下一状态逻辑
    always @(*) begin
        // default assignment
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (start) next_state = FETCH_DATA;
            end

            FETCH_DATA: begin
                if (fetch_done & buffer_ready) next_state = COMPUTE;
            end

            COMPUTE: begin
                if (compute_done) next_state = WRITE_BACK;
            end

            WRITE_BACK: begin
                next_state = IDLE;
            end
        endcase
    end

    // 更新逻辑
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    //输出逻辑
    always@(*) begin
        case (current_state) 
            IDLE: begin
                a_wr_en     = 0;
                a_rd_en     = 0;
                a_rd_addr   = 0;
                a_wr_addr   = 0;
                b_wr_en     = 0;
                b_rd_en     = 0;
                b_rd_addr   = 0;
                b_wr_addr   = 0;
                c_wr_en     = 0;
                c_rd_en     = 0;
                c_rd_addr   = 0;
                c_wr_addr   = 0;
                idle        = 1;
                fetch       = 0;
                compute     = 0;
                write_back  = 0;
            end

            FETCH_DATA: begin
                a_wr_en     = 1;
                a_rd_en     = 0;
                a_rd_addr   = 0;
                a_wr_addr   = step_cnt[0];
                b_wr_en     = 1;
                b_rd_en     = 0;
                b_rd_addr   = 0;
                b_wr_addr   = step_cnt[1:0];
                c_wr_en     = 1;
                c_rd_en     = 0;
                c_rd_addr   = 0;
                c_wr_addr   = step_cnt[2:0];
                idle        = 0;
                fetch       = 1;
                compute     = 0;
                write_back  = 0;
            end

            COMPUTE: begin
                a_wr_en     = 0;
                a_rd_en     = 1;
                a_rd_addr   = step_cnt[1];
                a_wr_addr   = 0;
                b_wr_en     = 0;
                b_rd_en     = 1;
                b_rd_addr   = {step_cnt[2], step_cnt[0]};
                b_wr_addr   = 0;
                c_wr_en     = 1;
                c_rd_en     = 1;
                c_rd_addr   = step_cnt;
                c_wr_addr   = step_cnt - 1;
                idle        = 0;
                fetch       = 0;
                compute     = 1;
                write_back  = 0;
            end

            WRITE_BACK: begin
                a_wr_en     = 0;
                a_rd_en     = 0;
                a_rd_addr   = 0;
                a_wr_addr   = 0;
                b_wr_en     = 0;
                b_rd_en     = 0;
                b_rd_addr   = 0;
                b_wr_addr   = 0;
                c_wr_en     = 0;
                c_rd_en     = 1;
                c_rd_addr   = counter;
                c_wr_addr   = 0;
                idle        = 0;
                fetch       = 0;
                compute     = 0;
                write_back  = 1;
            end

            default: begin
                a_wr_en     = 0;
                a_rd_en     = 0;
                a_rd_addr   = 0;
                a_wr_addr   = 0;
                b_wr_en     = 0;
                b_rd_en     = 0;
                b_rd_addr   = 0;
                b_wr_addr   = 0;
                c_wr_en     = 0;
                c_rd_en     = 0;
                c_rd_addr   = 0;
                c_wr_addr   = 0;
                idle        = 0;
                fetch       = 0;
                compute     = 0;
                write_back  = 0;
            end
        endcase
    end

endmodule
