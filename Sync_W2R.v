// Catch Write Pointer in RD_clk domain
module Sync_W2R

	// Parameters
	#(parameter WIDTH = 8)
	
	(
	input i_RD_clk, i_RD_rst_n,
	input [WIDTH:0] i_WR_Ptr,
	output reg [WIDTH:0] o_Sync_WR_Ptr
	);

	reg [WIDTH:0] r_WR_Ptr;

	always @(posedge i_RD_clk or negedge i_RD_rst_n)
	begin
		if (!i_RD_rst_n)
		begin
			o_Sync_WR_Ptr <= 1'b0;
			r_WR_Ptr <= 1'b0;
		end
		else
		begin
			o_Sync_WR_Ptr <= r_WR_Ptr;
			r_WR_Ptr <= i_WR_Ptr;
		end 	
	end
endmodule
