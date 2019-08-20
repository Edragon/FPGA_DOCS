library verilog;
use verilog.vl_types.all;
entity hcstratix_ram_register is
    generic(
        data_width      : integer := 144;
        sclr            : string  := "true";
        preset          : string  := "false"
    );
    port(
        data            : in     vl_logic_vector(143 downto 0);
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        ena             : in     vl_logic;
        ifclk           : in     vl_logic;
        ifaclr          : in     vl_logic;
        ifena           : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        powerup         : in     vl_logic;
        dataout         : out    vl_logic_vector(143 downto 0);
        aclrout         : out    vl_logic;
        clkout          : out    vl_logic;
        done            : out    vl_logic
    );
end hcstratix_ram_register;
