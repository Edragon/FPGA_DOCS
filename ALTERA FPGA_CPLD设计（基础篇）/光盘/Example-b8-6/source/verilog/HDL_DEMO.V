
module hdl_demo(rst, clk, start_value, in_a, in_b, in_c, accum_a, accum_b, result);
input rst, clk, in_a, in_b, in_c;
input [7:0] accum_a, accum_b;
input [31:0] start_value;
output [7:0] result;

`define S1 4'h0
`define S2 4'h1
`define S3 4'h2
`define S4 4'h3
`define S5 4'h4
`define S10 4'h8
`define S20 4'h9
`define S30 4'ha
`define S40 4'hb
`define S50 4'hc
`define SX 4'h7

reg [3:0] state ;
reg [2:0] op_code;
reg start;

`define op_add 3'h0
`define op_sub 3'h1
`define op_and 3'h2
`define op_or 3'h3
`define op_unary 3'h4
`define start_code 32'hAF95FE47

alu alu1( .clk(clk), .outp(result), .opcode(op_code), .a(accum_a), .b(accum_b));

always @ (posedge clk or posedge rst)
	if (rst) 
	start <= 1'b0;
	else if (start_value == `start_code)
	start <= 1'b1;
always @(posedge clk or posedge rst)
 begin
   if (rst) begin
     op_code <= 3'h0;
	 state <= `S1;
    end 
   else if (start == 1'b1)
    begin
		  case(state)
	   `S1: begin op_code <= `op_add;
	   			  state <= `S10;
	   		end
	   `S10: begin op_code <= `op_add;
	   			if (in_a)
	   			   state <= `S2;
				else
				   state <= `S1;
			 end
	   `S2: begin op_code <= `op_sub;
				   state <= `S20;
			end
	   `S20: begin op_code <= `op_sub;
	   			if (in_b && !in_a)
				  state <= `S3;
				else
				  state <= `S2;
			 end
		`S3: begin op_code <= `op_and;
				  state <= `S30;
			 end
		`S30: begin op_code <= `op_and;
				 if (in_c)
				   state <= `S4;
				 else
				   state <= `S3;
			  end
		`S4: begin op_code <=`op_or;
				   state <= `S40;
			 end
		`S40: begin op_code <= `op_or;
				 if ( in_a && in_c && ~in_b)
				   state <= `S5;
				 else
		   		   state <= `S4;
			  end
		`S5: begin op_code <=`op_unary;
				   state <= `S50;
			 end
		`S50: begin op_code <= `op_unary;
		   		   state <= `S5;
			  end
	  endcase
	end
 end

endmodule
