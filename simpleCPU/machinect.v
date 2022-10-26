`timescale 1ns/1ns
module machinect(ena,fetch,rst,clk1);
input fetch,rst,clk1;
output ena;
reg ena;
reg state;

always@(posedge clk1)
	begin
		if(rst)
			begin
				ena<=0;
			end
		else
			if(fetch)
			begin
			ena<=1;
		end
	end
endmodule
