library verilog;
use verilog.vl_types.all;
entity arm_scale_cntr is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        cout            : out    vl_logic;
        high            : in     vl_logic_vector(31 downto 0);
        low             : in     vl_logic_vector(31 downto 0);
        initial_value   : in     vl_logic_vector(31 downto 0);
        mode            : in     vl_logic_vector(48 downto 1);
        ph_tap          : in     vl_logic_vector(31 downto 0)
    );
end arm_scale_cntr;
