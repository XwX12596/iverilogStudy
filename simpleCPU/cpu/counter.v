module counter(pc_addr,ir_addr,load,clk,rst);
output[5:0]pc_addr;
input [5:0]ir_addr;
input load,clk,rst;
reg[5:0]pc_addr;

always @( posedge clk or posedge rst ) begin
	if(rst)
		pc_addr<=13'b0_0000_0000_0000;
	else if(load)
		pc_addr<=ir_addr;
	else
		pc_addr <= pc_addr + 1;
end
endmodule