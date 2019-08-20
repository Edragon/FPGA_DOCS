library verilog;
use verilog.vl_types.all;
entity b17mux21 is
    port(
        mo              : out    vl_logic_vector(16 downto 0);
        a               : in     vl_logic_vector(16 downto 0);
        b               : in     vl_logic_vector(16 downto 0);
        s               : in     vl_logic
    );
end b17mux21;
