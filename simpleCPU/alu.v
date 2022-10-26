module alu (alu_out, zero, data, accum, alu_clk, opcode);
output [7:0]alu_out;
output zero;
input [7:0] data, accum;
input [1:0] opcode;
input alu_clk;
reg [7:0] alu_out;

parameter 	
JMP = 2'B00,
INC = 2'B01,
DEC = 2'B10,
ADD = 2'B11;

assign zero = !accum;
always @(posedge alu_clk) begin 
	casex (opcode)	
		ADD: 
		begin
			alu_out<=data + accum;
			$display("test%h,data=%h,accum=%h",alu_out,data,accum);
		end
		JMP: alu_out<=accum;
		INC: alu_out= accum+1;
		DEC: alu_out= accum-1;
		default: alu_out<=8'bxxxx_xxxx;
	endcase
end
endmodule