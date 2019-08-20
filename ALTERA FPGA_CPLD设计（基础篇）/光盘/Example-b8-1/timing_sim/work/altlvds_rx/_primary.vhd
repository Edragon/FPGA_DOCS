library verilog;
use verilog.vl_types.all;
entity altlvds_rx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4;
        registered_output: string  := "ON";
        inclock_period  : integer := 10000;
        cds_mode        : string  := "UNUSED";
        intended_device_family: string  := "APEX20KE";
        input_data_rate : integer := 0;
        inclock_data_alignment: string  := "EDGE_ALIGNED";
        registered_data_align_input: string  := "ON";
        common_rx_tx_pll: string  := "ON";
        enable_dpa_mode : string  := "OFF";
        enable_dpa_fifo : string  := "ON";
        use_dpll_rawperror: string  := "OFF";
        use_coreclock_input: string  := "OFF";
        dpll_lock_count : integer := 0;
        dpll_lock_window: integer := 0;
        outclock_resource: string  := "AUTO";
        lose_lock_on_one_change: string  := "OFF";
        reset_fifo_at_first_lock: string  := "ON";
        use_external_pll: string  := "OFF";
        lpm_hint        : string  := "UNUSED";
        lpm_type        : string  := "altlvds_rx";
        clk_src_is_pll  : string  := "off"
    );
    port(
        rx_in           : in     vl_logic_vector;
        rx_inclock      : in     vl_logic;
        rx_enable       : in     vl_logic;
        rx_deskew       : in     vl_logic;
        rx_pll_enable   : in     vl_logic;
        rx_data_align   : in     vl_logic;
        rx_reset        : in     vl_logic_vector;
        rx_dpll_reset   : in     vl_logic_vector;
        rx_dpll_hold    : in     vl_logic_vector;
        rx_dpll_enable  : in     vl_logic_vector;
        rx_fifo_reset   : in     vl_logic_vector;
        rx_channel_data_align: in     vl_logic_vector;
        rx_cda_reset    : in     vl_logic_vector;
        rx_coreclk      : in     vl_logic_vector;
        pll_areset      : in     vl_logic;
        rx_out          : out    vl_logic_vector;
        rx_outclock     : out    vl_logic;
        rx_locked       : out    vl_logic;
        rx_dpa_locked   : out    vl_logic_vector;
        rx_cda_max      : out    vl_logic_vector
    );
end altlvds_rx;
