library verilog;
use verilog.vl_types.all;
entity altddio_bidir is
    generic(
        width           : integer := 1;
        power_up_high   : string  := "OFF";
        oe_reg          : string  := "UNUSED";
        extend_oe_disable: string  := "UNUSED";
        implement_input_in_lcell: string  := "UNUSED";
        intended_device_family: string  := "MERCURY";
        lpm_type        : string  := "altddio_bidir"
    );
    port(
        datain_h        : in     vl_logic_vector;
        datain_l        : in     vl_logic_vector;
        inclock         : in     vl_logic;
        inclocken       : in     vl_logic;
        outclock        : in     vl_logic;
        outclocken      : in     vl_logic;
        aset            : in     vl_logic;
        aclr            : in     vl_logic;
        oe              : in     vl_logic;
        dataout_h       : out    vl_logic_vector;
        dataout_l       : out    vl_logic_vector;
        combout         : out    vl_logic_vector;
        dqsundelayedout : out    vl_logic_vector;
        padio           : inout  vl_logic_vector
    );
end altddio_bidir;
