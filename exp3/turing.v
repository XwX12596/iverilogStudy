module turing(clk,rst,seq,a,b,c);

input				clk, rst;
input 		[2:0]	a, b;
output reg	[3:0]	c;
output reg	[18:0]	seq;
wire		[7:0]	da, db;
reg		 	[2:0] 	state;
integer 			k;
parameter 	Q1_0 = 3'b00_0,
			Q1_1 = 3'b00_1,
			Q2_0 = 3'b01_0,
			Q2_1 = 3'b01_1,
			Q3_0 = 3'b10_0,
			Q3_1 = 3'b10_1,
			Q4_0 = 3'b11_0,
			Q4_1 = 3'b11_1;

fora 	U1(a,da);
forb	U2(b,db);

always @(posedge clk or negedge rst)
if(!rst)
	begin
		state	<= Q1_1;
		k		<= 8 - b;
		seq 	<= {1'b0,da,1'b0,db,1'b0};
	end
else
	begin
		case(state)
		Q1_1:	// 	q1	1	0	q1
			begin
				state	<= Q1_0;
				seq[k]	<= 0;
			end
		Q1_0:	//	q1	0	R	q2
			begin
				state 	<= Q2_1;
				k		<= k + 1;
			end
		Q2_1:	//	q2	1	R	q2
			begin
				if(seq[k])
						k <= k + 1;
				else
					state <= Q2_0;
			end
		Q2_0:	//	q2	0	1	q3
			begin
				state	<= Q3_1;
				seq[k]	<= 1;
			end
		Q3_1:	//	q3	1	R	q3
			begin
				if(seq[k])
					k <= k + 1;
				else
					state 	<= Q3_0;
			end
		Q3_0:	//	q3	0	L	q4
			begin
				k <= k - 1;
				state <= Q4_1;
			end
		Q4_1:	// q4	1	0	q4
			begin
				state	<= Q4_1;
				seq[k]	<= 0;
				// for(k=0;k<=18;k=k+1)
				// 	if(seq[k])
				// 		c<=c+1;
				// c<=c-1;
			end
		default:;
		endcase
	end
endmodule


module fora(a,band);
input 		[2:0]	a;
output reg	[7:0]	band;
always @(a)
	case(a)
		3'b000:band=1'b1;
		3'b001:band=2'b11;
		3'b010:band=3'b111;
		3'b011:band=4'b1111;
		3'b100:band=5'b1_1111;
		3'b101:band=6'b11_1111;
		3'b110:band=7'b111_1111;
		3'b111:band=8'b1111_1111;
	endcase
endmodule

module forb(b,band);
input 		[2:0]	b;
output reg	[7:0]	band;
always @(b)
	case(b)
		3'b000:band=8'b1000_0000;
		3'b001:band=8'b1100_0000;
		3'b010:band=8'b1110_0000;
		3'b011:band=8'b1111_0000;
		3'b100:band=8'b1111_1000;
		3'b101:band=8'b1111_1100;
		3'b110:band=8'b1111_1110;
		3'b111:band=8'b1111_1111;
	endcase
endmodule

//~ `New testbench
`timescale  1ns / 1ps

module tb_turing;

// turing Parameters
parameter PERIOD = 10     ;
parameter Q1_0  = 3'b00_0;

// turing Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   [2:0]  a                             = 0 ;
reg   [2:0]  b                             = 0 ;

// turing Outputs
wire  [3:0]  c                             ;
wire  [18:0]  seq                          ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    a <= 3'b101;
    b <= 3'b101;
    #(PERIOD*2) rst  =  1;
end

turing #(
    .Q1_0 ( Q1_0 ))
    u_turing (
    .clk                     ( clk         ),
    .rst                     ( rst         ),
    .a                       ( a    [2:0]  ),
    .b                       ( b    [2:0]  ),

    .c                       ( c    [3:0]  ),
    .seq                     ( seq  [18:0] )
);

initial
begin
    $dumpfile("turing.vcd");
    $dumpvars;
end

initial
begin
    #(PERIOD*20)
    $finish;
end

endmodule



/*module forc(seq,band);

input		[18:0]	seq;

output reg	[3:0]	band;

integer k;

always @(seq)

begin

	for(k=0;k<=18;k=k+1)

		if(seq[k])

			band=band+1;

	band=band-1;

end

endmodule*/

