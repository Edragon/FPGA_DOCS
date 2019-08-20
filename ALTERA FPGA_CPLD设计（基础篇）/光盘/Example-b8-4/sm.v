// Copyright Model Technology, a Mentor Graphics
// Corporation company 2003, - All rights reserved.

/*******************************
*  Sample solution:   - Synthesizable  RTL
*  - Separate signals, One-hot encoding
*  - Requires "beh_sram.v" ( SRAM model)
*/
`timescale 1ns/100ps
module sm( clk, rst, opcode, a_wen_, wd_wen_, rd_wen_, ctrl_wen_, inca );

input clk, rst;
input [3:0] opcode;
output a_wen_, wd_wen_, rd_wen_, ctrl_wen_, inca;

parameter DLY = 1;
parameter [10:0]	 // state encodings  
  IDLE     	= 11'b00000000001,
  CTRL   	= 11'b00000000010,
  WT_WD_1  	= 11'b00000000100,
  WT_WD_2  	= 11'b00000001000,
  WT_BLK_1 	= 11'b00000010000,
  WT_BLK_2 	= 11'b00000100000,
  WT_BLK_3 	= 11'b00001000000,
  WT_BLK_4 	= 11'b00010000000,
  WT_BLK_5 	= 11'b00100000000,
  RD_WD_1  	= 11'b01000000000,
  RD_WD_2       = 11'b10000000000;
  	  

reg [10:0] state, n_state;  

// state machine output logic
wire a_wen_    = !( state[2] || state[4] || state[9]);
wire wd_wen_   = !( state[3] || state[5] 
	           || state[6] || state[7] || state[8]);
wire rd_wen_   = !( state[10]);
wire inca      = ( state[6] || state[7] || state[8]);
wire ctrl_wen_ = !( state[1]);


// sequential logic
always @ (posedge clk or posedge rst)
  if (rst)
     state <= IDLE;
  else
    state <= #DLY n_state;


// next state logic
always @ (state or opcode)
     case (state) //synopsys full_case parallel_case
	IDLE:		// IDLE 
	      case (opcode) // synopsys parallel_case
	 	0: // nop
			n_state = IDLE;
	 	1: // ctrl
			n_state = CTRL;
	 	2: // wt_wd
			n_state = WT_WD_1;
	 	3: // wt_blk
			n_state = WT_BLK_1;
	 	4: // rd_wd
			n_state = RD_WD_1;
	 	default: begin
 			n_state = IDLE;
			$display ($time,,"illegal op received");
			end
 	      endcase
  	CTRL:		// CTRL
	    n_state = IDLE;
  	WT_WD_1:		// WT_WD_1
	    n_state = WT_WD_2;
  	WT_WD_2:		// WT_WD_2
	    n_state = IDLE;
  	WT_BLK_1:		// WT_BLK_1
	    n_state = WT_BLK_2;
  	WT_BLK_2:		// WT_BLK_2
	    n_state = WT_BLK_3;
  	WT_BLK_3:		// WT_BLK_3
            n_state = WT_BLK_4;
  	WT_BLK_4:		// WT_BLK_4
            n_state = WT_BLK_5;
  	WT_BLK_5:		// WT_BLK_5
            n_state = IDLE;
   	RD_WD_1:		// RD_WD_1
	    n_state = RD_WD_2;
  	RD_WD_2:		// RD_WD_2
	    n_state = IDLE;
	default: 
	    n_state = IDLE;
    endcase

endmodule

