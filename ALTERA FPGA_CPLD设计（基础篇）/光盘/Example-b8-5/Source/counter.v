module counter (count, clk, reset);
output [7:0] count;
input clk, reset;

reg [7:0] count;
parameter tpd_clk_to_count   =  1;
parameter tpd_reset_to_count =  1;


function [7:0] increment;
input [7:0] val;
reg [3:0] i;
reg carry;
  begin
    increment = val;
    carry = 1'b1;
    /* 
     * Exit this loop when carry == zero, OR all bits processed 
     */ 
    for (i = 4'b0; ((carry == 4'b1) || (i <= 7));  i = i+ 4'b1)
       begin
         increment[i] = val[i] ^ carry;
         carry = val[i] & carry;
       end
  end       
endfunction

always @ (posedge clk or posedge reset)
  if (reset)
     count = #tpd_reset_to_count 8'h00;
  else
     count <= #tpd_clk_to_count increment(count);

/*
 * To make module counter synthesizeable, use the following
 *  alternate form of the always block:
 */
/***********************************************
always @ (posedge clk or posedge reset)
  if (reset)
     count <= 8'h00;
  else
     count <= count + 8'h01;
***********************************************/

endmodule
