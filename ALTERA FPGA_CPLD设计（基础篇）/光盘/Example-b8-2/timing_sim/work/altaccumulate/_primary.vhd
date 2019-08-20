library verilog;
use verilog.vl_types.all;
entity altaccumulate is
    generic(
        width_in        : integer := 4;
        width_out       : integer := 8;
        lpm_representation: string  := "UNSIGNED";
        extra_latency   : integer := 0;
        use_wys         : string  := "ON";
        lpm_hint        : string  := "UNUSED";
        lpm_type        : string  := "altaccumulate"
    );
    port(
        cin             : in     vl_logic;
        data            : in     vl_logic_vector;
        add_sub         : in     vl_logic;
        clock           : in     vl_logic;
        sload           : in     vl_logic;
        clken           : in     vl_logic;
        sign_data       : in     vl_logic;
        aclr            : in     vl_logic;
        result          : out    vl_logic_vector;
        cout            : out    vl_logic;
        overflow        : out    vl_logic
    );
end altaccumulate;
