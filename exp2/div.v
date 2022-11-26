module div(a,b,c,mod);
input  [7:0] a;
input  [3:0] b;
output reg  [7:0]   c;
output reg  [3:0]   mod;
reg     [10:0]  t1,t2,t3;
integer k;

always @(a or b) begin
    t2={3'b000,a};
    for(k=7;k>=7;k=k-1)
        begin
            t1=b << k;
            if (t2>=t1) 
                begin
                    c[k]=1;
                    t2=t2-t1;
                end
            else
                c[k] = 0;
        end
    mod = t2[3:0];
end
endmodule


//~ `New testbench
`timescale  1ns / 1ps

module tb_div;

// div Parameters
parameter PERIOD  = 10;


// div Inputs
reg   [7:0]  a                             = 10011011 ;
reg   [3:0]  b                             = 0010 ;

// div Outputs
wire  [7:0]  c                             ;
wire  [3:0]  mod                           ;


div  u_div (
    .a                       ( a    [7:0] ),
    .b                       ( b    [3:0] ),

    .c                       ( c    [7:0] ),
    .mod                     ( mod  [3:0] )
);

initial
begin
    #(PERIOD * 2)
    a <= 10011001;
    b <=0100;
    #(PERIOD * 2)
    a <= 10010101;
    b <=0110;
    #(PERIOD * 2)
    a <= 10010111;
    b <=0110;
    $finish;
end

initial
begin
    $dumpfile("div.vcd");
    $dumpvars;
end


endmodule
