module counter
#(parameter N = 4)
(
    input wire clk, rst,
    output wire [N-1:0] bin
);

reg [N-1:0]r;
wire [N-1:0]r_next;

always @(posedge clk or negedge rst) begin
    if(~rst)
        r <= 0;
    else
        r <= r_next;
end
assign bin = r;
assign r_next = r + 1;
endmodule