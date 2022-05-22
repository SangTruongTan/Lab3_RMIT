module TimeKeeper (
    read,
    write,
    rstn,
    clk50,
    CE,
    IO,
    SCLK,
    LED3,
    LED2,
    LED1,
    LED0
);

    parameter SEVENSEGMENT_LENGTH = 7;
    parameter DATA_LENGTH = 8;
    parameter UNITS_LENGTH = 4;

    input read;
    input write;
    input rstn;
    input clk50;

    output CE;
    inout IO;
    output SCLK;

    output [SEVENSEGMENT_LENGTH - 1:0] LED3;
    output [SEVENSEGMENT_LENGTH - 1:0] LED2;
    output [SEVENSEGMENT_LENGTH - 1:0] LED1;
    output [SEVENSEGMENT_LENGTH - 1:0] LED0;

//Internal wire
    wire clk2;
    wire [DATA_LENGTH - 1:0] Minutes;
    wire [DATA_LENGTH - 1:0] Seconds;
    wire [UNITS_LENGTH - 1:0] Min_up;
    wire [UNITS_LENGTH - 1:0] Min_down;
    wire [UNITS_LENGTH - 1:0] Sec_up;
    wire [UNITS_LENGTH - 1:0] Sec_down;

//Assign clock divider
Clock_divider clkdiv1(.clock_in(clk50),
                      .clock_out(clk2));

//Assign driver interface
Driver dri1(.clk2(clk2),
            .read(read),
            .write(write),
            .rstn(rstn),
            .CE(CE),
            .IO(IO),
            .SCLK(SCLK),
            .Minutes(Minutes),
            .Seconds(Seconds));

//Assign Decoder module
Decoder dec1(.Minutes(Minutes),
             .Seconds(Seconds),
             .Min_up(Min_up),
             .Min_down(Min_down),
             .Sec_up(Sec_up),
             .Sec_down(Sec_down));

//Assign 7-segment LED
Display_Seven led3(.In(Min_up),
                   .Out(LED3));

Display_Seven led2(.In(Min_down),
                   .Out(LED2));

Display_Seven led1(.In(Sec_up),
                   .Out(LED1));

Display_Seven led0(.In(Sec_down),
                   .Out(LED0));

endmodule
