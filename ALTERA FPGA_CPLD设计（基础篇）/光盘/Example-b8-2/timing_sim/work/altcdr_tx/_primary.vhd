library verilog;
use verilog.vl_types.all;
entity altcdr_tx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 3;
        inclock_period  : integer := 0;
        inclock_boost   : integer := 1;
        bypass_fifo     : string  := "OFF";
        intended_device_family: string  := "MERCURY";
        lpm_type        : string  := "altcdr_tx"
    );
    port(
        tx_in           : in     vl_logic_vector;
        tx_inclock      : in     vl_logic;
        tx_coreclock    : in     vl_logic;
        tx_aclr         : in     vl_logic;
        tx_pll_aclr     : in     vl_logic;
        tx_fifo_wren    : in     vl_logic_vector;
        tx_out          : out    vl_logic_vector;
        tx_outclock     : out    vl_logic;
        tx_pll_locked   : out    vl_logic;
        tx_full         : out    vl_logic_vector;
        tx_empty        : out    vl_logic_vector
    );
end altcdr_tx;
