## Generated SDC file "test.sdc"

## Copyright (C) 1991-2008 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 8.0 Build 215 05/29/2008 SJ Full Version"

## DATE    "Mon Mar 30 17:43:33 2009"

##
## DEVICE  "EP2C5F256C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_in_100mhz} -period 10.000 -waveform { 0.000 5.000 } [get_ports {clk_in_100mhz}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {inst1|altpll_component|pll|clk[1]} -source [get_pins {inst1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {clk_in_100mhz} [get_pins {inst1|altpll_component|pll|clk[1]}] 
create_generated_clock -name {inst1|altpll_component|pll|clk[2]} -source [get_pins {inst1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {clk_in_100mhz} [get_pins {inst1|altpll_component|pll|clk[2]}] 
create_generated_clock -name {inst1|altpll_component|pll|clk[0]} -source [get_pins {inst1|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {clk_in_100mhz} [get_pins {inst1|altpll_component|pll|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************

