// Testbench for Asynchronous FIFO

module FIFO_Async_tb();

	// Parameters
	parameter WIDTH = 8;
	parameter DEPTH = 3;
	parameter RD_CLK_DELAY = 2;
	parameter WR_CLK_DELAY = 2;

	logic r_rst_n = 1'b0;				// Common Reset for Write and Read parts
	logic r_RD_clk = 1'b0;				// Read clock
	logic r_WR_clk = 1'b0;				// Write clock
	logic r_RD_En = 1'b0;				// Read Enable
	logic r_WR_En = 1'b0;				// Write Enable
	logic w_Empty, w_Full;				// Empty and Full flags
	logic [WIDTH-1:0] r_WR_Data = 0;	//
	logic [WIDTH-1:0] w_RD_Data;
	
	// Instantiate FIFO_Async UUT
	FIFO_Async
	#(.WIDTH(WIDTH), .DEPTH(DEPTH)) FIFO_Async_UUT

	(
	// Read part
	.i_RD_clk(r_RD_clk),
	.i_RD_En(r_RD_En),
	.i_RD_rst_n(r_rst_n),
	.o_Empty(w_Empty),
	.o_RD_Data(w_RD_Data),
	
	// Write part
	.i_WR_clk(r_WR_clk),
	.i_WR_En(r_WR_En),
	.i_WR_rst_n(r_rst_n),
	.o_Full(w_Full),
	.i_WR_Data(r_WR_Data)
	);
	
	// Create both clocks
	always #(RD_CLK_DELAY) r_RD_clk <= ~ r_RD_clk;
	always #(WR_CLK_DELAY) r_WR_clk <= ~ r_WR_clk;

	// Task Reset FIFO
	task reset_fifo();
		@(posedge r_RD_clk);
		r_rst_n <= 1'b0;
		r_WR_En <= 1'b0;  
		r_RD_En <= 1'b0;
		@(posedge r_RD_clk);
		r_rst_n <= 1'b1;
		@(posedge r_RD_clk);
		@(posedge r_WR_clk);
	endtask


	initial
	begin 
		reset_fifo();

		// Write single word
		r_WR_En   <= 1'b1;
		r_WR_Data <= 8'hAB;
		@(posedge r_WR_clk);
		r_WR_En   <= 1'b0;
		@(posedge r_WR_clk);

		repeat(4) @(posedge r_RD_clk);

		// Read out that word
		r_RD_En <= 1'b1;
		@(posedge r_RD_clk);
		r_RD_En <= 1'b0;
		@(posedge r_RD_clk);

		// Fill FIFO
		reset_fifo();
		r_WR_Data <= 8'h40;
		
		repeat(2**DEPTH+1)
		begin
			r_WR_En <= 1'b1;
			@(posedge r_WR_clk);
			r_WR_En <= 1'b0;
			r_WR_Data <= r_WR_Data + 1;
			@(posedge r_WR_clk);
		end
		r_WR_En <= 1'b0;
		@(posedge r_WR_clk);

		@(posedge r_RD_clk);
		repeat(2**DEPTH+1)
		begin
			r_RD_En <= 1'b1;
			@(posedge r_RD_clk);
			r_RD_En <= 1'b0;
		end
	end
endmodule

