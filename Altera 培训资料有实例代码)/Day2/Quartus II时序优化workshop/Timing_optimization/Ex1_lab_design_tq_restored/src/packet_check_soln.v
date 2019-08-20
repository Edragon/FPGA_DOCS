//------------------------------------------------------------------------------
//
// File name:  PACKET_CHECK_SOLN.V
// Title    :  SPI3 RX packet checker
//
// Description
// ===========
// - checks the following:
//     (a)  packet length is 1024 words
//     (b)  MTY field is always "00"
//     (c)  SOP WORD = "DECAFBAD"
//     (d)  Check Parity on EOP WORD
//     (e)  ERR is not asserted
// - On error assert ERROR for 1 clock cycle
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
module PACKET_CHECK
(
   input  wire        CLK,
   input  wire        RESET,
   input  wire        VAL,
   input  wire        SOP,
   input  wire        EOP,
   input  wire        ERR,
   input  wire  [1:0] MTY,
   input  wire [31:0] DAT,
   output reg         ERROR
);


//------------------------------------------------------------------------------
//  Parameter declarations
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//  Variable declarations
//------------------------------------------------------------------------------
reg length_error;          // packet length error flag
reg parity_error;          // check parity on last word
reg mty_error;             // MTY error flag
reg sop_error;             // SOP data word error flag
reg err_error;             // ERR error flag

reg [9:0] count;           // counter for packet count
reg [31:0] last_data;		// last data word register
reg eop_delayed;           // EOP signal delayed 1 clock cycle

reg parity0;
reg parity1;
reg parity2;
reg parity3;
reg parity4;
reg parity5;
reg parity6;
reg parity7;
reg parity8;
reg parity9;
reg parity10;
integer i;


//------------------------------------------------------------------------------
//  Begin Module
//------------------------------------------------------------------------------

// delay EOP signal 1 clock cycle
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      eop_delayed <= 1'b0;
   end
   else begin
      eop_delayed <= EOP;
   end
end


//-------------------------------------
// length check logic
// -> use a counter to count # of words
// -> start count on SOP &
//		end count on EOP
// -> assert length_error if count not
//    equal to 1024
// -> generate a 1 clock wide pulse
//-------------------------------------
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      count 		 <= 10'd0;
      length_error <= 1'b0;
   end
   else begin
      if(VAL == 1'b1) begin
         // counter logic
         case({SOP, EOP})
            2'b00:    count <= count + 10'd1;   // no SOP & EOP, increment
            2'b01:    count <= count + 10'd1;   // EOP, still increment
            2'b10:    count <= 10'd0;           // SOP, reset counter
            2'b11:    ; 								// invalid condition, do nothing
            default:  ;	 								// all cases covered, do nothing
         endcase
      end

      // error check logic
      // -> generate a 1 clock wide pulse
      if(length_error == 1'b1)
         length_error <= 1'b0;   // clear if already set, limit to 1 clock
      else if((eop_delayed == 1'b1) && (count !== 10'b11_1111_1111))
         length_error <= 1'b1;   // assert on error
   end
end


//-------------------------------------
// MTY check logic
// -> assert error if MTY != "00"
// -> MTY only valid on EOP
// -> generate a 1 clock wide pulse
//-------------------------------------
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      mty_error <= 1'b0;
   end
   else begin
      if(VAL == 1'b1) begin
         if(mty_error == 1'b1)
            mty_error <= 1'b0;      // clear if already set, limit to 1 clock
         else if((EOP == 1'b1) && (MTY !== 2'b00))
            mty_error <= 1'b1;      // assert on error
      end
   end
end


//-------------------------------------
// SOP check logic
// -> assert error if SOP data != "DECAFBAD"
// -> only valid on SOP
// -> generate a 1 clock wide pulse
//-------------------------------------
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      sop_error <= 1'b0;
   end
   else begin
      if(VAL == 1'b1) begin
         if(sop_error == 1'b1)
            sop_error <= 1'b0;      // clear if already set, limit to 1 clock
         else if((SOP == 1'b1) && (DAT !== 32'hDECAFBAD))
            sop_error <= 1'b1;      // assert on error
      end
   end
end


//-------------------------------------
// Last word parity check logic
// -> assert parity of last data word
// -> generate a 1 clock wide pulse
//-------------------------------------
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      parity_error  <= 1'b0;
      last_data     <= 32'd0;
   end
   else begin
      if(VAL == 1'b1) begin
         // store previous data continually
         // -> data will be qualified by "eop_delayed" signal
         last_data[31:0]  <= DAT;
      end

      parity0  <= last_data[ 0] ^ last_data[ 1] ^ last_data[ 2];
      parity1  <= last_data[ 3] ^ last_data[ 4] ^ last_data[ 5] ^ parity0;
      parity2  <= last_data[ 6] ^ last_data[ 7] ^ last_data[ 8] ^ parity1;
      parity3  <= last_data[ 9] ^ last_data[10] ^ last_data[11] ^ parity2;
      parity4  <= last_data[12] ^ last_data[13] ^ last_data[14] ^ parity3;
      parity5  <= last_data[15] ^ last_data[16] ^ last_data[17] ^ parity4;
      parity6  <= last_data[18] ^ last_data[19] ^ last_data[20] ^ parity5;
      parity7  <= last_data[21] ^ last_data[22] ^ last_data[23] ^ parity6;
      parity8  <= last_data[24] ^ last_data[25] ^ last_data[26] ^ parity7;
      parity9  <= last_data[27] ^ last_data[28] ^ last_data[29] ^ parity8;
      parity10 <= last_data[30] ^ last_data[31] ^ parity9;
		
		if(parity_error == 1'b1)
         parity_error <= 1'b0;
      else if(eop_delayed == 1'b1)
         parity_error <= parity10;
   end
end


//-------------------------------------
// ERR check logic
// -> assert error if ERR is asserted
// -> generate a 1 clock wide pulse
//-------------------------------------
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      err_error <= 1'b0;
   end
   else begin
      if(VAL == 1'b1) begin
         if(err_error == 1'b1)
            err_error <= 1'b0;      // clear if already set, limit to 1 clock
         else if(ERR == 1'b1)
            err_error <= 1'b1;      // assert on error
      end
   end
end


//-------------------------------------
// ERROR output logic
// -> assert error if any error condition
//    active
// -> generate a 1 clock wide pulse
//-------------------------------------
always @(posedge CLK or posedge RESET)
begin
   if(RESET) begin
      ERROR <= 1'b0;
   end
   else begin
      if(ERROR == 1'b1)
         ERROR <= 1'b0;           // clear if already set, limit to 1 clock
      else
         ERROR <= length_error || // assert on error
						mty_error    ||
						sop_error    ||
                  parity_error ||
						err_error;
   end
end

//------------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------
