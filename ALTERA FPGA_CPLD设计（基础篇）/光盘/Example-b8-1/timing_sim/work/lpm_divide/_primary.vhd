library verilog;
use verilog.vl_types.all;
entity lpm_divide is
    generic(
        lpm_widthn      : integer := 1;
        lpm_widthd      : integer := 1;
        lpm_nrepresentation: string  := "UNSIGNED";
        lpm_drepresentation: string  := "UNSIGNED";
        lpm_pipeline    : integer := 0;
        lpm_type        : string  := "lpm_divide";
        lpm_hint        : string  := "LPM_REMAINDERPOSITIVE=TRUE"
    );
    port(
        numer           : in     vl_logic_vector;
        denom           : in     vl_logic_vector;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        quotient        : out    vl_logic_vector;
        remain          : out    vl_logic_vector
    );
end lpm_divide;
