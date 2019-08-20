module alu(clk, a, b, opcode, outp);
input clk;
input [7:0] a, b;
input [2:0] opcode;
output [7:0] outp;

reg [7:0] outp;

always @(posedge clk)
  begin
    case (opcode) /* synthesis full_case */
	  3'h0 : outp <= a + b;
	  3'h1 : outp <= a - b;
	  3'h2 : outp <= a & b;
	  3'h3 : outp <= a | b;
	  3'h4 : outp <= ~a;
	endcase
end
endmodule

