module rom(data,addr,read,ena);
output [7:0]data;
input [5:0]addr;
input read,ena;
reg [7:0]data;


parameter
INC_accum 	= 8'b01_000011,
ADD_accum_3 = 8'b11_000011;

always@(read or ena)
if(read&&ena) begin
	case(addr)
		6'b000000:data<=INC_accum;
		6'b000001:data<=INC_accum;
		6'b000010:data<=INC_accum;
		6'b000011:data<=INC_accum;
					
		6'b000100:data<=ADD_accum_3; //add al, [3]
		6'b000101:data<=ADD_accum_3;
		6'b000110:data<=ADD_accum_3;
		6'b000111:data<=ADD_accum_3;
		default: data<=8'bzzzzzzzz;
	endcase
end
else
	data<=8'bzzzzzzzz;

endmodule
