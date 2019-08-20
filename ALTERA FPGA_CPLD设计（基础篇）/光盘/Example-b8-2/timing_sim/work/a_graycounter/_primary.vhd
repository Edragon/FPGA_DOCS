library verilog;
use verilog.vl_types.all;
entity a_graycounter is
    generic(
        width           : integer := 3;
        pvalue          : integer := 0;
        lpm_type        : string  := "a_graycounter"
    );
    port(
        clock           : in     vl_logic;
        cnt_en          : in     vl_logic;
        clk_en          : in     vl_logic;
        updown          : in     vl_logic;
        aclr            : in     vl_logic;
        sclr            : in     vl_logic;
        q               : out    vl_logic_vector;
        qbin            : out    vl_logic_vector
    );
end a_graycounter;
