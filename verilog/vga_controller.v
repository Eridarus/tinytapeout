module vga_controller#(
	parameter WIDTH = 640, //10 bit line select, 10 bit counter including porches/waits
	parameter HEIGHT = 480, //9 bit column select, 10 bit counter including porches/waits
	parameter H_FRONT_PORCH = 16,
	parameter H_BACK_PORCH = 48,
	parameter H_SYNC_WAIT = 96,
	parameter V_FRONT_PORCH = 10,
	parameter V_BACK_PORCH = 33,
	parameter V_SYNC_WAIT = 2	
)(
	input pix_clk,
	input reset,
	output [9:0] h_sel, //select pixel x-axis
	output [8:0] v_sel, //select pixel y-axis
	output hsync,
	output vsync,
	output display_en
);

	parameter LINE_WAIT = HEIGHT + H_FRONT_PORCH + H_BACK_PORCH + H_SYNC_WAIT;
	
	parameter V_LINES_WAIT = HEIGHT + V_FRONT_PORCH + V_BACK_PORCH + V_SYNC_WAIT;
	
	parameter H_COUNT_DEPTH = 10;
	parameter V_COUNT_DEPTH = 10;
	
	wire [H_COUNT_DEPTH-1:0] h_count;
	wire [V_COUNT_DEPTH-1:0] v_count;
	wire line_end, frame_end;
	
	counter#(
		.DEPTH(H_COUNT_DEPTH),
		.RESET_VAL(LINE_WAIT)
	)h_counter (
		.clk(pix_clk),
		.reset(reset),
		.count(h_count),
		.last_cycle(line_end),
		.en(1'b1)
	);
	
	counter #(
		.DEPTH(V_COUNT_DEPTH),
		.RESET_VAL(V_LINES_WAIT)
	)v_counter (
		.clk(pix_clk),
		.reset(reset),
		.en(line_end),
		.count(v_count),
		.last_cycle(frame_end)
	);
	
	assign hsync = ((h_count < H_SYNC_WAIT) ? 1'b0 : 1'b1)|~reset;
	assign vsync = ((v_count < V_SYNC_WAIT) ? 1'b0 : 1'b1)|~reset;
	assign h_sel = h_count - (H_SYNC_WAIT + H_BACK_PORCH);
	assign v_sel = v_count - (V_SYNC_WAIT + V_BACK_PORCH);
	assign display_en = (h_count >= (H_SYNC_WAIT + H_BACK_PORCH)) & (v_count >= (V_SYNC_WAIT + V_BACK_PORCH)) & (h_count < (LINE_WAIT - H_FRONT_PORCH)) & (v_count < (V_LINES_WAIT - V_FRONT_PORCH));
//This signal goes high ON the cycles, not one before, so timing might be off by one cycle
endmodule