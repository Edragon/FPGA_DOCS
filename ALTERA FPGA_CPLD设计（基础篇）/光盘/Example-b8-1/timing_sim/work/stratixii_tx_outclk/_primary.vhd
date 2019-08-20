library verilog;
use verilog.vl_types.all;
entity stratixii_tx_outclk is
    generic(
        deserialization_factor: integer := 4;
        bypass_serializer: string  := "FALSE";
        use_falling_clock_edge: string  := "FALSE"
    );
    port(
        tx_in           : in     vl_logic_vector;
        tx_fastclk      : in     vl_logic;
        tx_enable       : in     vl_logic;
        tx_out          : out    vl_logic
    );
end stratixii_tx_outclk;
