library verilog;
use verilog.vl_types.all;
entity oper_div is
    generic(
        width_a         : integer := 6;
        width_b         : integer := 6;
        width_o         : integer := 6;
        sgate_representation: integer := 0
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        o               : out    vl_logic_vector
    );
end oper_div;
