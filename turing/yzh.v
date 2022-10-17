module Turing(data,clk);
wire[15:0] data;
wire clk;

reg[15:0] data_;
reg[1:0] state;
input [15:0] data;
input clk;
initial begin
    data_=data;
    state=2'b00;
end

integer i = 0;
always @(posedge clk) begin
    if(state==2'b00)begin
        if(data_[i]==0)begin
            state=2'b00;
            i = i + 1;
        end
        else if(data_[i]==1)begin
            state=2'b01;
            i = i + 1;
        end
    end
    else if(state==2'b01)begin
        if(data_[i]==0)begin
            state=2'b10;
            data_[i]=1;
            i = i + 1;
        end
        else if(data_[i]==1)begin
            state=2'b01;
            i = i + 1;
        end
    end
    else if(state==2'b10)begin
        if(data_[i]==0)begin
            state=2'b11;
            i = i - 1;
        end
        else if(data_[i]==1)begin
            state=2'b10;
            i = i + 1;
        end
    end
    else if(state==2'b11)begin
        if(data_[i]==0);
        else if(data_[i]==1)begin
            state=2'b00;
            data_[i]=0;
        end
    end
end
endmodule

`timescale  1ns / 1ps
module tb_Turing;

parameter PERIOD  = 10;
reg   clk = 0;

initial begin
    #200 $finish;
end

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

Turing  u_Turing (
    .data                    (16'b0000001110110000),
    .clk                     ( clk  )
);

initial
begin
    $dumpfile("Turing_test.vcd");
    $dumpvars;
end
endmodule




