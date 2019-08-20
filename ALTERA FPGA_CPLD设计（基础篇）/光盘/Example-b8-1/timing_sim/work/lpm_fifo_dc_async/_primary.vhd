library verilog;
use verilog.vl_types.all;
entity lpm_fifo_dc_async is
    generic(
        lpm_width       : integer := 1;
        lpm_widthu      : integer := 1;
        lpm_numwords    : integer := 2;
        delay_rdusedw   : integer := 1;
        delay_wrusedw   : integer := 1;
        rdsync_delaypipe: integer := 3;
        wrsync_delaypipe: integer := 3;
        lpm_showahead   : string  := "OFF";
        underflow_checking: string  := "ON";
        overflow_checking: string  := "ON";
        lpm_hint        : string  := "INTENDED_DEVICE_FAMILY=APEX20KE"
    );
    port(
        data            : in     vl_logic_vector;
        rdclk           : in     vl_logic;
        wrclk           : in     vl_logic;
        aclr            : in     vl_logic;
        rdreq           : in     vl_logic;
        wrreq           : in     vl_logic;
        rdfull          : out    vl_logic;
        wrfull          : out    vl_logic;
        rdempty         : out    vl_logic;
        wrempty         : out    vl_logic;
        rdusedw         : out    vl_logic_vector;
        wrusedw         : out    vl_logic_vector;
        q               : out    vl_logic_vector
    );
end lpm_fifo_dc_async;
