module top(q, a, b, sel, r_l, clk, rst);
output [7:0] q;
input [7:0] a, b;
input sel, r_l, clk, rst;
wire [7:0] mux_out, reg_out;

mux mux_1 (.outvec(mux_out), .a_vec(a), .b_vec(b), .sel(sel));
// notice that port connections listed by name can be in any order
reg8 reg8_1 (.clk(clk), .data(mux_out), .q(reg_out), .rst(rst));
// can mix port connections "in order" (below)  with port connections "by name" (above)
rotate rotate_1 (q, reg_out, clk, r_l, rst);

endmodule
