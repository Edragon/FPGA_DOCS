library verilog;
use verilog.vl_types.all;
entity parallel_add is
    generic(
        width           : integer := 4;
        size            : integer := 2;
        widthr          : integer := 4;
        shift           : integer := 0;
        msw_subtract    : string  := "NO";
        representation  : string  := "UNSIGNED";
        pipeline        : integer := 0;
        result_alignment: string  := "LSB";
        lpm_type        : string  := "parallel_add"
    );
    port(
        data            : in     vl_logic_vector;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        clken           : in     vl_logic;
        result          : out    vl_logic_vector
    );
end parallel_add;
