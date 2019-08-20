//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines.v                                              ////
////                                                              ////
////                                                              ////


// remove comments to restore use to the old version with 8 data bit interface
// in new mode (32bit bus), the wb_sel_i signal is used to pus data in correct place
// also, in 8-bit version there'll be no debugging features included

 `define UART_ADDR_WIDTH 3
 `define UART_DATA_WIDTH 8

// Uncomment this if you want your UART to have 
// 16xBaudrate output port.
// If defined, the enable signal will be used to drive baudrate_o signal
// It's frequency is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT

// Register addresses
`define UART_REG_RB	`UART_ADDR_WIDTH'd0	// receiver buffer
`define UART_REG_TR  `UART_ADDR_WIDTH'd0	// transmitter
`define UART_REG_IE	`UART_ADDR_WIDTH'd1	// Interrupt enable
`define UART_REG_II  `UART_ADDR_WIDTH'd2	// Interrupt identification
`define UART_REG_FC  `UART_ADDR_WIDTH'd2	// FIFO control
`define UART_REG_LC	`UART_ADDR_WIDTH'd3	// Line Control
//`define UART_REG_MC	`UART_ADDR_WIDTH'd4	// Modem control
`define UART_REG_LS  `UART_ADDR_WIDTH'd5	// Line status
`define UART_REG_MS  `UART_ADDR_WIDTH'd6	// Modem status
`define UART_REG_SR  `UART_ADDR_WIDTH'd7	// Scratch register
`define UART_REG_DL1	`UART_ADDR_WIDTH'd0	// Divisor latch bytes (1-2)
`define UART_REG_DL2	`UART_ADDR_WIDTH'd1

// Interrupt Enable register bits
`define UART_IE_RDA	0	// Received Data available interrupt
`define UART_IE_THRE	1	// Transmitter Holding Register empty interrupt
`define UART_IE_RLS	2	// Receiver Line Status Interrupt
`define UART_IE_MS	3	// Modem Status Interrupt

// FIFO Control Register bits
`define UART_FC_TL	1:0	// Trigger level

// FIFO trigger level values
`define UART_FC_1		2'b00
`define UART_FC_4		2'b01
`define UART_FC_8		2'b10
`define UART_FC_14	2'b11

// Line Control register bits
`define UART_LC_BITS	1:0	// bits in character
`define UART_LC_SB	2	// stop bits
`define UART_LC_PE	3	// parity enable
`define UART_LC_EP	4	// even parity
`define UART_LC_SP	5	// stick parity
`define UART_LC_BC	6	// Break control
`define UART_LC_DL	7	// Divisor Latch access bit

`define UART_FIFO_WIDTH	8
`define UART_FIFO_DEPTH	16
`define UART_FIFO_POINTER_W	4
`define UART_FIFO_COUNTER_W	5
// receiver fifo has width 11 because it has break, parity and framing error bits
`define UART_FIFO_REC_WIDTH  10 //11


`define VERBOSE_WB  0           // All activity on the WISHBONE is recorded
`define VERBOSE_LINE_STATUS 0   // Details about the lsr (line status register)
`define FAST_TEST   1           // 64/1024 packets are sent







