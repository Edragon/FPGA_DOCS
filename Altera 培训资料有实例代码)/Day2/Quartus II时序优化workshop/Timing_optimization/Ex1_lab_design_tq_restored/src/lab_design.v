//------------------------------------------------------------------------------
//
// File name:  LAB_DESIGN.V
// Title    :  Demo design for timing closure lab
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
module LAB_DESIGN
(
   // clocks & reset
   input  wire       RESET,
   input  wire       FCLK,                // FIFO clock
   input  wire       SCLK,                // System clock

   // SPI3 RX Channel
   input  wire        SPI3_RX_RFCLK,      // 100 MHz
   input  wire        SPI3_RX_RVAL,
   input  wire [31:0] SPI3_RX_RDAT,
   input  wire        SPI3_RX_RSOP,
   input  wire        SPI3_RX_REOP,
   input  wire        SPI3_RX_RERR,
   input  wire  [1:0] SPI3_RX_RMOD,
   output wire        SPI3_RX_RENB,

   // SPI3 TX Channel
   input  wire        SPI3_TX_TFCLK,      // 100 MHz
   input  wire        SPI3_TX_DTPA,
   output wire        SPI3_TX_TENB,
   output wire [31:0] SPI3_TX_TDAT,
   output wire        SPI3_TX_TSOP,
   output wire        SPI3_TX_TEOP,
   output wire        SPI3_TX_TERR,
   output wire  [1:0] SPI3_TX_TMOD,

   // Cypress FIFO interface - CY7C43682AV
   // -> side A, write port
   input  wire        FIFOA_AF_N,
   input  wire        FIFOA_FF_N,
   output wire        FIFOA_RST_N,
   output wire        FIFOA_CS_N,
   output wire        FIFOA_EN,
   output wire        FIFOA_WR,
   output wire [35:0] FIFOA_DATA,
   // -> side B, read port
   input  wire        FIFOB_AE_N,
   input  wire        FIFOB_EF_N,
   output wire        FIFOB_RST_N,
   output wire        FIFOB_CS_N,
   output wire        FIFOB_EN,
   output wire        FIFOB_RD_N,
   input  wire [35:0] FIFOB_DATA,

   // other
   output wire        PACKET_ERROR
);


//------------------------------------------------------------------------------
//  Parameter declarations
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  Variable declarations
//------------------------------------------------------------------------------
// reset signals & sync flops
reg  [1:0] reg_reset_rxclk;
reg  [1:0] reg_reset_txclk;
reg  [1:0] reg_reset_fclk;
reg  [1:0] reg_reset_sclk;
wire reset_rxclk;
wire reset_txclk;
wire reset_fclk;
wire reset_sclk /* synthesis keep */;
wire wr_rst_n   /* synthesis keep */;
wire rd_rst_n   /* synthesis keep */;


// SPI3 RX signals
wire        spi3_rx_b_dav;
wire        spi3_rx_b_val;
wire [31:0] spi3_rx_b_dat;
wire        spi3_rx_b_sop;
wire        spi3_rx_b_eop;
wire        spi3_rx_b_err;
wire  [1:0] spi3_rx_b_mty;

// FFT signals
wire        fft_sink_ena;
wire        fft_src_ena;
wire        fft_src_sop;
wire        fft_src_eop;
wire [31:0] fft_src_dat;
wire  [5:0] fft_src_exp;

// FIFO SCLK to FCLK Signals
wire        fifo_sclk_to_fclk_wr_dav;
wire        fifo_sclk_to_fclk_rd_dav;
wire        fifo_sclk_to_fclk_rd_val;
wire        fifo_sclk_to_fclk_rd_sop;
wire        fifo_sclk_to_fclk_rd_eop;
wire        fifo_sclk_to_fclk_rd_err;
wire  [1:0] fifo_sclk_to_fclk_rd_mty;
wire [31:0] fifo_sclk_to_fclk_rd_dat;

