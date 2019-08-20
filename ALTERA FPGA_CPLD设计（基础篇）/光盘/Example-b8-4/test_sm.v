// Copyright Model Technology, a Mentor Graphics
// Corporation company 2003, - All rights reserved.

/*
Test fixture for finite state machine

*/
`timescale 1ns/100ps
module test_sm;

reg [31:0] into, outof;
reg rst, clk;
wire [31:0] out_wire, dat;
wire [9:0]  addr;
reg[31:0] loop;
/* nop */
task nop;
# 5 into = {4'b0000,28'h0}; // op_word
endtask

/* the ctrl op */
task ctrl;
input [7:0] data;
begin
	#5 into = {4'b0001,28'b0}; // ctrl_word
	@ (posedge clk)
	#5 into = data; 
end
endtask

/* the wt_wd op */
task wt_wd;
input [31:0] addr,data;
begin
	#5 into = {4'b0010,28'h0}; // op_word
	@ (posedge clk)
	#5 into = addr; 
	@ (posedge clk)
	#5 into = data; 
end
endtask

/* the wt_blk op */
task wt_blk;
input [31:0] addr,data;
begin
	#5 into = {4'b0011,28'h0}; // op_word
	@ (posedge clk)
	#5 into = addr; // send address
	repeat (4)
	 begin
		@ (posedge clk)
		#5 into = data; // send data 
		data = data +1; // change the data word
	 end
end
endtask

/* the rd_wd op */
task rd_wd;
input [31:0] addr;
begin
	#5 into = {4'b0100,28'h0}; // op_word
	@ (posedge clk)
	#5 into = addr; 
	@ (posedge clk)
	#5 into = 0;  // nop
end
endtask

/* illegal op */
task ill_op;
  #5 into = {4'b0101,28'h0};  // op word
endtask


initial
	into = 0;  // set to nop to start off

/* the clock */
initial
 begin
	clk = 0;
	rst = 1;
	forever
		#10 clk = !clk;
 end

//always
//  begin
//    #10 clk = 1;
//    #10 clk = 0;
//  end  


always @(posedge clk)
	outof = #5 out_wire; // put output in register
	
always @ (outof)  // any change of outof
	$display ($time,,"outof = %h",outof);

integer i;



/* tests */
initial
	begin   
                rst = 0;
		#5 rst = 1;
                #20 rst = 0;
     	        repeat(3) @ (posedge clk); // wait for 3 clocks
		repeat (40000) begin
            //		for(loop = 0; loop < 2000; loop=loop+1) begin
//		  @ (posedge clk) ctrl('h5);
		  @ (posedge clk) wt_wd('h10,'haa);
		  @ (posedge clk) wt_wd('h20,'hbb);
		  @ (posedge clk) wt_blk('h30,'hcc);
		  @ (posedge clk) rd_wd('h10);
		  @ (posedge clk) rd_wd('h20);
		  @ (posedge clk) rd_wd('h30);
		  @ (posedge clk) rd_wd('h31);
		  @ (posedge clk) rd_wd('h32);
		  @ (posedge clk) rd_wd('h33);
		  @ (posedge clk) ill_op;
		  @ (posedge clk) nop;
		end
		#100 $stop;
	end
sm_seq  sm_seq0( into, out_wire, rst, clk, dat, addr, rd_, wr_);

beh_sram   sram_0(clk, dat, addr, rd_, wr_);

endmodule

