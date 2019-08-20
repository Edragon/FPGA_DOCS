library verilog;
use verilog.vl_types.all;
entity lpm_and is
    generic(
        lpm_width       : integer := 1;
        lpm_size        : integer := 1;
        lpm_type        : string  := "lpm_and";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        result          : out    vl_logic_vector
    );
end lpm_and;
