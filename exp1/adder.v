module adder (cout, sum, a, b, cin);
parameter   N = 2;  //定义参数，N为两个加数的位宽
input [N:0] a, b;   //输入变量，两个加数
input       cin;    //输入变量，低位进位
output [N:0] sum;   //输出变量，和
output      cout;   //输出变量，高位进位
    assign {cout, sum} = a + b + cin;   //赋值
endmodule