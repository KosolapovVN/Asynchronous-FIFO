// Generate Full flag and Write pointer in Grey Code
module WR_Ptr_Full

	// Parameters
	#(parameter DEPTH = 4)
	
	(
	input i_WR_clk, i_WR_rst_n,
	input i_WR_En,
	input [DEPTH:0] i_Sync_RD_Ptr,
	output reg [DEPTH:0] o_WR_Ptr,
	output [DEPTH-1:0] o_WR_Addr,
	output reg o_Full
	);

	reg [DEPTH:0] r_WR_Bin_Count;
	wire [DEPTH:0] w_WR_Bin_Next;
	wire [DEPTH:0] w_WR_Grey_Next;

	always @(posedge i_WR_clk or negedge i_WR_rst_n)
	begin
		if (!i_WR_rst_n)
		begin
			o_WR_Ptr <= 0;
			r_WR_Bin_Count <= 0;
		end
		else
		begin
			o_WR_Ptr <= w_WR_Grey_Next;
			r_WR_Bin_Count <= w_WR_Bin_Next;
		end
	end

	assign o_WR_Addr = r_WR_Bin_Count[DEPTH-1:0];
	assign w_WR_Bin_Next = r_WR_Bin_Count + (i_WR_En & ~o_Full);
	assign w_WR_Grey_Next = (w_WR_Bin_Next>>1) ^ w_WR_Bin_Next;			// Grey Code from Bin Code

 	always @(posedge i_WR_clk or negedge i_WR_rst_n)
	begin
		if (!i_WR_rst_n)
			o_Full <= 1'b0;
		else
			o_Full <= (w_WR_Grey_Next == {~i_Sync_RD_Ptr[DEPTH:DEPTH-1], i_Sync_RD_Ptr[DEPTH-2:0]});
	end	

endmodule
