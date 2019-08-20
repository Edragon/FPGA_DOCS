library verilog;
use verilog.vl_types.all;
entity stratixii_lvds_rx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4;
        enable_dpa_mode : string  := "OFF";
        lose_lock_on_one_change: string  := "OFF";
        reset_fifo_at_first_lock: string  := "ON";
        mux_width       : integer := 12;
        ram_width       : integer := 6
    );
    port(
        rx_in           : in     vl_logic_vector;
        rx_reset        : in     vl_logic_vector;
        rx_fastclk      : in     vl_logic;
        rx_enable       : in     vl_logic;
        rx_locked       : in     vl_logic;
        rx_dpll_hold    : in     vl_logic_vector;
        rx_dpll_enable  : in     vl_logic_vector;
        rx_fifo_reset   : in     vl_logic_vector;
        rx_channel_data_align: in     vl_logic_vector;
        rx_cda_reset    : in     vl_logic_vector;
        rx_out          : out    vl_logic_vector;
        rx_dpa_locked   : out    vl_logic_vector;
        rx_cda_max      : out    vl_logic_vector
    );
end stratixii_lvds_rx;
