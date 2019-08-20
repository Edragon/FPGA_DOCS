library verilog;
use verilog.vl_types.all;
entity lpm_outpad is
    generic(
        lpm_width       : integer := 1;
        lpm_type        : string  := "lpm_outpad";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        pad             : out    vl_logic_vector
    );
end lpm_outpad;
