library verilog;
use verilog.vl_types.all;
entity scfifo is
    generic(
        lpm_width       : integer := 1;
        lpm_widthu      : integer := 1;
        lpm_numwords    : integer := 2;
        lpm_showahead   : string  := "OFF";
        intended_device_family: string  := "APEX20KE";
        almost_full_value: integer := 0;
        almost_empty_value: integer := 0;
        underflow_checking: string  := "ON";
        overflow_checking: string  := "ON";
        allow_rwcycle_when_full: string  := "OFF";
        lpm_hint        : string  := "USE_EAB=ON";
        use_eab         : string  := "ON";
        add_ram_output_register: string  := "OFF";
        maximum_depth   : integer := 0;
        lpm_type        : string  := "scfifo"
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
        empty           : out    vl_logic;
        almost_full     : out    vl_logic;
        almost_empty    : out    vl_logic
    );
end scfifo;
