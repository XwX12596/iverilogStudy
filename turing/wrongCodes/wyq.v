module tuling(input  [1:10] Dig_1,input  [1:10] Dig_2);
integer i;
reg [0:1] control;
reg flag;
initial begin
    i = 1;
    control = 2'b01;
    flag = 0;
end
while(!flag) begin
    case (control)
        2'b00:
            if(Dig_1[i] == 1) begin
                Dig_1[i] == 0;
            else
                  i = i + 1;
                  assign control = 2'b01;   
            end;
        2'b01:
            if(Dig_1[i] == 1) begin
                i = i + 1;
            else
                  Dig_1[i] == 1;
                  assign control = 2'b10;   
            end;
        2'b10:
            if(Dig_1[i] == 1) begin
               i = i + 1;
            else
                  i = i - 1;
                  assign control = 2'b11;   
            end;
        2'b11:
            if(Dig_1[i] == 1) begin
                Dig_1[i] == 0;
                assign flag = 1; 
            end;
    endcase
    assign Dig_2 = Dig_1;
end
