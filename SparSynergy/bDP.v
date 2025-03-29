`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/07 08:47:20
// Design Name: 
// Module Name: bDP
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


module bDP(
	input wire 		  clk,
    input wire 		  rstn,
	input wire [63:0] activations,
	input wire [7:0]  weight_column,
	input wire [7:0]  weight_sign, 
	input wire [2:0]  shift_offset,
	output reg [15:0] result
);

	wire [7:0] partial_sum;              // Partial sum for the bit-column
    reg [15:0] aligned_sum;             // Aligned sum after shifting

	wire [7:0] act0;
	wire [7:0] act1;
	wire [7:0] act2;
	wire [7:0] act3;
	wire [7:0] act4;
	wire [7:0] act5;
	wire [7:0] act6;
	wire [7:0] act7;

	wire [7:0] product0;
	wire [7:0] product1;
	wire [7:0] product2;
	wire [7:0] product3;
	wire [7:0] product4;
	wire [7:0] product5;
	wire [7:0] product6;
	wire [7:0] product7;

	reg [7:0] 	weight_sign_reg;
	reg [63:0]	activations_reg;
	reg [7:0] 	weight_column_reg;
	reg [2:0] 	shift_offset_reg;

	always@(posedge clk or negedge rstn) begin
		if (!rstn) begin
			weight_sign_reg		<= 0;
			activations_reg		<= 0;
			weight_column_reg	<= 0;
			shift_offset_reg	<= 0;
		end
		else begin
			weight_sign_reg		<= weight_sign;
			activations_reg		<= activations;
			weight_column_reg	<= weight_column;
			shift_offset_reg	<= shift_offset;
		end
	end

	assign act0 = activations_reg[7:0];
	assign act1 = activations_reg[15:8];
	assign act2 = activations_reg[23:16];
	assign act3 = activations_reg[31:24];
	assign act4 = activations_reg[39:32];
	assign act5 = activations_reg[47:40];
	assign act6 = activations_reg[55:48];
	assign act7 = activations_reg[63:56];

	SMM SMM0(
		.act		(act0),
		.weight_bit	(weight_column_reg[0]),
		.weight_sign(weight_sign_reg[0]),
		.product	(product0)
	);

	SMM SMM1(
		.act		(act1),
		.weight_bit	(weight_column_reg[1]),
		.weight_sign(weight_sign_reg[1]),
		.product	(product1)
	);

	SMM SMM2(
		.act		(act2),
		.weight_bit	(weight_column_reg[2]),
		.weight_sign(weight_sign_reg[2]),
		.product	(product2)
	);

	SMM SMM3(
		.act		(act3),
		.weight_bit	(weight_column_reg[3]),
		.weight_sign(weight_sign_reg[3]),
		.product	(product3)
	);

	SMM SMM4(
		.act		(act4),
		.weight_bit	(weight_column_reg[4]),
		.weight_sign(weight_sign_reg[4]),
		.product	(product4)
	);

	SMM SMM5(
		.act		(act5),
		.weight_bit	(weight_column_reg[5]),
		.weight_sign(weight_sign_reg[5]),
		.product	(product5)
	);

	SMM SMM6(
		.act		(act6),
		.weight_bit	(weight_column_reg[6]),
		.weight_sign(weight_sign_reg[6]),
		.product	(product6)
	);

	SMM SMM7(
		.act		(act7),
		.weight_bit	(weight_column_reg[7]),
		.weight_sign(weight_sign_reg[7]),
		.product	(product7)
	);

	wire	[8:0] psum0;
	wire	[8:0] psum1;
	wire	[8:0] psum2;
	wire	[8:0] psum3;

	assign psum0 = {product0[7], product0} + {product1[7], product1};
	assign psum1 = {product2[7], product2} + {product3[7], product3};
	assign psum2 = {product4[7], product4} + {product5[7], product5};
	assign psum3 = {product6[7], product6} + {product7[7], product7};

	wire	[9:0] psum4;
	wire	[9:0] psum5;

	assign psum4 = {psum0[8], psum0} + {psum1[8], psum1};
	assign psum5 = {psum2[8], psum2} + {psum3[8], psum3};

	wire	[10:0] psum_total;
	wire    [15:0] psum_shift;

	assign psum_total = {psum4[9], psum4} + {psum5[9], psum5};
	assign psum_shift = psum_total << shift_offset_reg;

	always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            result <= 16'b0;
        end else begin
			result <= psum_shift;
		end
	end

endmodule
