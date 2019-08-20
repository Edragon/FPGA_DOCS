library verilog;
use verilog.vl_types.all;
entity hcstratix_io_register is
    generic(
        async_reset     : string  := "none";
        sync_reset      : string  := "none";
        power_up        : string  := "low"
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic;
        ena             : in     vl_logic;
        sreset          : in     vl_logic;
        areset          : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        regout          : out    vl_logic
    );
end hcstratix_io_register;
