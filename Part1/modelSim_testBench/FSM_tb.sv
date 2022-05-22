module FSM_tb;

    logic start_stop;
    logic lap_reset;
    logic updated_lap;
    logic rstn;

    wire [1:0] state;
    localparam [1:0]
        Reset = 2'b00,
        Start = 2'b01,
        Stop  = 2'b10,
        LapRecords = 2'b11;

//FSM
FSM fsm1(.start_stop(start_stop),
         .lap_reset(lap_reset),
         .updated_lap(updated_lap),
         .state(state),
         .rstn(rstn));

initial begin
    #0
    start_stop = 1'b1;
    lap_reset = 1'b1;
    updated_lap = 1'b0;
    rstn = 1'b1;
    $display("[time =%0t]Start TB", $time);
    #40
    $display("[time =%0t]Start/Stop = 0 => Start State", $time);
    start_stop = 1'b0;
    #40
    start_stop = 1'b1;
    #40
    $display("[time =%0t]Lap/Reset = 0 => Lap Records state", $time);
    lap_reset = 1'b0;
    #40
    $display("[time =%0t]Updated Lap = 1 => Start State", $time);
    lap_reset = 1'b1;
    updated_lap = 1'b1;
    #40
    $display("[time =%0t]Start/Stop = 0 => Start state", $time);
    updated_lap = 1'b0;
    start_stop = 1'b0;
    #40
    start_stop = 1'b1;
    #40
    $display("[time =%0t]Lap/Reset = 0 => Reset state", $time);
    lap_reset = 1'b0;
    #40
    lap_reset = 1'b1;
    #100
    $display("[time =%0t]Finish test bench", $time);
    $stop;

end

endmodule
