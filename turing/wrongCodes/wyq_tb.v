`timescale 1ns/1ns
module tuling_test; 
wire [1:10] Dig_1,Dig_2; 
parameter INTERVAL;

tuling a1(.Dig_1(Dig_1),.Dig_2(Dig_2));
initial
begin
  #INTERVAL Dig_1 = 10'b0111_1011_10;
end
endmodule
