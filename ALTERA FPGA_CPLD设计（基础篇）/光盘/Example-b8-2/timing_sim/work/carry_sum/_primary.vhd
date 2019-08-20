library verilog;
use verilog.vl_types.all;
entity carry_sum is
    port(
        sin             : in     vl_logic;
        cin             : in     vl_logic;
        sout            : out    vl_logic;
        cout            : out    vl_logic
    );
end carry_sum;
