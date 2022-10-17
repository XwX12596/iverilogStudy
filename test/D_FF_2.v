module d_ff(
    input wire clk,
    input wire D,
    input wire Rst,
    output reg Q
);

always @(negedge Rst or posedge clk)
begin
    if(!Rst)
        Q = 0;
    else
        Q= D;
end
endmodule

`timescale 1ns/1ps
module stimulus;
    reg clk;
    reg D;
    wire Q;
    reg Rst;
    d_ff d1(
        .clk(clk),
        .D(D),
        .Q(Q),
        .Rst(Rst)
    );
    integer i;
    initial begin
        $dumpfile("D_FF_2.vcd");
        $dumpvars(0,stimulus);
        D = 0;
        #8 D = 1;
        #10 D = 0;
        #10 D = 0;
        #10 D = 1;
        #10 D = 0;
        #10 D = 1;	
        #40;
    end
    initial begin
        clk = 0;
        for (i = 0; i<=10; i=i+1) begin
            #10 clk = ~clk;
        end
    end
    initial begin
        Rst = 1;
        #28 Rst = 0;
        #52 Rst = 1;
    end

endmodule