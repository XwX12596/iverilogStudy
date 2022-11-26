`timescale 1ns/1ns
module machinectl(ena, fetch, rst, clk);
output reg	ena;
input  		fetch, rst, clk;

always @(posedge clk)
	begin
		if(rst)
			ena <= 0;
		else if(fetch)			
			ena <= 1;
	end
endmodule