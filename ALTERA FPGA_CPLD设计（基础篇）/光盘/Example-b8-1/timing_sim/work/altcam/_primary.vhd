library verilog;
use verilog.vl_types.all;
entity altcam is
    generic(
        width           : integer := 1;
        widthad         : integer := 1;
        numwords        : integer := 1;
        lpm_file        : string  := "UNUSED";
        lpm_filex       : string  := "UNUSED";
        match_mode      : string  := "MULTIPLE";
        output_reg      : string  := "UNREGISTERED";
        output_aclr     : string  := "OFF";
        pattern_reg     : string  := "INCLOCK";
        pattern_aclr    : string  := "ON";
        wraddress_aclr  : string  := "ON";
        wrx_reg         : string  := "UNUSED";
        wrx_aclr        : string  := "UNUSED";
        wrcontrol_aclr  : string  := "OFF";
        use_eab         : string  := "ON";
        lpm_type        : string  := "altcam"
    );
    port(
        pattern         : in     vl_logic_vector;
        wrx             : in     vl_logic_vector;
        wrxused         : in     vl_logic;
        wrdelete        : in     vl_logic;
        wraddress       : in     vl_logic_vector;
        wren            : in     vl_logic;
        inclock         : in     vl_logic;
        inclocken       : in     vl_logic;
        inaclr          : in     vl_logic;
        outclock        : in     vl_logic;
        outclocken      : in     vl_logic;
        outaclr         : in     vl_logic;
        mstart          : in     vl_logic;
        mnext           : in     vl_logic;
        maddress        : out    vl_logic_vector;
        mbits           : out    vl_logic_vector;
        mfound          : out    vl_logic;
        mcount          : out    vl_logic_vector;
        rdbusy          : out    vl_logic;
        wrbusy          : out    vl_logic
    );
end altcam;
