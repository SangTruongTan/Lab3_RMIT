module Decoder(
    Minutes,
    Seconds,
    Min_up,
    Min_down,
    Sec_up,
    Sec_down
);

    input [7:0] Minutes;
    input [7:0] Seconds;

    output [3:0] Min_up;
    output [3:0] Min_down;
    output [3:0] Sec_up;
    output [3:0] Sec_down;

assign Min_up = Minutes[7:4];
assign Min_down = Minutes[3:0];
assign Sec_up = Seconds[7:4];
assign Sec_down = Seconds[3:0];


endmodule
