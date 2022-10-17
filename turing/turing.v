module turing (
    input wire clk,
    input wire[9:0] bin
);

reg [1:0] state = 2'b00;
reg [9:0] r_bin;
integer i = 0;

initial begin
    r_bin = bin;
end

always @(posedge clk)
begin
    if (state == 2'b00)
    begin
        if (r_bin[i] == 1)
            state = 2'b01;
        i = i + 1;
    end
    else if (state == 2'b01)
    begin
        if (r_bin[i] == 0)
        begin
            r_bin[i] = 1;
            state = 2'b10;
        end
        i = i + 1;
    end
    else if (state == 2'b10)
    begin
        if (i > 9)
        begin
            i = 9;
            r_bin[i] = 0;
            state = 2'b11;
        end
        else if (r_bin[i] == 1)
            i = i + 1;
        else
        begin
            state = 2'b11;
            i = i - 1;
        end
    end
    else if (state == 2'b11)
    begin
        if (r_bin[i] == 1)
            r_bin[i] = 0;
    end
end

endmodule

`timescale 1ns/1ps

module tb_turing;
reg clk;

turing uut
(
    .clk (clk),
    .bin (10'b0111110110)
);

integer i;

initial begin
    #10 clk = 0;
    for (i = 0;i <= 25 ;i=i+1) begin
        #10 clk=~clk;
    end
end

initial begin
    $dumpfile("tb_turing.vcd");
    $dumpvars(1, uut);
end

endmodule