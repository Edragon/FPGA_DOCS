module column_dct (clk, clken, aclr, y0, y1, y2, y3, y4, y5, y6, y7, dct_out);
					
						
    //////////////////						
	//Port Declaration
	//////////////////
	input clk, clken, aclr;
	input [21:0] y0, y1, y2, y3, y4, y5, y6, y7;
	output [21:0] dct_out;
	
	
    //////////////////////
	//Register Declaration
	//////////////////////
	reg wren;
	reg [2:0] mux_sel;
	reg [2:0] mux_sel_t0, mux_sel_t1;
	reg [2:0] inc7_r;
	reg [1:0] data_valid_state;
	
	reg [3:0] delay_data_cnt;
	reg delay_data_clken;
	reg [5:0] data_valid_cnt;
	reg count_64_clken;
	
	reg [8:0] rd_valid_cnt;
	reg [2:0] write_add;
	reg [2:0] read_add;
	reg [21:0] dct_out_r;
	
	reg [2:0] mux_sel_cnt;
	reg [2:0] wren_cnt;
	reg [7:0] column_dct_cnt;

    //////////////////
	//Wire Declaration
	//////////////////
	wire [21:0] ram0_d, ram1_d, ram2_d, ram3_d, ram4_d, ram5_d, ram6_d, ram7_d;
	wire [21:0] ram0_q, ram1_q, ram2_q, ram3_q, ram4_q, ram5_q, ram6_q, ram7_q;
	wire [2:0] wradd_w, rdadd_w;
	wire wren_w;
    wire inc7_w;
	wire wren_ram;
    wire delay_data_cnt_w;
    wire data_valid_cnt_w;
    wire rd_valid_cnt_w;
	wire inc7_read_w;
	wire mux_sel_w;
	wire rd_clken;
	wire wr_clken;
	wire mux_clken;
	
	
	assign ram0_d = y0;
	assign ram1_d = y1;
	assign ram2_d = y2;
	assign ram3_d = y3;
	assign ram4_d = y4;
	assign ram5_d = y5;
	assign ram6_d = y6;
	assign ram7_d = y7;
	
	//assign wren_w = wren_ram;
	assign wradd_w = write_add;
	assign rdadd_w = read_add;
	assign dct_out = dct_out_r;
	
	
	always @ (posedge clk or posedge aclr)
	begin
		if (aclr)
			begin
				column_dct_cnt <= 0;
			end
		else if (clken)
			begin
				column_dct_cnt <= column_dct_cnt + 1;
			end
		else
			begin
				column_dct_cnt <= 0;
			end
	end
	
	assign wr_clken = ( column_dct_cnt <=56  && clken == 1) ? 1'b1 : 1'b0;
    assign rd_clken = ( column_dct_cnt >50  && clken == 1) ? 1'b1 : 1'b0;
    assign mux_clken = (column_dct_cnt > 59 && clken == 1) ? 1'b1 : 1'b0;


	//Generate write enable signal 
    assign wren_w = (wren_cnt == 3'b000 && wr_clken == 1'b1) ? 1'b1 : 1'b0;
	
	always @ (posedge clk or posedge aclr)
	  begin
	    if (aclr)
	       begin
	         wren_cnt <= 0;
	       end
	    else if (wr_clken)
	       begin
	          wren_cnt <= wren_cnt + 1;
	       end
	    else
	       begin
	          wren_cnt <= 0;
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
	
           
	assign mux_sel_w = ((mux_sel_cnt == 3'b000) && (mux_clken == 1'b1 )) ? 1'b1 : 1'b0;
	
	always @ (posedge clk or posedge aclr)
	  begin
	    if (aclr)
	       begin
	         mux_sel_cnt <= 0;
	       end
	   	  else if (mux_clken)
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

    // Mux control between transpose matrix ram blocks and serial-to-parallel conversion
    always @ (mux_sel)
	  begin
		case (mux_sel)
			0:  dct_out_r = ram0_q;
			1: 	dct_out_r = ram1_q;
			2: 	dct_out_r = ram2_q;
			3:  dct_out_r = ram3_q;
			4:  dct_out_r = ram4_q;
			5:  dct_out_r = ram5_q;
			6:  dct_out_r = ram6_q;
			7:  dct_out_r = ram7_q;
		endcase
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