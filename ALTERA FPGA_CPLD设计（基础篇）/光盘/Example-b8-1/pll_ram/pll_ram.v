//This is a simple modelSim simulation flow demo
//Use PLL and RAM to demo simulation concerned with LPM
//Function: use PLL multiple the input clock, then put the input data to a DPRAM
//2004-12-2 Westor
module pll_ram(clk_in, rst,
                data_in,
                wr_en, rd_en, rd_addr,                
                clk_out, lock,
                package_full,
                data_out
                );
                
input        clk_in;    //50MHz
input        rst;       //asynchronous reset, low-effect
input  [7:0] data_in;   //data to ram
input        wr_en;      //wirte enable
input        rd_en;      //read enable
input  [4:0] rd_addr;     //read addrress

output       clk_out;      //clock output, 100MHz
output       lock;         //pll lock indicator
output       package_full; //indicate the ram is full      
output [7:0] data_out;    //data to ram

wire         clk;          //clk 100MHz
reg    [4:0] wr_addr;        //write as sequence

//pll to multiple the input 50M clock to 100M
pllx2 pllx2_u1 (
	         .inclk0(clk_in),
	         .areset(!rst),
	         .c0(clk),
	         .locked(lock));
	         
	         

always @ (posedge clk or negedge rst)
      if (!rst)
          wr_addr <= 4'b0;
      else if (wr_en)
          wr_addr <= wr_addr+1;
    
 	         

//dpram to store data_in
dpram8x32 dpram8x32_u1 (
	.data(data_in),
	.wren(wr_en),
	.wraddress(wr_addr),
	.rdaddress(rd_addr),
	.rden(rd_en),
	.clock(clk),
	.aclr(!rst),
	.q(data_out));

         

assign clk_out = clk;
assign package_full=(wr_addr==31)? 1:0;     

endmodule 