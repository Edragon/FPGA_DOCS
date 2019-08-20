# Create a post-map (post-synthesis) or fast or slow post-fit netlist.

#create_timing_netlist -post_map -model slow -zero_ic_delays
create_timing_netlist -model slow
#create_timing_netlist -model fast

# Read in the SDC file.

read_sdc

# Update the timing netlist.
update_timing_netlist;

# Generate reports.

report_clocks -panel_name "Clocks Summary"
report_ucp -panel_name "Unconstrained Paths"
report_sdc -ignored -panel_name "Ignored Constraints"
report_sdc -panel_name "SDC Assignments"
create_timing_summary -setup -panel_name "Summary (Setup)"
create_timing_summary -hold -panel_name "Summary (Hold)"
report_timing -to_clock {clk1} -setup -npaths 20 -detail summary -panel_name {Setup: clk1 Summary}