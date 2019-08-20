library verilog;
use verilog.vl_types.all;
entity oper_less_than is
    generic(
        width_a         : integer := 6;
        width_b         : integer := 6;
        sgate_representation: integer := 0
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        cin             : in     vl_logic;
        o               : out    vl_logic
    );
end oper_less_than;
