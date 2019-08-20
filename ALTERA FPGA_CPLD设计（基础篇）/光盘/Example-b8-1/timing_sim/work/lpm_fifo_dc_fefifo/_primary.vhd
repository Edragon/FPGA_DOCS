library verilog;
use verilog.vl_types.all;
entity lpm_fifo_dc_fefifo is
    generic(
        lpm_widthad     : integer := 1;
        lpm_numwords    : integer := 1;
        underflow_checking: string  := "ON";
        overflow_checking: string  := "ON";
        lpm_mode        : string  := "READ";
        lpm_hint        : string  := ""
    );
    port(
        usedw_in        : in     vl_logic_vector;
        wreq            : in     vl_logic;
        rreq            : in     vl_logic;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        empty           : out    vl_logic;
        full            : out    vl_logic
    );
end lpm_fifo_dc_fefifo;
