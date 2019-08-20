module dct (clk, aclr, clken, col_en, row_en, 
			x0,x1,x2,x3,x4,x5,x6,x7,
			y0,y1,y2,y3, y4,y5,y6,y7);
	
	input clk, aclr;
	input clken;
	input col_en, row_en;
	input [21:0] x0, x1, x2, x3, x4, x5, x6, x7;
	output [21:0] y0, y1, y2, y3, y4, y5, y6, y7;

    //Parameter Declaration
    //Row-based DCT
	parameter constant_09808_14_8 = 251;	  //FB     C(1)
	parameter constant_m09808_14_8 = 4194053;  //3FFF05 -C(1)
	parameter constant_092388 = 236;		  //EC	   C(2)
	parameter constant_m092388 = 4194068;     //3FFF14 -C(2)
	parameter constant_08315_14_8 = 212;	  //D4     C(3)
	parameter constant_070711 = 181;		  //B5     C(4)
	parameter constant_05556_14_8 = 142;	  //8E     C(5)
	parameter constant_m05556_14_8 = 4194161; //3FFF71 -C(5)
	parameter constant_038268 = 98;			  //62     C(6)
	parameter constant_01951_14_8 = 50;		  //32     C(7)
	parameter constant_m01951_14_8 = 4194254; //3FFFCE -C(7)
	
	//Reg Declaration
	wire [21:0] stage1_0, stage1_1, stage1_2, stage1_3;
	wire [21:0] stage1_4, stage1_5, stage1_6, stage1_7;
	wire [21:0] stage2_0, stage2_1, stage2_2, stage2_3;
	wire [21:0] stage3_0, stage3_1;
	reg [21:0] stage4_0_0p, stage4_0_1p, stage4_0_2p, stage4_0_3p;
	reg [21:0] stage4_0_4p;
	reg [21:0] stage4_4_0p, stage4_5_0p, stage4_6_0p, stage4_7_0p;
	reg [21:0] stage4_4_1p, stage4_5_1p, stage4_6_1p, stage4_7_1p;
	reg [21:0] stage4_4_2p, stage4_5_2p, stage4_6_2p, stage4_7_2p;
	reg [21:0] stage4_4_sel, stage4_5_sel, stage4_6_sel, stage4_7_sel;
	reg [21:0] stage5_sel_0p, stage5_sel_1p, stage5_sel_2p;
	reg [21:0] stage6_2_0p, stage6_3_0p, stage6_2_1p, stage6_3_1p;
	reg [21:0] stage6_2_2p, stage6_3_2p;
	reg [21:0] stage6_4, stage6_5, stage6_6, stage6_7;
	reg [1:0] mux_sel;
	reg [7:0] mux_clken_cnt;
	
	//Wire Declaration
	wire [21:0] X0, X1, X2, X3, X4, X5, X6, X7;
	wire [21:0] stage2_4_w, stage2_5_w, stage2_6_w, stage2_7_w;
	wire [21:0] stage3_2_w, stage3_3_w, stage3_4_w, stage3_5_w, stage3_6_w, stage3_7_w;
	wire [21:0] stage4_1_w, stage4_2_w, stage4_3_w;
	wire [21:0] stage5_0_w;
	wire [35:0] stage5_1_w;
	wire [36:0] stage5_2, stage5_3;
	wire [37:0] stage5_sel;
	wire [21:0] stage5_2_w, stage5_3_w, stage5_4_w, stage5_5_w, stage5_6_w, stage5_7_w;
	wire [21:0] stage6_0_w, stage6_1_w, stage6_4_w, stage6_5_w, stage6_6_w, stage6_7_w;
	wire [21:0] stage4_4_w, stage4_5_w, stage4_6_w, stage4_7_w;
	wire [21:0] stage5_sel_w;
	wire mux_clken, mux_clken_w;
	wire mux_cnt_en;
	
	
	//Feeding adders in stage1
	assign X0=   x0 ;
	assign X1=   x1 ;
	assign X2=   x2 ;
	assign X3=   x3 ;	
	assign X4=   x4 ;
	assign X5=   x5 ;
	assign X6=   x6 ;
	assign X7=   x7 ;
	
	//Connect output transform (switch order)
	assign y0 = stage6_0_w;
	assign y1 = stage6_4_w;
	assign y2 = stage6_2_2p;
	assign y3 = stage6_5_w;
	assign y4 = stage6_1_w;
	assign y5 = stage6_6_w;
	assign y6 = stage6_3_2p;
	assign y7 = stage6_7_w;
	
	//Stage 1
	
	adder	adder_s1_0 (
	.dataa ( X0 ),
	.datab ( X7 ),
	.clock ( clk ),
	.aclr ( aclr),
	.clken ( clken ),
	.result ( stage1_0 ),
	.cout ( ),
	.overflow ( )
	);
	
	adder	adder_s1_1 (
	.dataa ( X1 ),
	.datab ( X6 ),
	.clock ( clk ),
	.aclr ( aclr),
	.clken ( clken ),
	.result ( stage1_1 ),
	.cout ( ),
	.overflow ( )
	);
	
	adder	adder_s1_2 (
	.dataa ( X2 ),
	.datab ( X5 ),
	.clock ( clk ),
	.aclr ( aclr),
	.clken ( clken ),
	.result ( stage1_2 ),
	.cout ( ),
	.overflow ( )
	);
	
	adder	adder_s1_3 (
	.dataa ( X3 ),
	.datab ( X4 ),
	.clock ( clk ),
	.aclr ( aclr),
	.clken ( clken ),
	.result ( stage1_3 ),
	.cout ( ),
	.overflow ( )
	);

    subtractor	subtractor_s1_4 (
	.dataa ( X3 ),
	.datab ( X4 ),
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage1_4 ),
	.cout ( ),
	.overflow ( )
	);
	
	 subtractor	subtractor_s1_5 (
	.dataa ( X2 ),
	.datab ( X5 ),
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage1_5 ),
	.cout ( ),
	.overflow ( )
	);
	
	 subtractor	subtractor_s1_6 (
	.dataa ( X1 ),
	.datab ( X6 ),
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage1_6 ),
	.cout ( ),
	.overflow ( )
	);
	
	 subtractor	subtractor_s1_7 (
	.dataa ( X0 ),
	.datab ( X7 ),
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage1_7 ),
	.cout ( ),   
	.overflow ( )
	);

	//Stage 2
	
	adder	adder_s2_0 (
	.dataa ( stage1_0 ),
	.datab ( stage1_3 ),
	.clock ( clk ),
	.aclr ( aclr),
	.clken ( clken ),
	.result ( stage2_0 ),
	.cout ( ),
	.overflow ( )
	);
	
	adder	adder_s2_1 (
	.dataa ( stage1_1 ),
	.datab ( stage1_2 ),
	.clock ( clk ),
	.aclr ( aclr),
	.clken ( clken ),
	.result ( stage2_1 ),
	.cout ( ),
	.overflow ( )
	);

    subtractor	subtractor_s2_2 (
	.dataa ( stage1_1 ),
	.datab ( stage1_2 ),
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage2_2 ),
	.cout ( ),
	.overflow ( )
	);
	
	 subtractor	subtractor_s2_3 (
	.dataa ( stage1_0 ),
	.datab ( stage1_3 ),
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage2_3 ),
	.cout ( ),
	.overflow ( )
	);

	assign stage2_4_w = stage1_4;
	assign stage2_5_w = stage1_5;
	assign stage2_6_w = stage1_6;
	assign stage2_7_w = stage1_7;
	
	

	//Stage 3
	
	adder	adder_s3_0 (
	.dataa ( stage2_0 ),
	.datab ( stage2_1 ),
	.clock ( clk ),
	.aclr ( aclr),
	.clken ( clken ),
	.result ( stage3_0 ),
	.cout ( ),
	.overflow ( )
	);

    subtractor	subtractor_s3_1 (
	.dataa ( stage2_0 ),
	.datab ( stage2_1 ),
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage3_1 ),
	.cout ( ),
	.overflow ( )
	);

    assign stage3_2_w = stage2_2;
    assign stage3_3_w = stage2_3;
	assign stage3_4_w = stage2_4_w;
	assign stage3_5_w = stage2_5_w;
	assign stage3_6_w = stage2_6_w;
	assign stage3_7_w = stage2_7_w;
	
	
	//Stage 4
	
	always @(posedge clk or posedge aclr)
	begin
		if (aclr)
		   begin
			stage4_0_0p <= 0;
			stage4_0_1p <= 0;
			stage4_0_2p <= 0;
			stage4_0_3p <= 0;
			stage4_0_4p <= 0;
			stage4_4_0p <= 0;
			stage4_5_0p <= 0;
			stage4_6_0p <= 0;
			stage4_7_0p <= 0;
			stage4_4_1p <= 0;
			stage4_5_1p <= 0;
			stage4_6_1p <= 0;
			stage4_7_1p <= 0;
			stage4_4_2p <= 0;
			stage4_5_2p <= 0;
			stage4_6_2p <= 0;
			stage4_7_2p <= 0;
		   end
		else if (clken)
		   begin
		    stage4_0_0p <= stage3_0;
			stage4_0_1p <= stage4_0_0p;
			stage4_0_2p <= stage4_0_1p;
			stage4_0_3p <= stage4_0_2p;
			stage4_0_4p <= stage4_0_3p;
			stage4_4_0p <= stage3_4_w;
			stage4_5_0p <= stage3_5_w;
			stage4_6_0p <= stage3_6_w;
			stage4_7_0p <= stage3_7_w;
			stage4_4_1p <= stage4_4_0p;
			stage4_5_1p <= stage4_5_0p;
			stage4_6_1p <= stage4_6_0p;
			stage4_7_1p <= stage4_7_0p;
			stage4_4_2p <= stage4_4_1p;
			stage4_5_2p <= stage4_5_1p;
			stage4_6_2p <= stage4_6_1p;
			stage4_7_2p <= stage4_7_1p;
		   end
	end		
	
	assign stage4_1_w = stage3_1;
    assign stage4_2_w = stage3_2_w;
    assign stage4_3_w = stage3_3_w;	

	
	//Stage5 
    assign stage5_0_w = stage4_0_4p;
	
	assign stage4_4_w =  stage4_4_sel;
	assign stage4_5_w =  stage4_5_sel;
	assign stage4_6_w =  stage4_6_sel;
	assign stage4_7_w =  stage4_7_sel;

	assign mux_cnt_en = clken;
    assign mux_clken = mux_clken_w ? 1'b1 : 1'b0;
 	assign mux_clken_w = mux_clken_cnt >=8 && clken == 1'b1 ;

	always @ (posedge clk or posedge aclr)
	  begin
	     if (aclr)
	       begin 
	         mux_clken_cnt <= 0;
	       end
		 else if (mux_cnt_en)
		   begin
		     mux_clken_cnt <= mux_clken_cnt + 1;
		   end
		 else 
		   begin
			 mux_clken_cnt <= 0;
		   end
	   end  
	
    //Generate mux select signal
    always @ (posedge clk or posedge aclr)
	  begin
	     if (aclr)
	       begin 
	         mux_sel <= 0;
	       end
		 else if (mux_clken)
		   begin
		     mux_sel <= mux_sel + 1;
		   end
		else
		   begin
		     mux_sel <= 0;
		   end
	   end  

    // Mux control for data feeding the four_mul_add block 
    always @ (posedge clk)
	  begin
		case (mux_sel)
			0:  stage4_4_sel = stage3_4_w;
			1: 	stage4_4_sel = -stage4_6_0p;
			2: 	stage4_4_sel = stage4_5_1p;
			3:  stage4_4_sel = stage4_7_2p;
		endcase
	end
 
    always @ (posedge clk)
	  begin
		case (mux_sel)
			0:  stage4_5_sel = stage3_5_w;
			1: 	stage4_5_sel = -stage4_4_0p;
			2: 	stage4_5_sel = stage4_7_1p;
			3:  stage4_5_sel = -stage4_6_2p;
		endcase
	end
	
	
   always @ (posedge clk)
	  begin
		case (mux_sel)
			0:  stage4_6_sel = stage3_6_w;
			1: 	stage4_6_sel = stage4_7_0p;
			2: 	stage4_6_sel = stage4_4_1p;
			3:  stage4_6_sel = stage4_5_2p;
		endcase
	end
	
	always @ (posedge clk)
	  begin
		case (mux_sel)
			0:  stage4_7_sel = stage3_7_w;
			1: 	stage4_7_sel = -stage4_5_0p;
			2: 	stage4_7_sel = -stage4_6_1p;
			3:  stage4_7_sel = -stage4_4_2p;
		endcase
	end
    
	one_mult_blk	one_mult_blk_inst0 (
	.dataa ( stage4_1_w[17:0] ),
	.datab ( constant_070711 ),	 //C5
	.clock ( clk ),
	.aclr ( aclr ),
	.clken ( clken ),
	.result ( stage5_1_w )
	);
	
	two_mult_add_blk two_mult_add_blk_inst0(
	.aclr ( aclr ),
	.clken ( clken ),
	.clk ( clk ),
	.constant_one ( constant_038268 ),  //C6
	.constant_two ( constant_092388 ),  //C2
	.X ( stage4_2_w[17:0]),
	.Y ( stage4_3_w[17:0]),
	.result ( stage5_2 )
	);
	
	two_mult_add_blk two_mult_add_blk_inst1(
	.aclr ( aclr ),
	.clken ( clken ),
	.clk ( clk ),
	.constant_one ( constant_m092388 ),  //-C2
	.constant_two ( constant_038268 ),   //C6
	.X ( stage4_2_w[17:0]),
	.Y ( stage4_3_w[17:0]),
	.result ( stage5_3 )
	);
	
	four_mult_add_blk four_mult_add_blk_inst0(
	.aclr ( aclr ),
	.clken ( clken ),
	.clk ( clk ),
	.constant_one ( constant_01951_14_8 ),	//C7
	.constant_two ( constant_05556_14_8 ),  //C5
	.constant_three ( constant_08315_14_8 ),//C3
	.constant_four ( constant_09808_14_8 ), //C1
	.W ( stage4_4_w[17:0] ),
	.X ( stage4_5_w[17:0] ),
	.Y ( stage4_6_w[17:0] ),
	.Z ( stage4_7_w[17:0] ),
	.result ( stage5_sel )
	);
	
	assign stage5_sel_w = stage5_sel[29:8];
	
	always @(posedge clk or posedge aclr)
	begin
		if (aclr)
		   begin
			stage5_sel_0p <= 0;
			stage5_sel_1p <= 0;
			stage5_sel_2p <= 0;
		   end
		else if (clken)
		   begin
		    stage5_sel_0p <= stage5_sel_w;  // s6
			stage5_sel_1p <= stage5_sel_0p; // s5
			stage5_sel_2p <= stage5_sel_1p; // s4
		   end
	end		
	
	
	//Stage6
	assign stage5_2_w = stage5_2[29:8];
	assign stage5_3_w = stage5_3[29:8];
	 
	assign stage5_4_w = stage5_sel_2p;
	assign stage5_5_w = stage5_sel_1p;
	assign stage5_6_w = stage5_sel_0p;
	assign stage5_7_w = stage5_sel_w;
	
	always @(posedge clk or posedge aclr)
	begin
		if (aclr)
		   begin
			stage6_2_0p <= 0;
			stage6_3_0p <= 0;
			stage6_2_1p <= 0;
			stage6_3_1p <= 0;
			stage6_2_2p <= 0;
			stage6_3_2p <= 0;
		   end
		else if (clken)
		   begin
		    stage6_2_0p <= stage5_2_w;
			stage6_3_0p <= stage5_3_w;
			stage6_2_1p <= stage6_2_0p;
			stage6_3_1p <= stage6_3_0p;
			stage6_2_2p <= stage6_2_1p;
			stage6_3_2p <= stage6_3_1p;
		   end
	  end		
	  
	  assign stage6_0_w = stage5_0_w;
	  assign stage6_1_w = stage5_1_w[29:8];
	  assign stage6_4_w = stage5_4_w;
	  assign stage6_5_w = stage5_5_w;
	  assign stage6_6_w = stage5_6_w;
	  assign stage6_7_w = stage5_7_w;
     
endmodule
