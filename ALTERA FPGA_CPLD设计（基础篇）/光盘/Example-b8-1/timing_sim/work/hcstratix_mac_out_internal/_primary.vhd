library verilog;
use verilog.vl_types.all;
entity hcstratix_mac_out_internal is
    generic(
        operation_mode  : string  := "output_only";
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        datac_width     : integer := 36;
        datad_width     : integer := 36;
        dataout_width   : integer := 72
    );
    port(
        dataa           : in     vl_logic_vector(35 downto 0);
        datab           : in     vl_logic_vector(35 downto 0);
        datac           : in     vl_logic_vector(35 downto 0);
        datad           : in     vl_logic_vector(35 downto 0);
        signx           : in     vl_logic;
        signy           : in     vl_logic;
        addnsub0        : in     vl_logic;
        addnsub1        : in     vl_logic;
        zeroacc         : in     vl_logic;
        dataout_global  : in     vl_logic_vector(71 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0);
        accoverflow     : out    vl_logic
    );
end hcstratix_mac_out_internal;
