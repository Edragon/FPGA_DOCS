library verilog;
use verilog.vl_types.all;
entity tri_bus is
    generic(
        width_datain    : integer := 1;
        width_dataout   : integer := 1
    );
    port(
        datain          : in     vl_logic_vector;
        dataout         : out    vl_logic_vector
    );
end tri_bus;
