module miniALU(
    input [1:0] op,
    input [7:0] dig_h,
    input [7:0] dig_l,
    input clk,
    input rstn,
    output [16:0] prd,
    output [7:0] mct,
    output [7:0] res
);

//input
wire [1:0] op;
wire [7:0] dig_h;
wire [7:0] dig_l;
wire clk;
wire rstn;
//output
reg [16:0] prd;
reg [7:0] mct;
reg [7:0] res;
//reg
reg [7:0] dig_1;
reg [7:0] dig_2;

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
            dig_1 = dig_h;
            dig_2 = dig_l;
            prd = 0;
            mct = 0;
            res = 0;
    end
    else if(op == 2'b10) begin
        if (dig_2 > 0) begin
            if (dig_1 > 0) begin
                prd = prd + dig_1;
                dig_2 = dig_2 - 1;
            end
            else begin
                prd = 0;
            end
        end
    end
    else if (op == 2'b11) begin
        if (dig_2 > 0) begin
            if (dig_1 > dig_2) begin
                dig_1 = dig_1 - dig_2;
                mct = mct + 1;
            end
            else begin
                res = dig_1;
            end
        end
    end
end
endmodule


`timescale  1ns / 1ps
module tb_miniALU;
parameter PERIOD  = 10;

// miniALU Inputs
reg [1:0]  op = 0 ;
reg [7:0]  dig_h = 0 ;
reg [7:0]  dig_l = 0 ;
reg clk = 0 ;
reg rstn = 0 ;
// miniALU Outputs
wire  [16:0]  prd;
wire  [7:0]  mct;
wire  [7:0]  res;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    rstn = 1;

    op = 2'b10;
    dig_h = 8'b0010_1111;
    dig_l = 8'b0000_0111;
    #(PERIOD) rstn  =  0;
    #(PERIOD) rstn  =  1;

    #(PERIOD*9)

    op = 2'b11;
    dig_h = 8'b0000_0111;
    dig_l = 8'b0000_0010;
    #(PERIOD) rstn  =  0;
    #(PERIOD) rstn  =  1;
end

miniALU  u_miniALU (
    .op                      ( op     [1:0]  ),
    .dig_h                   ( dig_h  [7:0]  ),
    .dig_l                   ( dig_l  [7:0]  ),
    .clk                     ( clk           ),
    .rstn                    ( rstn          ),

    .prd                     ( prd    [16:0] ),
    .mct                     ( mct    [7:0]  ),
    .res                     ( res    [7:0]  )
);

always
begin
    #PERIOD
    if ($time > PERIOD*20)
        $finish;
end

initial begin
    $dumpfile("minialu.vcd");
    $dumpvars(1, u_miniALU);
end

endmodule