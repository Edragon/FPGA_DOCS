library verilog;
use verilog.vl_types.all;
entity hcstratix_ram_clear is
    port(
        aclr            : in     vl_logic;
        d               : in     vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        edg             : in     vl_logic;
        q               : out    vl_logic
    );
end hcstratix_ram_clear;
