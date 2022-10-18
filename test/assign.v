module assi(
    input clk,
    input din,
    output dout
);

wire clk;
wire din;
reg din_curr;
reg din_next;
reg dout;

always @(posedge clk) begin
    din_curr <= din_next;
end

always @(*) begin
    case (din)
        1:
            din_next = 1;
        0:  
            din_next = 0;
    endcase
end

always @(posedge clk) begin
    dout <= din_curr ^ din;
end

endmodule


//~ `New testbench
`timescale  1ns / 1ps

module tb_assi;

// assi Parameters
parameter PERIOD  = 10;


// assi Inputs
reg   clk                                  = 0 ;
reg   din                                  = 0 ;

// assi Outputs
wire  dout                                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

assi  u_assi (
    .clk                     ( clk    ),
    .din                     ( din    ),

    .dout                    ( dout   )
);

initial begin
    #(PERIOD/4);
    forever #(PERIOD)   din=~din;
end

initial begin
    $dumpfile("assi.vcd");
    $dumpvars;
end

always
begin
    #PERIOD
    if($time >= 10*PERIOD)
        $finish;
end

endmodule