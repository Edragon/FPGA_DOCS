library verilog;
use verilog.vl_types.all;
entity lpm_clshift is
    generic(
        lpm_width       : integer := 1;
        lpm_widthdist   : integer := 1;
        lpm_shifttype   : string  := "LOGICAL";
        lpm_type        : string  := "lpm_clshift";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        distance        : in     vl_logic_vector;
        direction       : in     vl_logic;
        result          : out    vl_logic_vector;
        underflow       : out    vl_logic;
        overflow        : out    vl_logic
    );
end lpm_clshift;
