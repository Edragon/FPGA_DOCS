# Copyright Model Technology, a Mentor Graphics
# Corporation company 2003, - All rights reserved.

vlib work
vmap work work
vlog test_sm.v sm_seq.v sm.v beh_sram.v
vsim -wlf gold.wlf test_sm
add wave *
onbreak {resume}
run 750 ns
quit -sim
