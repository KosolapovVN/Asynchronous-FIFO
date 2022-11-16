// Generate Empty flag and Read pointer in Grey Code
module RD_Ptr_Empty

	// Parameters
	#(parameter DEPTH = 8)
	
	(
	input i_RD_clk, i_RD_rst_n,
	input i_RD_En,
	input [DEPTH:0] i_Sync_WR_Ptr,
	output reg [DEPTH:0] o_RD_Ptr,
	output [DEPTH-1:0] o_RD_Addr,
	output reg o_Empty
	);

	reg [DEPTH:0] r_RD_Bin_Count;
	wire [DEPTH:0] w_RD_Bin_Next;
	wire [DEPTH:0] w_RD_Grey_Next;

	always @(posedge i_RD_clk or negedge i_RD_rst_n)
	begin
		if (!i_RD_rst_n)
		begin
			o_RD_Ptr <= 0;
			r_RD_Bin_Count <= 0;
		end
		else
		begin
			o_RD_Ptr <= w_RD_Grey_Next;
			r_RD_Bin_Count <= w_RD_Bin_Next;
		end
	end

	assign o_RD_Addr = r_RD_Bin_Count[DEPTH-1:0];
	assign w_RD_Bin_Next = r_RD_Bin_Count + (i_RD_En & ~o_Empty);
	assign w_RD_Grey_Next = (w_RD_Bin_Next>>1) ^ w_RD_Bin_Next;			// Grey Code from Bin Code

// FIFO empty when the next Read pointer equal synchronized Write pointer or on reset

 	always @(posedge i_RD_clk or negedge i_RD_rst_n)
	begin
		if (!i_RD_rst_n)
			o_Empty <= 1'b1;
		else
			o_Empty <= (w_RD_Grey_Next == i_Sync_WR_Ptr);
	end	

endmodule
