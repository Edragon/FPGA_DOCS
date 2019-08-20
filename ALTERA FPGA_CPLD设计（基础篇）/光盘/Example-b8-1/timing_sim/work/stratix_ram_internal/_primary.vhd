library verilog;
use verilog.vl_types.all;
entity stratix_ram_internal is
    generic(
        operation_mode  : string  := "single_port";
        ram_block_type  : string  := "M512";
        mixed_port_feed_through_mode: string  := "dont_care";
        port_a_data_width: integer := 16;
        port_b_data_width: integer := 16;
        port_a_address_width: integer := 16;
        port_b_address_width: integer := 16;
        port_a_byte_enable_mask_width: integer := 16;
        port_b_byte_enable_mask_width: integer := 16;
        init_file_layout: string  := "none";
        port_a_first_address: integer := 0;
        port_a_last_address: integer := 4096;
        port_b_first_address: integer := 0;
        port_b_last_address: integer := 4096;
        port_a_address_clear: string  := "none";
        port_b_address_clear: string  := "none";
        mem1            : integer := 0;
        mem2            : integer := 0;
        mem3            : integer := 0;
        mem4            : integer := 0;
        mem5            : integer := 0;
        mem6            : integer := 0;
        mem7            : integer := 0;
        mem8            : integer := 0;
        mem9            : integer := 0
    );
    port(
        portawriteenable: in     vl_logic;
        portbwriteenable: in     vl_logic;
        cleara          : in     vl_logic;
        clearb          : in     vl_logic;
        portadatain     : in     vl_logic_vector(143 downto 0);
        portbdatain     : in     vl_logic_vector(143 downto 0);
        portaaddress    : in     vl_logic_vector(15 downto 0);
        portbaddress    : in     vl_logic_vector(15 downto 0);
        portabyteenamask: in     vl_logic_vector(15 downto 0);
        portbbyteenamask: in     vl_logic_vector(15 downto 0);
        portbreadenable : in     vl_logic;
        portaclock      : in     vl_logic;
        portbclock      : in     vl_logic;
        sameclock       : in     vl_logic;
        portadataout    : out    vl_logic_vector(143 downto 0);
        portbdataout    : out    vl_logic_vector(143 downto 0)
    );
end stratix_ram_internal;
