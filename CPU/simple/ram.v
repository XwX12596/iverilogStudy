module ram(data,addr,read,ena);
output [7:0]data;
input [5:0]addr;
input read,ena;
reg [7:0]data;

parameter
F0 = 8'b1111_0000,
F1 = 8'b1111_0001,
F2 = 8'b1111_0010,
F3 = 8'b1111_0011; // F3

always@(read or ena)
if(read&& (!ena)) begin
	case(addr)
		6'b000000:data<=F0;
		6'b000001:data<=F1;
		6'b000010:data<=F2;
		6'b000011:data<=F3;
		default: data<=6'bzzzzzz;
	endcase
end
else 
	data<=6'bzzzzzz;
endmodule

