//Attention: Because this system will be run in real time. It's too large to
//simulation by ModelSim in exactly time scale. So, we change the time scale.
//Specifically, In this file, we select the divisor (in the module clock
//divider) to 2. If this system need to be verified on the FPGA prototype,
//we change this factor return 5000000 as the its above lines. We don't need
//to change anything in the test bench if we run on the factor is 2. The time
//run of the test bench should be 10ns. Some of signals need to be added as
//start_stop, lap_reset, rstn, Counter(stopwatch), LapCounter(stopwatch),
//state(fsm1), EHEX_Decimal, EHEX and HEX for each 7-segment element.
//The HEX7 HEX6: HEX5 HEX 4 represent for minutes:seconds of the current time,
//The HEX3 HEX 2: HEX1 HEX0 equivalent for the lap time.

module StopWatch(
    start_stop,
    lap_reset,
    rstn,
    clk,
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5,
    HEX6,
    HEX7
);

localparam [1:0]
    Reset = 2'b00,
    Start = 2'b01,
    Stop  = 2'b10,
    LapRecords = 2'b11;

input start_stop;
input lap_reset;
input rstn;
input clk;

output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;
output [6:0] HEX6;
output [6:0] HEX7;

wire clk_10;
reg updated_lap;

reg [1:0] state;

//Counter
reg [15:0] Counter;
reg [15:0] Lap_Counter;


//Assign FSM
FSM fsm1(.start_stop(start_stop),
         .lap_reset(lap_reset),
         .updated_lap(updated_lap),
         .state(state),
         .rstn(rstn));

//Clock dividor
Clock_divider clk1(.clock_in(clk),
              .clock_out(clk_10));

//Display for Time counter
Display_Four displayfour1(.Time(Counter),
                          .HEX3(HEX7),
                          .HEX2(HEX6),
                          .HEX1(HEX5),
                          .HEX0(HEX4)); //Choose HEX7 to HEX4 for time display

Display_Four displayfour2(.Time(Lap_Counter),
                          .HEX3(HEX3),
                          .HEX2(HEX2),
                          .HEX1(HEX1),
                          .HEX0(HEX0)); //Choose HEX3 to HEX0 for lap time

initial begin
    Counter <= 16'd0;
    Lap_Counter <= 16'd0;
    updated_lap <= 1'b0;
end

always @(posedge clk_10) begin
    case (state)
        Reset: begin
            Counter <= 16'd0;
            Lap_Counter <= 16'd0;
        end
        Start: begin
            Counter <= Counter + 16'd1;
            updated_lap <= 1'b0;
        end
        Stop: begin
            Counter <= Counter;
        end
        LapRecords: begin
            Lap_Counter <= Counter;
            updated_lap <= 1'b1;
            Counter <= Counter + 16'd1;
        end
    endcase
end



endmodule


//Display Minutes and Seconds (Four 7-segment elements)
module Display_Four(
    Time,
    HEX0,
    HEX1,
    HEX2,
    HEX3
);

parameter TimeCoefficent = 4'd10; //Time Coefficent, 10 means ms precision, 1 means s precision.

input [15:0] Time;

output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;

reg [7:0] Minutes;
reg [7:0] Seconds;
reg [15:0] TimeScale;

reg [15:0] TempMinutes;
reg [15:0] TempSeconds;

//Assign Module to display minutes and seconds
Display_Two dis1(.Time(Minutes),
            .HEX1(HEX3),
            .HEX0(HEX2));

Display_Two dis2(.Time(Seconds),
            .HEX1(HEX1),
            .HEX0(HEX0));

always @(Time) begin
    TimeScale = Time/TimeCoefficent;
    TempMinutes = TimeScale/60;
    Minutes = TempMinutes[7:0];
    TempSeconds = TimeScale - Minutes*60;
    Seconds =TempSeconds[7:0];
end

endmodule

//Display Minutes or Seconds (Two 7-segment elements)
module Display_Two(
    Time,
    HEX0,
    HEX1
);

input [7:0] Time;

output reg [6:0] HEX0;
output reg [6:0] HEX1;

reg [3:0] Dozens;
reg [3:0] Units;

//Assign 7 segment module
Display_Seven display1(.In(Dozens),
                       .Out(HEX1));

Display_Seven display2(.In(Units),
                       .Out(HEX0));

always @(Time) begin
    Dozens <= Time/10%10;
    Units <= Time%10;
end

endmodule

//Clock divider to divide 50Mhz to 10 Hz
module Clock_divider(clock_in,clock_out
    );
input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;

//Changes here.
// parameter DIVISOR = 28'd5000000;
parameter DIVISOR = 28'd2;

always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
end
endmodule
