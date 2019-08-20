library verilog;
use verilog.vl_types.all;
entity hssi_tx is
    generic(
        channel_width   : integer := 1
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic_vector;
        areset          : in     vl_logic;
        dataout         : out    vl_logic;
        clkout          : out    vl_logic
    );
end hssi_tx;
