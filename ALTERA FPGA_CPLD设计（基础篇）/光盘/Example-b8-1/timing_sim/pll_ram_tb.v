//This is a simple modelSim simulation flow demo
//Function: simple testbench of pll_tb.v
//2004-12-2 Westor

`timescale 1ns/100ps

module pll_ram_tb ();
                
reg        clk_in;    //50MHz
reg   rst;       //asynchronous reset, low-effect
reg  [7:0] data_in;   //data to ram
reg        wr_en;      //wirte enable
reg        rd_en;      //read enable
reg  [4:0] rd_addr;     //read addrress

wire       clk_out;      //clock output, 100MHz
wire       lock;         //pll lock indicator
wire       package_full; //indicate the ram is full      
wire [7:0] data_out;    //data to ram


initial 
     begin
         clk_in = 0;
         rst    = 0;
         data_in = 8'h55;
         rd_en   = 1'bz;
         wr_en   = 1'bz;
         rd_addr = 5'b0;
         
         # 500
         rst     =1;
         
         # 1500
         rst     =0;
         
         # 1700
         rst     =1;
         
         repeat (9)
         write_ram;
         
         repeat (5)
         read_ram;
         
         repeat (8)
         begin      
         # 100
         write_ram;
         
         # 5
         read_ram;
         end
         
         
         # 8000
         $stop;
     end

always # 10 clk_in =~clk_in;

task write_ram;
     begin
     # 5
     wr_en = 1;
     data_in = data_in + 1;
     
     # 20
     wr_en = 1'bz;
     end       
endtask


task read_ram;
     begin
     # 5
     rd_en = 1;
     rd_addr = rd_addr + 1;
     
     # 20
     rd_en = 1'bz;
     end
endtask


pll_ram pll_ram_u1(clk_in, rst,
                data_in,
                wr_en, rd_en, rd_addr,                
                clk_out, lock,
                package_full,
                data_out
                );

endmodule 