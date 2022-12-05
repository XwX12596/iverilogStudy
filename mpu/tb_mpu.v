`timescale  1ns / 1ps  
`include "./mpu.v"

module tb_mpc;

// mpc Parameters      
parameter PERIOD  = 10;


// mpc Inputs
reg   [17:0]  instr                        = 0 ;

// mpc Outputs
wire  [8:0]  out                           ;


// initial
// begin
//   forever #(PERIOD/2)  clk=~clk;
// end

initial
begin
    #(PERIOD*2)
    instr = 18'b000000011100000001;
end

mpc  u_mpc (
    .instr                   ( instr  [17:0] ),

    .out                     ( out    [8:0]  )
);

initial
begin
    $dumpfile("tb_mpu_wave.vcd");
    $dumpvars;
    
    
    $finish;
end

endmodule