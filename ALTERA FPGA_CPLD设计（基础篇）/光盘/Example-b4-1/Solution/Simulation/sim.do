#�˳���һ�η���
quit -sim

#����work��
vlib work

#��ModelSim��Ҫʹ�õ�work��ӳ�䵽�½�����work����
vmap work work

#����Altera�ķ�����ļ�
vlog altera_mf.v

#��������ļ�
vlog DualPortRAM.v

#���붥���ļ�
vlog TOP.v

#����testbench
vlog TOP.vt

#��������
vsim TOP_vlg_vec_tst

#�򿪲��δ���
view wave

#�����ź�
do wave.do

#ִ�з���
run -all
