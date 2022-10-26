module addr(addr,fetch,ir_addr,pc_addr);
output 	[5:0]	addr;
input 	[5:0]	ir_addr,pc_addr;
input fetch;

assign addr=fetch?pc_addr:ir_addr;

endmodule