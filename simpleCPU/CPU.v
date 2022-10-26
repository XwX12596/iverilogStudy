`include "accum.v"
`include "addr.v"
`include "alu.v"
`include "clk.v"
`include "control.v"
`include "counter.v"
`include "datactl.v"
`include "machinect.v"
`include "ram.v"
`include "register.v"
`include "rom.v"
module CPU(clk, reset, halt, rd, wr, addr,
    data, opcode, fetch, ir_addr, pc_addr);
input clk;
input reset;
output wire halt;
output wire rd;
output wire wr;
output wire fetch;
output wire[5:0] addr;
output wire[7:0] data;
output wire[1:0] opcode;
output wire[5:0] ir_addr;
output wire[5:0] pc_addr;

wire [7:0]alu_out;
wire [7:0] accum_out;
wire [7:0] alu_in;
wire alu_clk;
wire zero;
wire inc_pc;
wire load_acc;
wire load_pc;
wire load_ir;
wire datactl_ena;
wire clk;
wire clk1;
wire control_ena;

clk clk_u(
    .clk(clk),
    .clk1(clk1),
    .fetch(fetch),
    .alu_ena(alu_clk)
);

control control_u(
    .inc_pc(inc_pc),
    .load_acc(load_acc),
    .load_pc(load_pc),
    .rd(rd),
    .wr(wr),
    .load_ir(load_ir),
    .datactl_ena(datactl_ena),
    .halt(halt),
    .clk1(clk1),
    .zero(zero),
    .ena(control_ena),
    .opcode(opcode)
);

alu alu_u(
    .alu_out(alu_out),
    .zero(zero),
    .data(alu_in),
    .accum(accum_out),
    .opcode(opcode),
    .alu_clk(alu_clk)
);

accum accum_u(
    .accum(accum_out),
    .data(alu_out),
    .ena(load_acc),
    .clk1(clk1),
    .rst(reset)
);

datactl datactl_u(
    .data(data),
    .in(alu_out),
    .data_ena(datactl_ena)
);

register register_u (
    .opcode(opcode),
    .ir_addr(ir_addr),
    .data(alu_in),
    .ena(load_ir),
    .clk1(clk1),
    .rst(reset)
);

addr addr_u(
    .addr(addr),
    .fetch(fetch),
    .ir_addr(ir_addr),
    .pc_addr(pc_addr)
);

counter counter_u(
    .pc_addr(pc_addr),
    .ir_addr(ir_addr),
    .load(load_pc),
    .clk(inc_pc),
    .rst(reset)
);

ram ram_u(
    .data(alu_in),
    .addr(addr),
    .read(rd),
    .ena(fetch)
);

rom rom_u(
    .data(alu_in),
    .addr(addr),
    .read(rd),
    .ena(fetch)
);

machinect machinect_u(
    .ena(control_ena),
    .fetch(fetch),
    .rst(reset),
    .clk1(clk1)
);

endmodule