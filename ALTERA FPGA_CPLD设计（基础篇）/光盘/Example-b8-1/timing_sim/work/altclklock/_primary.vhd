library verilog;
use verilog.vl_types.all;
entity altclklock is
    generic(
        inclock_period  : integer := 10000;
        inclock_settings: string  := "UNUSED";
        valid_lock_cycles: integer := 5;
        invalid_lock_cycles: integer := 5;
        valid_lock_multiplier: integer := 5;
        invalid_lock_multiplier: integer := 5;
        operation_mode  : string  := "NORMAL";
        clock0_boost    : integer := 1;
        clock0_divide   : integer := 1;
        clock0_settings : string  := "UNUSED";
        clock0_time_delay: string  := "0";
        clock1_boost    : integer := 1;
        clock1_divide   : integer := 1;
        clock1_settings : string  := "UNUSED";
        clock1_time_delay: string  := "0";
        clock2_boost    : integer := 1;
        clock2_divide   : integer := 1;
        clock2_settings : string  := "UNUSED";
        clock2_time_delay: string  := "0";
        clock_ext_boost : integer := 1;
        clock_ext_divide: integer := 1;
        clock_ext_settings: string  := "UNUSED";
        clock_ext_time_delay: string  := "0";
        outclock_phase_shift: integer := 0;
        intended_device_family: string  := "APEX20KE";
        lpm_type        : string  := "altclklock"
    );
    port(
        inclock         : in     vl_logic;
        inclocken       : in     vl_logic;
        fbin            : in     vl_logic;
        clock0          : out    vl_logic;
        clock1          : out    vl_logic;
        clock2          : out    vl_logic;
        clock_ext       : out    vl_logic;
        locked          : out    vl_logic
    );
end altclklock;
