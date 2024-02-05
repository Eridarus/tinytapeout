module top_level#(
	parameter H_PIXELS = 640,
	parameter V_PIXELS = 480
)
(
	input [3:0] buttons,
	input reset,
	input pix_clk,
	output [1:0] red,
	output [1:0] blu,
	output [1:0] grn,
	output hsync,
	output vsync
);

	wire [9:0] h_sel;
	wire [8:0] v_sel;
	wire display_en;

	vga_controller vga(
		.reset(reset),
		.pix_clk(pix_clk),
		.hsync(hsync),
		.vsync(vsync),
		.v_sel(v_sel),
		.h_sel(h_sel),
		.display_en(display_en)
	);
	
	

endmodule