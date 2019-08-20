library verilog;
use verilog.vl_types.all;
entity hssi_pll is
    generic(
        clk0_multiply_by: integer := 1;
        clk1_divide_by  : integer := 1;
        input_frequency : integer := 1000
    );
    port(
        clk             : in     vl_logic;
        areset          : in     vl_logic;
        clk0            : out    vl_logic;
        clk1            : out    vl_logic;
        locked          : out    vl_logic
    );
end hssi_pll;
