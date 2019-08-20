library verilog;
use verilog.vl_types.all;
entity alt3pram is
    generic(
        width           : integer := 1;
        widthad         : integer := 1;
        numwords        : integer := 0;
        lpm_file        : string  := "UNUSED";
        lpm_hint        : string  := "USE_EAB=ON";
        indata_reg      : string  := "UNREGISTERED";
        indata_aclr     : string  := "OFF";
        write_reg       : string  := "UNREGISTERED";
        write_aclr      : string  := "OFF";
        rdaddress_reg_a : string  := "UNREGISTERED";
        rdaddress_aclr_a: string  := "OFF";
        rdcontrol_reg_a : string  := "UNREGISTERED";
        rdcontrol_aclr_a: string  := "OFF";
        rdaddress_reg_b : string  := "UNREGISTERED";
        rdaddress_aclr_b: string  := "OFF";
        rdcontrol_reg_b : string  := "UNREGISTERED";
        rdcontrol_aclr_b: string  := "OFF";
        outdata_reg_a   : string  := "UNREGISTERED";
        outdata_aclr_a  : string  := "OFF";
        outdata_reg_b   : string  := "UNREGISTERED";
        outdata_aclr_b  : string  := "OFF";
        intended_device_family: string  := "APEX20KE";
        ram_block_type  : string  := "AUTO";
        maximum_depth   : integer := 0;
        lpm_type        : string  := "alt3pram"
    );
    port(
        wren            : in     vl_logic;
        data            : in     vl_logic_vector;
        wraddress       : in     vl_logic_vector;
        inclock         : in     vl_logic;
        inclocken       : in     vl_logic;
        rden_a          : in     vl_logic;
        rden_b          : in     vl_logic;
        rdaddress_a     : in     vl_logic_vector;
        rdaddress_b     : in     vl_logic_vector;
        outclock        : in     vl_logic;
        outclocken      : in     vl_logic;
        aclr            : in     vl_logic;
        qa              : out    vl_logic_vector;
        qb              : out    vl_logic_vector
    );
end alt3pram;
