module Driver (
    clk2,
    read,
    write,
    rstn,
    CE,
    IO,
    SCLK,
    Minutes,
    Seconds
);

    parameter Hours_default = 8'h13;
    parameter Minutes_default = 8'h24;
    parameter Seconds_default = 8'h30;
    input clk2;
    input read;
    input write;
    input rstn;
    output reg CE;
    inout IO;
    output reg SCLK;
    output reg [7:0] Minutes;
    output reg [7:0] Seconds;

    reg clk2;
    reg [7:0] wr_addr;
    reg [7:0] wr_data;
    reg [1:0] dir;
    reg start;
    wire [7:0] rd;
    wire finish;

//Internal reg
    reg write_process;
    reg read_process;
    reg [7:0] process_cnt;
    logic finish_process;

    wire [7:0] rd_1;
    wire [7:0] rd_2;
    logic sel;

DeMux demux1(.PortIn(rd),
             .Port1(rd_1),
             .Port2(rd_2),
             .Sel(sel));

//Assign SPI module
SPI spi1(.clk(clk2),
         .wr_addr(wr_addr),
         .wr_data(wr_data),
         .dir(dir),
         .start_rw(start),
         .io(IO),
         .ce(CE),
         .sclk(SCLK),
         .rd(rd),
         .finish(finish),
         .reset(rstn));

always @(posedge read_process or
         posedge write_process or
         posedge finish or posedge clk2 or negedge rstn) begin
    if(rstn == 1'b0) begin
        process_cnt = 8'd0;
        start = 1'b1;
        wr_addr = 8'h0;
        wr_data = 8'h0;
        dir = 2'b00;
        Minutes = 8'h0;
        Seconds = 8'h0;
        sel = 1'b0;
        finish_process = 1'b0;
    end else begin
            case (process_cnt)
                8'd0: begin
                    //Select read or write
                    finish_process = 1'd0;
                    if(read_process == 1'b1)
                        process_cnt = 8'd1;
                    else if(write_process == 1'b1)
                        process_cnt = 8'd9;
                end
                8'd1: begin
                    //Read seconds
                    wr_addr = 8'h81;
                    dir = 2'b01;
                    start = 1'b0;
                    process_cnt = 8'd2;
                end
                8'd2: begin process_cnt = 8'd3;
                end
                8'd3: begin
                    start = 1'b1;
                    process_cnt = 8'd4;
                    sel = 1'b0;
                end
                8'd4: begin
                    process_cnt = 8'd4;
                    start = 1'b1;
                    dir = 2'b01;
                    wr_addr = 8'h81;
                    if(finish == 1'b1) begin
                        //Assign Seconds
                        Seconds = rd_1;
                        start = 1'b0;
                        //Read minutes
                        wr_addr = 8'h83;
                        process_cnt = 8'd5;
                    end
                end
                8'd5: begin process_cnt = 8'd6;
                end
                8'd6: begin
                    sel = 1'b1;
                    start = 1'b1;
                    process_cnt = 8'd7;
                end
                8'd7: begin
                    process_cnt = 8'd7;
                    sel = 1'b1;
                    start = 1'b1;
                    dir = 2'b01;
                    if(finish == 1'b1) begin
                        //Assign minutes
                        Minutes = rd_2;
                        //Reset Spi module
                        dir = 2'b00;
                        start = 1'b0;
                        process_cnt = 8'd8;
                    end
                end
                8'd8: begin
                    //Jump to 20 (end)
                    process_cnt = 8'd20;
                    start = 1'b1;
                    finish_process = 1'b1;
                end
                4'd9: begin
                    //Write seconds
                    wr_addr = 8'h80;
                    wr_data = Seconds_default;
                    dir = 2'b10;
                    start = 1'b0;
                    process_cnt = 8'd10;
                end
                8'd10: begin process_cnt = 8'd11;
                end
                8'd11: begin
                    start = 1'b1;
                    process_cnt = 8'd12;
                end
                8'd12: begin
                    process_cnt = 8'd12;
                    start = 1'b1;
                    dir = 2'b10;
                    wr_data = Seconds_default;
                    //Write minutes
                    if(finish == 1'b1) begin
                        wr_addr = 8'h82;
                        wr_data = Minutes_default;
                        start = 1'b0;
                        process_cnt = 8'd13;
                    end
                end
                8'd13: begin process_cnt = 8'd14;
                end
                8'd14: begin
                    start = 1'b1;
                    process_cnt = 8'd15;
                end
                8'd15: begin
                    process_cnt = 8'd15;
                    start = 1'b1;
                    dir = 2'b10;
                    wr_data = Minutes_default;
                    //Write hour
                    if(finish == 1'b1) begin
                        wr_addr = 8'h84;
                        wr_data = Hours_default;
                        start = 1'b0;
                        process_cnt = 8'd16;
                    end
                end
                8'd16: begin process_cnt = 8'd17;
                end
                8'd17: begin
                    start = 1'b1;
                    process_cnt = 8'd18;
                end
                8'd18: begin
                    start = 1'b1;
                    process_cnt = 8'd18;
                    dir = 2'b10;
                    if(finish == 1'b1) begin
                        dir = 2'b00;
                        start = 1'b0;
                        process_cnt = 8'd19;
                    end
                end
                8'd19: begin
                    process_cnt = 8'd20;
                    start = 1'b1;
                    finish_process = 1'b1;
                end
                default: process_cnt = 8'd0;
            endcase
    end
end

always @(posedge finish_process or posedge clk2 or negedge rstn) begin
    if(rstn == 1'b0) begin
        read_process = 1'b0;
        write_process = 1'b0;
    end else begin
        if(finish_process == 1'b1) begin
            read_process = 1'b0;
            write_process = 1'b0;
        end else begin
            if(read_process == 1'b0 && write_process == 1'b0) begin
                if(read == 1'b0)
                    read_process = 1'b1;
                else if(write == 1'b0)
                    write_process = 1'b1;
            end
        end
    end
end

endmodule
