library verilog;
use verilog.vl_types.all;
entity lpm_rom is
    generic(
        lpm_width       : integer := 1;
        lpm_widthad     : integer := 1;
        lpm_numwords    : integer := 0;
        lpm_address_control: string  := "REGISTERED";
        lpm_outdata     : string  := "REGISTERED";
        lpm_file        : string  := "";
        intended_device_family: string  := "APEX20KE";
        lpm_type        : string  := "lpm_rom";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        address         : in     vl_logic_vector;
        inclock         : in     vl_logic;
        outclock        : in     vl_logic;
        memenab         : in     vl_logic;
        q               : out    vl_logic_vector
    );
end lpm_rom;
