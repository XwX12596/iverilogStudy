`timescale 1ns/1ps
`include "wyq.v"     //分开写两个模块要include
module tuling_test; 
wire [1:10] Dig;
assign Dig = 10'b0111_1011_10;

tuling a1(.Dig(Dig)); //模块实例化的时候用wire变量赋值就行


initial begin
  $dumpfile("wyq.vcd");  //导出.vcd文件
  $dumpvars;
end

endmodule
