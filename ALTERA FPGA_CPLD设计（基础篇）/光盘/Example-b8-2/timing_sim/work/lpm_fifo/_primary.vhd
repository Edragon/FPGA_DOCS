library verilog;
use verilog.vl_types.all;
entity lpm_fifo is
    generic(
        lpm_width       : integer := 1;
        lpm_widthu      : integer := 1;
        lpm_numwords    : integer := 2;
        lpm_showahead   : string  := "OFF";
        lpm_type        : string  := "lpm_fifo";
        lpm_hint        : string  := "INTENDED_DEVICE_FAMILY=APEX20KE"
    );
    port(
        data            : in     vl_logic_vector;
        clock           : in     vl_logic;
        wrreq           : in     vl_logic;
        rdreq           : in     vl_logic;
        aclr            : in     vl_logic;
        sclr            : in     vl_logic;
        q               : out    vl_logic_vector;
        usedw           : out    vl_logic_vector;
        full            : out    vl_logic;
        empty           : out    vl_logic
    );
end lpm_fifo;
