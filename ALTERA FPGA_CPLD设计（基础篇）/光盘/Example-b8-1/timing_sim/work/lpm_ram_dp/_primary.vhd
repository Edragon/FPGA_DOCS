library verilog;
use verilog.vl_types.all;
entity lpm_ram_dp is
    generic(
        lpm_width       : integer := 1;
        lpm_widthad     : integer := 1;
        lpm_indata      : string  := "REGISTERED";
        lpm_rdaddress_control: string  := "REGISTERED";
        lpm_wraddress_control: string  := "REGISTERED";
        lpm_outdata     : string  := "REGISTERED";
        lpm_file        : string  := "UNUSED";
        use_eab         : string  := "OFF";
        rden_used       : string  := "TRUE";
        intended_device_family: string  := "APEX20KE";
        lpm_type        : string  := "lpm_ram_dp";
        lpm_hint        : string  := "UNUSED"
    );
    port(
        data            : in     vl_logic_vector;
        rdaddress       : in     vl_logic_vector;
        wraddress       : in     vl_logic_vector;
        rdclock         : in     vl_logic;
        rdclken         : in     vl_logic;
        wrclock         : in     vl_logic;
        wrclken         : in     vl_logic;
        rden            : in     vl_logic;
        wren            : in     vl_logic;
        q               : out    vl_logic_vector
    );
end lpm_ram_dp;
