library verilog;
use verilog.vl_types.all;
entity nmux21 is
    port(
        mo              : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        s               : in     vl_logic
    );
end nmux21;
