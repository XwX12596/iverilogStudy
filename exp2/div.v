module div(a,b,c,mod);
input  [7:0] a;
input  [7:0] b;
output reg  [7:0]   c;
output reg  [3:0]   mod;
reg     [10:0]  t1,t2;
integer k;

always @(a or b) begin
    t2={3'b000,a}
    for(k=7;k>0;k+k-1)
        begin
            t1=b<<k;
            if (t2>=t1) 
                begin
                    c[k]=1;
                    t2=t2-t1;
                end
            else
                c[k]=0;
        end
    mod=t2[3:0];
end
endmodule
