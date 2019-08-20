library verilog;
use verilog.vl_types.all;
entity oper_decoder is
    generic(
        width_i         : integer := 6;
        width_o         : integer := 6
    );
    port(
        i               : in     vl_logic_vector;
        o               : out    vl_logic_vector
    );
end oper_decoder;
