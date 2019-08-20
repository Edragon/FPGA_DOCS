library verilog;
use verilog.vl_types.all;
entity mf_ram7x20_syn is
    generic(
        ram_width       : integer := 20
    );
    port(
        wclk            : in     vl_logic;
        rst_l           : in     vl_logic;
        addr_wr         : in     vl_logic_vector(2 downto 0);
        addr_rd         : in     vl_logic_vector(2 downto 0);
        data_in         : in     vl_logic_vector(19 downto 0);
        we              : in     vl_logic;
        re              : in     vl_logic;
        data_out        : out    vl_logic_vector(19 downto 0)
    );
end mf_ram7x20_syn;
