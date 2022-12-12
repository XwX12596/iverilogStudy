module mpc(instr, out);
    input   [17:0] instr;
    output reg  [8:0] out;
    reg func;
    reg [7:0] op1, op2;
    function [16:0] code_add;
        input [17:0] instr;
        reg add_func;
        reg [7:0] code, opr1, opr2;
        begin
            code = instr[17:16];
            opr1 = instr[7:0];
            case(code)
                2'b00:
                    begin
                        add_func = 1;
                        opr2 = instr[15:8];
                    end
                2'b01:
                    begin
                        add_func = 0;
                        opr2 = instr[15:8];
                    end
                2'b10:
                    begin
                        add_func = 1;
                        opr2 = 8'd1;
                    end
                2'b11:
                    begin
                        add_func = 0;
                        opr2 = 8'd1;
                    end
            endcase
            code_add = {add_func, opr2, opr1};
        end
    endfunction

always @(instr) begin
    {func, op2, op1} = code_add(instr);
    if (func==1)
        out = op1 + op2;
    else
        out = op1 - op2;
end
endmodule

//~ `New testbench
`timescale  1ns / 1ps

module tb_mpc;

// mpc Parameters
parameter PERIOD  = 10;


// mpc Inputs
reg   [17:0]  instr                        = 0 ;

// mpc Outputs
wire  [8:0]  out                           ;


initial
begin
    #(PERIOD*2)
    instr = 18'b00_01110010_10001011;
    #(PERIOD)
    instr = 18'b01_01110010_10001011;
    #(PERIOD)
    instr = 18'b10_01110010_10001011;
    #(PERIOD)
    instr = 18'b11_01110010_10001011;
end

mpc  u_mpc (
    .instr                   ( instr  [17:0] ),

    .out                     ( out    [8:0]  )
);

initial
begin
    $dumpfile("mpv.vcd");
    $dumpvars;
end

initial
begin
    #(PERIOD*6)
    $finish;
end

endmodule