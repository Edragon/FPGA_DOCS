//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs.v                                                 ////

// synopsys translate_off
// synopsys translate_on
`include "uart_defines.v"

module uart_regs (clk,
	wb_rst_i, wb_addr_i, wb_dat_i, wb_dat_o, wb_we_i, wb_re_i, 
	stx_pad_o, srx_pad_i,mc_cs3,
	 int_o	);

input 		clk;
input 		wb_rst_i;
input [2:0] 	wb_addr_i;
input [7:0] 	wb_dat_i;
output [7:0] 	wb_dat_o;
input 		wb_we_i;
input 		wb_re_i;
input           mc_cs3;

output 		stx_pad_o;
input 		srx_pad_i;
output          int_o;

wire 		rf_pop;
wire            rf_push_pulse;

wire   [7:0]    test_reg;

wire            stx_pad_o;		// received from transmitter module
wire            srx_pad_i;
                
reg [7:0]       wb_dat_o;

wire [2:0]      wb_addr_i;
wire [7:0]      wb_dat_i;

reg [3:0]        ier;
reg [3:0]        iir;
reg [1:0]        fcr;  /// bits 7 and 6 of fcr. Other bits are ignored
reg [7:0]        lcr;
reg [15:0]        dl;  // 32-bit divisor latch
reg [7:0]        scratch; // UART scratch register
reg 	        start_dlc; // activate dlc on writing to UART_DL1
reg 	        lsr_mask_d; // delay for lsr_mask condition
//reg 	        	msi_reset; // reset MSR 4 lower bits indicator
//reg 	        	threi_clear; // THRE interrupt clear flag
reg [15:0]        dlc;  // 32-bit divisor latch counter
reg 	        int_o;
reg 	        enable;
reg [3:0]        trigger_level; // trigger level of the receiver FIFO
reg 	        rx_reset;
reg 	        tx_reset;
                
wire 	        dlab;			   // divisor latch access bit

// LSR bits wires 
wire [7:0] 	lsr;
wire 		lsr0,lsr1,  lsr3, lsr4, lsr5, lsr6, lsr7;
reg		lsr0r, lsr1r,  lsr3r, lsr4r, lsr5r, lsr6r, lsr7r;
wire 		lsr_mask; // lsr_mask

assign 		lsr[7:0] = { lsr7r, lsr6r, lsr5r, lsr4r, lsr3r, 1'b0, lsr1r, lsr0r };
assign 		dlab = lcr[7];

// Interrupt signals
wire 		rls_int;  // receiver line status interrupt
wire 		rda_int;  // receiver data available interrupt
wire 		ti_int;   // timeout indicator interrupt
wire		thre_int; // transmitter holding register empty interrupt

// FIFO signals
wire 		tf_push;
wire            fifo_empty;

wire [9:0] 	rf_data_out;
wire 		rf_error_bit; // an error (parity or framing) is inside the fifo
wire [3:0] 	rf_count;
wire [3:0] 	tf_count;
wire [2:0]      tstate;
//wire [2:0] 	tstate;
wire [2:0] 	rstate;
wire [9:0] 	counter_t;

wire            thre_set_en; // THRE status is delayed one character time when a character is written to fifo.
reg  [7:0]      block_cnt;   // While counter counts, THRE status is blocked (delayed one character cycle)

// Transmitter Instance
wire serial_out;
wire aclr;

uart_transmitter transmitter(clk,wb_rst_i,lcr,tf_push,wb_dat_i,enable,serial_out, 
                             tstate,tf_count,tx_reset,lsr_mask);

reg serial_delay,serial_in;
always @(posedge clk or posedge wb_rst_i)
if(wb_rst_i)
begin
    serial_delay <= 1'b1;
    serial_in   <= 1'b1;
end
else 
begin
    serial_delay <= srx_pad_i;
    serial_in   <= serial_delay;
end
                     
//wire serial_in = srx_pad_i;
assign stx_pad_o =  serial_out;

// Receiver Instance
uart_receiver receiver(clk, wb_rst_i,  rf_pop, serial_in, enable,counter_t, rf_count,aclr, 
                      rf_data_out, rf_error_bit, rf_overrun, rx_reset, lsr_mask, rstate, 
                      rf_push_pulse,fifo_empty,test_reg);

// Asynchronous reading
always @(dl or dlab or ier or iir or scratch or
	lcr or lsr or rf_data_out or wb_addr_i or wb_re_i)   // asynchrounous reading
begin
	case (wb_addr_i)
		`UART_REG_RB   : wb_dat_o = dlab ? dl[7:0] : rf_data_out[9:2];
		`UART_REG_IE	: wb_dat_o = dlab ? dl[15:8] : ier;
		`UART_REG_II	: wb_dat_o = {4'b1100,iir};
		`UART_REG_LC	: wb_dat_o = lcr;
		`UART_REG_LS	: wb_dat_o = lsr;
		`UART_REG_SR	: wb_dat_o = scratch;
		default:  wb_dat_o = 8'b0; 
	endcase 
 end 
                       
reg rf_pop_temp,rf_pop_delay;
always @(posedge clk or posedge wb_rst_i)
if (wb_rst_i)
	rf_pop_temp <=  0;
else
begin	      
   if((wb_re_i==1'b1)&&(wb_addr_i==`UART_REG_RB)&& !dlab) 
	rf_pop_temp <=1;
   else
	rf_pop_temp <=0;	             
