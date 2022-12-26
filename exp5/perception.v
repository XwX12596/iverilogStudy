module perc(clk, data_in, data_out);
parameter width = 8;
input wire clk;
input wire [width-1:0] data_in;
output reg data_out;
reg [7:0] weigh[width - 1:0];
reg [11:0] sum = 0;
integer i = 0;

initial begin
    weigh[0] <= 8'b00000011;
    weigh[1] <= 8'b00000110;
    weigh[2] <= 8'b00001100;
    weigh[3] <= 8'b00011000;
    weigh[4] <= 8'b00110000;
    weigh[5] <= 8'b01100000;
    weigh[6] <= 8'b11000000;
    weigh[7] <= 8'b11000000;
end

always @(posedge clk) begin
    for (i = 0; i < width; i = i + 1) begin
        sum = sum + data_in[i] * weigh[i];
        $display("i is %d, data_in is %d, weigh is %8b", i, data_in[i], weigh[i]);
    end
    $display("sum is %b", sum);
    if (sum >= 8'b11111111) begin
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
parameter width  = 8;

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
    data_in = 8'b1111_0000;
    // data_in = 8'b00001011;
    #(PERIOD)
    $finish;
end

endmodule