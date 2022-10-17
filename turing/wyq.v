module tuling(
    input wire [1:10] Dig,
    output reg [1:10] Dig_r
);
integer i = 1;
reg [0:1] control = 2'b00;  //初始化可以用C的方式初始化
reg flag = 0;

initial begin
    Dig_r = Dig;
end

initial begin
    while(!flag) begin  //while 外面要嵌套别的东西，always，initial啥的
        #20;            // 每运行一次延时一次
        case (control)
            2'b00:
                if(Dig_r[i] == 1) //if 和 else 的begin end分开呀
                    Dig_r[i] = 0;
                else
                begin
                    i = i + 1;
                    control = 2'b01;   //assign 别乱用
                end
            2'b01:
                if(Dig_r[i] == 1)
                    i = i + 1;
                else
                begin
                    Dig_r[i] = 1;
                    control = 2'b10;   
                end
            2'b10:
                if(Dig_r[i] == 1)
                    i = i + 1;
                else
                begin
                    i = i - 1;
                    control = 2'b11;   
                end
            2'b11:
                if(Dig_r[i] == 1) begin
                    Dig_r[i] = 0;
                    flag = 1; 
                end
        endcase
    end
    #10;   //停机后再模拟一会儿
end

endmodule