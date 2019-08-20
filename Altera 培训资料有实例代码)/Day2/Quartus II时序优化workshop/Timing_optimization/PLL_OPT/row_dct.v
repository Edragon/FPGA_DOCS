module row_dct (clk, aclr, clken,  serial_data,  row_col_en, first_col_dct, 
				post_row_dct, pt0, pt1, pt2, pt3, pt4, pt5, pt6, pt7 );
     
//Port Declaration
input clk, aclr;
input clken;
input row_col_en;
input first_col_dct;
input [7:0] serial_data;
input [21:0] post_row_dct;
output [21:0] pt0, pt1, pt2, pt3, pt4, pt5, pt6, pt7;

//Register Declaration
reg [21:0] data_t0;
reg [21:0] data_t1;
reg [21:0] data_t2;
reg [21:0] data_t3;
reg [21:0] data_t4;
reg [21:0] data_t5;
reg [21:0] data_t6;
reg [21:0] data_t7;

//Wire Declaration
wire [21:0] start_col_data = (first_col_dct == 1'b1) ? pt0 : data_t0;
wire [21:0] dct_data = (row_col_en == 1'b1) ? {{6 {1'b0}}, serial_data, {8 {1'b0}}} : post_row_dct;

   
always @ (posedge clk or posedge aclr)
  begin
    if (aclr)
      begin
        data_t0 <= 0;
	    data_t1 <= 0;
	    data_t2 <= 0;
	    data_t3 <= 0;
	    data_t4 <= 0;
	    data_t5 <= 0;
	    data_t6 <= 0;
	    data_t7 <= 0;
	   end
	 else if (clken)
	   begin
	    data_t0 <= dct_data;
		data_t1 <= data_t0;
		data_t2 <= data_t1;
		data_t3 <= data_t2;
		data_t4 <= data_t3;
		data_t5 <= data_t4;
		data_t6 <= data_t5;
		data_t7 <= data_t6;
	  end
  end		

dct u1(
.clk(clk), 
.aclr(aclr), 
.clken(clken),
.x0(data_t7),
.x1(data_t6),
.x2(data_t5),
.x3(data_t4),
.x4(data_t3),
.x5(data_t2),
.x6(data_t1),
.x7(start_col_data),
.y0(pt0),
.y1(pt1),
.y2(pt2),
.y3(pt3), 
.y4(pt4),
.y5(pt5),
.y6(pt6),
.y7(pt7));


endmodule