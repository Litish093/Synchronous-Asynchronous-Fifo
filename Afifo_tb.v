`timescale 1ns / 1ps

module async_fifo_tb;


reg wclk, rclk, rst;
reg wen, ren;
reg [2:0] datain;
wire [2:0] dataout;
wire full, empty;

Afifo DUT (
    .wen(wen),
    .ren(ren),
    .rclk(rclk),
    .wclk(wclk),
    .datain(datain),
    .dataout(dataout),
    .empty(empty),
    .full(full),
    .rst(rst)
);


always #5  wclk = ~wclk;   
always #8  rclk = ~rclk;  

initial begin
   
    wclk = 0; rclk = 0;
    rst = 1;
    wen = 0; ren = 0;
    datain = 0;

   
    #20 rst = 0;

    
    #10;
    wen = 1;
    ren = 0;
    repeat (8) begin
        @(posedge wclk);
        datain = $random % 8; 
    end
    @(posedge wclk);
    wen = 0;

    
    #20;
    ren = 1;
    repeat (8) begin
        @(posedge rclk);
      
    end
    @(posedge rclk);
    ren = 0;

    #50 $finish;
end

endmodule
