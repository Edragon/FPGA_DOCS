library verilog;
use verilog.vl_types.all;
entity alt_exc_dpram is
    generic(
        operation_mode  : string  := "SINGLE_PORT";
        addrwidth       : integer := 14;
        width           : integer := 32;
        depth           : integer := 16384;
        ramblock        : integer := 65535;
        output_mode     : string  := "UNREG";
        lpm_file        : string  := "NONE";
        lpm_type        : string  := "alt_exc_dpram"
    );
    port(
        portadatain     : in     vl_logic_vector;
        portadataout    : out    vl_logic_vector;
        portaaddr       : in     vl_logic_vector;
        portawe         : in     vl_logic;
        portaena        : in     vl_logic;
        portaclk        : in     vl_logic;
        portbdatain     : in     vl_logic_vector;
        portbdataout    : out    vl_logic_vector;
        portbaddr       : in     vl_logic_vector;
        portbwe         : in     vl_logic;
        portbena        : in     vl_logic;
        portbclk        : in     vl_logic
    );
end alt_exc_dpram;
