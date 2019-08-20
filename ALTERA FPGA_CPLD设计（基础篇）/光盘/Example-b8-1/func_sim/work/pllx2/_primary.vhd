library verilog;
use verilog.vl_types.all;
entity pllx2 is
    port(
        inclk0          : in     vl_logic;
        areset          : in     vl_logic;
        c0              : out    vl_logic;
        locked          : out    vl_logic
    );
end pllx2;
