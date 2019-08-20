quit -sim

vlib work
vmap work work

vlog 220model.v
vlog altera_mf.v
vlog sgate.v

vlog ENC.vo

vlog ENC_tb.v

vsim tb

view wave 

do wave.do

run -all