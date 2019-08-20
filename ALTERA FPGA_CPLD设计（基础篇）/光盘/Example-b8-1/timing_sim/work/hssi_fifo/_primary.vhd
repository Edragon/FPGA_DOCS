library verilog;
use verilog.vl_types.all;
entity hssi_fifo is
    generic(
        channel_width   : integer := 1
    );
    port(
        datain          : in     vl_logic_vector;
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        we              : in     vl_logic;
        re              : in     vl_logic;
        reset           : in     vl_logic;
        dataout         : out    vl_logic_vector;
        empty           : out    vl_logic;
        overflow        : out    vl_logic
    );
end hssi_fifo;
