library verilog;
use verilog.vl_types.all;
entity oper_add is
    generic(
        width_a         : integer := 32;
        width_b         : integer := 32;
        width_o         : integer := 32;
        sgate_representation: integer := 1
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        cin             : in     vl_logic;
        cout            : out    vl_logic;
        o               : out    vl_logic_vector
    );
end oper_add;
