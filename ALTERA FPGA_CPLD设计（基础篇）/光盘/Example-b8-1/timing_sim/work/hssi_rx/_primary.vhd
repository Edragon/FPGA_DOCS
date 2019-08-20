library verilog;
use verilog.vl_types.all;
entity hssi_rx is
    generic(
        channel_width   : integer := 1;
        operation_mode  : string  := "CDR";
        run_length      : integer := 1
    );
    port(
        clk             : in     vl_logic;
        coreclk         : in     vl_logic;
        datain          : in     vl_logic;
        areset          : in     vl_logic;
        feedback        : in     vl_logic;
        fbkcntl         : in     vl_logic;
        dataout         : out    vl_logic_vector;
        clkout          : out    vl_logic;
        rlv             : out    vl_logic;
        locked          : out    vl_logic
    );
end hssi_rx;
