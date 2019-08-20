library verilog;
use verilog.vl_types.all;
entity b5mux21 is
    port(
        mo              : out    vl_logic_vector(4 downto 0);
        a               : in     vl_logic_vector(4 downto 0);
        b               : in     vl_logic_vector(4 downto 0);
        s               : in     vl_logic
    );
end b5mux21;
