if {[cmp get_assignment_value "" "" "" ROOT] != ""} {
  cmp remove_assignment "" "" "" ROOT ""
}
if {[cmp get_assignment_value "" "" "" FAMILY] !=  ""} {
  cmp remove_assignment "" "" "" FAMILY ""
}
if {[cmp get_assignment_value "top" "" "" DEVICE] !=  ""} {
  cmp remove_assignment "top" "" "" DEVICE ""
}
if {[project get_assignment_value "top" "" "" "clk" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "top" "" "" "clk" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "" "clk_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "clk_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "top" "" "" "clk" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "top" "" "" "clk" "USE_CLOCK_SETTINGS" ""
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
foreach a [project get_all_assignments "top" "" "" ""] {
	if { [regexp "^LL_" [lindex $a 3] ]  &&  "synplify_7" == [lindex $a 0] } {
		project remove_assignment "top" [lindex $a 0] [lindex $a 1] [lindex $a 2] [lindex $a 3] [lindex $a 4]
	}
}
