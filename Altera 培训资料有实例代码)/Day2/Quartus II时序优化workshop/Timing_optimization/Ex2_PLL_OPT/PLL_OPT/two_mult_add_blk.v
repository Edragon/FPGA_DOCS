// Copyright (C) 1991-2002 Altera Corporation
// Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
// support information,  device programming or simulation file,  and any other
// associated  documentation or information  provided by  Altera  or a partner
// under  Altera's   Megafunction   Partnership   Program  may  be  used  only
// to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
// other  use  of such  megafunction  design,  netlist,  support  information,
// device programming or simulation file,  or any other  related documentation
// or information  is prohibited  for  any  other purpose,  including, but not
// limited to  modification,  reverse engineering,  de-compiling, or use  with
// any other  silicon devices,  unless such use is  explicitly  licensed under
// a separate agreement with  Altera  or a megafunction partner.  Title to the
// intellectual property,  including patents,  copyrights,  trademarks,  trade
// secrets,  or maskworks,  embodied in any such megafunction design, netlist,
// support  information,  device programming or simulation file,  or any other
// related documentation or information provided by  Altera  or a megafunction
// partner, remains with Altera, the megafunction partner, or their respective
// licensors. No other licenses, including any licenses needed under any third
// party's intellectual property, are provided herein.

module two_mult_add_blk(
	aclr,
	clken,
	clk,
	constant_one,
	constant_two,
	X,
	Y,
	result
);

input	aclr;
input	clken;
input	clk;
input	[17:0] constant_one;
input	[17:0] constant_two;
input	[17:0] X;
input	[17:0] Y;
output	[36:0] result;


two_mult_add	two_mult_add_inst(.clock0(clk),
							      .aclr3(aclr),
							      .ena0(clken),
								  .dataa_0(X),
	  							  .dataa_1(Y),
								  .datab_0(constant_one),
								  .datab_1(constant_two),
								  .result(result));

endmodule
