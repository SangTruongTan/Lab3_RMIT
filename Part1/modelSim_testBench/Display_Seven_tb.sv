module Display_Seven_tb;


logic [3:0] In;
wire [6:0] Out;       //Reference to DE2 Kit


module4 mod4(.In(In),
             .Out(Out));

initial begin
    #0
    In = 4'd0;
    #10
    In = 4'd1;
    #10
    In = 4'd2;
    #10
    In = 4'd3;
    #10
    In = 4'd4;
    #10
    In = 4'd5;
    #10
    In = 4'd6;
    #10
    In = 4'd7;
    #10
    In = 4'd8;
    #10
    In = 4'd8;
    #10
    In = 4'ha;
    #10
    In = 4'hb;
    #10
    In = 4'hc;
    #10
    In = 4'hd;
    #10
    In = 4'he;
    #10
    In = 4'hf;
end

endmodule
