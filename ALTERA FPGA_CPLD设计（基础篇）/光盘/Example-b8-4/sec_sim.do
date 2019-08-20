# Copyright Model Technology, a Mentor Graphics
# Corporation company 2003, - All rights reserved.

vlog test_sm.v 
vsim test_sm
add wave *
run 750 ns

