library verilog;
use verilog.vl_types.all;
entity altshift_taps is
    generic(
        number_of_taps  : integer := 4;
        tap_distance    : integer := 3;
        width           : integer := 8;
        power_up_state  : string  := "CLEARED";
        lpm_type        : string  := "altshift_taps";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        shiftin         : in     vl_logic_vector;
        clock           : in     vl_logic;
        clken           : in     vl_logic;
        shiftout        : out    vl_logic_vector;
        taps            : out    vl_logic_vector
    );
end altshift_taps;
