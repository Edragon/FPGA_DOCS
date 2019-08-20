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

module four_mult_add_blk(
	aclr,
	clken,
	clk,
	constant_one,
	constant_two,
	constant_three,
	constant_four,
	W,
	X,
	Y,
	Z,
	result
);

input	aclr;
input	clken;
input	clk;
input	[17:0] constant_one;
input	[17:0] constant_two;
input   [17:0] constant_three;
input   [17:0] constant_four;
input   [17:0] W;
input	[17:0] X;
input	[17:0] Y;
input   [17:0] Z;
output	[37:0] result;


four_mult_add	four_mult_add_inst (.clock0(clk),
									.aclr3(aclr),
									.ena0(clken),
							    	.dataa_0(W),
									.dataa_1(X),
									.dataa_2(Y),
									.dataa_3(Z),
									.datab_0(constant_one),
									.datab_1(constant_two),
									.datab_2(constant_three),
									.datab_3(constant_four),
									.result(result));


endmodule
