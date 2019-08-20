module transpose_matrix (clk, clken, aclr, data_rdy, col_dct_en, 
						first_col_dct, serial_out,
						pt0, pt1, pt2, pt3, pt4, pt5, pt6, pt7);
													
    //////////////////						
	//Port Declaration
	//////////////////
	input clk, clken, aclr;
	input col_dct_en;
	input data_rdy;
	input [21:0] pt0, pt1, pt2, pt3, pt4, pt5, pt6, pt7;
	output first_col_dct;
    output [21:0] serial_out;
  	
    //////////////////////
	//Register Declaration
	//////////////////////
	reg	rden_ram0_w, rden_ram1_w, rden_ram2_w, rden_ram3_w;
	reg rden_ram4_w, rden_ram5_w,rden_ram6_w, rden_ram7_w;
	reg	wren_ram0_w, wren_ram1_w, wren_ram2_w, wren_ram3_w;
	reg wren_ram4_w, wren_ram5_w,wren_ram6_w, wren_ram7_w;
	reg [21:0] serial_out;
    reg [2:0] wren_cnt;
    reg [2:0] mux_sel_cnt;
		
	reg [2:0] mux_sel;
	reg [2:0] inc7_r;
	reg [1:0] data_valid_state;
	
	reg [4:0] delay_data_cnt;
	reg delay_data_clken;
	reg [5:0] data_valid_cnt;
	reg count_64_clken;
  	
	reg [8:0] rd_valid_cnt;
	reg rd_valid_clken;
	reg [2:0] write_add;
	reg [2:0] read_add;
	reg [3:0] ram_rden_state;
	reg ram_wren_st;
	reg [7:0] tm_cnt;

    //////////////////
	//Wire Declaration
	//////////////////
	wire [21:0] ram0_d, ram1_d, ram2_d, ram3_d;
	wire [21:0] ram4_d, ram5_d, ram6_d, ram7_d;
	wire [21:0] ram0_q, ram1_q, ram2_q, ram3_q;
	wire [21:0] ram4_q, ram5_q, ram6_q, ram7_q;
	wire [2:0] wradd_w, rdadd_w;
    wire delay_data_cnt_w;
    wire data_valid_cnt_w;
    wire rd_valid_cnt_w;
 	wire next_ram_wren;
    wire wren_w;
	wire mux_sel_w;
	wire wr_clken;
	wire rd_clken;
	
	
	assign ram0_d = pt0;
	assign ram1_d = pt1;
	assign ram2_d = pt2;
	assign ram3_d = pt3;
	assign ram4_d = pt4;
	assign ram5_d = pt5;
	assign ram6_d = pt6;
	assign ram7_d = pt7;
	
	assign wradd_w = write_add;
	assign rdadd_w = read_add;

	assign first_col_dct = (write_add == 3'b111) ? wren_w : 1'b0;
	assign mux_sel_w = ((mux_sel_cnt == 3'b000) && (col_dct_en == 1'b1 )) ? 1'b1 : 1'b0;
	
	always @ (posedge clk or posedge aclr)
	  begin
	    if (aclr)
	       begin
	         mux_sel_cnt <= 0;
	       end
	   else if (col_dct_en)
	       begin
	          mux_sel_cnt <= mux_sel_cnt + 1;
	       end
	    else
	       begin
	          mux_sel_cnt <= 0;
	       end
	   end
	
	
	 always @ (posedge clk or posedge aclr)
	  begin
	     if (aclr)
	       begin 
	         mux_sel <= 0;
	       end
		 else if (mux_sel_w)
		   begin
		     mux_sel <= mux_sel + 1;
		   end
	   end  
	
	
	always @ (mux_sel)
	  begin
		case (mux_sel)
			0:  serial_out = ram0_q;
			1: 	serial_out = ram1_q;
			2: 	serial_out = ram2_q;
			3:  serial_out = ram3_q;
			4:  serial_out = ram4_q;
			5:  serial_out = ram5_q;
			6:  serial_out = ram6_q;
			7:  serial_out = ram7_q;
		endcase
	end
	
  

   always @ (posedge clk or posedge aclr)
	begin
		if (aclr)
			begin
				tm_cnt <= 0;
			end
		else if (clken)
			begin
				tm_cnt <= tm_cnt + 1;
			end
		else
			begin
				tm_cnt <= 0;
			end
	end
	
	assign wr_clken = ( tm_cnt > 12 && tm_cnt <= 72  && clken == 1) ? 1'b1 : 1'b0;
    assign rd_clken = ( tm_cnt > 60  && clken == 1) ? 1'b1 : 1'b0;

	//Generate wren enable 
	assign wren_w = (wren_cnt == 3'b010 && wr_clken == 1'b1) ? 1'b1 : 1'b0;
  
	
	always @ (posedge clk or posedge aclr)
	  begin
	    if (aclr)
	       begin
	         wren_cnt <= 0;
	       end
	    else if (wr_clken && clken)
	       begin
	          wren_cnt <= wren_cnt + 1;
	       end
	    else
	       begin
	          wren_cnt <= 0;
	       end
	   end
	
	
	//Generate read address
	always @ (posedge clk or posedge aclr)
	  begin
	    if (aclr)
	       begin
	  		 read_add <= 0;
	       end
	    else if (rd_clken)
	       begin
	          read_add <= read_add + 1;
	       end
	    else
	       begin
			  read_add <= 0;
	       end
	   end
	
   //Generate write address
   always @ (posedge clk or posedge aclr)
	  begin
	    if (aclr)
	       begin
	         write_add <= 0;
	       end
	    else if (wren_w)
	       begin
	          write_add <= write_add + 1;
			end
	   end

           
 	ram_tpmtx ram0(
	.data ( ram0_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram0_q )
	);
	
	ram_tpmtx ram1(
	.data ( ram1_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram1_q )
	);
	
	ram_tpmtx ram2(
	.data ( ram2_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram2_q )
	);
	
	ram_tpmtx ram3(
	.data ( ram3_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram3_q )
	);
	
	ram_tpmtx ram4(
	.data ( ram4_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram4_q )
	);
	
	ram_tpmtx ram5(
	.data ( ram5_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram5_q )
	);
	
	ram_tpmtx ram6(
	.data ( ram6_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram6_q )
	);
	
	ram_tpmtx ram7(
	.data ( ram7_d ),
	.wren ( wren_w ),
	.wraddress ( wradd_w ),
	.rdaddress ( rdadd_w ),
	.clock ( clk ),
	.enable ( clken ),
	.aclr ( aclr ),
	.q ( ram7_q )
	);

endmodule