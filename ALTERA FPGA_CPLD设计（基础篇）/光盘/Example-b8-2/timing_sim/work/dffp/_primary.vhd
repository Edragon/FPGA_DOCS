library verilog;
use verilog.vl_types.all;
entity dffp is
    port(
        q               : out    vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        d               : in     vl_logic;
        clrn            : in     vl_logic;
        prn             : in     vl_logic
    );
end dffp;
