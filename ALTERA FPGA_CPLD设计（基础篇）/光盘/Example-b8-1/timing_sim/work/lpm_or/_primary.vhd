library verilog;
use verilog.vl_types.all;
entity lpm_or is
    generic(
        lpm_width       : integer := 1;
        lpm_size        : integer := 1;
        lpm_type        : string  := "lpm_or";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        result          : out    vl_logic_vector
    );
end lpm_or;
