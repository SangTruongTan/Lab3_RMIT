module FSM(
    start_stop,
    lap_reset,
    updated_lap,
    state,
    rstn
);
    input start_stop;
    input lap_reset;
    input updated_lap;
    input rstn;

    output reg [1:0] state;
    localparam [1:0]
        Reset = 2'b00,
        Start = 2'b01,
        Stop  = 2'b10,
        LapRecords = 2'b11;

    initial begin
        state = Reset;
    end

    always @(negedge start_stop or negedge lap_reset or posedge updated_lap or negedge rstn) begin
        if(rstn == 1'b0) begin
            state = Reset;
        end else begin
            case (state)
            Reset: begin
                if(start_stop == 1'b0) begin
                    state = Start;
                end
            end
            Start: begin
                if(start_stop == 1'b0) begin
                    state = Stop;
                end else if(lap_reset == 1'b0) begin    //Prevent hold both button
                    state = LapRecords;                 //Prioritize start//stop
                end
            end
            Stop: begin
                if(lap_reset == 1'b0) begin
                    state = Reset;
                end else if (start_stop == 1'b0) begin  //Prioritize lap/reset
                    state = Start;
                end
            end
            LapRecords: begin
                if(updated_lap == 1'b1) begin
                    state = Start;
                end
            end
        endcase
        end

    end

endmodule
