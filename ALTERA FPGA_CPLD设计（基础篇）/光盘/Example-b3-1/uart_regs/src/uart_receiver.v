
//  uart_receiver.v                                             

// synopsys translate_off
// synopsys translate_on
module uart_receiver (clk, wb_rst_i,  rf_pop, srx_pad_i, enable,counter_t, rf_count, aclr,
               rf_data_out, rf_error_bit, rf_overrun, rx_reset, lsr_mask, rstate, 
               rf_push_pulse,fifo_empty,test_reg);
	
	
input	    clk;
input	    wb_rst_i;
input	    rf_pop;
input	    srx_pad_i;
input	    enable;
input	    rx_reset;
input       lsr_mask;


output	[9:0]	counter_t;
output	[3:0]	rf_count;
output	[9:0]	rf_data_out;
output		rf_overrun;
output		rf_error_bit;
output [2:0] 	rstate;
output 		rf_push_pulse;

output fifo_empty;
output aclr;
output [7:0] test_reg;
wire   [7:0] test_reg;

reg	[2:0]	rstate ;
reg	[3:0]	rcounter16;
reg	[2:0]	rbit_counter;
reg	[7:0]	rshift;		// receiver shift register
reg		rframing_error;	// framing error flag
reg		rbit_in;
reg	[7:0]	counter_b;	// counts the 0 (low) signals
reg   rf_push_q;

// RX FIFO signals
reg	[9:0]	rf_data_in;
wire	[9:0]	rf_data_out;
wire            rf_push_pulse;
reg		rf_push;
wire		rf_pop;
wire		rf_overrun;
wire	[3:0]	rf_count;
wire		rf_error_bit; // an error (parity or framing) is inside the fifo
wire 		break_error = (counter_b == 0)?1'b1:1'b0;

wire aclr;
wire fifo_empty;
assign aclr = wb_rst_i||rx_reset||lsr_mask;


myfifo_10 myfifo_u(.data(rf_data_in),
	           .wrreq(rf_push_pulse),
	           .rdreq(rf_pop),
	           .clock(clk),
	           .aclr(aclr),
	           .q(rf_data_out),
	           .full(rf_overrun),
	           .empty(fifo_empty),
	           .usedw(rf_count));
    
assign rf_error_bit=|(rf_data_out[1:0]);

wire   		rcounter16_eq_7 = (rcounter16 == 4'd7)?1:0;
wire		rcounter16_eq_0 = (rcounter16 == 4'd0)?1:0;
wire		rcounter16_eq_1 = (rcounter16 == 4'd1)?1:0;

wire [3:0] rcounter16_minus_1 = rcounter16 - 1'b1;

parameter  sr_idle 	     = 3'd0;
parameter  sr_rec_start      = 3'd1;
parameter  sr_rec_bit 	     = 3'd2;
parameter  sr_rec_stop 	     = 3'd4;
parameter  sr_rec_prepare    = 3'd3;
parameter  sr_end_bit	     = 3'd5;
parameter  sr_push 	     = 3'd6;
parameter  sr_temp           = 3'd7;

wire  test_start;
assign test_start=((srx_pad_i==1'b0) && (break_error == 1'b0))?1'b1:1'b0;

always @(posedge clk or posedge wb_rst_i)
begin
  if (wb_rst_i)
  begin
          rstate 		<=  sr_idle;
	  rbit_in 		<=  1'b0;
	  rcounter16 		<=  0;
	  rbit_counter 		<=  0;
	  rframing_error 	<=  1'b0;
	  rshift 		<=  0;
	  rf_push 		<=  1'b0;
	  rf_data_in 		<=  0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle :       begin
			        rf_push     <=  1'b0;
			        rf_data_in  <=  0;
			        rcounter16  <=  4'b1110;
			        if(test_start==1'b1)// detected a pulse (start bit)
			        begin
			        	rstate 	<=  sr_rec_start;
			        end
			        else    rstate  <=  sr_idle;
		        end
	sr_rec_start :	begin
				if (rcounter16_eq_7)    // check the pulse
					if (srx_pad_i==1'b1)   // no start bit
						rstate <=  sr_idle;
					else            // start bit detected
						rstate <=  sr_rec_prepare;
                                else            rstate <=  sr_rec_start;
				rcounter16 <=  rcounter16_minus_1;
			end
	sr_rec_prepare: begin
				rbit_counter <=  3'b111;
				if (rcounter16_eq_0)
				begin
					rstate	<=  sr_rec_bit;
					rshift	<=  0;
				end
				else
					rstate <=  sr_rec_prepare;
				rcounter16 <=  rcounter16_minus_1;
			end
	sr_rec_bit :	begin
				if (rcounter16_eq_0)
					rstate <=  sr_end_bit;
				else    rstate <=  sr_rec_bit;
			        if (rcounter16_eq_7) // read the bit
					 rshift[7:0]  <=  {srx_pad_i, rshift[7:1]};
			        rcounter16 <=  rcounter16_minus_1;
			end
	sr_end_bit :    begin
				if (rbit_counter==3'b0) // no more bits in word
						rstate <=  sr_rec_stop;
				else		// else we have more bits to read
				begin
					rstate <=  sr_rec_bit;
					rbit_counter <=  rbit_counter - 1'b1;
				end
				rcounter16 <=  4'b1110;				
		        end
	sr_rec_stop :	begin
				if (rcounter16_eq_7)	// read the parity
				begin
					rframing_error <=  !srx_pad_i; // no framing error if input is 1 (stop bit)
					rstate <=  sr_push;
				end
				else    rstate <= sr_rec_stop;
				rcounter16 <=  rcounter16_minus_1;
			end
	sr_push :	begin
                          if(srx_pad_i | break_error)
                                 begin
                                    if(break_error)
        		                rf_data_in  <=  {8'b0, 2'b10}; // break input (empty character) to receiver FIFO
                                    else
        			        rf_data_in  <=  {rshift, 1'b0,  rframing_error};
      		                        rf_push     <=  1'b1;
    				        rstate      <=  sr_idle;
                                 end           
                          else
                              rstate      <=  sr_push;
                        end
        sr_temp :       begin
	                     rstate <=  sr_idle;
	                end
	default :       begin
	                     rstate <=  sr_idle;
                        end
	endcase
  end  
end // always of receiver

always @ (posedge clk or posedge wb_rst_i)
begin
  if(wb_rst_i)
    rf_push_q <= 0;
  else
    rf_push_q <=  rf_push;
end

assign rf_push_pulse = rf_push & ~rf_push_q;

// Break condition detection.
// Works in conjuction with the receiver state machine
always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
		counter_b <=  8'd159;
	else
	if (srx_pad_i)
		counter_b <=  8'd159; // character time length - 1
	else
	if(enable & counter_b != 8'b0)            // only work on enable times  break not reached.
		counter_b <=  counter_b - 1;  // decrement break counter
end // always of break condition detection

/// Timeout condition detection
reg	[9:0]	counter_t;	// counts the timeout condition clocks

always @(posedge clk or posedge wb_rst_i)
begin
	if (wb_rst_i)
		counter_t <=  10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse || rf_pop || rf_count == 0) // counter is reset when RX FIFO is empty, accessed or above trigger level
			counter_t <=  10'd639;
		else
		if (enable && counter_t != 10'b0)  // we don't want to underflow
			counter_t <=  counter_t - 1;		
end
	
assign test_reg[0]= srx_pad_i;
assign test_reg[1]= enable;
assign test_reg[4:2]=rstate;
assign test_reg[5] = wb_rst_i;	
assign test_reg[6]= break_error;	
assign test_reg[7]= test_start;

endmodule
