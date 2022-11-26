`include "clk_gen.v"
`include "accum.v"
`include "adr.v"
`include "alu.v"
`include "machine.v"
`include "counter.v"
`include "machinectl.v"
`include "register.v"
`include "datactl.v"

module cpu(clk, reset ,halt, rd, wr, addr, data,
			opcode, fetch,ir_addr, pc_addr);
input 			clk, reset;
output 			rd, wr, halt, fetch;
output	[12:0]	addr, ir_addr,pc_addr;
output	[2:0]	opcode;
inout 	[7:0]	data;

wire 			clk, reset, halt, fetch, alu_ena, rd, wr;
wire 	[7:0]  	data, alu_out, accum;
wire 	[12:0] 	addr, ir_addr,pc_addr;
wire 	[2:0] 	opcode;
wire 			zero, inc_pc, load_acc, load_pc, load_ir, data_ena, contr_ena;

clk_gen  m_clk_gen (.clk(clk),.fetch(fetch),.alu_ena(alu_ena),.reset(reset));

register  m_register (.data(data),.ena(load_ir),.rst(reset),
                                  .clk(clk),.opc_iraddr({opcode,ir_addr}));

accum      m_accum    (.data(alu_out),.ena(load_acc),
                                      .clk(clk),.rst(reset),.accum(accum));

alu        m_alu      (.data(data),.accum(accum),.alu_ena(alu_ena),
                                .opcode(opcode),.alu_out(alu_out),.zero(zero));

machinectl  m_machinecl(.clk(clk), .rst(reset), .fetch(fetch),.ena(contr_ena));

machine    m_machine  (.inc_pc(inc_pc),.load_acc(load_acc),.load_pc(load_pc),
                       .rd(rd), .wr(wr), .load_ir(load_ir), .clk(clk),
                       .datactl_ena(data_ena), .halt(halt), .zero(zero),
                       .ena(contr_ena),.opcode(opcode));

datactl    m_datactl  (.in(alu_out), .data_ena(data_ena), .data(data));

adr        m_adr (.fetch(fetch),.ir_addr(ir_addr),.pc_addr(pc_addr),.addr(addr));

counter    m_counter  (.ir_addr(ir_addr),.load(load_pc),.clock(inc_pc),
                                        .rst(reset),.pc_addr(pc_addr));
endmodule