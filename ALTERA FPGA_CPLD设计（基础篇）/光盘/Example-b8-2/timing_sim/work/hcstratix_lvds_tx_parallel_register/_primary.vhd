library verilog;
use verilog.vl_types.all;
entity hcstratix_lvds_tx_parallel_register is
    generic(
        channel_width   : integer := 4
    );
    port(
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        datain          : in     vl_logic_vector(9 downto 0);
        dataout         : out    vl_logic_vector(9 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end hcstratix_lvds_tx_parallel_register;
