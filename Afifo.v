`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2025 19:52:11
// Design Name: 
// Module Name: Afifo
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


module Afifo(wen,ren,rclk,wclk,datain,dataout,empty,full,rst);
input rclk,wclk;
input wen,ren;
input rst;
input [2:0]datain;
output reg [2:0]dataout;
output empty,full;
reg [3:0] wptr,rptr;
reg [2:0]mem[0:7];
wire [3:0]wptrb2g;
wire [3:0]rptrb2g;
wire [3:0]syncwptr;
wire [3:0]syncrptr;
always@(posedge wclk or posedge rst)
begin 
if (rst)
wptr<=0;
else if (wen && !full)
begin
 mem[wptr[2:0]]<=datain;
 wptr <= wptr +1;
end
end

always@(posedge rclk or posedge rst)
begin
if(rst)
rptr <=0;
else if (ren && !empty)begin
dataout <= mem[rptr[2:0]];
rptr <= rptr+1;
end
end

assign wptrb2g = wptr ^ wptr >> 1;
assign rptrb2g = rptr ^ rptr >> 1;

synchronizer s1 (rclk,wptrb2g,syncwptr,rst);
synchronizer s2 (wclk,rptrb2g,syncrptr,rst);
wire [3:0] wptrg2b = g2b(syncwptr);

assign full = ({~syncwptr[3:2],syncwptr[1:0]}== syncrptr);
assign empty = (wptrg2b  == rptr);
function [3:0] g2b;
    input [3:0] g;
    integer i;
    reg [3:0] temp;
    begin
        temp[3] = g[3];
        for (i = 2; i >= 0; i = i - 1)
            temp[i] = g[i] ^ temp[i+1];
        g2b = temp;  // Return assignment
    end
endfunction




    
endmodule

module synchronizer(clk,ptr1,ptr2,rst);
input clk,rst;
input [3:0]ptr1;
output reg [3:0]ptr2;
reg [3:0]ptr3;
always@ (posedge clk or posedge rst)
begin 
if(rst)
begin
ptr3<=0;
ptr2<=0;
end
else
begin 
ptr3<=ptr1;
ptr2<=ptr3;
end
end
endmodule

