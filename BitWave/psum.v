module psum(
    input   wire [7:0]  product0,
	input   wire [7:0]  product1,
	input   wire [7:0]  product2,
	input   wire [7:0]  product3,
    input   wire [7:0]  product4,
	input   wire [7:0]  product5,
	input   wire [7:0]  product6,
	input   wire [7:0]  product7,
    output  wire  [10:0] psum_total
);

    wire [8:0]  psum0;
    wire [8:0]  psum1;
    wire [8:0]  psum2;
    wire [8:0]  psum3;
    wire [9:0]  psum4;
    wire [9:0]  psum5;

	assign psum0 = {product0[7], product0} + {product1[7], product1};
	assign psum1 = {product2[7], product2} + {product3[7], product3};
	assign psum2 = {product4[7], product4} + {product5[7], product5};
	assign psum3 = {product6[7], product6} + {product7[7], product7};

	assign psum4 = {psum0[8], psum0} + {psum1[8], psum1};
	assign psum5 = {psum2[8], psum2} + {psum3[8], psum3};

	assign psum_total = {psum4[9], psum4} + {psum5[9], psum5};

endmodule
