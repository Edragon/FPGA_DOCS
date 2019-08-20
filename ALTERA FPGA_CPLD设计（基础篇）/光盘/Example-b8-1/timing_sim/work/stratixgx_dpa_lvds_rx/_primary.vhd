library verilog;
use verilog.vl_types.all;
entity stratixgx_dpa_lvds_rx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4;
        use_coreclock_input: string  := "OFF";
        enable_dpa_fifo : string  := "ON"
    );
    port(
        rx_in           : in     vl_logic_vector;
        rx_fastclk      : in     vl_logic;
        rx_slowclk      : in     vl_logic;
        rx_locked       : in     vl_logic;
        rx_coreclk      : in     vl_logic_vector;
        rx_reset        : in     vl_logic_vector;
        rx_dpll_reset   : in     vl_logic_vector;
        rx_channel_data_align: in     vl_logic_vector;
        rx_out          : out    vl_logic_vector;
        rx_dpa_locked   : out    vl_logic_vector
    );
end stratixgx_dpa_lvds_rx;
