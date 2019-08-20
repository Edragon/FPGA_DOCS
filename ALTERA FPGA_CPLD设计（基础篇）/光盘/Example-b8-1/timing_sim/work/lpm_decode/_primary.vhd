library verilog;
use verilog.vl_types.all;
entity lpm_decode is
    generic(
        lpm_width       : integer := 1;
        lpm_pipeline    : integer := 0;
        lpm_type        : string  := "lpm_decode";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        enable          : in     vl_logic;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        eq              : out    vl_logic_vector
    );
end lpm_decode;
