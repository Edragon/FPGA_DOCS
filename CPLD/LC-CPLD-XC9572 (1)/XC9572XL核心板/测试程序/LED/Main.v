`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:43:46 07/19/2011 
// Design Name: 
// Module Name:    Main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Main(
   iCLK,
	oLED
	 );

input iCLK;
output [3:0]oLED;

reg [24:0]sr_counter = 25'b0;
reg [3:0]sr_led = 4'b1110;

assign oLED = sr_led;

always@(posedge iCLK)
	if(sr_counter >= 25'd25000000)
		sr_counter <= 1'b0;
	else
		sr_counter <= sr_counter + 1'b1;

always@(posedge iCLK)
	if(sr_counter >= 25'd25000000)
		sr_led <= {sr_led[2:0],sr_led[3]};
	else
		sr_led <= sr_led;

endmodule
