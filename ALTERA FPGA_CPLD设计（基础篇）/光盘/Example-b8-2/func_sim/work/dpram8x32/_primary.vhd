library verilog;
use verilog.vl_types.all;
entity dpram8x32 is
    port(
        data            : in     vl_logic_vector(7 downto 0);
        wren            : in     vl_logic;
        wraddress       : in     vl_logic_vector(4 downto 0);
        rdaddress       : in     vl_logic_vector(4 downto 0);
        rden            : in     vl_logic;
        clock           : in     vl_logic;
        aclr            : in     vl_logic;
        q               : out    vl_logic_vector(7 downto 0)
    );
end dpram8x32;
