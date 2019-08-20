// Copyright Model Technology, a Mentor Graphics
// Corporation company 2003, - All rights reserved.

/* Simple Behavioral SRAM Model */
`timescale 1ns/100ps
module beh_sram(clk, dat, addr, rd_, wr_);

inout [31:0] dat;
input [9:0] addr;
input clk, rd_, wr_;

parameter M_DLY = 9;

reg  [31:0] mem [0:1023]; // memory array
reg  [31:0] dat_r;
tri [31:0] dat = rd_ ?  32'bZ : dat_r ;

initial begin
   dat_r = 0;
end

 specify
   specparam ts = 9, th = 5, thr = 10;
   $setup(rd_, negedge clk, ts);	
   $setup(wr_, negedge clk, ts);	
   $setup(addr, negedge clk, ts);	
   $hold(negedge clk, rd_, thr);	
   $hold(negedge clk, wr_, th);	
   $hold(negedge clk, addr, th);	
endspecify 


always @ (negedge clk) 
   if (rd_ || wr_) begin
	 if (!rd_)
	   dat_r <= #M_DLY  mem[addr];
	 if (!wr_)
	   mem[addr] <= #M_DLY dat;
	   
     end
   else 
    if ((rd_ || wr_) == 0) 
	$display($stime,, "Error: Simultaneous Reads & Writes not supported.");


endmodule

