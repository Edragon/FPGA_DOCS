onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /tb/clk
add wave -noupdate -format Logic -radix hexadecimal /tb/reset_n
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_idle_ins
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_kin
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_enable
add wave -noupdate -format Literal -radix hexadecimal /tb/enc_datain
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_rdin
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_rdforce
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_kerr
add wave -noupdate -format Literal -radix hexadecimal /tb/enc_dataout
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_valid
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_rdout
add wave -noupdate -format Logic -radix hexadecimal /tb/enc_rdcascade
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {1 ns}
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
