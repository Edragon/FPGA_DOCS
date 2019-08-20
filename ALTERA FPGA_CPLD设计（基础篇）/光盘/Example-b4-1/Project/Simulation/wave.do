onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /TOP_vlg_vec_tst/tb/In_Wen
add wave -noupdate -format Logic -radix hexadecimal /TOP_vlg_vec_tst/tb/In_Wclk
add wave -noupdate -format Logic -radix hexadecimal /TOP_vlg_vec_tst/tb/In_Rclk
add wave -noupdate -format Literal -radix hexadecimal /TOP_vlg_vec_tst/tb/In_Raddr
add wave -noupdate -format Literal -radix hexadecimal /TOP_vlg_vec_tst/tb/In_Waddr
add wave -noupdate -format Literal -radix hexadecimal /TOP_vlg_vec_tst/tb/In_Wdata
add wave -noupdate -format Literal -radix hexadecimal /TOP_vlg_vec_tst/tb/Out_Rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {51840 ps} {174372 ps}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
