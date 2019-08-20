library verilog;
use verilog.vl_types.all;
entity altfp_mult is
    generic(
        width_exp       : integer := 8;
        width_man       : integer := 23;
        dedicated_multiplier_circuitry: string  := "AUTO";
        reduced_functionality: string  := "NO";
        pipeline        : integer := 5;
        lpm_hint        : string  := "UNUSED";
        lpm_type        : string  := "altfp_mult"
    );
    port(
        clock           : in     vl_logic;
        clk_en          : in     vl_logic;
        aclr            : in     vl_logic;
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        result          : out    vl_logic_vector;
        overflow        : out    vl_logic;
        underflow       : out    vl_logic;
        zero            : out    vl_logic;
        denormal        : out    vl_logic;
        indefinite      : out    vl_logic;
        nan             : out    vl_logic
    );
end altfp_mult;
