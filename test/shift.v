module shifter
#(parameter N = 8)
(
    input wire clk,rst,
    output wire s_in,
    output wire s_out
);

reg [N-1:0] r_reg;
wire [N-1:0] r_next;

always @(posedge clk, negedge rst)
begin
    if(~rst)
        r_reg <= 0;
    else
        r_reg <= r_next;
end

assign r_next = {s_in, r_reg[N-1:1]};
assign s_out = r_reg[0];

endmodule