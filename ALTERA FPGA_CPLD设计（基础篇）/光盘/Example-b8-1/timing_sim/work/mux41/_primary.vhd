library verilog;
use verilog.vl_types.all;
entity mux41 is
    port(
        mo              : out    vl_logic;
        in0             : in     vl_logic;
        in1             : in     vl_logic;
        in2             : in     vl_logic;
        in3             : in     vl_logic;
        s               : in     vl_logic_vector(1 downto 0)
    );
end mux41;
