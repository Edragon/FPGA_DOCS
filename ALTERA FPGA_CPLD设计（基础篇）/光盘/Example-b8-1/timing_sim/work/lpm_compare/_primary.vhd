library verilog;
use verilog.vl_types.all;
entity lpm_compare is
    generic(
        lpm_width       : integer := 1;
        lpm_representation: string  := "UNSIGNED";
        lpm_pipeline    : integer := 0;
        lpm_type        : string  := "lpm_compare";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        alb             : out    vl_logic;
        aeb             : out    vl_logic;
        agb             : out    vl_logic;
        aleb            : out    vl_logic;
        aneb            : out    vl_logic;
        ageb            : out    vl_logic
    );
end lpm_compare;
