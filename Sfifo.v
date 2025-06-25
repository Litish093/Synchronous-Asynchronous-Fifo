`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2025 10:07:59
// Design Name: 
// Module Name: Sfifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sfifo(wen,ren,rst,clk,datain,dataout,full,empty);
input wen,ren,rst;
input clk;
input [2:0]datain;
output reg [2:0]dataout;
output  full,empty;
parameter depth = 8;
reg [2:0] wptr=0;
reg [2:0] rptr=0;
reg [3:0]count;
reg [2:0]mem[0:depth-1];
assign full = (count==depth);
assign empty= (count==0);
always@(posedge clk or posedge rst)
begin 
if(rst)
begin
  wptr <= 0;
end
else if(wen && !full  )
begin
  mem[wptr]<= datain;
  wptr <= wptr + 1;
end
end
always@(posedge clk or posedge rst)
begin
if (rst)
  rptr <= 0;
else if(ren  && !empty  )
begin
  dataout <= mem[rptr];
  rptr <= rptr+1;
end
end

always@(posedge clk or posedge rst)
begin
if(rst)
count<=0;
else if(wen && !ren && !full)
count<=count+1;
else if(ren && !wen && !empty)
count<=count-1;
else if(wen && ren)
count<=count;
end
endmodule
