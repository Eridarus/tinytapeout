module vga_controller(
	parameter WIDTH = 640, //10 bit line select, 10 bit counter including porches/waits
	parameter HEIGHT = 480, //9 bit column select, 10 bit counter including porches/waits
	parameter H_FRONT_PORCH = 16,
	parameter H_BACK_PORCH = 48,
	parameter H_SYNC_WAIT = 96
)(
	input pix_clk,
	input reset,
	output [9:0] line_sel,
	output [8:0] col_sel,
	output hsync,
	output vsync
);

	parameter LINE_WAIT = HEIGHT + H_FRONT_PORCH + H_BACK_PORCH_ + H_SYNC_WAIT;
	
	parameter V_FRONT_PORCH = 10 * LINE_WAIT;
	parameter V_BACK_PORCH = 33 * LINE_WAIT;
	parameter V_SYNC_WAIT = 2 * LINE_WAIT;
	parameter V_LINES_WAIT = HEIGHT + V_FRONT_PORCH + V_BACK_PORCH + V_SYNC_WAIT;
	
	parameter H_COUNT_DEPTH = 10;
	parameter V_COUNT_DEPTH = 10;
	
	wire [H_COUNT_DEPTH-1:0] h_count;
	wire [V_COUNT_DEPTH-1:0] v_count;
	wire line_end, frame_end;
	
	counter h_counter#(
		DEPTH = H_COUNT_DEPTH,
		RESET_VAL = LINE_WAIT
	)(
		.clk(pix_clk),
		.reset(reset),
		.count(h_count),
		.last_cycle(line_end),
		.en(1'b1)
	);
	
	counter V_counter#(
		DEPTH = V_COUNT_DEPTH,
		RESET_VAL = V_LINES_WAIT
	)(
		.clk(pix_clk),
		.reset(reset),
		.en(line_end),
		.count(v_count),
		.last_cycle(frame_end)
	);

endmodule