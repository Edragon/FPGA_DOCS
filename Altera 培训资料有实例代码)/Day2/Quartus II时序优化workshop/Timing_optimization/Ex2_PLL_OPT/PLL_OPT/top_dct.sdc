create_clock -period 4 [get_ports {clk}]

create_generated_clock -name clk_int -source [get_pins {inst1|altpll_component|pll|inclk[0]}] \
		-master_clock clk [get_pins {inst1|altpll_component|pll|clk[0]}]
create_generated_clock -name clk_out -source [get_pins {inst1|altpll_component|pll|inclk[0]}] \
		-master_clock clk [get_pins {inst1|altpll_component|pll|clk[1]}]

set_input_delay -clock clk -max 1.5 [get_ports {serial_data* aclr clken}]
set_input_delay -clock clk -min 1 [get_ports {serial_data* aclr clken}]

set_output_delay -clock clk -max 1 [get_ports dct_out*] 
set_output_delay -clock clk -min 0 [get_ports dct_out*]
set_output_delay -clock clk -max 1 [get_ports data_valid] 
set_output_delay -clock clk -min 0 [get_ports data_valid]

set_multicycle_path -from [get_clocks clk] -to [get_clocks clk_int] -setup -end 2