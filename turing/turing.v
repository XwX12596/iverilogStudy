module turing (
    input clk,
    input [9:0] din
);

wire clk;
wire [9:0] din;
reg [1:0] state = 2'b00;
reg [9:0] r_din;
integer i = 0;

initial begin
    r_din = din;
end

always @(posedge clk)
begin
    if (state == 2'b00)
    begin
        if (r_din[i] == 1)
            state = 2'b01;
        i = i + 1;
    end
    else if (state == 2'b01)
    begin
        if (r_din[i] == 0)
        begin
            r_din[i] = 1;
            state = 2'b10;
        end
        i = i + 1;
    end
    else if (state == 2'b10)
    begin
        if (i > 9)
        begin
            i = 9;
            r_din[i] = 0;
            state = 2'b11;
        end
        else if (r_din[i] == 1)
            i = i + 1;
        else
        begin
            state = 2'b11;
            i = i - 1;
        end
    end
    else if (state == 2'b11)
    begin
        if (r_din[i] == 1)
            r_din[i] = 0;
    end
end

endmodule

`timescale 1ns/1ps

module tb_turing;
reg clk = 0;
wire [9:0] din;
integer i;

assign din = 10'b00_1111_0_11_0;

turing uut
(
    .clk (clk),
    .din (din)
);

initial begin
    for (i = 0;i <= 25 ;i=i+1) begin
        #10 clk=~clk;
    end
end

initial begin
    $dumpfile("turing.vcd");
    $dumpvars(1, uut);
end

endmodule