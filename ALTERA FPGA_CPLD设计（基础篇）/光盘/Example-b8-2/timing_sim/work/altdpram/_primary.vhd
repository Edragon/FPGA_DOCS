library verilog;
use verilog.vl_types.all;
entity altdpram is
    generic(
        width           : integer := 1;
        widthad         : integer := 1;
        numwords        : integer := 0;
        lpm_file        : string  := "UNUSED";
        lpm_hint        : string  := "USE_EAB=ON";
        use_eab         : string  := "ON";
        lpm_type        : string  := "altdpram";
        indata_reg      : string  := "INCLOCK";
        indata_aclr     : string  := "ON";
        wraddress_reg   : string  := "INCLOCK";
        wraddress_aclr  : string  := "ON";
        wrcontrol_reg   : string  := "INCLOCK";
        wrcontrol_aclr  : string  := "ON";
        rdaddress_reg   : string  := "OUTCLOCK";
        rdaddress_aclr  : string  := "ON";
        rdcontrol_reg   : string  := "OUTCLOCK";
        rdcontrol_aclr  : string  := "ON";
        outdata_reg     : string  := "UNREGISTERED";
        outdata_aclr    : string  := "ON";
        maximum_depth   : integer := 2048;
        intended_device_family: string  := "APEX20KE"
    );
    port(
        wren            : in     vl_logic;
        data            : in     vl_logic_vector;
        wraddress       : in     vl_logic_vector;
        inclock         : in     vl_logic;
        inclocken       : in     vl_logic;
        rden            : in     vl_logic;
        rdaddress       : in     vl_logic_vector;
        outclock        : in     vl_logic;
        outclocken      : in     vl_logic;
        aclr            : in     vl_logic;
        q               : out    vl_logic_vector
    );
end altdpram;
