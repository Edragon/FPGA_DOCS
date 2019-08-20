library verilog;
use verilog.vl_types.all;
entity lpm_abs is
    generic(
        lpm_width       : integer := 1;
        lpm_type        : string  := "lpm_abs";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        result          : out    vl_logic_vector;
        overflow        : out    vl_logic
    );
end lpm_abs;
