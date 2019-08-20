library verilog;
use verilog.vl_types.all;
entity hcstratix_mac_mult_internal is
    generic(
        dataa_width     : integer := 18;
        datab_width     : integer := 18;
        dataout_width   : integer := 36
    );
    port(
        dataa           : in     vl_logic_vector(17 downto 0);
        datab           : in     vl_logic_vector(17 downto 0);
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        scanouta        : out    vl_logic_vector(17 downto 0);
        scanoutb        : out    vl_logic_vector(17 downto 0);
        dataout         : out    vl_logic_vector(35 downto 0)
    );
end hcstratix_mac_mult_internal;
