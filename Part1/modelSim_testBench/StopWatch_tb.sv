module StopWatch_tb;

logic start_stop;
logic lap_reset;
logic rstn;
logic clk;

wire [6:0] HEX0;
wire [6:0] HEX1;
wire [6:0] HEX2;
wire [6:0] HEX3;
wire [6:0] HEX4;
wire [6:0] HEX5;
wire [6:0] HEX6;
wire [6:0] HEX7;

logic [34: 0] testVector[0 : 100];
logic [31 : 0] i;
logic [3:0] EHEX0_Decimal;
logic [3:0] EHEX1_Decimal;
logic [3:0] EHEX2_Decimal;
logic [3:0] EHEX3_Decimal;
logic [3:0] EHEX4_Decimal;
logic [3:0] EHEX5_Decimal;
logic [3:0] EHEX6_Decimal;
logic [3:0] EHEX7_Decimal;

logic [6:0] EHEX0;
logic [6:0] EHEX1;
logic [6:0] EHEX2;
logic [6:0] EHEX3;
logic [6:0] EHEX4;
logic [6:0] EHEX5;
logic [6:0] EHEX6;
logic [6:0] EHEX7;

logic clk_1;

Clock_divider1 clk1(.clock_in(clk),
                    .clock_out(clk_1));

//Assign StopWatch
StopWatch stopwatch(.start_stop(start_stop),
                    .lap_reset(lap_reset),
                    .rstn(rstn),
                    .clk(clk),
                    .HEX0(HEX0),
                    .HEX1(HEX1),
                    .HEX2(HEX2),
                    .HEX3(HEX3),
                    .HEX4(HEX4),
                    .HEX5(HEX5),
                    .HEX6(HEX6),
                    .HEX7(HEX7));

//Assign Module Convert 7-segment code
Convert conv0(.In(EHEX0_Decimal),
              .Out(EHEX0));

Convert conv1(.In(EHEX1_Decimal),
              .Out(EHEX1));

Convert conv2(.In(EHEX2_Decimal),
              .Out(EHEX2));

Convert conv3(.In(EHEX3_Decimal),
              .Out(EHEX3));

Convert conv4(.In(EHEX4_Decimal),
              .Out(EHEX4));

Convert conv5(.In(EHEX5_Decimal),
              .Out(EHEX5));

Convert conv6(.In(EHEX6_Decimal),
              .Out(EHEX6));

Convert conv7(.In(EHEX7_Decimal),
              .Out(EHEX7));

initial begin
    i = 0;
    clk = 1'b0;
    $readmemh("StopWatch_tb_vector.txt", testVector);
end

always @ (posedge clk_1) begin
    {start_stop, lap_reset, rstn, EHEX7_Decimal, EHEX6_Decimal, EHEX5_Decimal,
    EHEX4_Decimal, EHEX3_Decimal, EHEX2_Decimal, EHEX1_Decimal, EHEX0_Decimal}
    = testVector[i];
    if(testVector[i] == 35'd0) begin
        $display("Stop!!! Total Time=%0t", $time);
        #100
        $stop;
    end
end

always @(negedge clk_1) begin
    if(EHEX0 != HEX0 || EHEX1 != HEX1 || EHEX2 != HEX2 || EHEX3 != HEX3 ||
       EHEX4 != HEX4 || EHEX5 != HEX5 || EHEX6 != HEX6 || EHEX7 != HEX7   ) begin
        $display("[time =%0t]Error => Stop at instruction =%0d", $time, {i});
        #100
        $stop;
    end
    i = i + 1;
end

always begin
    #10;
    clk = !clk;
end

endmodule

module Convert(
    In,
    Out
);

input [3:0] In;
output reg [6:0] Out;

localparam LED0 = 7'b000_0001,
           LED1 = 7'b100_1111,
           LED2 = 7'b001_0010,
           LED3 = 7'b000_0110,
           LED4 = 7'b100_1100,
           LED5 = 7'b010_0100,
           LED6 = 7'b010_0000,
           LED7 = 7'b000_1111,
           LED8 = 7'b000_0000,
           LED9 = 7'b000_0100;

always @(In) begin
    case (In)
        4'd0: Out = LED0;
        4'd1: Out = LED1;
        4'd2: Out = LED2;
        4'd3: Out = LED3;
        4'd4: Out = LED4;
        4'd5: Out = LED5;
        4'd6: Out = LED6;
        4'd7: Out = LED7;
        4'd8: Out = LED8;
        4'd9: Out = LED9;
    endcase
end
endmodule

//Clock divider to divide 50Mhz to 1 Hz
module Clock_divider1(clock_in,clock_out
    );
input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd20;

always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
end
endmodule
