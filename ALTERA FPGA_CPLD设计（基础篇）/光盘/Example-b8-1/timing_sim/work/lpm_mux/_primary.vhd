library verilog;
use verilog.vl_types.all;
entity lpm_mux is
    generic(
        lpm_width       : integer := 1;
        lpm_size        : integer := 2;
        lpm_widths      : integer := 1;
        lpm_pipeline    : integer := 0;
        lpm_type        : string  := "lpm_mux";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        sel             : in     vl_logic_vector;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        result          : out    vl_logic_vector
    );
end lpm_mux;
