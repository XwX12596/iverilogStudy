`include "CPU.v"

`timescale 1ns / 1ns
`define PERIOD 100             // matches clk_gen.v
module cputop;
reg             reset_req, clock;
integer         test;
reg   [(3*8):0] mnemonic;    //array that holds 3 8-bit ASCII characters
reg   [5:0]    PC_addr,IR_addr;
wire  [7:0]     data;
wire  [5:0]    addr, ir_addr, pc_addr;
wire            rd, wr, halt, ram_sel, rom_sel, fetch;
wire  [1:0]     opcode;

//------------------------   cpu  ROM RAM--------------------------------------
CPU   m(.clk(clock), .reset(reset_req), .halt(halt), .rd(rd),
                   .wr(wr), .addr(addr), .data(data),
                   .opcode(opcode), .fetch(fetch),
                   .ir_addr(ir_addr), .pc_addr(pc_addr));

//--------------------cpu ROM RAM ?---------------------------------- 

always #50 clock=~clock; 

initial
  begin
    $dumpfile("wave.vcd");
    $dumpvars(0, m);
        clock = 0;
        reset_req = 0;
    #10 reset_req = 1;
    #880 reset_req = 0;
    #10000 $finish;
  end


endmodule
//------------------------------------------- cputop.v-----------------------------------------------------