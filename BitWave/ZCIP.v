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

module ZCIP (
    input wire clk,
    input wire rstn,
    input wire [6:0] index_vector,  // Index vector indicating non-zero bit columns
    output reg [2:0] shift_offset,  // Shift offset for the BCE module
    output reg valid,         // Indicates if the shift offset is valid
    output reg done                 // Indicates completion of processing all non-zero columns
);

    reg [6:0] index_reg;            // Register to store the index vector
    reg [2:0] bit_counter;       // Keeps track of processed bits
	reg [6:0] index_tmp;
	reg [2:0] offset_tmp;
	
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            index_reg <= 7'b0;
            bit_counter <= 3'b0;
        end
        else begin
            index_reg <= index_vector;
            bit_counter <= offset_tmp + 3'b1;
        end
    end

    always@(*) begin
		// Find the first non-zero bit using a case statement
		index_tmp = (index_reg >> bit_counter) << bit_counter;
        
        casez (index_tmp)
            7'b1??_????: offset_tmp = 3'd6;
            7'b01?_????: offset_tmp = 3'd5;
            7'b001_????: offset_tmp = 3'd4;
            7'b000_1???: offset_tmp = 3'd3;
            7'b000_01??: offset_tmp = 3'd2;
            7'b000_001?: offset_tmp = 3'd1;
            7'b000_0001: offset_tmp = 3'd0;
            default:     offset_tmp = 3'd7; // 若无1位，返回7
        endcase

	end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            valid       <= 1'b0;
            done        <= 1'b0;
			shift_offset <= 3'b0;
        end else begin
			valid   <= 1'b1;
			done    <= (offset_tmp == 3'd7)? 1 : 0; // if index_tmp == 000_0000, then done
			shift_offset <= offset_tmp;
        end
    end
endmodule

