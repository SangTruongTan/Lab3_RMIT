module Display_Seven(
    In,
    Out
);


input [3:0] In;
output reg [6:0] Out;       //Reference to DE2 Kit

//Please be informed that it's 7 segment code from the DE kit prototype
always @(In) begin
    case(In)
        4'h0: Out = 7'b000_0001;
        4'h1: Out = 7'b100_1111;
        4'h2: Out = 7'b001_0010;
        4'h3: Out = 7'b000_0110;
        4'h4: Out = 7'b100_1100;
        4'h5: Out = 7'b010_0100;
        4'h6: Out = 7'b010_0000;
        4'h7: Out = 7'b000_1111;
        4'h8: Out = 7'b000_0000;
        4'h9: Out = 7'b000_0100;
        4'ha: Out = 7'b000_1000;
        4'hb: Out = 7'b110_0000;
        4'hc: Out = 7'b011_0001;
        4'hd: Out = 7'b100_0010;
        4'he: Out = 7'b011_0000;
        4'hf: Out = 7'b011_1000;
        default: Out = 7'b000_0001;
    endcase
end



endmodule
