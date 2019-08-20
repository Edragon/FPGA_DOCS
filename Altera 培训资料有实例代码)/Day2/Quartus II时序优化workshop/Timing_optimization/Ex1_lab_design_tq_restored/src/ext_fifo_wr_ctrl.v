//------------------------------------------------------------------------------
//
// File name:  EXT_FIFO_WR_CTRL.V
// Title    :  External FIFO write control logic
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
module EXT_FIFO_WR_CTRL
(
   input  wire CLK,
   input  wire RESET,
   
	input  wire RD_RST_N,
   output wire WR_RST_N,

   output wire        MASTER_SINK_ENA,
   input  wire        MASTER_SINK_DAV,
   input  wire        MASTER_SINK_VAL,
   input  wire        MASTER_SINK_SOP,
   input  wire        MASTER_SINK_EOP,
   input  wire        MASTER_SINK_ERR,
   input  wire  [1:0] MASTER_SINK_MTY,
   input  wire [31:0] MASTER_SINK_DAT,

   // Cypress FIFO interface - CY7C43682AV
   // -> write port
   input  wire        FIFOA_AF_N,
   input  wire        FIFOA_FF_N,
   output wire        FIFOA_RST_N,
   output wire        FIFOA_CS_N,
   output wire        FIFOA_EN,
   output wire        FIFOA_WR,
   output wire [35:0] FIFOA_DATA
);


//------------------------------------------------------------------------------
//  Parameter declarations
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  Variable declarations
//------------------------------------------------------------------------------

// External FIFO signals
reg reg_fifo_af;
reg reg_fifo_ff;
reg reg_fifo_rst_n;
reg reg_fifo_rst_n_dup /* synthesis preserve */;   // duplicate register
reg reg_fifo_cs_n;
reg reg_fifo_en;
reg reg_fifo_wr;
reg [35:0] reg_fifo_data;

wire reset_delay /* synthesis keep */;


//------------------------------------------------------------------------------
//  Begin Module
//------------------------------------------------------------------------------

// register all input signals from external fifo
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      reg_fifo_af <= 1'b0;
      reg_fifo_ff <= 1'b0;
   end
   else begin
      reg_fifo_af <= !FIFOA_AF_N;
      reg_fifo_ff <= !FIFOA_FF_N;
   end
end


// Master Sink enabled when external fifo is
// not full and not almost full
assign MASTER_SINK_ENA = !reg_fifo_af && !reg_fifo_ff;


// add wire delay to create timing violation
// -> Do not edit
assign reset_delay = RD_RST_N;


// register all output signals to external fifo
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      reg_fifo_rst_n 	 <= 1'b0;
      reg_fifo_rst_n_dup <= 1'b0;
      reg_fifo_cs_n  	 <= 1'b1;
      reg_fifo_en    	 <= 1'b0;
      reg_fifo_wr    	 <= 1'b0;
      reg_fifo_data  	 <= 36'd0;
   end
   else begin
      // assert reset only when RESET is asserted
      // or when read reset asserted
      reg_fifo_rst_n 	 <= RD_RST_N;
      reg_fifo_rst_n_dup <= reset_delay;

      // assert CS_N always except during RESET
		reg_fifo_cs_n <= 1'b0;

      // assert WR always except during RESET
		reg_fifo_wr <= 1'b1;

      // write to external fifo only when DAV and VAl are asserted
		reg_fifo_en <= MASTER_SINK_DAV && MASTER_SINK_VAL;

      reg_fifo_data[31:0]  <= MASTER_SINK_DAT;
      reg_fifo_data[32]    <= MASTER_SINK_SOP;
      reg_fifo_data[33]    <= MASTER_SINK_EOP;
      reg_fifo_data[35:34] <= MASTER_SINK_MTY;
   end
end


// assign outputs
assign FIFOA_RST_N = reg_fifo_rst_n;
assign FIFOA_CS_N  = reg_fifo_cs_n;
assign FIFOA_EN    = reg_fifo_en;
assign FIFOA_WR    = reg_fifo_wr;
assign FIFOA_DATA  = reg_fifo_data;
assign WR_RST_N    = reg_fifo_rst_n_dup;


//------------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
