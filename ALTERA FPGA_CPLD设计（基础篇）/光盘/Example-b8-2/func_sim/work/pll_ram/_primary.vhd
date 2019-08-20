library verilog;
use verilog.vl_types.all;
entity pll_ram is
    port(
        clk_in          : in     vl_logic;
        rst             : in     vl_logic;
        data_in         : in     vl_logic_vector(7 downto 0);
        wr_en           : in     vl_logic;
        rd_en           : in     vl_logic;
        rd_addr         : in     vl_logic_vector(4 downto 0);
        clk_out         : out    vl_logic;
        lock            : out    vl_logic;
        package_full    : out    vl_logic;
        data_out        : out    vl_logic_vector(7 downto 0)
    );
end pll_ram;
