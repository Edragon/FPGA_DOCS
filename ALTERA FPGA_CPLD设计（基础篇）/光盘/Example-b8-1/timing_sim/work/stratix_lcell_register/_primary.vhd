library verilog;
use verilog.vl_types.all;
entity stratix_lcell_register is
    generic(
        synch_mode      : string  := "off";
        register_cascade_mode: string  := "off";
        power_up        : string  := "low";
        x_on_violation  : string  := "on"
    );
    port(
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        aload           : in     vl_logic;
        sclr            : in     vl_logic;
        sload           : in     vl_logic;
        ena             : in     vl_logic;
        datain          : in     vl_logic;
        datac           : in     vl_logic;
        regcascin       : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        regout          : out    vl_logic;
        qfbkout         : out    vl_logic
    );
end stratix_lcell_register;
