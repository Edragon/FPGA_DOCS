
cmp start_batch

project start_batch

project start_batch top
cmp add_assignment "" "" "" ROOT "|top"
cmp add_assignment "" "" "" FAMILY "STRATIX"
cmp add_assignment "top" "" "" DEVICE "EP1S10F780C5"
project add_assignment "" "top" "" "" "EDA_DESIGN_ENTRY_SYNTHESIS_TOOL" "SYNPLIFY"
project add_assignment "" "eda_design_synthesis" "" "" "EDA_USE_LMF" "synplcty.lmf"
project add_assignment "top" "" "" "clk" "GLOBAL_SIGNAL" "ON"
project add_assignment "" "clk_setting" "" "" "DUTY_CYCLE" "50.00"
project add_assignment "top" "" "" "clk" "USE_CLOCK_SETTINGS" "clk_setting"
project add_assignment "" "clk_setting" "" "" "FMAX_REQUIREMENT" "150.0MHZ"
project add_assignment "" "" "" "" "TAO_FILE" "myresults.tao"
project add_assignment "" "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000"

# False path constraints 

# Multicycle constraints 

# Path delay constraints 

project end_batch top

project end_batch

cmp end_batch
