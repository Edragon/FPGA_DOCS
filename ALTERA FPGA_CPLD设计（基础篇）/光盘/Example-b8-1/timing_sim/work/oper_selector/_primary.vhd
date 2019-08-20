library verilog;
use verilog.vl_types.all;
entity oper_selector is
    generic(
        width_sel       : integer := 6;
        width_data      : integer := 6
    );
    port(
        sel             : in     vl_logic_vector;
        data            : in     vl_logic_vector;
        o               : out    vl_logic
    );
end oper_selector;
