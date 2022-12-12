module regn(R, Rin, clk, Q);  
//寄存器模块，如果Rin信号位高则将输入信号R装入连接的8位寄存器Q中
    parameter n = 8;
    input [n - 1:0] R;
    input Rin, clk;
    output reg [n - 1:0] Q = 8'b00000000;

    always @(posedge clk) begin
        if(Rin)
            Q <= R;
    end
endmodule

module trin (Y, E, F);
// 三态门，E信号控制通断，Y信号控制高低电平
    parameter n=8;
    input [n-1:0] Y;
    input E;
    output [n-1:0] F;
    wire [n-1:0] F;
    assign F=E?Y:8'bzzzzzzzz;
endmodule

module upcount(clear, clk, Q);
// 带清零功能的计数器
    input clear, clk;
    output [1:0] Q;
    reg [1:0] Q;

    always @(posedge clk)
        if(clear)
            Q <= 0;
        else
            Q <= Q + 1;
endmodule

module dec2to4(two, ena, four);
// 2-4线译码器
    input [1:0] two;
    input ena;
    output reg [3:0] four;
    always @(two) begin
        case (two)
            2'b00:  four = 4'b0001;
            2'b01:  four = 4'b0010;
            2'b10:  four = 4'b0100;
            2'b11:  four = 4'b1000;
            default: four = 4'b0000;
        endcase
    end
endmodule

module processor(data, reset, w, clk, F, Rx, Ry, Done, BusWires); // 主要逻辑模块
    input [7:0] data;
    input reset, w, clk;
    input [1:0] F, Rx, Ry;
    output [7:0] BusWires;
    output Done;
    wire [7:0] BusWires;
    reg [0:3] Rin,Rout;
    reg [7:0] Sum;
    wire clear, AddSub, Extern, Ain, Gin, Gout, FRin;
    wire [1:0] count;
    wire[3:0] T, I, Xreg, Y;
    wire [7:0] R0, R1, R2, R3, A, G;
    wire [1:6] Func, FuncReg;
    integer k;

    upcount counter (clear, clk, count); //用clear信号实现四周期循环计数
    dec2to4 decT (count, 1'b1, T); //译码得到四个时序信号并列的T信号
    assign clear = reset | Done | (~w & T[3]); //在T4时清零
    assign Func = {F, Rx, Ry};
    assign FRin = w & T[0]; //第一个周期写入指令信息
    regn functionreg (Func, FRin, clk, FuncReg);  //指令寄存器
    defparam functionreg.n=6;
    dec2to4 decI (FuncReg[1:2], 1'b1, I);      //以下三个信号均为2-4线译码通知相关硬件
    dec2to4 decX (FuncReg[3:4], 1'b1, Xreg);
    dec2to4 decY (FuncReg[5:6], 1'b1, Y);

    //根据时序图，按照真值表的逻辑写出各个控制信号的表达式
    assign Extern =  I[0] & T[1];
    assign Done = ((I[0] | I[1]) & T[1]) | ((I[2] | I[3]) & T[3]);
    assign Ain = (I[2] | I[3]) & T[1];
    assign Gin = (I[2] | I[3]) & T[2];
    assign Gout = (I[2] | I[3]) & T[3];
    assign AddSub = I[3];
    always @(I or T or Xreg or Y) begin
        for (k = 0; k < 4; k = k + 1)
        begin
            Rin[k] = ((I[0] | I[1]) & T[1] & Xreg[k]) | 
            ((I[2] | I[3]) & T[3] & Xreg[k]);
            Rout[k] = (I[1] & T[1] & Y[k]) | ((I[2] | I[3])
            & ((T[1] & Xreg[k]) | (T[2] & Y[k])));
        end
    end

    // 例化三态门和寄存器，均受到控制信号控制
    trin tri_ext (data, Extern, BusWires);
    regn reg_0(BusWires, Rin[0], clk, R0);
    regn reg_1(BusWires, Rin[1], clk, R1);
    regn reg_2(BusWires, Rin[2], clk, R2);
    regn reg_3(BusWires, Rin[3], clk, R3);

    trin tri_0(R0, Rout[0], BusWires);
    trin tri_1(R1, Rout[1], BusWires);
    trin tri_2(R2, Rout[2], BusWires);
    trin tri_3(R3, Rout[3], BusWires);
    regn reg_A(BusWires, Ain, clk, A);

    //alu

    always @(AddSub or A or BusWires) begin
        if(!AddSub)
            Sum = A + BusWires;
        else
            Sum = A - BusWires;
    end

    regn reg_G(Sum, Gin, clk, G);
    trin tri_G (G, Gout, BusWires);
endmodule


// testbench
`timescale  1ns / 1ps

module tb_processor;

// processor Parameters
parameter PERIOD  = 10;


// processor Inputs
reg   [7:0]  data                          = 0 ;
reg   reset                                = 1 ;
reg   w                                    = 0 ;
reg   clk                                  = 0 ;
reg   [1:0]  F                             = 0 ;
reg   [1:0]  Rx                            = 0 ;
reg   [1:0]  Ry                            = 0 ;

// processor Outputs
wire  [7:0]  BusWires                      ;
wire  Done                                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    //init
    #(PERIOD*2) 
    reset  =  0;
    //载入data到Rx（R0）
    data <= 8'b00101010;
    F <= 2'b00;
    Rx <= 2'b00;
    Ry <= 2'b00;
    w <= 1;
    #PERIOD
    w = 0;
    #(PERIOD*2);

    #PERIOD
    //载入data到Rx（R1）
    data <= 8'b01010101;
    F <= 2'b00;
    Rx <= 2'b01;
    Ry <= 2'b00;
    w <= 1;
    #PERIOD
    w <= 0;
    #(PERIOD*2);

    #PERIOD
    //载入data到Rx（R2）
    data <= 8'b00100010;
    F <= 2'b00;
    Rx <= 2'b10;
    Ry <= 2'b00;
    w <= 1;
    #PERIOD
    w <= 0;
    #(PERIOD*2);

    #PERIOD
    //两寄存器（R1，R0）相加
    data <= 8'b00000000;
    F <= 2'b10;
    Rx <= 2'b01;
    Ry <= 2'b00;
    w <= 1;
    #PERIOD
    w <= 0;
    #(PERIOD*2);

    #PERIOD
    //两寄存器（R1，R0）相减
    data <= 8'b00000000;
    F <= 2'b11;
    Rx <= 2'b01;
    Ry <= 2'b00;
    w <= 1;
    #PERIOD
    w <= 0;
    #(PERIOD*2);
end

processor  u_processor (
    .data                    ( data      [7:0] ),
    .reset                   ( reset           ),
    .w                       ( w               ),
    .clk                     ( clk             ),
    .F                       ( F         [1:0] ),
    .Rx                      ( Rx        [1:0] ),
    .Ry                      ( Ry        [1:0] ),

    .BusWires                ( BusWires  [7:0] ),
    .Done                    ( Done            )
);

initial begin
    $dumpfile("processor.vcd");
    $dumpvars;
end

initial
begin
    #(PERIOD * 25)
    $finish;
end

endmodule