library verilog;
use verilog.vl_types.all;
entity lpm_latch is
    generic(
        lpm_width       : integer := 1;
        lpm_avalue      : string  := "UNUSED";
        lpm_pvalue      : string  := "UNUSED";
        lpm_type        : string  := "lpm_latch";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        gate            : in     vl_logic;
        aclr            : in     vl_logic;
        aset            : in     vl_logic;
        q               : out    vl_logic_vector
    );
end lpm_latch;
