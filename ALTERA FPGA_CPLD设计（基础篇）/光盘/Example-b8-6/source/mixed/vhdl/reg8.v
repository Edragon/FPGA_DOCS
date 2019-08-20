module reg8(q, data, clk, rst); // eight bit register
output [7:0] q;
input [7:0] data;
input clk, rst;
reg [7:0] q;

always @(posedge clk or posedge rst)
begin
	if (rst)
		q = 0;
	else
		q = data;
end
endmodule
