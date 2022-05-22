module SPI_tb;

logic clk;	// clock for this module
logic[7:0] wr_addr;
logic[7:0] wr_data;
logic[1:0] dir;  // 1 in dir[1] means output data, 1 in dir[0]means read data
logic start_rw;

wire io;  //input and output data

wire ce; //enable the ds1302
wire sclk;//clock for ds1302
wire [7:0] rd;
wire finish;

//To drive the inout pin
logic dir_io;
logic gen_io;

assign io = dir_io? gen_io : 1'bz;

SPI spi1(.clk(clk),
         .wr_addr(wr_addr),
         .wr_data(wr_data),
         .dir(dir),
         .start_rw(start_rw),
         .io(io),
         .ce(ce),
         .sclk(sclk),
         .rd(rd),
         .finish(finish));

initial begin
    #0
    $display("[time =%0t]Intialize the test bench", $time);
    start_rw = 1'b1;
    clk = 1'b0;
    wr_addr = 8'h0;
    wr_data = 8'h0;
    dir = 2'b0;
    dir_io = 1'b0;
    gen_io = 1'b1;
    #40
    $display("[time =%0t]Simulate read process", $time);
    wr_addr = 8'h8A;
    dir = 2'b01;
    start_rw = 1'b0;
    #45
    start_rw = 1'b1;
    #700
    dir_io = 1'b1;
    gen_io = 1'b1;
    #400
    gen_io = 1'b0;
    #300
    $display("[time =%0t]Simulate write process", $time);
    dir = 2'b10;
    dir_io = 1'b0;
    wr_addr = 8'h82;
    wr_data = 8'hBA;
    start_rw = 1'b0;
    #45
    start_rw = 1'b1;
    #1600
    dir = 2'b00;
    start_rw = 1'b0;
    #45
    start_rw = 1'b1;
    #200
    $display("[time =%0t]Finish simulation", $time);
    $stop;

end

always begin
    #20 clk = !clk;
end

endmodule
