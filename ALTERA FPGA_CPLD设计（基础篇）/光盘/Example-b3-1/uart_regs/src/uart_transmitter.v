
//  uart_transmitter.v                                          

// synopsys translate_off
// synopsys translate_on
`include "uart_defines.v"

module uart_transmitter (clk,wb_rst_i,lcr,tf_push,wb_dat_i,enable,stx_pad_o, 
                         tstate,tf_count,tx_reset,lsr_mask);

input 		clk;
input 		wb_rst_i;
input [7:0] 	lcr;
input 		tf_push;
input [7:0] 	wb_dat_i;
input 		enable;
input 		tx_reset;
input 		lsr_mask; //reset of fifo
output 		stx_pad_o;
output [2:0]    tstate ; 
output [3:0] 	tf_count;

reg [2:0]    tstate;
reg [4:0] 	counter;
reg [2:0] 	bit_counter;   // counts the bits to be sent
reg [6:0] 	shift_out;	// output shift register
reg 		stx_o_tmp;
reg 		tf_pop;
reg 		bit_out;
reg             parity_xor;

// TX FIFO instance
// Transmitter FIFO signals
wire [7:0] 		tf_data_in;
wire [7:0] 		tf_data_out;
wire 			tf_push;
wire 			tf_overrun;
wire [3:0] 		tf_count;

assign 			tf_data_in = wb_dat_i;

wire aclr;
assign aclr= wb_rst_i||tx_reset;

wire empty_fifo;
myfifo_8  myfifo_u1 (
	.data(tf_data_in),
	.wrreq(tf_push),
	.rdreq(tf_pop),
	.clock(clk),
	.aclr(aclr),
	.q(tf_data_out),
	.full(tf_overrun),
	.empty(empty_fifo),
	.usedw(tf_count));
// TRANSMITTER FINAL STATE MACHINE
parameter s_idle        = 3'd0;
parameter s_send_start  = 3'd1;
parameter s_send_byte   = 3'd2;
parameter s_send_parity = 3'd3;
parameter s_send_stop   = 3'd4;
parameter s_pop_byte    = 3'd5;

always @(posedge clk or posedge wb_rst_i)
begin
  if (wb_rst_i)
  begin
	tstate      <=  s_idle;
	stx_o_tmp   <=  1'b1;
	counter     <=  5'b0;
	shift_out   <=  7'b0;
	parity_xor  <=  1'b0;
	bit_out     <=  1'b0;
	tf_pop      <=  1'b0;
	bit_counter <=  3'b0;
  end
  else
  if (enable)
  begin
	case (tstate)
	s_idle	 :	if (~|tf_count) // if tf_count==0，ram中无数据
			begin
				tstate <=  s_idle;
				stx_o_tmp <=  1'b1;
			end
			else
			begin
				tf_pop <=  1'b0;
				stx_o_tmp  <=  1'b1;
				tstate  <=  s_pop_byte;
			end
	s_pop_byte :	begin
				tf_pop <=  1'b1;
				bit_counter <=  3'b111;
				parity_xor  <=  ^tf_data_out[7:0];  	
				tstate <=  s_send_start;
			end
	s_send_start :	begin
	                        {shift_out[6:0], bit_out} <=  tf_data_out;
				tf_pop <=  1'b0;
				if (~|counter)
					counter <=  5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <=  0;
					tstate <=  s_send_byte;
				end
				else
					counter <=  counter - 1'b1;
				stx_o_tmp <=  1'b0;
			end
	s_send_byte :	begin
				if (~|counter)
					counter <=  5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter > 3'b0)
					begin
						bit_counter <=  bit_counter - 1'b1;
						{shift_out[5:0],bit_out  } <=  {shift_out[6:1], shift_out[0]};
						tstate <=  s_send_byte;
					end
					else   // end of byte
					if (~lcr[`UART_LC_PE])
          					begin
          						tstate <=  s_send_stop;
          					end
          					else
          					begin
          						case ({lcr[`UART_LC_EP],lcr[`UART_LC_SP]})
          						2'b00:	bit_out <=  ~parity_xor;
          						2'b01:	bit_out <=  1'b1;
          						2'b10:	bit_out <=  parity_xor;
          						2'b11:	bit_out <=  1'b0;
          						endcase
          						tstate <= #1 s_send_parity;
          					end					
					counter <=  0;
				end
				else
					counter <=  counter - 1'b1;
				stx_o_tmp <=  bit_out; // set output pin
			end
	s_send_parity :	begin
          			if (~|counter)
          				counter <= #1 5'b01111;
          			else
          			if (counter == 5'b00001)
          			begin
          			        counter <= #1 4'b0;
          				tstate <= #1 s_send_stop;
          			end
          			else
          				counter <= #1 counter - 1'b1;
          			stx_o_tmp <= #1 bit_out;
          		end
	s_send_stop :  begin
				if (~|counter)
				   counter <=  5'b01101;     // 1 stop bit or ignor					
				else
				if (counter == 5'b00001)
				begin
					counter <=  0;
					tstate <=  s_idle;
				end
				else
					counter <=  counter - 1'b1;
				stx_o_tmp <=  1'b1;
			end

	   default :    tstate <=  s_idle;
	endcase
  end // end if enable
  else
    tf_pop <=  1'b0;  // tf_pop must be 1 cycle width
end // transmitter logic

assign stx_pad_o = lcr[6] ? 1'b0 : stx_o_tmp;    // Break condition
	
endmodule
