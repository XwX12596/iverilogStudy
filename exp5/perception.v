module perc(clk, data_in, data_out);
parameter width = 4;
input wire clk;
input wire [width-1:0] data_in;
output reg data_out;
reg [3:0] weigh[width - 1:0];
reg [7:0] sum = 0;
integer i = 0;

initial begin
    weigh[0] <= 4'b0001;
    weigh[1] <= 4'b0010;
    weigh[2] <= 4'b0100;
    weigh[3] <= 4'b1000;
end

always @(posedge clk) begin
    for (i = 0; i < width; i = i + 1) begin
        sum = sum + data_in[i] * weigh[i];
        $display("i is %d, data_in is %d, weigh is %d", i, data_in[i], weigh[i]);
    end
    $display("sum is %d", sum);
    if (sum >= 5'b01010) begin
        data_out = 1;
        $display("Active!");
    end
    else begin
        data_out = 0;
        $display("Inactive!");
    end
end

endmodule


//~ `New testbench
`timescale  1ns / 1ps

module tb_perc;

// perc Parameters
parameter PERIOD = 10;
parameter width  = 4;

// perc Inputs
reg   clk                                  = 0 ;
reg   [width-1:0]  data_in                 = 0 ;

// perc Outputs
wire  data_out                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

perc #(
    .width ( width ))
u_perc (
    .clk                     ( clk                   ),
    .data_in                 ( data_in   [width-1:0] ),

    .data_out                ( data_out              )
);

initial
begin
    data_in = 4'b1011;
    #(PERIOD)
    $finish;
end

endmodule