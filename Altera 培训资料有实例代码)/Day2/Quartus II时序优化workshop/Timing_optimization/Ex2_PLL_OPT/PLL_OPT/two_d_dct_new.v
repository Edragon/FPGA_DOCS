module two_d_dct_new (clk, outclk, aclr, clken, data_valid, serial_data, dct_out);
					
	//Port Declaration
	input clk, outclk, aclr, clken;
	input [7:0] serial_data;
	output [21:0] dct_out;
	output data_valid;

	// State machine 
	parameter idle = 0, row_dct = 1, col_dct = 2;
	
	//Reg Declaration
	reg [1:0] data_valid_state;
	reg data_valid;
	reg row_clken;
	reg col_clken;
	reg [7:0] row_cnt;
	reg [8:0] col_cnt;
	reg [7:0] dct_cnt;
	reg [21:0] dct_out;
	
	//Wire Declaration
	wire [21:0] pt0_w, pt1_w, pt2_w, pt3_w, pt4_w, pt5_w, pt6_w, pt7_w;
	wire [21:0] dct_out_prescale;
	wire [35:0] dct_out_postscale;
	wire col_dct_clken;
	wire dct_clken;
	wire row_ncol;
	wire row_state, col_state;
	wire data_valid_w;
	wire [21:0] serial_out;
    wire col_dct_en;
	wire column_dct_en;
    wire first_col_dct;
	wire [21:0] dct_out_comb;


	assign dct_clken = (data_valid_state != idle);
	assign col_dct_en = ( dct_clken && (dct_cnt > 69) );
	assign column_dct_en = ( dct_clken && (dct_cnt >= 79) );
    assign row_state = (row_cnt == 84) ? 1'b1 : 1'b0; 
	assign col_state = (col_cnt == 156)? 1'b1 : 1'b0;  //changed from 59
    assign data_valid_w = (dct_cnt > 130) && (dct_cnt <195); 

	always @ (posedge clk)
	begin
		case (data_valid_state)
			idle: begin
					row_clken = 0;
					col_clken = 0;
				  end	
				
			row_dct: begin
					row_clken = 1;
					col_clken = 0;
				  end
	
			col_dct: begin
					row_clken = 0;
					col_clken = 1;
			  	end
			
			default : begin
					row_clken = 0;
					col_clken = 0;
		    	  end
		endcase
	end

   always @(posedge clk or posedge aclr)
	begin
		if (aclr)
			data_valid_state = idle;
		else
			case (data_valid_state)
				idle: begin
				  		if (clken)
							data_valid_state = row_dct;
   					  end
					
				row_dct: begin
						if (row_state)		      
							data_valid_state = col_dct;
					    end
					
				col_dct: begin
						if (col_state)		      
							data_valid_state = idle;
					    end
			endcase	
		end		
		
	always @ (posedge clk or posedge aclr)
		begin
			if (aclr)
				dct_cnt = 0;
			else if (dct_clken)
				dct_cnt = dct_cnt + 1;
			else
				dct_cnt = 0;
		end
		
   always @ (posedge clk or posedge aclr)
		begin
			if (aclr)
				row_cnt = 0;
			else if (row_clken)
				row_cnt = row_cnt + 1;
			else
				row_cnt = 0;
		end
		
	always @ (posedge clk or posedge aclr)
		begin
			if (aclr)
				col_cnt = 0;
			else if (col_clken)
				col_cnt = col_cnt + 1;
			else
				col_cnt = 0;
		end
		
	always @ (posedge outclk or posedge aclr)
		begin
		   if (aclr)
			   data_valid <= 0;
		   else
				data_valid <= data_valid_w;
		end


     row_dct row_dct_inst(
    .clk(clk),
	.aclr(aclr),
	.clken(dct_clken),
	.row_col_en(clken),
	.first_col_dct(first_col_dct),
	.serial_data(serial_data), 
	.post_row_dct(serial_out),
	.pt0(pt0_w),
 	.pt1(pt1_w),
    .pt2(pt2_w),
    .pt3(pt3_w),
    .pt4(pt4_w),
    .pt5(pt5_w),
    .pt6(pt6_w),
    .pt7(pt7_w));
	
	transpose_matrix tp_mtx_inst(
	.clk(clk), 
	.clken(dct_clken),
	.col_dct_en(col_dct_en),
	.aclr(aclr), 
	.pt0(pt0_w),
	.pt1(pt1_w),
	.pt2(pt2_w),
	.pt3(pt3_w),
	.pt4(pt4_w),
	.pt5(pt5_w),
	.pt6(pt6_w),
	.pt7(pt7_w),
	.first_col_dct(first_col_dct),
	.serial_out(serial_out));
	
	column_dct col_dct_inst(
	.clk(clk), 
	.clken(column_dct_en),
	.aclr(aclr), 
	.y0(pt0_w),
	.y1(pt1_w),
	.y2(pt2_w),
	.y3(pt3_w),
	.y4(pt4_w),
	.y5(pt5_w),
	.y6(pt6_w),
	.y7(pt7_w),
	.dct_out(dct_out_comb));
	
	always @ (posedge outclk or posedge aclr)
		begin
			if (aclr)
				dct_out <= 0;
			else
				dct_out <= dct_out_comb;
		end
	
endmodule