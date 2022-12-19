module rom(data,addr,read,ena);
output [7:0]data;
input [5:0]addr;
input read,ena;
reg [7:0]data;


parameter
INC_accum 	= 8'b01_000011,
ADD_accum_3 = 8'b11_000011,
ADD_accum_2 = 8'b11_000010,
DEC_accum = 8'b10_000010;


always@(read or ena)
if(read&&ena) begin
	case(addr)
		6'b000000:data<=INC_accum; 	//inc al
		6'b000001:data<=DEC_accum; //dec al	
		6'b000010:data<=INC_accum;	//inc al
		6'b000011:data<=DEC_accum; //dec al
					
		6'b000100:data<=ADD_accum_3; //add al, [3]
		6'b000101:data<=ADD_accum_2; //add al, [2]
		6'b000110:data<=ADD_accum_3; //add al, [3]
		6'b000111:data<=ADD_accum_2; //add al, [2]
		default: data<=8'bzzzzzzzz;
	endcase
end
else
	data<=8'bzzzzzzzz;

endmodule
