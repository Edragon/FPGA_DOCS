`timescale 1ns/1ns
module counter( clk,
                arst,
                data	        
                );


 input          clk;   //input clock
 input          arst;   //asynchronous reset, low effect
 
 output [7:0]   data;
 reg    [7:0]   data;

 


always@(posedge clk or negedge arst)	
     if(!arst)
	data <= 0;
     else
        data <= data+1;


endmodule