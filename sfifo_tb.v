`timescale 1ns / 1ps

module Sfifo_tb;

  // Parameters and signals
  reg clk, rst;
  reg wen, ren;
  reg [2:0] datain;
  wire [2:0] dataout;
  wire full, empty;

  // Instantiate the DUT
  Sfifo dut (
    .wen(wen),
    .ren(ren),
    .rst(rst),
    .clk(clk),
    .datain(datain),
    .dataout(dataout),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  initial clk = 1'b0;
  always #5 clk = ~clk;

  integer i;

  initial begin
    // Initialize inputs
    rst = 1;
    wen = 0;
    ren = 0;
    datain = 3'b000;

    // Reset pulse
    #10 rst = 0;

    // Write 8 values
    wen = 1;
    for (i = 0; i < 8; i = i + 1) begin
      datain = i[2:0];  // Ensure 3-bit values
      #10;
    end
    wen = 0;

    // Read 8 values
    ren = 1;
    for (i = 0; i < 8; i = i + 1) begin
      #10;
    end
    ren = 0;

    // Write again
    wen = 1;
    for (i = 0; i < 8; i = i + 1) begin
      datain = (i[2:0] + 1);
      #10;
    end
    wen = 0;

    // Read again
    ren = 1;
    for (i = 0; i < 8; i = i + 1) begin
      #10;
    end
    ren = 0;

    #20;
    $stop;
  end
endmodule
