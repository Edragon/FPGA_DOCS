//------------------------------------------------------------------------------
//
// File name:  ASYNC_FIFO.V
// Title    :  Asynchronous dual clock fifo with Atlantic interfaces
//
// Description
// ===========
// - slave sink interface on write port
// - slave source interface on read port
//
//
// Conventions
// ===========
// - Port names are 'UPPER' case.
// - Internal signals and variables are 'lower' case.
// - Active low signals are identified with '_n' or '_N'.
// - instances begin with lower case 'i', rest upper case
// - parameters begin with lower case 'p', rest upper case
// - tasks begin with lower case 't', rest upper case
// - functions begin with lower case 'f', rest upper case
//
// Tab setting = 3
// Right Margin = 80
//
//------------------------------------------------------------------------------
// Revision History :
//------------------------------------------------------------------------------
// Version No | Author | Changes Made:                              | Mod. Date
//------------------------------------------------------------------------------
//   v1.0     | mk     | First write                                | 00/00/00
//------------------------------------------------------------------------------
`timescale 1 ns/1 ps


//------------------------------------------------------------------------------
//  Include Files
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  Local Defines
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  Module declaration
//------------------------------------------------------------------------------
module ASYNC_FIFO
(
   input  wire        WR_CLK,
   input  wire        WR_RST,
   input  wire        WR_ENA,
   output  reg        WR_DAV,
   input  wire        WR_SOP,
   input  wire        WR_EOP,
   input  wire        WR_ERR,
   input  wire  [1:0] WR_MTY,
   input  wire [31:0] WR_DAT,

   input  wire        RD_CLK,
   input  wire        RD_RST,
   input  wire        RD_ENA,
   output  reg        RD_DAV,
   output  reg        RD_VAL,
   output  reg        RD_SOP,
   output  reg        RD_EOP,
   output  reg        RD_ERR,
   output  reg  [1:0] RD_MTY,
   output  reg [31:0] RD_DAT
);


//------------------------------------------------------------------------------
//  Parameter declarations
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  Variable declarations
//------------------------------------------------------------------------------
wire wr_full;
reg  reg_wr_ena;
reg [36:0] wr_data;

wire rd_empty;
reg  reg_rd_ena;
wire [36:0] rd_data;


//------------------------------------------------------------------------------
//  Begin Module
//------------------------------------------------------------------------------


// Define Write logic
// -> register inputs & outputs
always @(posedge WR_CLK or posedge WR_RST)
begin
   if(WR_RST) begin
      WR_DAV     <= 1'b0;
      wr_data    <= 36'd0;
      reg_wr_ena <= 1'b0;
   end
   else begin
      WR_DAV <= !wr_full;
      wr_data[31:0]  <= WR_DAT;
      wr_data[32]    <= WR_SOP;
      wr_data[33]    <= WR_EOP;
      wr_data[34]    <= WR_ERR;
		wr_data[36:35] <= WR_MTY;
      reg_wr_ena     <= WR_ENA;
   end
end


// Define Read logic
// RD_VAL signal is simply 1 clock delayed version of
// RD_ENA qualified by empty flag
// -> because of 1 cycle delay to get data from RAM
// -> register inputs & outputs
always @(posedge RD_CLK or posedge RD_RST)
begin
   if(RD_RST) begin
      RD_VAL     <= 1'b0;
      RD_DAV     <= 1'b0;
      RD_DAT     <= 32'd0;
      RD_SOP     <= 1'b0;
      RD_EOP     <= 1'b0;
      RD_ERR     <= 1'b0;
      RD_MTY 	  <= 2'd0;
      reg_rd_ena <= 1'b0;
   end
   else begin
      RD_VAL     <= RD_ENA & !rd_empty;
      RD_DAV     <= !rd_empty;
      RD_DAT     <= rd_data[31:0];
      RD_SOP     <= rd_data[32];
      RD_EOP     <= rd_data[33];
      RD_ERR     <= rd_data[34];
      RD_MTY     <= rd_data[36:35];
      reg_rd_ena <= RD_ENA;
   end
end


//-------------------------------------
// Instantiate Megawizard DCFIFO
//-------------------------------------
dc_fifo iDC_FIFO
(
   .wrclk   (WR_CLK     ),
   .wrreq   (reg_wr_ena ),
   .data    (wr_data    ),
   .wrfull  (wr_full    ),

   .rdclk   (RD_CLK    ),
   .rdreq   (reg_rd_ena),
   .q       (rd_data   ),
   .rdempty (rd_empty  )
);



//------------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
