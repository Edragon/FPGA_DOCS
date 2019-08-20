library verilog;
use verilog.vl_types.all;
entity latch is
    port(
        d               : in     vl_logic;
        ena             : in     vl_logic;
        pre             : in     vl_logic;
        clr             : in     vl_logic;
        q               : out    vl_logic
    );
end latch;
