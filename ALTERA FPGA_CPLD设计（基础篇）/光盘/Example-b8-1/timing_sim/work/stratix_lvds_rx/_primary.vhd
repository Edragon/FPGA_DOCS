library verilog;
use verilog.vl_types.all;
entity stratix_lvds_rx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4;
        registered_data_align_input: string  := "ON"
    );
    port(
        rx_in           : in     vl_logic_vector;
        rx_fastclk      : in     vl_logic;
        rx_slowclk      : in     vl_logic;
        rx_data_align   : in     vl_logic;
        rx_enable0      : in     vl_logic;
        rx_enable1      : in     vl_logic;
        rx_locked       : in     vl_logic;
        rx_out          : out    vl_logic_vector
    );
end stratix_lvds_rx;