// External FIFO signals
wire			ext_fifo_sink_ena;
wire 			ext_fifo_src_ena;
wire 			ext_fifo_src_sop;
wire 			ext_fifo_src_eop;
wire 			ext_fifo_src_err;
wire  [1:0] ext_fifo_src_mty;
wire [31:0] ext_fifo_src_dat;

// FIFO FCLK to SCLK Signals
wire        fifo_fclk_to_sclk_wr_dav;
wire        fifo_fclk_to_sclk_rd_dav;
wire        fifo_fclk_to_sclk_rd_val;
wire        fifo_fclk_to_sclk_rd_sop;
wire        fifo_fclk_to_sclk_rd_eop;
wire        fifo_fclk_to_sclk_rd_err;
wire  [1:0] fifo_fclk_to_sclk_rd_mty;
wire [31:0] fifo_fclk_to_sclk_rd_dat;

// SPI3 TX signals
wire spi3_tx_b_ena;


//------------------------------------------------------------------------------
//  Begin Module
//------------------------------------------------------------------------------

//-------------------------------------
// Resets
// -> synchronize resets to each clock
//    domain
//-------------------------------------
always @(posedge SPI3_RX_RFCLK)
begin
   reg_reset_rxclk[0] <= RESET;
   reg_reset_rxclk[1] <= reg_reset_rxclk[0];
end
assign reset_rxclk = reg_reset_rxclk[1];


always @(posedge SPI3_TX_TFCLK)
begin
   reg_reset_txclk[0] <= RESET;
   reg_reset_txclk[1] <= reg_reset_txclk[0];
end
assign reset_txclk = reg_reset_txclk[1];


always @(posedge FCLK)
begin
   reg_reset_fclk[0] <= RESET;
   reg_reset_fclk[1] <= reg_reset_fclk[0];
end
assign reset_fclk = reg_reset_fclk[1];


always @(posedge SCLK)
begin
   reg_reset_sclk[0] <= RESET;
   reg_reset_sclk[1] <= reg_reset_sclk[0];
end
assign reset_sclk = reg_reset_sclk[1];



//-------------------------------------
// Instantiations
//-------------------------------------

// SPI3 RX core
// -> Backend of core has Slave Source atlantic interface
spi3_rx iSPI3_RX
(
   .a_rfclk    (SPI3_RX_RFCLK),
   .a_rreset_n (!reset_rxclk ),
   .a_rval     (SPI3_RX_RVAL ),
   .a_rdat     (SPI3_RX_RDAT ),
   .a_rsop     (SPI3_RX_RSOP ),
   .a_reop     (SPI3_RX_REOP ),
   .a_rerr     (SPI3_RX_RERR ),
   .a_rmod     (SPI3_RX_RMOD ),
   .a_renb     (SPI3_RX_RENB ),

   .b_clk      (SCLK         ),
   .b_reset_n  (!reset_sclk  ),
   .b_ena      (fft_sink_ena ),
   .b_dav      (spi3_rx_b_dav),  // used
   .b_val      (spi3_rx_b_val),
   .b_dat      (spi3_rx_b_dat),  // used
   .b_sop      (spi3_rx_b_sop),  // used
   .b_eop      (spi3_rx_b_eop),
   .b_err      (spi3_rx_b_err),
   .b_mty      (spi3_rx_b_mty)
);

// SPI3 RX packet checker
// -> check received packets
PACKET_CHECK iPACKET_CHECK
(
   .CLK    (SCLK         ),
   .RESET  (!reset_sclk  ),

   .VAL    (spi3_rx_b_val),
   .DAT    (spi3_rx_b_dat),
   .SOP    (spi3_rx_b_sop),
   .EOP    (spi3_rx_b_eop),
   .ERR    (spi3_rx_b_err),
   .MTY    (spi3_rx_b_mty),
   .ERROR  (PACKET_ERROR )
);


