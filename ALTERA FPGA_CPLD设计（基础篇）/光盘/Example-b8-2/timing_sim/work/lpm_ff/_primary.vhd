library verilog;
use verilog.vl_types.all;
entity lpm_ff is
    generic(
        lpm_width       : integer := 1;
        lpm_avalue      : string  := "UNUSED";
        lpm_svalue      : string  := "UNUSED";
        lpm_pvalue      : string  := "UNUSED";
        lpm_fftype      : string  := "DFF";
        lpm_type        : string  := "lpm_ff";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        clock           : in     vl_logic;
        enable          : in     vl_logic;
        aclr            : in     vl_logic;
        aset            : in     vl_logic;
        aload           : in     vl_logic;
        sclr            : in     vl_logic;
        sset            : in     vl_logic;
        sload           : in     vl_logic;
        q               : out    vl_logic_vector
    );
end lpm_ff;
