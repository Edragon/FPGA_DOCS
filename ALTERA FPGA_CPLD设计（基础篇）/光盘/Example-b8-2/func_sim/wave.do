onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/clk_in
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/rst
add wave -noupdate -format Literal -radix hexadecimal /pll_ram_tb/pll_ram_u1/data_in
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/wr_en
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/rd_en
add wave -noupdate -format Literal -radix hexadecimal /pll_ram_tb/pll_ram_u1/rd_addr
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/clk_out
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/lock
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/package_full
add wave -noupdate -format Literal -radix hexadecimal /pll_ram_tb/pll_ram_u1/data_out
add wave -noupdate -format Logic -radix hexadecimal /pll_ram_tb/pll_ram_u1/clk
add wave -noupdate -format Literal -radix hexadecimal /pll_ram_tb/pll_ram_u1/wr_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3925000 ps} 0} {{Cursor 2} {4154643 ps} 0}
WaveRestoreZoom {3639777 ps} {4390190 ps}
configure wave -namecolwidth 201
configure wave -valuecolwidth 38
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
