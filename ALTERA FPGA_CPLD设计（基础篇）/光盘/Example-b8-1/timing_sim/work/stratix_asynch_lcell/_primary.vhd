library verilog;
use verilog.vl_types.all;
entity stratix_asynch_lcell is
    generic(
        operation_mode  : string  := "normal";
        sum_lutc_input  : string  := "datac";
        lut_mask        : string  := "ffff";
        cin_used        : string  := "false";
        cin0_used       : string  := "false";
        cin1_used       : string  := "false"
    );
    port(
        dataa           : in     vl_logic;
        datab           : in     vl_logic;
        datac           : in     vl_logic;
        datad           : in     vl_logic;
        cin             : in     vl_logic;
        cin0            : in     vl_logic;
        cin1            : in     vl_logic;
        inverta         : in     vl_logic;
        qfbkin          : in     vl_logic;
        regin           : out    vl_logic;
        combout         : out    vl_logic;
        cout            : out    vl_logic;
        cout0           : out    vl_logic;
        cout1           : out    vl_logic
    );
end stratix_asynch_lcell;
