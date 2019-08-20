library verilog;
use verilog.vl_types.all;
entity lpm_inpad is
    generic(
        lpm_width       : integer := 1;
        lpm_type        : string  := "lpm_inpad";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        pad             : in     vl_logic_vector;
        result          : out    vl_logic_vector
    );
end lpm_inpad;
