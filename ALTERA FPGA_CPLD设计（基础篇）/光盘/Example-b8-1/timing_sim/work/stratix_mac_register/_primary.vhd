library verilog;
use verilog.vl_types.all;
entity stratix_mac_register is
    generic(
        data_width      : integer := 18;
        power_up        : integer := 0
    );
    port(
        data            : in     vl_logic_vector(71 downto 0);
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        if_aclr         : in     vl_logic;
        ena             : in     vl_logic;
        async           : in     vl_logic;
        dataout         : out    vl_logic_vector(71 downto 0)
    );
end stratix_mac_register;
