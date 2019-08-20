# Synplicity, Inc. constraint file
# D:\prj_D\Synplify_Pro\ALU_Syn_demo.sdc
# Written on Wed Mar 23 02:14:01 2005
# by Synplify Pro, 7.5.1      Scope Editor

#
# Clocks
#
define_clock           -virtual -name {clk}  -freq 150.000 -clockgroup default_clkgroup_0

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_input_delay               -default -improve 2.00 -route 2.00
define_output_delay              -default -improve 2.00 -route 2.00
define_input_delay -disable      {accum_a[7:0]} -improve 0.00 -route 0.00
define_input_delay -disable      {accum_b[7:0]} -improve 0.00 -route 0.00
define_input_delay -disable      {in_a} -improve 0.00 -route 0.00
define_input_delay -disable      {in_b} -improve 0.00 -route 0.00
define_input_delay -disable      {in_c} -improve 0.00 -route 0.00
define_output_delay -disable     {result[7:0]} -improve 0.00 -route 0.00
define_input_delay -disable      {rst} -improve 0.00 -route 0.00
define_input_delay -disable      {start_value[31:0]} -improve 0.00 -route 0.00

#
# Registers
#
define_reg_output_delay          {alu1.outp[7:0]} -route 5.00

#
# Multicycle Path
#

#
# False Path
#
define_false_path           -from {p:rst}  -to {p:result[7:0]} 

#
# Delay Path
#
define_path_delay           -from {i:op_code[2:0]}  -to {p:result[7:0]}  -max 10.000

#
# Attributes
#

#
# Compile Points
#

#
# Other Constraints
#
