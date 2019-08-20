library verilog;
use verilog.vl_types.all;
entity dcfifo_dffpipe is
    generic(
        lpm_delay       : integer := 1;
        lpm_width       : integer := 64
    );
    port(
        d               : in     vl_logic_vector;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        q               : out    vl_logic_vector
    );
end dcfifo_dffpipe;
