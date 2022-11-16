// FIFO RAM 
module FIFO_RAM

	#(
	// Parameters
	parameter WIDTH = 8,
	parameter DEPTH = 4
	)
	
	(
	input i_WR_clk,
	input i_WR_En,
	input i_Full,
	input [DEPTH-1:0] i_WR_Addr, i_RD_Addr,
	input [WIDTH-1:0] i_WR_Data,
	output [WIDTH-1:0] o_RD_Data   
	);

	// Memory Declaration
  	reg [WIDTH-1:0] r_Mem[2**DEPTH-1:0];

	// Write operation
	always @ (posedge i_WR_clk)
	begin
		if (i_WR_En && ~ i_Full)
		begin
			r_Mem[i_WR_Addr] <= i_WR_Data;
    	end
	end	

	assign o_RD_Data = r_Mem[i_RD_Addr];

endmodule
