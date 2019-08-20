module mux (outvec, a_vec, b_vec, sel);
output[7:0] outvec;
input[7:0] a_vec, b_vec;
input sel;

mux21 u0 (.Y(outvec[0]), .A(a_vec[0]), .B(b_vec[0]), .SEL(sel));
mux21 u1 (.Y(outvec[1]), .A(a_vec[1]), .B(b_vec[1]), .SEL(sel));
mux21 u2 (.Y(outvec[2]), .A(a_vec[2]), .B(b_vec[2]), .SEL(sel));
mux21 u3 (.Y(outvec[3]), .A(a_vec[3]), .B(b_vec[3]), .SEL(sel));
mux21 u4 (.Y(outvec[4]), .A(a_vec[4]), .B(b_vec[4]), .SEL(sel));
mux21 u5 (.Y(outvec[5]), .A(a_vec[5]), .B(b_vec[5]), .SEL(sel));
mux21 u6 (.Y(outvec[6]), .A(a_vec[6]), .B(b_vec[6]), .SEL(sel));
mux21 u7 (.Y(outvec[7]), .A(a_vec[7]), .B(b_vec[7]), .SEL(sel));

endmodule
