library verilog;
use verilog.vl_types.all;
entity altcdr_rx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 3;
        inclock_period  : integer := 20000;
        inclock_boost   : integer := 1;
        run_length      : integer := 62;
        bypass_fifo     : string  := "OFF";
        intended_device_family: string  := "MERCURY";
        lpm_type        : string  := "altcdr_rx";
        run_length_max  : integer := 62
    );
    port(
        rx_in           : in     vl_logic_vector;
        rx_inclock      : in     vl_logic;
        rx_coreclock    : in     vl_logic;
        rx_aclr         : in     vl_logic;
        rx_pll_aclr     : in     vl_logic;
        rx_fifo_rden    : in     vl_logic_vector;
        rx_out          : out    vl_logic_vector;
        rx_outclock     : out    vl_logic;
        rx_pll_locked   : out    vl_logic;
        rx_locklost     : out    vl_logic_vector;
        rx_rlv          : out    vl_logic_vector;
        rx_full         : out    vl_logic_vector;
        rx_empty        : out    vl_logic_vector;
        rx_rec_clk      : out    vl_logic_vector
    );
end altcdr_rx;
