module Driver_tb;

logic clk2;
logic read;
logic write;
logic rstn;

wire IO;

wire CE;
wire SCLK;
wire [7:0] Minutes;
wire [7:0] Seconds;

//To drive the inout pin
logic dir_io;
logic gen_io;

assign IO = dir_io? gen_io : 1'bz;


//Driver
Driver driver1(.clk2(clk2),
               .read(read),
               .write(write),
               .rstn(rstn),
               .CE(CE),
               .IO(IO),
               .SCLK(SCLK),
               .Minutes(Minutes),
               .Seconds(Seconds));

initial begin
    #0
    $display("[time =%0t]Intialize the test bench", $time);
    clk2 = 1'b0;
    read = 1'b1;
    write = 1'b1;
    rstn = 1'b1;
    dir_io = 1'b0;
    gen_io = 1'b0;
    #40
    $display("[time =%0t]Read seconds", $time);
    read = 1'b0;
    #100
    read = 1'b1;
    #720
    dir_io = 1'b1;
    gen_io = 1'b0;
    #240
    gen_io = 1'b1;
    #400
    $display("[time =%0t]Read seconds complete", $time);
    dir_io = 1'b0;
    #160
    $display("[time =%0t]Read Minutes", $time);
    #640
    $display("[time =%0t]Put simulated valued", $time);
    dir_io = 1'b1;
    gen_io = 1'b0;
    #160
    gen_io = 1'b1;
    #160
    gen_io = 1'b0;
    #160
    gen_io = 1'b1;
    #160
    dir_io = 1'b0;
    $display("[time =%0t]Read Minutes complete", $time);
    #200
    $display("[time =%0t]Write default times", $time);
    write = 1'b0;
    #40
    write = 1'b1;
    #120
    $display("[time =%0t]Write seconds", $time);
    #1280
    $display("[time =%0t]Write minutes", $time);
    #1440
    $display("[time =%0t]Write hours", $time);
    #1480
    $display("[time =%0t]Write process successfully", $time);
    rstn = 1'b0;
    #100
    $stop;


end

always begin
    #20 clk2 = !clk2;
end



endmodule
