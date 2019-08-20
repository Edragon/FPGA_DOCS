library verilog;
use verilog.vl_types.all;
entity lpm_ram_dq is
    generic(
        lpm_width       : integer := 1;
        lpm_widthad     : integer := 1;
        lpm_indata      : string  := "REGISTERED";
        lpm_address_control: string  := "REGISTERED";
        lpm_outdata     : string  := "REGISTERED";
        lpm_file        : string  := "UNUSED";
        use_eab         : string  := "OFF";
        intended_device_family: string  := "APEX20KE";
        lpm_type        : string  := "lpm_ram_dq";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        address         : in     vl_logic_vector;
        inclock         : in     vl_logic;
        outclock        : in     vl_logic;
        we              : in     vl_logic;
        q               : out    vl_logic_vector
    );
end lpm_ram_dq;
