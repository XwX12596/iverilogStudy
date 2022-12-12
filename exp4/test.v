module regn(R, Rin, clk, Q);
    parameter n = 8;
    input [n - 1:0] R;
    input Rin, clk;
    output reg [n - 1:0] Q;

    always @(posedge clk) begin
        if(Rin)
            Q = R;
    end
endmodule

`timescale  1ns / 1ps
module tb_regn;

// regn Parameters
parameter PERIOD = 10;
parameter n  = 8;

// regn Inputs
reg   [n - 1:0]  R                         = 0 ;
reg   Rin                                  = 0 ;
reg   clk                                  = 0 ;

// regn Outputs
reg  [n - 1:0]  Q                         ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) 
    Q <= 8'b11100011;
end

regn #(
    .n ( n ))
u_regn (
    .R                       ( R    [n - 1:0] ),
    .Rin                     ( Rin            ),
    .clk                     ( clk            ),

    .Q                       ( Q    [n - 1:0] )
);

initial
begin
    $dumpfile("test.vcd");
    $dumpvars;
end

initial
begin
    #(PERIOD * 10)
    $finish;
end

endmodule