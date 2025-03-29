`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/02 15:42:06
// Design Name: 
// Module Name: BitWave
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


module BitWave_top(
    input wire              clk,
    input wire              rstn,
    input wire              wen,
    input wire  [1023:0]    w_in,
    input wire  [1023:0]    a_in, // psum used a_in as well
    output reg             sram_en,
    output reg [15:0]      sram_w_read_address,
    output reg [15:0]      sram_a_read_address,
    output reg [15:0]      sram_write_address,
    output reg [8191:0]    sram_result
    // output wire [1:0] status
);
    
    reg              wen_reg;
    reg  [1023:0]    w_in_reg;
    reg  [1023:0]    a_in_reg;

    wire             sram_en_t;
    wire [15:0]      sram_w_read_address_t;
    wire [15:0]      sram_a_read_address_t;
    wire [15:0]      sram_write_address_t;
    wire [8191:0]    sram_result_t;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            wen_reg     <= 0;
            w_in_reg    <= 0;
            a_in_reg    <= 0;
        end else begin
            wen_reg     <= wen;
            w_in_reg    <= w_in;
            a_in_reg    <= a_in;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sram_en             <= 0;
            sram_w_read_address <= 0;
            sram_a_read_address <= 0;
            sram_write_address  <= 0;
            sram_result         <= 0;
        end else begin
            sram_en             <= sram_en_t;
            sram_w_read_address <= sram_w_read_address_t;
            sram_a_read_address <= sram_a_read_address_t;
            sram_write_address  <= sram_write_address_t;
            sram_result         <= sram_result_t;
        end
    end

    wire [895:0]    index_vector; // 输入的 index_vector，用于 ZCIP_array
    wire [1:0]      acc_en;              // 用于 PE_array 的 accumulator enable

    // 控制器信号
    wire [1:0]  a_mode;
    wire [1:0]  w_mode;
    wire [5:0]  w_read_address;
    wire [5:0]  a_read_address;
    // wire        en;
    wire        dispatcher_done;
    // wire [1023:0] activation;
    wire        activation_valid;
    // wire [1023:0] weight_columns;
    wire weight_valid;
    wire weight_sign_en;

    wire [5:0]    w_write_address;
    wire [5:0]    a_write_address;

    // ZCIP_array 输出信号
    wire [383:0]     shift_offset;
    wire [127:0]     valid;
    wire [127:0]     zcip_done;

    // PE_array 输出信号
    // wire [8191:0] 	result;
    // wire [255:0] 	status;
    wire [127:0]    pe_done;

    // Dispatcher 输出信号
    wire [1023:0] activations_out;
    wire [1023:0] weight_columns_out;
    wire          empty;
    // wire [223:0]  index_vector_buffer;
    wire          index_en;


    // 实例化 ZCIP_array
    ZCIP_array zcip_array_inst (
        .clk(clk),
        .rstn(rstn),
        .index_vector(index_vector),
        .shift_offset(shift_offset),
        .valid(valid),
        .done(zcip_done)
    );

    // 实例化 Dispatcher
    Dispatcher dispatcher_inst (
        .clk(clk),
        .rstn(rstn),
        .a_mode(a_mode),
        .w_mode(w_mode),
        .w_read_address(w_read_address),
        .a_read_address(a_read_address),
        .en(en),
        .w_write_address(w_write_address),
        .a_write_address(a_write_address),
        .wen(wen_reg),
        .w_in(w_in_reg),
        .a_in(a_in_reg),
        .activations(activations_out),
        .activation_valid(activation_valid),
        .weight_columns(weight_columns_out),
        .weight_valid(weight_valid),
        .empty(empty),
        .index_en(index_en),
        .done(dispatcher_done)
    );

    // 将 Dispatcher 的输出分配给 PE_array 的输入
    // assign activations[0] = activations_out[255:0];
    // assign activations[1] = activations_out[511:256];
    // assign activations[2] = activations_out[767:512];
    // assign activations[3] = activations_out[1023:768];

    // assign weight_columns[0] = weight_columns_out[31:0];
    // assign weight_columns[1] = weight_columns_out[63:32];
    // assign weight_columns[2] = weight_columns_out[95:64];
    // assign weight_columns[3] = weight_columns_out[127:96];
    // assign weight_columns[4] = weight_columns_out[159:128];
    // assign weight_columns[5] = weight_columns_out[191:160];
    // assign weight_columns[6] = weight_columns_out[223:192];
    // assign weight_columns[7] = weight_columns_out[255:224];
    // assign weight_columns[8]  = weight_columns_out[287:256];
    // assign weight_columns[9]  = weight_columns_out[319:288];
    // assign weight_columns[10] = weight_columns_out[351:320];
    // assign weight_columns[11] = weight_columns_out[383:352];
    // assign weight_columns[12] = weight_columns_out[415:384];
    // assign weight_columns[13] = weight_columns_out[447:416];
    // assign weight_columns[14] = weight_columns_out[479:448];
    // assign weight_columns[15] = weight_columns_out[511:480];
    // assign weight_columns[16] = weight_columns_out[543:512];
    // assign weight_columns[17] = weight_columns_out[575:544];
    // assign weight_columns[18] = weight_columns_out[607:576];
    // assign weight_columns[19] = weight_columns_out[639:608];
    // assign weight_columns[20] = weight_columns_out[671:640];
    // assign weight_columns[21] = weight_columns_out[703:672];
    // assign weight_columns[22] = weight_columns_out[735:704];
    // assign weight_columns[23] = weight_columns_out[767:736];
    // assign weight_columns[24] = weight_columns_out[799:768];
    // assign weight_columns[25] = weight_columns_out[831:800];
    // assign weight_columns[26] = weight_columns_out[863:832];
    // assign weight_columns[27] = weight_columns_out[895:864];
    // assign weight_columns[28] = weight_columns_out[927:896];
    // assign weight_columns[29] = weight_columns_out[959:928];
    // assign weight_columns[30] = weight_columns_out[991:960];
    // assign weight_columns[31] = weight_columns_out[1023:992];

    // 实例化 PE_array
    PE_array pe_array_inst (
        .clk(clk),
        .rstn(rstn),
        .activations(activations_out),
        .activation_valid(activation_valid),
        .weight_column(weight_columns_out),
        .weight_sign_en (weight_sign_en),       // 假设 weight_sign 与 weight_column 相同
        .weight_valid(weight_valid),
        .shift_offset(shift_offset),
        .acc_en(acc_en),
        .zcip_done(zcip_done),
        .result(sram_result_t),
        // .status(status),
        .done(pe_done)
    );

    // 实例化 Controller
    Controller controller_inst (
        .clk(clk),
        .rstn(rstn),
        .dispatcher_done(dispatcher_done),
        .pe_done(&pe_done),
        .zcip_done(&zcip_done),
        .empty(empty),
        .index_vector_buffer(weight_columns_out[895:0]),
        .index_en(index_en),
        .a_mode(a_mode),
        .w_mode(w_mode),
        .w_read_address(w_read_address),
        .a_read_address(a_read_address),
        .en(en),
        .acc_en(acc_en),
        .index_vector(index_vector),
        .weight_sign_en(weight_sign_en),
        .w_write_address(w_write_address),
        .a_write_address(a_write_address),
        .sram_w_read_address(sram_w_read_address_t),
        .sram_a_read_address(sram_a_read_address_t),
        .sram_write_address(sram_write_address_t),
        .sram_en(sram_en_t),
        .done(done)
    );

endmodule

