module counter#(
	parameter DEPTH = 8,
	parameter RESET_VAL = 2**8 //this is a number of cycles - if you want to reset every 800 cycles put 800 not 799
)(
	input clk,
	input reset,
	input en,
	output [DEPTH-1:0] count,
	output last_cycle
);

	reg [DEPTH-1:0] val;
	
	always@(posedge clk, negedge reset)
		begin
		
			if(reset==1'b0)
				val <= 0;
			else
				val <= en ? ((val==RESET_VAL-1) ? 0 : val + 1) : val;
		end
		
	assign count = val;
	assign last_cycle = val=RESET_VAL-1;

endmodule