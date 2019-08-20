library verilog;
use verilog.vl_types.all;
entity stratix_asynch_io is
    generic(
        operation_mode  : string  := "input";
        bus_hold        : string  := "false";
        open_drain_output: string  := "false";
        phase_shift     : string  := "0";
        input_frequency : string  := "10000 ps"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        regin           : in     vl_logic;
        ddioregin       : in     vl_logic;
        padio           : inout  vl_logic;
        delayctrlin     : in     vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic;
        ddioregout      : out    vl_logic;
        dqsundelayedout : out    vl_logic
    );
end stratix_asynch_io;