// FFT
// -> data received by SPI3 RX core is feed into FFT engine
// -> FFT engine's input interface is Master Sink
// -> FFT engine's output interface is Master Source
fft iFFT
(
   .clk               (SCLK                ),
   .reset             (reset_sclk          ),
   .inv_i             (1'b0                ),
   .master_sink_dav   (spi3_rx_b_dav       ),
   .master_sink_ena   (fft_sink_ena        ),
   .master_sink_sop   (spi3_rx_b_sop       ),
   .data_real_in      (spi3_rx_b_dat[15:0] ),
   .data_imag_in      (spi3_rx_b_dat[31:16]),

   .master_source_dav (fifo_sclk_to_fclk_wr_dav),
   .master_source_sop (fft_src_sop             ),
   .master_source_eop (fft_src_eop             ),
   .master_source_ena (fft_src_ena             ),
   .fft_real_out      (fft_src_dat[15:0]       ),
   .fft_imag_out      (fft_src_dat[31:16]      ),
   .exponent_out      (fft_src_exp             )
);


// FIFO
// -> FFT'ed data is put into a dual clock fifo
// -> data is transferred from SCLK to FCLK
// -> FIFO input interface is Slave Sink
// -> FIFO output interface is Slave Source
ASYNC_FIFO iFIFO_SCLK_TO_FCLK
(
   .WR_CLK (SCLK                    ),
   .WR_RST (reset_sclk              ),
   .WR_ENA (fft_src_ena				   ),
   .WR_DAV (fifo_sclk_to_fclk_wr_dav),
   .WR_SOP (fft_src_sop             ),
   .WR_EOP (fft_src_eop             ),    
   .WR_ERR (1'b0                    ),
   .WR_MTY (2'd0                    ),    
   .WR_DAT (fft_src_dat             ),

   .RD_CLK (FCLK                    ),
   .RD_RST (reset_fclk              ),
   .RD_ENA (ext_fifo_sink_ena       ),
   .RD_DAV (fifo_sclk_to_fclk_rd_dav),
   .RD_VAL (fifo_sclk_to_fclk_rd_val),
   .RD_SOP (fifo_sclk_to_fclk_rd_sop),
   .RD_EOP (fifo_sclk_to_fclk_rd_eop),
   .RD_ERR (fifo_sclk_to_fclk_rd_err),
   .RD_MTY (fifo_sclk_to_fclk_rd_mty),
   .RD_DAT (fifo_sclk_to_fclk_rd_dat)
);


// Cypress, CY7C43682AV, Write Interface Logic
// -> data is read from iFIFO_SCLK_TO_FCLK and
//    written to external FIFO for buffering
// -> input interface is Master Sink
EXT_FIFO_WR_CTRL iEXT_FIFO_WR_CTRL
(
   .CLK   (FCLK      ),
   .RESET (reset_fclk),

   .RD_RST_N (rd_rst_n),
   .WR_RST_N (wr_rst_n),

   .MASTER_SINK_ENA (ext_fifo_sink_ena       ),
   .MASTER_SINK_DAV (fifo_sclk_to_fclk_rd_dav),
   .MASTER_SINK_VAL (fifo_sclk_to_fclk_rd_val),
   .MASTER_SINK_SOP (fifo_sclk_to_fclk_rd_sop),
   .MASTER_SINK_EOP (fifo_sclk_to_fclk_rd_eop),
   .MASTER_SINK_ERR (fifo_sclk_to_fclk_rd_err),
   .MASTER_SINK_MTY (fifo_sclk_to_fclk_rd_mty),
   .MASTER_SINK_DAT (fifo_sclk_to_fclk_rd_dat),

   .FIFOA_AF_N  (FIFOA_AF_N ),
   .FIFOA_FF_N  (FIFOA_FF_N ),
   .FIFOA_RST_N (FIFOA_RST_N),
   .FIFOA_CS_N  (FIFOA_CS_N ),
   .FIFOA_EN    (FIFOA_EN   ),
   .FIFOA_WR    (FIFOA_WR   ),
   .FIFOA_DATA  (FIFOA_DATA )
);


// Cypress, CY7C43682AV, Write Interface Logic
// -> data is read from external FIFO and
//    written to iFIFO_FCLK_TO_SCLK
// -> output interface is Master Source
EXT_FIFO_RD_CTRL iEXT_FIFO_RD_CTRL
(
   .CLK   (FCLK      ),
   .RESET (reset_fclk),

   .RD_RST_N (rd_rst_n),
   .WR_RST_N (wr_rst_n),

   .MASTER_SRC_ENA  (ext_fifo_src_ena        ),
   .MASTER_SRC_DAV  (fifo_fclk_to_sclk_wr_dav),
   .MASTER_SRC_SOP  (ext_fifo_src_sop        ),
   .MASTER_SRC_EOP  (ext_fifo_src_eop        ),
   .MASTER_SRC_ERR  (ext_fifo_src_err        ),
   .MASTER_SRC_MTY  (ext_fifo_src_mty        ),
   .MASTER_SRC_DAT  (ext_fifo_src_dat        ),

   .FIFOB_AE_N  (FIFOB_AE_N ),
   .FIFOB_EF_N  (FIFOB_EF_N ),
   .FIFOB_RST_N (FIFOB_RST_N),
   .FIFOB_CS_N  (FIFOB_CS_N ),
   .FIFOB_EN    (FIFOB_EN   ),
   .FIFOB_RD_N  (FIFOB_RD_N ),
   .FIFOB_DATA  (FIFOB_DATA )
);


// FIFO
// -> data from external fifo is put into a dual clock fifo
// -> data is transferred from FCLK to SCLK
// -> FIFO input interface is Slave Sink
// -> FIFO output interface is Slave Source
ASYNC_FIFO iFIFO_FCLK_TO_SCLK
(
   .WR_CLK (FCLK                    ),
   .WR_RST (reset_fclk              ),
   .WR_ENA (ext_fifo_src_ena        ),
   .WR_DAV (fifo_fclk_to_sclk_wr_dav),
   .WR_SOP (ext_fifo_src_sop        ),
   .WR_EOP (ext_fifo_src_eop        ),    
   .WR_ERR (ext_fifo_src_err        ),    
   .WR_MTY (ext_fifo_src_mty        ),    
   .WR_DAT (ext_fifo_src_dat        ),

   .RD_CLK (SCLK                    ),
   .RD_RST (reset_sclk              ),
   .RD_ENA (spi3_tx_b_ena           ),
   .RD_DAV (fifo_fclk_to_sclk_rd_dav),
   .RD_VAL (fifo_fclk_to_sclk_rd_val),
   .RD_SOP (fifo_fclk_to_sclk_rd_sop),
   .RD_EOP (fifo_fclk_to_sclk_rd_eop),
   .RD_ERR (fifo_fclk_to_sclk_rd_err),
   .RD_MTY (fifo_fclk_to_sclk_rd_mty),
   .RD_DAT (fifo_fclk_to_sclk_rd_dat)
);


// SPI3 TX core
// -> Backend of core has Master Sink atlantic interface
spi3_tx iSPI3_TX
(
   .a_tfclk    (SPI3_TX_TFCLK),
   .a_treset_n (!reset_txclk ),
   .a_dtpa     (SPI3_TX_DTPA ),
   .a_tenb     (SPI3_TX_TENB ),
   .a_tdat     (SPI3_TX_TDAT ),
   .a_tsop     (SPI3_TX_TSOP ),
   .a_teop     (SPI3_TX_TEOP ),
   .a_terr     (SPI3_TX_TERR ),
   .a_tmod     (SPI3_TX_TMOD ),

   .b_clk      (SCLK                    ),
   .b_reset_n  (!reset_sclk             ),
   .b_ena      (spi3_tx_b_ena           ),
   .b_dav      (fifo_fclk_to_sclk_rd_dav),
   .b_val      (fifo_fclk_to_sclk_rd_val),
   .b_sop      (fifo_fclk_to_sclk_rd_sop),
   .b_eop      (fifo_fclk_to_sclk_rd_eop),
   .b_err      (fifo_fclk_to_sclk_rd_err),
   .b_mty      (fifo_fclk_to_sclk_rd_mty),
   .b_dat      (fifo_fclk_to_sclk_rd_dat)
);


//------------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
