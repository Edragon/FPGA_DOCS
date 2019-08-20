library verilog;
use verilog.vl_types.all;
entity lpm_constant is
    generic(
        lpm_width       : integer := 1;
        lpm_cvalue      : integer := 0;
        lpm_strength    : string  := "UNUSED";
        lpm_type        : string  := "lpm_constant";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        result          : out    vl_logic_vector
    );
end lpm_constant;
