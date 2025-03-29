//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yang Jingkui
// 
// Create Date: 2024/08/27 09:39:16
// Design Name: Top Controller
// Module Name: Controller
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

module BCE (
    input wire clk,
    input wire rstn,
    input wire [63:0] activations,       // 8 * 8-bit activation inputs
    input wire [7:0]  weight_column,     // 8-bit weight bit column (1-bit column replicated)
    input wire 		  weight_sign_en,       // Sign bit for the weight column signal, data using weight_col
    // input wire [31:0] index_vector,      // idx of bitlevel
	input wire [2:0]  shift_offset,		 // 3bit shift
	input wire 	  done,
	output reg 	  valid,
    output reg [15:0] result            // 16-bit accumulated result
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

	// wire [2:0] shift_offset;

    // ZCIP ZCIP(
    //     .clk            (clk),
    //     .rstn            (rstn),
    //     .index_vector   (index_vector),
    //     .shift_offset   (shift_offset),
    //     .valid          (valid),
    //     .done           (done),
    // );

	reg [7:0] 	weight_sign;
	reg [63:0]	activations_reg;
	reg [7:0] 	weight_column_reg;
	reg [2:0] 	shift_offset_reg;

	reg         valid_tmp;
	reg         done_reg;
	
	always@(posedge clk or negedge rstn) begin
		if (!rstn) begin
			weight_sign			<= 0;
			activations_reg		<= 0;
			weight_column_reg	<= 0;
			shift_offset_reg	<= 0;
			valid_tmp           <= 0;
			done_reg			<= 0;
		end
		else if(weight_sign_en)begin
			weight_sign		<= weight_column;
		end
		else begin
			activations_reg		<= activations;
			weight_column_reg	<= weight_column;
			shift_offset_reg	<= shift_offset;
			valid_tmp           <= 1;
			done_reg			<= done;
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
		.weight_sign(weight_sign[0]),
		.product	(product0)
	);

	SMM SMM1(
		.act		(act1),
		.weight_bit	(weight_column_reg[1]),
		.weight_sign(weight_sign[1]),
		.product	(product1)
	);

	SMM SMM2(
		.act		(act2),
		.weight_bit	(weight_column_reg[2]),
		.weight_sign(weight_sign[2]),
		.product	(product2)
	);

	SMM SMM3(
		.act		(act3),
		.weight_bit	(weight_column_reg[3]),
		.weight_sign(weight_sign[3]),
		.product	(product3)
	);

	SMM SMM4(
		.act		(act4),
		.weight_bit	(weight_column_reg[4]),
		.weight_sign(weight_sign[4]),
		.product	(product4)
	);

	SMM SMM5(
		.act		(act5),
		.weight_bit	(weight_column_reg[5]),
		.weight_sign(weight_sign[5]),
		.product	(product5)
	);

	SMM SMM6(
		.act		(act6),
		.weight_bit	(weight_column_reg[6]),
		.weight_sign(weight_sign[6]),
		.product	(product6)
	);

	SMM SMM7(
		.act		(act7),
		.weight_bit	(weight_column_reg[7]),
		.weight_sign(weight_sign[7]),
		.product	(product7)
	);

	reg [7:0] product0_reg;
	reg [7:0] product1_reg;
	reg [7:0] product2_reg;
	reg [7:0] product3_reg;
	reg [7:0] product4_reg;
	reg [7:0] product5_reg;
	reg [7:0] product6_reg;
	reg [7:0] product7_reg;
	reg       valid_tmp2;
	reg		  done_reg2;

	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			product0_reg	<= 0;
			product1_reg	<= 0;
			product2_reg	<= 0;
			product3_reg	<= 0;
			product4_reg	<= 0;
			product5_reg	<= 0;
			product6_reg	<= 0;
			product7_reg	<= 0;
			valid_tmp2      <= 0;
			done_reg2		<= 0;
		end else begin
		  	product0_reg	<= product0;
			product1_reg	<= product1;
			product2_reg	<= product2;
			product3_reg	<= product3;
			product4_reg	<= product4;
			product5_reg	<= product5;
			product6_reg	<= product6;
			product7_reg	<= product7;
			valid_tmp2		<= valid_tmp;
			done_reg2		<= done_reg;
		end
	end

	wire	[10:0] psum_total;

	psum psum(
    	.product0	(product0_reg),
		.product1	(product1_reg),
		.product2	(product2_reg),
		.product3	(product3_reg),
    	.product4	(product4_reg),
		.product5	(product5_reg),
		.product6	(product6_reg),
		.product7	(product7_reg),
    	.psum_total	(psum_total)
	);

	// wire	[8:0] psum0;
	// wire	[8:0] psum1;
	// wire	[8:0] psum2;
	// wire	[8:0] psum3;

	// assign psum0 = {product0[7], product0} + {product1[7], product1};
	// assign psum1 = {product2[7], product2} + {product3[7], product3};
	// assign psum2 = {product4[7], product4} + {product5[7], product5};
	// assign psum3 = {product6[7], product6} + {product7[7], product7};

	// wire	[9:0] psum4;
	// wire	[9:0] psum5;

	// assign psum4 = {psum0[8], psum0} + {psum1[8], psum1};
	// assign psum5 = {psum2[8], psum2} + {psum3[8], psum3};

	// wire	[10:0] psum_total;

	// assign psum_total = {psum4[9], psum4} + {psum5[9], psum5};

	wire	[15:0]	psum_shift;
	// Area cost ~ 10
	assign psum_shift = psum_total << shift_offset_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            result <= 16'b0;
			valid  <= 0;
        end else begin
			valid  <= valid_tmp2;
            if (valid_tmp2) begin
                result <= result + psum_shift;
            end else if (done_reg2) begin
				result <= 0;
			end
        end
    end

endmodule
