add wave /clk
add wave /arst
add wave -hex /data
force /clk 0 0, 1 50 -repeat 100
force /arst 0 0, 1 200
run 2000
