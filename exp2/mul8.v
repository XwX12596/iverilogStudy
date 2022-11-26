module mul8(a, b, c);
input [7:0] a, b;
output  reg [15:0] c;
reg [15:0] t;
integer k;
always @(a or b) begin
    t = a;
    c = 0;
    for (k=0 ; k<8; k=k+1) begin
        if(b[k])
            c = t + c;
        t = t << 1;
    end
end
endmodule