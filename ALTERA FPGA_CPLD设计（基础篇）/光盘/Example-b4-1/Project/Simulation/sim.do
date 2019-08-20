#退出上一次仿真
quit -sim

#建立work库
vlib work

#把ModelSim所要使用的work库映射到新建立的work库上
vmap work work

#编译Altera的仿真库文件
vlog altera_mf.v

#编译设计文件
vlog DualPortRAM.v

#编译顶层文件
vlog TOP.v

#编译testbench
vlog TOP.vt

#载入仿真库
vsim TOP_vlg_vec_tst

#打开波形窗口
view wave

#载入信号
do wave.do

#执行仿真
run -all
