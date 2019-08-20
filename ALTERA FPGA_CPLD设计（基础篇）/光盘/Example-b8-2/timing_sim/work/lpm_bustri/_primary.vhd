library verilog;
use verilog.vl_types.all;
entity lpm_bustri is
    generic(
        lpm_width       : integer := 1;
        lpm_type        : string  := "lpm_bustri";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        tridata         : inout  vl_logic_vector;
        data            : in     vl_logic_vector;
        enabletr        : in     vl_logic;
        enabledt        : in     vl_logic;
        result          : out    vl_logic_vector
    );
end lpm_bustri;
