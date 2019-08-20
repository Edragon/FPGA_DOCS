//------------------------------------------------------------------------------
//
// File name:  EXT_FIFO_RD_CTRL.V
// Title    :  External FIFO read control logic
//
// Description
// ===========
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
module EXT_FIFO_RD_CTRL
(
   input  wire CLK,
   input  wire RESET,

	input  wire WR_RST_N,
   output wire RD_RST_N,

   output wire        MASTER_SRC_ENA,
   input  wire        MASTER_SRC_DAV,
   output wire        MASTER_SRC_SOP,
   output wire        MASTER_SRC_EOP,
   output wire        MASTER_SRC_ERR,
   output wire  [1:0] MASTER_SRC_MTY,
   output wire [31:0] MASTER_SRC_DAT,

   // Cypress FIFO interface - CY7C43682AV
   // -> read port
   input  wire        FIFOB_AE_N,
   input  wire        FIFOB_EF_N,
   output wire        FIFOB_RST_N,
   output wire        FIFOB_CS_N,
   output wire        FIFOB_EN,
   output wire        FIFOB_RD_N,
   input  wire [35:0] FIFOB_DATA
);


//------------------------------------------------------------------------------
//  Parameter declarations
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  Variable declarations
//------------------------------------------------------------------------------

// External FIFO signals
reg reg_fifo_ae;
reg reg_fifo_ef;
reg reg_fifo_rst_n;
reg reg_fifo_rst_n_dup /* synthesis preserve */;   // duplicate register
reg reg_fifo_cs_n;
reg reg_fifo_en;
reg reg_fifo_rd_n;
reg [35:0] reg_fifo_data;

wire reset_delay /* synthesis keep */;


//------------------------------------------------------------------------------
//  Begin Module
//------------------------------------------------------------------------------

// register all input signals from external fifo
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      reg_fifo_ae   <= 1'b0;
      reg_fifo_ef   <= 1'b0;
      reg_fifo_data <= 36'd0;
   end
   else begin
      reg_fifo_ae   <= !FIFOB_AE_N;
      reg_fifo_ef   <= !FIFOB_EF_N;
      reg_fifo_data <= FIFOB_DATA;
   end
end


// Master Source enabled when external fifo is
// not empty and not almost empty
assign MASTER_SRC_ENA = !reg_fifo_ae && !reg_fifo_ef;
assign MASTER_SRC_DAT = reg_fifo_data[31:0];
assign MASTER_SRC_SOP = reg_fifo_data[32];
assign MASTER_SRC_EOP = reg_fifo_data[33];
assign MASTER_SRC_ERR = 1'b0;
assign MASTER_SRC_MTY = reg_fifo_data[35:34];


// add wire delay to create timing violation
// -> Do not edit
assign reset_delay = WR_RST_N;


// register all output signals to external fifo
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      reg_fifo_rst_n     <= 1'b0;
      reg_fifo_rst_n_dup <= 1'b0;
      reg_fifo_cs_n      <= 1'b1;
      reg_fifo_en        <= 1'b0;
      reg_fifo_rd_n      <= 1'b1;
   end
   else begin
      // assert reset only when RESET is asserted
      // or when write reset asserted
      reg_fifo_rst_n     <= WR_RST_N;
      reg_fifo_rst_n_dup <= reset_delay;

      // assert CS_N always except during RESET
		reg_fifo_cs_n <= 1'b0;

      // assert RD_N always except during RESET
		reg_fifo_rd_n <= 1'b0;

      // read from external fifo only when DAV is asserted
		reg_fifo_en <= MASTER_SRC_DAV;

   end
end

// assign outputs
assign FIFOB_RST_N = reg_fifo_rst_n;
assign FIFOB_CS_N  = reg_fifo_cs_n;
assign FIFOB_EN    = reg_fifo_en;
assign FIFOB_RD_N  = reg_fifo_rd_n;
assign RD_RST_N    = reg_fifo_rst_n_dup;

//------------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
