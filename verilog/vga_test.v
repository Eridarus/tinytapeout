module vga_test#(
	parameter H_PIXELS = 640,
	parameter V_PIXELS = 480
)
(
	input [3:0] buttons,
	input reset,
	input pix_clk_in,
	output [1:0] red,
	output [1:0] blu,
	output [1:0] grn,
	output hsync,
	output vsync,
	output pix_clk_out
);

	wire [9:0] h_sel;
	wire [8:0] v_sel;
	wire display_en, pix_clk;
	
	pll_vga(
		//.rst(reset),
		.refclk(pix_clk_in),
		.outclk_0(pix_clk)
	);
	
	assign pix_clk_out = pix_clk;

	vga_controller vga(
		.reset(reset),
		.pix_clk(pix_clk),
		.hsync(hsync),
		.vsync(vsync),
		.v_sel(v_sel),
		.h_sel(h_sel),
		.display_en(display_en)
	);
	
	/*assign red[1] = ~(h_sel[0] & h_sel[1]);
	assign blu[1] = h_sel[0] & ~h_sel[1];
	assign grn[1] = ~h_sel[0] & h_sel[1];*/
	
	assign red[1] = h_sel > v_sel ? 1'b1 : 1'b0;
	
	

endmodule