// Top level module of Asynchronous FIFO

module FIFO_Async

	#(
	parameter WIDTH = 8,
	parameter DEPTH = 4
	)

	(
	output [WIDTH-1:0] o_RD_Data,
	output o_Full,
	output o_Empty,
	input [WIDTH-1:0] i_WR_Data,
	input i_WR_En, i_WR_clk, i_WR_rst_n,
	input i_RD_En, i_RD_clk, i_RD_rst_n
	);

	wire [DEPTH:0] w_WR_Ptr, w_Sync_WR_Ptr;
	wire [DEPTH:0] w_RD_Ptr, w_Sync_RD_Ptr;
	wire [DEPTH-1:0] w_WR_Addr, w_RD_Addr; 

	// Instantiate Sync_R2W
	Sync_R2W 
	Sync_R2W_Inst 
	(
	.i_WR_clk(i_WR_clk), 
	.i_WR_rst_n(i_WR_rst_n),
	.i_RD_Ptr(w_RD_Ptr),
	.o_Sync_RD_Ptr(w_Sync_RD_Ptr));


	// Instantiate Sync_W2R
	Sync_W2R 
	Sync_W2R_Inst 
	(
	.i_RD_clk(i_RD_clk), 
	.i_RD_rst_n(i_RD_rst_n),
	.i_WR_Ptr(w_WR_Ptr),
	.o_Sync_WR_Ptr(w_Sync_WR_Ptr));


	// Instantiate FIFO_RAM
	FIFO_RAM
	#(.WIDTH(WIDTH),
	.DEPTH(DEPTH)) FIFO_RAM_Inst
	
	(
	.i_WR_clk(i_WR_clk),
	.i_WR_En(i_WR_En),
	.i_Full(o_Full),
	.i_WR_Addr(w_WR_Addr), 
	.i_RD_Addr(w_RD_Addr),
	.i_WR_Data(i_WR_Data),
	.o_RD_Data(o_RD_Data)   
	);


	// Instantiate RD_Ptr_Empty
	RD_Ptr_Empty 
	#(.DEPTH(DEPTH)) RD_Ptr_Empty_Inst
	
	(
	.i_RD_clk(i_RD_clk), 
	.i_RD_rst_n(i_RD_rst_n),
	.i_RD_En(i_RD_En), 
	.i_Sync_WR_Ptr(w_Sync_WR_Ptr),
	.o_RD_Ptr(w_RD_Ptr),
	.o_RD_Addr(w_RD_Addr),
	.o_Empty(o_Empty)
	);	

	// Instantiate WR_Ptr_Full
	WR_Ptr_Full 
	#(.DEPTH(DEPTH)) WR_Ptr_Full_Inst
	
	(
	.i_WR_clk(i_WR_clk), 
	.i_WR_rst_n(i_WR_rst_n),
	.i_WR_En(i_WR_En),
	.i_Sync_RD_Ptr(w_Sync_RD_Ptr),
	.o_WR_Ptr(w_WR_Ptr),
	.o_WR_Addr(w_WR_Addr),
	.o_Full(o_Full)
	);

endmodule
