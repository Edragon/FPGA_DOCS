create_clock -period 4 [get_ports {clk}]

set_input_delay -clock clk -max 1.5 [get_ports {serial_data* aclr clken}]
set_input_delay -clock clk -min 1 [get_ports {serial_data* aclr clken}]

set_output_delay -clock clk -max 1 [get_ports dct_out*] 
set_output_delay -clock clk -min 0 [get_ports dct_out*]
set_output_delay -clock clk -max 1 [get_ports data_valid] 
set_output_delay -clock clk -min 0 [get_ports data_valid]

