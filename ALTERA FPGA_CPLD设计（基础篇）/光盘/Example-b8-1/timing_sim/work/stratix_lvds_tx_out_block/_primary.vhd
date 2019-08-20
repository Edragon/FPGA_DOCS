library verilog;
use verilog.vl_types.all;
entity stratix_lvds_tx_out_block is
    generic(
        bypass_serializer: string  := "false";
        invert_clock    : string  := "false";
        use_falling_clock_edge: string  := "false"
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic;
        dataout         : out    vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratix_lvds_tx_out_block;
