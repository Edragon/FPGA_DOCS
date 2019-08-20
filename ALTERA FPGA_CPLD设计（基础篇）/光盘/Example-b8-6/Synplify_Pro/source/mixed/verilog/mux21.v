module mux21 (Y, A, B, SEL);
output Y;
input A, B;
input SEL;

assign Y = SEL ? A : B;

endmodule 
