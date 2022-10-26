module register(opcode,ir_addr,data,ena,clk1,rst);
output[1:0] opcode;
output[5:0] ir_addr;
reg [7:0] opc_iraddr;
input [7:0] data;
input ena, clk1, rst;

always @(posedge clk1) begin
	if(rst)
		opc_iraddr<=8'b00_0000;
	else if(ena)		
		opc_iraddr[7:0]<=data;
end

assign opcode=opc_iraddr[7:6];
assign ir_addr=opc_iraddr[5:0];

endmodule

