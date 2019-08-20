package require ::quartus::project
package require ::quartus::flow

if { [is_project_open ] == 0 } {
project_open  ENC_aot1151_enc8b10b
}

set need_to_close_project 0
set make_assignments 1

set_global_assignment -name AUTO_ROM_RECOGNITION OFF
export_assignments
execute_module -tool map 
# need to re-run quartus_map because
# the netlist is changed by the AUTO_ROM

