module rotate(q, data, clk, r_l, rst); // rotates bits or loads
output [7:0] q;
input [7:0] data;
input clk, r_l, rst;
reg [7:0] q;

// when r_l is high, it rotates; if low, it loads data
always @(posedge clk or posedge rst)
begin
	if (rst)
		q = 8'b0;
	else if (r_l)
		q = {q[6:0], q[7]};
	else
		q = data;
end
endmodule

