module DeMux(
    Port1,
    Port2,
    PortIn,
    Sel
);
    input [7:0] PortIn;
    output reg [7:0] Port1;
    output reg [7:0] Port2;
    input Sel;

    always @(*) begin
        if(Sel == 1'b0)
            Port1 = PortIn;
        else
            Port2 = PortIn;
    end
endmodule
