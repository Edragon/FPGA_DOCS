library verilog;
use verilog.vl_types.all;
entity altlvds_tx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4;
        registered_input: string  := "ON";
        multi_clock     : string  := "OFF";
        inclock_period  : integer := 10000;
        center_align_msb: string  := "OFF";
        intended_device_family: string  := "APEX20KE";
        output_data_rate: integer := 0;
        inclock_data_alignment: string  := "EDGE_ALIGNED";
        outclock_alignment: string  := "EDGE_ALIGNED";
        common_rx_tx_pll: string  := "ON";
        outclock_resource: string  := "AUTO";
        use_external_pll: string  := "OFF";
        preemphasis_setting: integer := 0;
        vod_setting     : integer := 0;
        differential_drive: integer := 0;
        lpm_type        : string  := "altlvds_tx";
        clk_src_is_pll  : string  := "off"
    );
    port(
        tx_in           : in     vl_logic_vector;
        tx_inclock      : in     vl_logic;
        tx_enable       : in     vl_logic;
        sync_inclock    : in     vl_logic;
        tx_pll_enable   : in     vl_logic;
        pll_areset      : in     vl_logic;
        tx_out          : out    vl_logic_vector;
        tx_outclock     : out    vl_logic;
        tx_coreclock    : out    vl_logic;
        tx_locked       : out    vl_logic
    );
end altlvds_tx;
