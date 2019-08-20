if {[cmp get_assignment_value "" "" "" ROOT] != ""} {
  cmp remove_assignment "" "" "" ROOT ""
}
if {[cmp get_assignment_value "" "" "" FAMILY] !=  ""} {
  cmp remove_assignment "" "" "" FAMILY ""
}
if {[cmp get_assignment_value "hdl_demo" "" "" DEVICE] !=  ""} {
  cmp remove_assignment "hdl_demo" "" "" DEVICE ""
}
if {[project get_assignment_value "hdl_demo" "" "" "clk" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "hdl_demo" "" "" "clk" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "" "clk_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "clk_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "hdl_demo" "" "" "clk" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "hdl_demo" "" "" "clk" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "clk_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "clk_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "" "" "TAO_FILE" "myresults.tao"] != ""} {
  project remove_assignment "" "" "" "TAO_FILE" "myresults.tao" ""
}
if {[project get_assignment_value "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000"] != ""} {
  project remove_assignment "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000" ""
}
if {[project get_assignment_value "hdl_demo" "" "|rst" "|result\[*\]" "CUT"] != ""} {
 project remove_assignment  "hdl_demo" "" "|rst" "|result\[*\]" "CUT" ""  
}
if {[project get_assignment_value "hdl_demo" "" "|op_code\[*\]" "|result\[*\]" "TPD_REQUIREMENT"] != ""} {
 project remove_assignment  "hdl_demo" "" "|op_code\[*\]" "|result\[*\]" "TPD_REQUIREMENT" ""  
}
foreach a [project get_all_assignments "hdl_demo" "" "" ""] {
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_1" == [lindex $a 0] } {
		project remove_assignment "hdl_demo" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
}
