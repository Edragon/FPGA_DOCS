library verilog;
use verilog.vl_types.all;
entity and16 is
    port(
        y               : out    vl_logic_vector(15 downto 0);
        in1             : in     vl_logic_vector(15 downto 0)
    );
end and16;
