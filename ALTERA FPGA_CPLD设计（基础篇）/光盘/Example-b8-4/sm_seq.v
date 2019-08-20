// Copyright Model Technology, a Mentor Graphics
// Corporation company 2003, - All rights reserved.

/*******************************
*  Sample solution:   - Synthesizable  RTL
*  - Separate signals, One-hot encoding
*  - Requires "beh_sram.v" ( SRAM model)
*  - this is the seqential part
*/
`timescale 1ns/100ps
module sm_seq ( into, outof, rst, clk, mem, addr, rd_, wr_);

input [31:0] into;
output [31:0] outof;
input rst, clk;
inout [31:0] mem;
output [9:0] addr;
output rd_, wr_;

parameter DLY = 1;
reg [31:0] in_reg, outof,
	 w_data, r_data;
reg [9:0] addr;
reg wr_; 
reg [7:0] ctrl;

tri [31:0]  mem = wr_ ? 32'bZ : w_data;

// instantiate the state machine module
sm sm_0( clk, rst, in_reg[31:28], a_wen_, wd_wen_, rd_wen_, ctrl_wen_, inca);

wire rd_ = rd_wen_;
always @ (posedge clk)
 if (rst)
   begin
	in_reg <= #DLY 0; // get the input
     	outof  <= #DLY 0; // send the output
	  addr <= #DLY 0;
	  w_data <= #DLY 0;
	  wr_ <= 1'b1;
 	  r_data <= #DLY 0;
    end

 else
   begin
	in_reg <= #DLY into; // get the input
     	outof  <= #DLY r_data; // send the output
	if (!a_wen_)
	  addr <= #DLY in_reg[9:0];
	else if (inca)
	  addr <= #DLY addr + 1;
	if (!wd_wen_) 
	  w_data <= #DLY in_reg;
	wr_ <= #DLY wd_wen_;
	if (!rd_wen_)
 	  r_data <= #DLY mem;
	if (!ctrl_wen_)
	  ctrl <= in_reg[7:0];  
    end

endmodule

