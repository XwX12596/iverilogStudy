module ram(data,addr,read,write,ena);
output [7:0]data;
input [5:0]addr;
input [7:0]din;
input read,write,ena;
reg [7:0]data;

reg [7:0]R_0 = 8'b1111_0000;
reg [7:0]R_1 = 8'b1111_0001;
reg [7:0]R_2 = 8'b1111_0010;
reg [7:0]R_3 = 8'b1111_0011;

always@(read or ena) begin
	if(!ena) begin
		if(read) begin
			case(addr)
				6'b000000: data <= R_0;
				6'b000001: data <= R_1;
				6'b000010: data <= R_2;
				6'b000011: data <= R_3;
				default:data <= 8'bzzzzzzzz;
			endcase
		end
		else if(write) begin
			case (addr)
				6'b000000:R_0 <= din;
				6'b000001:R_1 <= din;
				6'b000010:R_2 <= din;
				6'b000011:R_3 <= din;
			endcase
		end
	end
	else begin
		data <= 8'bzzzzzzzz;
	end
end
endmodule

