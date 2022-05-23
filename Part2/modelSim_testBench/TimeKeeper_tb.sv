module TimeKeeper_tb;

    parameter SEVENSEGMENT_LENGTH = 7;
    parameter DATA_LENGTH = 8;
    parameter UNITS_LENGTH = 4;

    localparam  LED_0 = 7'b000_0001,
                LED_1 = 7'b100_1111,
                LED_2 = 7'b001_0010,
                LED_3 = 7'b000_0110,
                LED_4 = 7'b100_1100,
                LED_5 = 7'b010_0100,
                LED_6 = 7'b010_0000,
                LED_7 = 7'b000_1111,
                LED_8 = 7'b000_0000,
                LED_9 = 7'b000_0100;

    logic read;
    logic write;
    logic rstn;
    logic clk50;

    wire CE;
    wire IO;
    wire SCLK;

    wire [SEVENSEGMENT_LENGTH - 1:0] LED3;
    wire [SEVENSEGMENT_LENGTH - 1:0] LED2;
    wire [SEVENSEGMENT_LENGTH - 1:0] LED1;
    wire [SEVENSEGMENT_LENGTH - 1:0] LED0;

//To drive the inout pin
logic dir_io;
logic gen_io;

assign IO = dir_io? gen_io : 1'bz;

//Assign TimeKeeper module
TimeKeeper time1(.read(read),
                 .write(write),
                 .rstn(rstn),
                 .clk50(clk50),
                 .CE(CE),
                 .IO(IO),
                 .SCLK(SCLK),
                 .LED3(LED3),
                 .LED2(LED2),
                 .LED1(LED1),
                 .LED0(LED0));


initial begin
    #0
    $display("[time =%0t]Intialize the test bench", $time);
    read = 1'b1;
    write = 1'b1;
    rstn = 1'b1;
    clk50 = 1'b0;
    dir_io = 1'b0;
    gen_io = 1'b0;
    if(LED0 != LED_0 || LED1 != LED_0 || LED2 != LED_0 || LED3 != LED_0 ) begin
        $display("[time =%0t]Wrong value output led", $time);
        #1000
        $stop;
    end
    #100
    rstn = 1'b0;
    #100
    rstn = 1'b1;
    #100
    $display("[time =%0t]Read times and write to the 7 Segment led", $time);
    read = 1'b0;
    #5000
    read = 1'b1;
    #15900
    $display("[time =%0t]Simualate the seconds from DS1302", $time);
    dir_io = 1'b1;
    gen_io = 1'b1;
    #6000
    gen_io = 1'b0;
    #2000
    gen_io = 1'b1;
    #4000
    gen_io = 1'b0;
    #4000
    dir_io = 1'b0;
    $display("[time =%0t]Simualate the senconds complete", $time);
    #1500
    if(LED0 == LED_7 && LED1 == LED_3 && LED2 == LED_0 && LED3 == LED_0) begin
        $display("[time =%0t]The seconds is 37s", $time);
    end else begin
        $display("[time =%0t]Wrong value", $time);
        #1000
        $stop;
    end
    #2500
    $display("[time =%0t]Simualate the minutes from DS1302", $time);
    #17500
    dir_io = 1'b1;
    gen_io = 1'b0;
    #6000
    gen_io = 1'b1;
    #6000
    gen_io = 1'b0;
    #4000
    dir_io = 1'b0;
    #500
    if(LED0 == LED_7 && LED1 == LED_3 && LED2 == LED_8 && LED3 == LED_3) begin
        $display("[time =%0t]The minutes is 38m", $time);
    end else begin
        $display("[time =%0t]Wrong value", $time);
        #1000
        $stop;
    end
    #3000
    $display("[time =%0t]Write process", $time);
    write = 1'b0;
    #5000
    write = 1'b1;
    #110000
    $display("[time =%0t]Write process successfully", $time);
    #1000
    $display("[time =%0t]Read times and write to the 7 Segment led in second time", $time);
    read = 1'b0;
    #5000
    read = 1'b1;
    #16000
    $display("[time =%0t]Simualate the seconds from DS1302", $time);
    dir_io = 1'b1;
    gen_io = 1'b1;
    #4000
    gen_io = 1'b0;
    #4000
    gen_io = 1'b1;
    #2000
    gen_io = 1'b0;
    #6000
    dir_io = 1'b0;
    $display("[time =%0t]Simualate the senconds complete", $time);
    #1500
    if(LED0 == LED_3 && LED1 == LED_1 && LED2 == LED_8 && LED3 == LED_3) begin
        $display("[time =%0t]The seconds is 13s, minutes still 38", $time);
    end else begin
        $display("[time =%0t]Wrong value", $time);
        #1000
        $stop;
    end
    #2500
    $display("[time =%0t]Simualate the minutes from DS1302", $time);
    #17500
    dir_io = 1'b1;
    gen_io = 1'b1;
    #2000
    gen_io = 1'b0;
    #2000
    gen_io = 1'b1;
    #2000
    gen_io = 1'b0;
    #4000
    gen_io = 1'b1;
    #2000
    gen_io = 1'b0;
    #4000
    #500
    if(LED0 == LED_3 && LED1 == LED_1 && LED2 == LED_5 && LED3 == LED_2) begin
        $display("[time =%0t]The minutes is 45m", $time);
    end else begin
        $display("[time =%0t]Wrong value", $time);
        #1000
        $stop;
    end
    #10000
    $display("[time =%0t]Reset", $time);
    rstn = 1'b0;
    #1000
    rstn = 1'b1;
    if(LED0 == LED_0 && LED1 == LED_0 && LED2 == LED_0 && LED3 == LED_0) begin
        $display("[time =%0t]Reset successfully", $time);
    end else begin
        $display("[time =%0t]Can not reset", $time);
    end
    #1000
    $stop;

end


always begin
    #20 clk50 = !clk50;
end

endmodule
