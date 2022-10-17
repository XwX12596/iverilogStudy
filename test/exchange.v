`timescale 1ns/1ps

module exchange;
    reg a, b;
    initial begin
        a = 0;
        b = 0;
        #10
        a = 1;
        b = 2;
    end
    always begin
        #10
        a <= b;
        b <= a;
        if ($time >= 100) $finish;
    end
    initial begin
        $dumpfile("ex.vcd");
        $dumpvars;
    end
endmodule
