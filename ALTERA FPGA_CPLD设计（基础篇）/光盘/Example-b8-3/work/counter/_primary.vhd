library verilog;
use verilog.vl_types.all;
entity counter is
    port(
        clk             : in     vl_logic;
        arst            : in     vl_logic;
        data            : out    vl_logic_vector(7 downto 0)
    );
end counter;
