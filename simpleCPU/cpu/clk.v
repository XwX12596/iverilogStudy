`timescale 1ns/1ns
module clk(clk,clk1,fetch,alu_ena);
input clk;
output fetch,alu_ena,clk1;
wire clk,clk1;
reg fetch,alu_ena;
reg[7:0] state;
parameter     s1 = 8'b0000_0001,
              s2 = 8'b0000_0010,
              s3 = 8'b0000_0100,
              s4 = 8'b0000_1000,
              s5 = 8'b0001_0000,
              s6 = 8'b0010_0000,
              s7 = 8'b0100_0000,
              s8 = 8'b1000_0000,
			  idle = 8'b0000_0000;
assign clk1=~clk;
always@(posedge clk)
 		begin
			case(state)
				s1:
					begin
						alu_ena<=1;
						state<=s2;
					end
				s2:
					begin
						alu_ena<=0;
						state<=s3;
					end
				s3:
					begin
						fetch<=1;
						state<=s4;
					end
				s4:
						state<=s5;
				s5:
						state<=s6;
				s6:
						state<=s7;
				s7:
					begin
						fetch<=0;
						state<=s8;
					end
				s8:
					begin
						state<=s1;
					end
				idle:	state<=s1;
				default: state<=idle;
endcase
end
endmodule

