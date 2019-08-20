library verilog;
use verilog.vl_types.all;
entity lpm_counter is
    generic(
        lpm_width       : integer := 1;
        lpm_direction   : string  := "UNUSED";
        lpm_modulus     : integer := 0;
        lpm_avalue      : string  := "UNUSED";
        lpm_svalue      : string  := "UNUSED";
        lpm_pvalue      : string  := "UNUSED";
        lpm_type        : string  := "lpm_counter";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        clock           : in     vl_logic;
        clk_en          : in     vl_logic;
        cnt_en          : in     vl_logic;
        updown          : in     vl_logic;
        aclr            : in     vl_logic;
        aset            : in     vl_logic;
        aload           : in     vl_logic;
        sclr            : in     vl_logic;
        sset            : in     vl_logic;
        sload           : in     vl_logic;
        data            : in     vl_logic_vector;
        cin             : in     vl_logic;
        q               : out    vl_logic_vector;
        cout            : out    vl_logic;
        eq              : out    vl_logic_vector(15 downto 0)
    );
end lpm_counter;
