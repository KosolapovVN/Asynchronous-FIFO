// Catch Read Pointer in WR_clk domain
module Sync_R2W

	// Parameters
	#(parameter WIDTH = 8)
	
	(
	input i_WR_clk, i_WR_rst_n,
	input [WIDTH:0] i_RD_Ptr,
	output reg [WIDTH:0] o_Sync_RD_Ptr
	);

	reg [WIDTH:0] r_RD_Ptr;

	always @(posedge i_WR_clk or negedge i_WR_rst_n)
	begin
		if (!i_WR_rst_n)
		begin
			o_Sync_RD_Ptr <= 1'b0;
			r_RD_Ptr <= 1'b0;
		end
		else
		begin
			o_Sync_RD_Ptr <= r_RD_Ptr;
			r_RD_Ptr <= i_RD_Ptr;
		end 	
	end
endmodule
