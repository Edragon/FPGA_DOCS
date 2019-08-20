library verilog;
use verilog.vl_types.all;
entity oper_rotate_left is
    generic(
        width_a         : integer := 6;
        width_amount    : integer := 6;
        width_o         : integer := 6;
        sgate_representation: integer := 0
    );
    port(
        amount          : in     vl_logic_vector;
        a               : in     vl_logic_vector;
        o               : out    vl_logic_vector
    );
end oper_rotate_left;
