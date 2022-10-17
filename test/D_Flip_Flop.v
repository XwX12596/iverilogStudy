`timescale 1ns/1ps
module d_ff
(
    input wire clk,
    input wire D,
    output reg  Q
);

always @(posedge clk) begin
    Q = D;
end
endmodule

module sitimulus;
	reg clk;
	reg D;
	wire Q;

	d_ff d_ff_d1(
		.clk(clk),
		.D(D),
		.Q(Q)
	);
	integer i;
	
	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0,sitimulus);
		D = 0;
		#8 D=1;
		#10 D=0;
		#10 D=0;
		#10 D=1;
		#10 D=0;
		#10 D=1;
		#40;
	end
	initial begin
		clk = 0;
		for (i = 0;i<=10 ;i=i+1 ) begin
			#10 clk=~clk;
		end
	end

	initial begin
		$monitor("Clock=%d,D=%d,Q=%d\n",clk,D,Q);
	end
endmodule