
//模块名：series_port.v



 
 
`include "uart_defines.v" 
      
module 	series_port (reset,clk,MC_BD,MC_BA,mc_cs3,fpa_rw,MC_re,mc_irq4,
	              lpd_txd,ltp_txd,tpm_txd,outer_txd,
	              ltr_txd,lpm_txd,llp1_txd,llp2_txd,
	              lpd_rxd,ltp_rxd,tpm_rxd,outer_rxd,
	              ltr_rxd,lpm_rxd,llp2_rxd,llp1_rxd,test_lmc);
	             
       input reset;
       input clk;
       input [5:0] MC_BA;
       
       inout [7:0] MC_BD;
       input mc_cs3,fpa_rw,MC_re;
       output mc_irq4;
       output [7:0] test_lmc;  
      
       reg [7:0] wb_dat_out;
       
       input lpd_txd,ltp_txd,tpm_txd,outer_txd;
       input ltr_txd,lpm_txd,llp1_txd,llp2_txd;
       
       output lpd_rxd,ltp_rxd,tpm_rxd,outer_rxd;
       output ltr_rxd,lpm_rxd,llp2_rxd,llp1_rxd;
       
       
       wire   lpd_rxd,ltp_rxd,tpm_rxd,outer_rxd;
       wire   ltr_rxd,lpm_rxd,llp2_rxd,llp1_rxd;
       
       wire int_o1,int_o2,int_o3,int_o4,int_o5,int_o6,int_o7,int_o8;
       wire [7:0] int_o;
       assign int_o={int_o8,int_o7,int_o6,int_o5,int_o4,int_o3,int_o2,int_o1};
       assign mc_irq4=^int_o;     
       
          
       wire [7:0] wb_dat_o1,wb_dat_o2,wb_dat_o3,wb_dat_o4;
       wire [7:0] wb_dat_o5,wb_dat_o6,wb_dat_o7,wb_dat_o8; 
       
              
       always @( reset or MC_re or mc_cs3 or MC_BA or
                wb_dat_o1 or wb_dat_o2 or wb_dat_o3 or wb_dat_o4 or wb_dat_o5 or wb_dat_o6 or wb_dat_o7 or wb_dat_o8)
       begin
             case(MC_BA[5:3])
                     3'b000: wb_dat_out <= wb_dat_o1;
                     3'b001: wb_dat_out <= wb_dat_o2;
                     3'b010: wb_dat_out <= wb_dat_o3;
                     3'b011: wb_dat_out <= wb_dat_o4;
                     3'b100: wb_dat_out <= wb_dat_o5;
                     3'b101: wb_dat_out <= wb_dat_o6;
                     3'b110: wb_dat_out <= wb_dat_o7;
                     3'b111: wb_dat_out <= wb_dat_o8;
                    default: wb_dat_out <= 8'h0;
             endcase
       end
        
      assign MC_BD = ((MC_re==1'b0)&&(mc_cs3==1'b0))?wb_dat_out: 8'hzz;
       
      //将写信号用高速时钟往后延
      reg rw_d;
      
      always @(posedge clk or negedge reset)
      if(!reset)
             rw_d <= 1;
      else  
            rw_d <= fpa_rw;
                  
//       assign MC_BD = ((fpa_rw==1)&&(mc_cs3==1'b0)? wb_dat_out:8'hzz;
              
       wire [7:0] wb_dat_in;
      assign wb_dat_in=((fpa_rw==1'b0)&&(mc_cs3==1'b0))?MC_BD:8'h00; 
       
       wire  wb_we_i1,wb_we_i2,wb_we_i3,wb_we_i4,wb_we_i5,wb_we_i6,wb_we_i7,wb_we_i8;
       assign wb_we_i1 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b000)) ?rw_d:1;    //fpa_rw是低写
       assign wb_we_i2 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b001)) ?rw_d:1; 
       assign wb_we_i3 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b010)) ?rw_d:1;
       assign wb_we_i4 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b011)) ?rw_d:1;  
       assign wb_we_i5 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b100)) ?rw_d:1;
       assign wb_we_i6 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b101)) ?rw_d:1;  
       assign wb_we_i7 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b110)) ?rw_d:1;
       assign wb_we_i8 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b111)) ?rw_d:1;   
       
       wire  wb_re_i1,wb_re_i2,wb_re_i3,wb_re_i4,wb_re_i5,wb_re_i6,wb_re_i7,wb_re_i8;
       assign wb_re_i1 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b000)) ?MC_re:1;    //fpa_rw是低写
       assign wb_re_i2 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b001)) ?MC_re:1; 
       assign wb_re_i3 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b010)) ?MC_re:1;
       assign wb_re_i4 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b011)) ?MC_re:1;  
       assign wb_re_i5 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b100)) ?MC_re:1;
       assign wb_re_i6 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b101)) ?MC_re:1;  
       assign wb_re_i7 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b110)) ?MC_re:1;
       assign wb_re_i8 = ((mc_cs3==0)&&(MC_BA[5:3]==3'b111)) ?MC_re:1; 
       

       wire [7:0] test_lmc0,test_lmc1,test_lmc2,test_lmc3,test_lmc4,test_lmc5,test_lmc6,test_lmc7;
       assign test_lmc = test_lmc2; 
/*
       reg serial_delay,serial_in2;
       always @(posedge clk or negedge reset)
       if(!reset)
       begin
           serial_delay <= 1'b1;
           serial_in2   <= 1'b1;
       end
       else 
       begin
           serial_delay <= tpm_txd;
           serial_in2   <= serial_delay;
       end
*/                                
       uart_regs	regs0(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o1),.wb_we_i(~wb_we_i1),.wb_re_i(~wb_re_i1),.mc_cs3(mc_cs3),
	                        .stx_pad_o(lpd_rxd),.srx_pad_i(lpd_txd),.int_o(int_o1),.test_reg(test_lmc0)
                               );   
       uart_regs	regs1(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o2),.wb_we_i(~wb_we_i2),.wb_re_i(~wb_re_i2),.mc_cs3(mc_cs3),
	                        .stx_pad_o(ltp_rxd), .srx_pad_i(ltp_txd),.int_o(int_o2),.test_reg(test_lmc1)
                                );   	     
       uart_regs	regs2(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o3),.wb_we_i(~wb_we_i3),.wb_re_i(~wb_re_i3),.mc_cs3(mc_cs3),
	                        .stx_pad_o(tpm_rxd), .srx_pad_i(tpm_txd),.int_o(int_o3),.test_reg(test_lmc2)
                                );   	     
       uart_regs	regs3(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o4),.wb_we_i(~wb_we_i4),.wb_re_i(~wb_re_i4),.mc_cs3(mc_cs3),
	                        .stx_pad_o(outer_rxd), .srx_pad_i(outer_txd),.int_o(int_o4),.test_reg(test_lmc3)
                                );   	     
       uart_regs	regs4(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o5),.wb_we_i(~wb_we_i5),.wb_re_i(~wb_re_i5),.mc_cs3(mc_cs3),
	                        .stx_pad_o(lpm_rxd), .srx_pad_i(lpm_txd),.int_o(int_o5),.test_reg(test_lmc4)
                                );   	     
       uart_regs	regs5(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o6),.wb_we_i(~wb_we_i6),.wb_re_i(~wb_re_i6),.mc_cs3(mc_cs3),
	                        .stx_pad_o(ltr_rxd), .srx_pad_i(ltr_txd),.int_o(int_o6),.test_reg(test_lmc5)
                                );  
       uart_regs	regs6(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o7),.wb_we_i(~wb_we_i7),.wb_re_i(~wb_re_i7),.mc_cs3(mc_cs3),
	                        .stx_pad_o(llp1_rxd), .srx_pad_i(llp1_txd),.int_o(int_o7),.test_reg(test_lmc6)
                                );  
       uart_regs	regs7(	.clk(clk),.wb_rst_i(~reset),.wb_addr_i(MC_BA[2:0]),.wb_dat_i(wb_dat_in),
	                        .wb_dat_o(wb_dat_o8),.wb_we_i(~wb_we_i8),.wb_re_i(~wb_re_i8),.mc_cs3(mc_cs3),
	                        .stx_pad_o(llp2_rxd), .srx_pad_i(llp2_txd),.int_o(int_o8),.test_reg(test_lmc7)
                                );   	                                       	                                       	                                                                                                                                                                          	              
	              
	           
endmodule	                     
	              
	         
	         
	        