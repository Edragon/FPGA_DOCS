library verilog;
use verilog.vl_types.all;
entity altsqrt is
    generic(
        q_port_width    : integer := 1;
        r_port_width    : integer := 1;
        width           : integer := 1;
        pipeline        : integer := 0;
        lpm_hint        : string  := "UNUSED";
        lpm_type        : string  := "altsqrt"
    );
    port(
        radical         : in     vl_logic_vector;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        aclr            : in     vl_logic;
        q               : out    vl_logic_vector;
        remainder       : out    vl_logic_vector
    );
end altsqrt;
