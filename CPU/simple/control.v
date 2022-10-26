`timescale 1ns/1ns
module control(inc_pc, load_acc, load_pc,
 rd,wr, load_ir, datactl_ena, halt, clk1, 
 zero, ena, opcode );

output inc_pc, load_acc, load_pc, rd, wr, load_ir;
output datactl_ena, halt;
input clk1, zero, ena;
input [1:0] opcode;
reg inc_pc, load_acc, load_pc, rd, wr, load_ir;
reg datactl_ena, halt;
reg [2:0] state;

parameter 	JMP  = 2 'b00,
			INC  = 2 'b01,
			DEC  = 2 'b10,
			ADD  = 2 'b11;

always @( negedge clk1 )
if ( !ena )	begin	//接收到复位信号RST，进行复位操作	
	state<=3'b000;
	{inc_pc,load_acc,load_pc,rd}<=4'b0000;
	{wr,load_ir,datactl_ena,halt}<=4'b0000;
end
else begin
	casex(state)
	3'b000: begin		// idle		
		{inc_pc,load_acc,load_pc,rd}<=4'b0000;
		{wr,load_ir,datactl_ena,halt}<=4'b0000;
		state<=3'b001;
	end
	3'b001: begin		// idle		
		{inc_pc,load_acc,load_pc,rd}<=4'b0000;
		{wr,load_ir,datactl_ena,halt}<=4'b0000;
		state<=3'b010;
	end
	3'b010:	begin		// 读一条指令		
		{inc_pc,load_acc,load_pc,rd}<=4'b0001;
		{wr,load_ir,datactl_ena,halt}<=4'b0100;
		state<=3'b011;
	end
	3'b011:begin		//next instruction address setup 分析指令从这里开始		
		{inc_pc,load_acc,load_pc,rd}<=4'b1000;
		{wr,load_ir,datactl_ena,halt}<=4'b0000;
		state<=3'b100;
	end

	3'b100:	begin		//fetch oprand		
		if(opcode==JMP) begin
			{inc_pc,load_acc,load_pc,rd}<=4'b0010;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;
		end
		else if( opcode==ADD) begin//暂时只加一调指令？		
			{inc_pc,load_acc,load_pc,rd}<=4'b0001;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;
		end	
		else begin
			{inc_pc,load_acc,load_pc,rd}<=4'b0000;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;
		end
		state<=3'b101;
	end

	3'b101:		// operation
		begin
		if ( opcode==ADD) begin //过一个时钟后与累加器的内容进行运算
			{inc_pc,load_acc,load_pc,rd}<=4'b0101;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;
		end			
		else if(opcode==INC||opcode==DEC)
			begin
			{inc_pc,load_acc,load_pc,rd}<=4'b0100;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;			
			end
		else if(opcode==JMP)
			begin
			{inc_pc,load_acc,load_pc,rd}<=4'b1010;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;
			end	
		else
			begin
			{inc_pc,load_acc,load_pc,rd}<=4'b0000;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;
			end	
		state<=3'b110;
		end

	3'b110:	begin	//idle			
		if ( opcode==ADD||opcode==INC||opcode||DEC ) begin
			{inc_pc,load_acc,load_pc,rd}<=4'b0001;
			{wr,load_ir,datactl_ena,halt}<=4'b0010;
		end
		else begin
			{inc_pc,load_acc,load_pc,rd}<=4'b0000;
			{wr,load_ir,datactl_ena,halt}<=4'b0000;
			end
			state<=3'b111;
	end

	3'b111:	begin
		{inc_pc,load_acc,load_pc,rd}<=4'b0000;
		{wr,load_ir,datactl_ena,halt}<=4'b0000;
		state<=3'b000;
	end
	default: begin
		{inc_pc,load_acc,load_pc,rd}<=4'b0000;
		{wr,load_ir,datactl_ena,halt}<=4'b0000;
		state<=3'b000;
	end
	endcase
end
endmodule