end

always @(posedge clk or posedge wb_rst_i)
if(wb_rst_i)
        rf_pop_delay <= 1'b0;
else    rf_pop_delay <= rf_pop_temp;

assign  rf_pop = rf_pop_temp&&(~rf_pop_delay);

wire 	lsr_mask_condition;
wire 	iir_read;
wire	fifo_read;
wire	fifo_write;

assign lsr_mask_condition = (wb_re_i && wb_addr_i == `UART_REG_LS && !dlab);
assign iir_read = (wb_re_i && wb_addr_i == `UART_REG_II && !dlab);
assign fifo_read = (wb_re_i && wb_addr_i == `UART_REG_RB && !dlab);
assign fifo_write = (wb_we_i && wb_addr_i == `UART_REG_TR && !dlab);

// lsr_mask_d delayed signal handling
always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
		lsr_mask_d <=  0;
	else // reset bits in the Line Status Register
		lsr_mask_d <=  lsr_mask_condition;
end

// lsr_mask is rise detected
assign lsr_mask = lsr_mask_condition && ~lsr_mask_d;

//   WRITES AND RESETS   //
        // Line Control Register
        always @(posedge wb_we_i or posedge wb_rst_i)
        	if (wb_rst_i)
        		lcr <=  8'b00000011; // 8n1 setting
        	else
        	if ((mc_cs3==1'b0) && wb_addr_i==`UART_REG_LC)
        		lcr <=  wb_dat_i;
        
        // Interrupt Enable Register or UART_DL2
        always @(posedge wb_we_i or posedge wb_rst_i)
        	if (wb_rst_i)
        	begin
        		ier <=  4'b0000; // no interrupts after reset
        		dl[15:8] <=  8'b0;
        	end
        	else
        	if ((mc_cs3==1'b0)&& wb_addr_i==`UART_REG_IE)
        		if (dlab)
        		begin
        			dl[15:8] <=  wb_dat_i;
        		end
        		else
        			ier <=  wb_dat_i[3:0]; // ier uses only 4 lsb      
      
        // FIFO Control Register and rx_reset, tx_reset signals
        always @(posedge wb_we_i or posedge wb_rst_i)
        	if (wb_rst_i) begin
        		fcr <=  2'b11; 
        		rx_reset <=  0;
        		tx_reset <=  0;
        	end else
        	if ((mc_cs3==1'b0) && wb_addr_i==`UART_REG_FC) begin
        		fcr <=  wb_dat_i[7:6];
        		rx_reset <=  wb_dat_i[1];
        		tx_reset <=  wb_dat_i[2];
        	end else begin
        		rx_reset <=  0;
        		tx_reset <=  0;
        	end

      // Scratch register
     // Line Control Register
    always @(posedge wb_we_i or posedge wb_rst_i)
	       if (wb_rst_i)
		     scratch <=  0; // 8n1 setting
	      else
	      if ((mc_cs3==1'b0) && wb_addr_i==`UART_REG_SR)
		     scratch <=  wb_dat_i;        
		     
               // TX_FIFO or UART_DL1
      always @(posedge wb_we_i or posedge wb_rst_i)
        	if (wb_rst_i)
        	begin
        		dl[7:0]  <=  8'b0;
        		start_dlc <=  1'b0;
        	end
        	else
        	if ( (mc_cs3==1'b0)&& wb_addr_i==`UART_REG_TR )
        		if (dlab)
        		begin
        			dl[7:0] <=  wb_dat_i;
        			start_dlc <=  1'b1; // enable DL counter
        		end
        		else
        		begin
        			start_dlc <=  1'b0;
        		end 
        	else
        	begin
        		start_dlc <=  1'b0;
        	end 

reg tf_push_temp,tf_push_delay;

always @(posedge clk or posedge wb_rst_i)
if (wb_rst_i)
        tf_push_temp <=  1'b0;
else
begin
   if((wb_we_i==1'b1)&&(wb_addr_i==`UART_REG_TR)&& !dlab)	        
	tf_push_temp <=1'b1;
   else   tf_push_temp <=1'b0;
end
	
always @(posedge clk or posedge wb_rst_i)
if(wb_rst_i)	       
        tf_push_delay <= 1'b0;
else    tf_push_delay <= tf_push_temp;

assign  tf_push = tf_push_temp&&(~tf_push_delay);        
  
	        	
// Receiver FIFO trigger level selection logic (asynchronous mux)
always @(fcr)
	case (fcr[1:0])
		2'b00 : trigger_level = 1;
		2'b01 : trigger_level = 4;
		2'b10 : trigger_level = 8;
		2'b11 : trigger_level = 14;
	endcase 

// Line Status Register
// activation conditions
//assign lsr0 = (rf_count==0 && rf_push_pulse); 
assign lsr1 = rf_overrun;     // Receiver overrun error
assign lsr3 = rf_data_out[0]; // framing error bit
assign lsr4 = rf_data_out[1]; // break error in the character
assign lsr5 = (tf_count==4'b0 && thre_set_en);  // transmitter fifo is empty
assign lsr6 = (tf_count==4'b0 && thre_set_en && (tstate == 0)); // transmitter empty
assign lsr7 = rf_error_bit | rf_overrun;

always @(posedge clk or posedge wb_rst_i)
begin
if(wb_rst_i)
       lsr0r <= 0;
else   
if(rx_reset)
       lsr0r <= 0;
else
  begin
       if(rf_count==4'd0)
           lsr0r <= 0;
       else lsr0r<= 1;
  end
end
       
reg 	 /*lsr0_d,*/lsr1_d,lsr3_d,lsr4_d,lsr5_d,lsr6_d,lsr7_d;
/*
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr0_d <= #1 0;
	else lsr0_d <= #1 lsr0;

always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr0r <= #1 0;
	else lsr0r <= #1 (rf_count==1 && fifo_read || rx_reset) ? 0 : // deassert condition
					  lsr0r || (lsr0 && ~lsr0_d); 
*/
// lsr bit 1 (receiver overrun)
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr1_d <=  0;
	else lsr1_d <=  lsr1;

always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr1r <=  0;
	else	lsr1r <= 	lsr_mask ? 0 : lsr1r || (lsr1 && ~lsr1_d); // set on rise

// lsr bit 3 (framing error)
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr3_d <=  0;
	else lsr3_d <=  lsr3;

always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr3r <=  0;
	else lsr3r <=  lsr_mask ? 0 : lsr3r || (lsr3 && ~lsr3_d); // set on rise

// lsr bit 4 (break indicator)
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr4_d <=  0;
	else lsr4_d <=  lsr4;

always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr4r <=  0;
	else lsr4r <=  lsr_mask ? 0 : lsr4r || (lsr4 && ~lsr4_d);

// lsr bit 5 (transmitter fifo is empty)
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr5_d <=  1;
	else lsr5_d <=  lsr5;

always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr5r <=  1;
	else lsr5r <=  (fifo_write) ? 0 :  lsr5r || (lsr5 && ~lsr5_d);

// lsr bit 6 (transmitter empty indicator)
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr6_d <=  1;
	else lsr6_d <=  lsr6;

always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr6r <=  1;
	else lsr6r <=  (fifo_write) ? 0 : lsr6r || (lsr6 && ~lsr6_d);

// lsr bit 7 (error in fifo)
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr7_d <=  0;
	else lsr7_d <=  lsr7;

always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) lsr7r <=  0;
	else lsr7r <=  lsr_mask ? 0 : lsr7r || (lsr7 && ~lsr7_d);

// Frequency divider
always @(posedge clk or posedge wb_rst_i) 
begin
	if (wb_rst_i)
		dlc <=  0;
	else
		if (start_dlc | ~ (|dlc))
  			dlc <=  dl - 1;               // preset counter
		else
			dlc <=  dlc - 1;              // decrement counter
end

// Enable signal generation logic
always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
		enable <=  1'b0;
	else
		if (|dl & ~(|dlc))     // dl>0 & dlc==0
			enable <=  1'b1;
		else
			enable <=  1'b0;
end

// Counting time of one character minus stop bit
always @(posedge clk or posedge wb_rst_i)
begin
  if (wb_rst_i)
    block_cnt <=  8'd0;
  else
  if(lsr5r & fifo_write)  // THRE bit set & write to fifo occured
    block_cnt <=  8'd143;
  else
  if (enable & block_cnt != 8'b0)  // only work on enable times
    block_cnt <=  block_cnt - 1;  // decrement break counter
end // always of break condition detection

// Generating THRE status enable signal
assign thre_set_en = ~(|block_cnt);

//	INTERRUPT LOGIC
assign rls_int  = ier[2] && (lsr[1] || lsr[3] || lsr[4]);
assign rda_int  = ier[0] && (rf_count >= {trigger_level});
assign thre_int = ier[1] && lsr[5];
assign ti_int   = ier[0] && (counter_t == 10'b0);

reg 	 rls_int_d;
reg 	 thre_int_d;
reg 	 ti_int_d;
reg 	 rda_int_d;

// delay lines
always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) rls_int_d <=  0;
	else rls_int_d <=  rls_int;

always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) rda_int_d <=  0;
	else rda_int_d <=  rda_int;

always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) thre_int_d <=  0;
	else thre_int_d <=  thre_int;

always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) ti_int_d <=  0;
	else ti_int_d <=  ti_int;

// rise detection signals
wire 	 rls_int_rise;
wire 	 thre_int_rise;
wire 	 ti_int_rise;
wire 	 rda_int_rise;

assign rda_int_rise    = rda_int & ~rda_int_d;
assign rls_int_rise    = rls_int & ~rls_int_d;
assign thre_int_rise   = thre_int & ~thre_int_d;
assign ti_int_rise     = ti_int & ~ti_int_d;

// interrupt pending flags
reg 	rls_int_pnd;
reg	rda_int_pnd;
reg 	thre_int_pnd;
reg 	ti_int_pnd;

// interrupt pending flags assignments
always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) rls_int_pnd <=  0; 
	else 
		rls_int_pnd <=  lsr_mask ? 0 :  						// reset condition
				rls_int_rise ? 1 :						// latch condition
				rls_int_pnd && ier[2];	// default operation: remove if masked

always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) rda_int_pnd <=  0; 
	else 
		rda_int_pnd <=  ((rf_count == trigger_level) && fifo_read) ? 0 :  	// reset condition
							rda_int_rise ? 1 :						// latch condition
							rda_int_pnd && ier[0];	// default operation: remove if masked

always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) thre_int_pnd <=  0; 
	else 
		thre_int_pnd <=  fifo_write || (iir_read & ~iir[0] & iir[3:1] == 3'b001)? 0 : 
							thre_int_rise ? 1 :
							thre_int_pnd && ier[1];

always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) ti_int_pnd <=  0; 
	else 
		ti_int_pnd <=  fifo_read ? 0 : 
				ti_int_rise ? 1 :
				ti_int_pnd && ier[0];
// end of pending flags

// INT_O logic
always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)	
		int_o <=  1'b0;
	else
		int_o <=  rls_int_pnd ? ~lsr_mask:
			  rda_int_pnd ? 1:
			  ti_int_pnd  ? ~fifo_read:
			  thre_int_pnd	? !(fifo_write & iir_read) :
			  0;	// if no interrupt are pending
end


// Interrupt Identification register
always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
		iir <=  1;
	else
	if (rls_int_pnd)  // interrupt is pending
	begin
		iir[3:1] <=  3'b011;	// set identification register to correct value
		iir[0] <=  1'b0;		// and clear the IIR bit 0 (interrupt pending)
	end else // the sequence of conditions determines priority of interrupt identification
	if (rda_int)
	begin
		iir[3:1] <=  3'b010;
		iir[0] <=  1'b0;
	end
	else if (ti_int_pnd)
	begin
		iir[3:1] <=  3'b110;
		iir[0] <=  1'b0;
	end
	else if (thre_int_pnd)
	begin
		iir[3:1] <=  3'b001;
		iir[0] <=  1'b0;
	end
	else	// no interrupt is pending
	begin
		iir[3:1] <=  0;
		iir[0] <=  1'b1;
	end
end

//assign test_reg[0]   = rf_overrun;
//assign test_reg[1]   = rf_pop;
//assign test_reg[2]   = rf_push_pulse;
//assign test_reg[3]   = fifo_empty;
//assign test_reg[4]   = aclr;
//assign test_reg[5]   = rf_count[0];
//assign test_reg[7:6] = rstate[1:0];
//assign test_reg[7]   = rf_overrun;

endmodule
