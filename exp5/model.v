module pla(x1,x2,y,W1,W2);
input[2:0]  x1,x2;
output y;
output[7:0] W1,W2;
wire [2:0] x1, x2;
reg y;
reg[7:0] sum;
reg[7:0] W1,W2;
function [15:0]w1w2;
    input [7:0]v1,v2;
    integer k;
    reg[7:0] w1, w2;
    reg [1:0] rand;
    begin
        w1=v1;
        w2=v2;
        for(k=1;k<=60;k=k+1)
        begin
            rand = {$random} % 10;
            if(rand == 0)
                w2=w2+2;        // x0 = (0, 2) t1 = 1
            else if(rand == 1)
                w2=w2+1;        // x1 = (0, 1) t2 = 1
            else if(rand == 2)
                w1=w1-2;        // x2 = (2, 0) t3 = -1
            else if(rand == 3)
                begin
                    w1=w1-2;    // x3 = (2, 2) t4 = -1
                    w2=w2-2;
                end
            else if(rand == 4)
                    w2=w2-3;    // x4 = (0, 3) t5 = 1
            else if(rand == 5)
                    w1=w1-1;    //x5 = (1, 0) t6 = -1
            else if(rand == 6)
                begin
                    w1=w1-2;    //x6 = (2, 1) t7 = -1
                    w2=w2-1;
                end
            else if(rand == 7)
                begin
                    w1=w1-1;    //x7 = (1, 2) t8 = -1
                    w2=w2-2;
                end
            else if(rand == 8)
                begin
                    w1=w1+1;    //x8 = (1, 4) t9 = 1
                    w2=w2+4;
                end
            else if(rand == 9)
                begin
                    w1=w1+0;    //x9 = (0, 7) t10 = 1
                    w2=w2+7;
                end
        end
        $display("w1 is %d, w2 is %d", w1, w2);
        w1w2 = {w1, w2};
    end
endfunction

initial begin
    {W1,W2}=w1w2(1,1);
end

always @(x1 or x2) 
begin
    sum = W1*x1+W2*x2;
    if((sum)>8'b01111111)
        y=0;
    else
        y=1;
    if (sum > 0)
        $display("(%d, %d), sum is %d, y is %d", x1, x2, $signed(sum), y);
end
endmodule


//~ `New testbench
`timescale  1ns / 1ps

module tb_pla;

// pla Parameters
parameter PERIOD  = 10;


// pla Inputs
reg  [2:0]  x1                            = 0 ;
reg  [2:0]  x2                            = 0 ;

// pla Outputs
wire  y                                    ;
wire  [7:0]  W1                            ;
wire  [7:0]  W2                            ;



pla  u_pla (
    .x1                      ( x1  [2:0] ),
    .x2                      ( x2  [2:0] ),

    .y                       ( y         ),
    .W1                      ( W1  [7:0] ),
    .W2                      ( W2  [7:0] )
);

initial begin
    $dumpfile("model.vcd");
    $dumpvars;
end

initial begin
    x1 <= 3'b000;
    x2 <= 3'b010;
    #PERIOD
    x1 <= 3'b000;
    x2 <= 3'b001;
    #PERIOD
    x1 <= 3'b010;
    x2 <= 3'b000;
    #PERIOD
    x1 <= 3'b010;
    x2 <= 3'b010;
    #PERIOD
    x1 <= 3'b001;
    x2 <= 3'b001;
    #PERIOD
    x1 <= 3'b001;
    x2 <= 3'b111;
    #PERIOD
    x1 <= 3'b010;
    x2 <= 3'b011;
    #PERIOD
    x1 <= 3'b000;
    x2 <= 3'b111;
    #PERIOD
    x1 <= 3'b001;
    x2 <= 3'b010;
    #PERIOD
    x1 <= 3'b001;
    x2 <= 3'b010;
    #PERIOD
    $finish;
end

endmodule