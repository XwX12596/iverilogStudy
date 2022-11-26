module accum( accum, data, ena, clk, rst);
output reg	[7:0]	accum;
input		[7:0]	data;
input				ena, clk, rst;

always@(posedge clk)
	begin
		if(rst)
			accum<=8'b0000_0000;	//Reset
		else if(ena)				//CPU load_acc
			accum<=data;			//Accumulate
	end

endmodule