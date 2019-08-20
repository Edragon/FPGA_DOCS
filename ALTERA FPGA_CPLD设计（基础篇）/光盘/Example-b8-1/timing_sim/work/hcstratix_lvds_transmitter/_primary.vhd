library verilog;
use verilog.vl_types.all;
entity hcstratix_lvds_transmitter is
    generic(
        channel_width   : integer := 4;
        bypass_serializer: string  := "false";
        invert_clock    : string  := "false";
        use_falling_clock_edge: string  := "false";
        lpm_type        : string  := "hcstratix_lvds_transmitter"
    );
    port(
        clk0            : in     vl_logic;
        enable0         : in     vl_logic;
        datain          : in     vl_logic_vector(9 downto 0);
        dataout         : out    vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end hcstratix_lvds_transmitter;
