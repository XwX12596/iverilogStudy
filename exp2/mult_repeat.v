module mult_repeat(c, a, b);
parameter size = 8;
input[size - 1 : 0] a, b;
output [2*size - 1 : 0] c;
reg [2*size - 1 : 0] temp_a, c;
reg [size - 1 : 0] temp_b;
always @(a or b) begin
    c = 0;
    temp_a = a;
    temp_b = b;
    repeat(size) begin
        if(temp_b[0])
            c = c + temp_a;
        temp_a = temp_a << 1;
        temp_b = temp_b >> 1;
    end
end
endmodule