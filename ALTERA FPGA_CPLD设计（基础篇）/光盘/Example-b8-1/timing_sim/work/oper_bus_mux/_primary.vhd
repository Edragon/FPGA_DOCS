library verilog;
use verilog.vl_types.all;
entity oper_bus_mux is
    generic(
        width_a         : integer := 6;
        width_b         : integer := 6;
        width_o         : integer := 6
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        sel             : in     vl_logic;
        o               : out    vl_logic_vector
    );
end oper_bus_mux;
