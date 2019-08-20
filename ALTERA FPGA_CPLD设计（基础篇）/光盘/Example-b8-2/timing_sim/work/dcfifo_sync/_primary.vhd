library verilog;
use verilog.vl_types.all;
entity dcfifo_sync is
    generic(
        lpm_width       : integer := 1;
        lpm_widthu      : integer := 1;
        lpm_numwords    : integer := 2;
        intended_device_family: string  := "APEX20KE";
        lpm_showahead   : string  := "OFF";
        underflow_checking: string  := "ON";
        overflow_checking: string  := "ON";
        use_eab         : string  := "ON";
        add_ram_output_register: string  := "OFF"
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
end dcfifo_sync;
