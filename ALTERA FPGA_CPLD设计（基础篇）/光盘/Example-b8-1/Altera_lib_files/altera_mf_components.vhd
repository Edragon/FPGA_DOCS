--
-- Copyright (C) 1988-2004 Altera Corporation
--
-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any
-- other associated documentation or information provided by Altera or a
-- partner under Altera's Megafunction Partnership Program may be used only
-- to program PLD devices (but not masked PLD devices) from Altera.  Any
-- other use of such megafunction design, net list, support information,
-- device programming or simulation file, or any other related
-- documentation or information is prohibited for any other purpose,
-- including, but not limited to modification, reverse engineering, de-
-- compiling, or use with any other silicon devices, unless such use is
-- explicitly licensed under a separate agreement with Altera or a
-- megafunction partner.  Title to the intellectual property, including
-- patents, copyrights, trademarks, trade secrets, or maskworks, embodied
-- in any such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information provided by Altera or a megafunction partner, remains with
-- Altera, the megafunction partner, or their respective licensors.  No
-- other licenses, including any licenses needed under any third party's
-- intellectual property, are provided herein.
----------------------------------------------------------------------------
-- ALtera Megafunction Component Declaration File
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package altera_mf_components is
type altera_mf_logic_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;
component altcam
   generic
      ( width:            natural := 1;
        widthad:          natural := 1;
        numwords:         natural := 1;
        lpm_file:         string := "UNUSED";
        lpm_filex:        string := "UNUSED";
        match_mode:       string := "MULTIPLE";
        output_reg:       string := "UNREGISTERED";
        output_aclr:      string := "OFF";
        pattern_reg:      string := "INCLOCK";
        pattern_aclr:     string := "ON";
        wraddress_aclr:   string := "ON";
        wrx_reg:          string := "UNUSED";
        wrx_aclr:         string := "UNUSED";
        wrcontrol_aclr:   string := "OFF";
        use_eab:          string := "ON"; 
        lpm_type : string := "altcam"
       );

        
   port
      ( pattern:    in std_logic_vector(width-1 downto 0);
        wrx:        in std_logic_vector(width-1 downto 0) := (others => '0');
        wrxused:    in std_logic := '1';
        wrdelete:   in std_logic := '0';
        wraddress:  in std_logic_vector(widthad-1 downto 0);
        wren:       in std_logic;
        inclock:    in std_logic;
        inclocken:  in std_logic := '1';
        inaclr:     in std_logic := '0';
        outclock:   in std_logic := '0';
        outclocken: in std_logic := '1';
        outaclr:    in std_logic := '0';
        mstart:     in std_logic := 'X';
        mnext:      in std_logic := '0';
        maddress:   out std_logic_vector(widthad-1 downto 0);
        mbits:      out std_logic_vector(numwords-1 downto 0);
        mfound:     out std_logic;
        mcount:     out std_logic_vector(widthad-1 downto 0);
        rdbusy:     out std_logic;
        wrbusy:     out std_logic );
end component;

component altclklock
generic(
    inclock_period          : natural := 10000;   -- units in ps
    inclock_settings        : string := "UNUSED";
    valid_lock_cycles       : natural := 5;
    invalid_lock_cycles     : natural := 5;
    valid_lock_multiplier   : natural := 5;
    invalid_lock_multiplier : natural := 5;
    operation_mode          : string := "NORMAL";
    clock0_boost            : natural := 1;
    clock0_divide           : natural := 1;
    clock0_settings         : string := "UNUSED";
    clock0_time_delay       : string := "0";
    clock1_boost            : natural := 1;
    clock1_divide           : natural := 1;
    clock1_settings         : string := "UNUSED";
    clock1_time_delay       : string := "0";
    clock2_boost            : natural := 1;
    clock2_divide           : natural := 1;
    clock2_settings         : string := "UNUSED";
    clock2_time_delay       : string := "0";
    clock_ext_boost         : natural := 1;
    clock_ext_divide        : natural := 1;
    clock_ext_settings      : string := "UNUSED";
    clock_ext_time_delay    : string := "0";
    outclock_phase_shift    : natural := 0;   -- units in ps
    intended_device_family  : string := "APEX20KE" ;
    lpm_type                : string := "altclklock"
);
port(
    inclock   : in std_logic;  -- required port, input reference clock
    inclocken : in std_logic := '1';  -- PLL enable signal
    fbin      : in std_logic := '1';  -- feedback input for the PLL

    clock0    : out std_logic;  -- clock0 output
    clock1    : out std_logic;  -- clock1 output
    clock2    : out std_logic;  -- clock2 output, for Mercury only
    clock_ext : out std_logic;  -- external clock output, for Mercury only
    locked    : out std_logic   -- PLL lock signal
);
end component;

component altlvds_rx
    generic
      ( number_of_channels          : natural;
        deserialization_factor      : natural;
        inclock_boost               : natural:= 0;
        registered_output           : string := "ON";
        inclock_period              : natural;
        cds_mode                    : string := "UNUSED";
        intended_device_family      : string := "APEX20KE";
        input_data_rate             : natural:= 0;
        inclock_data_alignment      : string := "EDGE_ALIGNED";
        registered_data_align_input : string :="ON";
        common_rx_tx_pll            : string :="ON";
        enable_dpa_mode             : string := "OFF";
        enable_dpa_fifo             : string := "ON";
        use_dpll_rawperror          : string := "OFF";
        use_coreclock_input         : string := "OFF";
        dpll_lock_count             : natural:= 0;      
        dpll_lock_window            : natural:= 0;
        outclock_resource           : string := "AUTO";
        data_align_rollover         : natural := 10;
        lose_lock_on_one_change     : string  := "OFF";
        reset_fifo_at_first_lock    : string  := "ON";
        use_external_pll            : string  := "OFF";
        lpm_hint                    : string := "UNUSED";
        lpm_type                    : string := "altlvds_rx";
        clk_src_is_pll              : string := "off"
      );
    port
      ( rx_in                 : in std_logic_vector(number_of_channels-1 downto 0);
        rx_inclock            : in std_logic;
        rx_enable             : in std_logic := '1';
        rx_deskew             : in std_logic := '0';
        rx_pll_enable         : in std_logic := '1';
        rx_data_align         : in std_logic := '0';
        rx_reset              : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0'); 
        rx_dpll_reset         : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_dpll_hold          : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_dpll_enable        : in std_logic_vector(number_of_channels-1 downto 0) := (others => '1');
        rx_fifo_reset         : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_channel_data_align : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_cda_reset          : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        rx_coreclk            : in std_logic_vector(number_of_channels-1 downto 0) := (others => '0');
        pll_areset            : in std_logic := '0';   
        rx_out                : out std_logic_vector(deserialization_factor*number_of_channels -1 downto 0);
        rx_outclock           : out std_logic;
        rx_locked             : out std_logic;
        rx_dpa_locked         : out std_logic_vector(number_of_channels-1 downto 0);
        rx_cda_max            : out std_logic_vector(number_of_channels-1 downto 0));
end component;

component altlvds_tx
    generic
      ( number_of_channels     : natural;
        deserialization_factor : natural:= 4;
        inclock_boost          : natural := 0;
        outclock_divide_by     : positive:= 1;
        registered_input       : string := "ON";
        multi_clock            : string := "OFF";
        inclock_period         : natural;
        center_align_msb       : string := "UNUSED";
        intended_device_family : string := "APEX20KE";
        output_data_rate       : natural:= 0;
        outclock_resource      : string := "AUTO";
        common_rx_tx_pll       : string := "ON";
        inclock_data_alignment : string := "EDGE_ALIGNED";
        outclock_alignment     : string := "EDGE_ALIGNED";
        use_external_pll       : string := "OFF";
        preemphasis_setting    : natural := 0;
        vod_setting            : natural := 0;
        differential_drive     : natural := 0;
        lpm_type               : string := "altlvds_tx";
        clk_src_is_pll              : string := "off"
    );
    port
      ( tx_in           : in std_logic_vector(deserialization_factor*number_of_channels -1 downto 0);
        tx_inclock      : in std_logic;
        tx_enable       : in std_logic := '1';
        sync_inclock    : in std_logic := '0';
        tx_pll_enable   : in std_logic := '1';
        pll_areset      : in std_logic := '0';
        tx_out          : out std_logic_vector(number_of_channels-1 downto 0);
        tx_outclock     : out std_logic;
        tx_coreclock    : out std_logic;
        tx_locked       : out std_logic );
end component;

component altdpram
    generic
      ( width                  : natural;
        widthad                : natural;
        numwords               : natural := 0;
        lpm_file               : string := "UNUSED";
        lpm_hint               : string := "USE_EAB=ON";
        use_eab                : string := "ON";
        indata_reg             : string := "UNREGISTERED";
        indata_aclr            : string := "OFF";
        wraddress_reg          : string := "UNREGISTERED";
        wraddress_aclr         : string := "OFF";
        wrcontrol_reg          : string := "UNREGISTERED";
        wrcontrol_aclr         : string := "OFF";
        rdaddress_reg          : string := "UNREGISTERED";
        rdaddress_aclr         : string := "OFF";
        rdcontrol_reg          : string := "UNREGISTERED";
        rdcontrol_aclr         : string := "OFF";
        outdata_reg            : string := "UNREGISTERED";
        outdata_aclr           : string := "OFF";
        intended_device_family : string := "APEX20KE";
        lpm_type               : string := "altdpram" );
    port
      ( wren       : in std_logic := '0';
        data       : in std_logic_vector(width-1 downto 0);
        wraddress  : in std_logic_vector(widthad-1 downto 0);
        inclock    : in std_logic := '0';
        inclocken  : in std_logic := '1';
        rden       : in std_logic := '1';
        rdaddress  : in std_logic_vector(widthad-1 downto 0);
        outclock   : in std_logic := '0';
        outclocken : in std_logic := '1';
        aclr       : in std_logic := '0';
        q          : out std_logic_vector(width-1 downto 0) );
end component;


component alt3pram 
    generic
      ( width                  : natural;
        widthad                : natural;
        numwords               : natural := 0;
        lpm_file               : string := "UNUSED";
        lpm_hint               : string := "USE_EAB=ON";
        indata_reg             : string := "UNREGISTERED";
        indata_aclr            : string := "OFF";
        write_reg       : string := "UNREGISTERED";
        write_aclr          : string := "OFF";
        rdaddress_reg_a          : string := "UNREGISTERED";
        rdaddress_aclr_a         : string := "OFF";
    rdaddress_reg_b          : string := "UNREGISTERED";
        rdaddress_aclr_b         : string := "OFF";
        rdcontrol_reg_a          : string := "UNREGISTERED";
        rdcontrol_aclr_a         : string := "OFF";
    rdcontrol_reg_b          : string := "UNREGISTERED";
        rdcontrol_aclr_b         : string := "OFF";
        outdata_reg_a            : string := "UNREGISTERED";
        outdata_aclr_a           : string := "OFF";
    outdata_reg_b            : string := "UNREGISTERED";
        outdata_aclr_b           : string := "OFF";
        intended_device_family : string := "APEX20KE";
        ram_block_type           : string  := "AUTO";
        maximum_depth            : integer := 0;
        lpm_type : string := "alt3pram"
       );
    port
      ( wren        : in std_logic := '0';
        data        : in std_logic_vector(width-1 downto 0);
        wraddress   : in std_logic_vector(widthad-1 downto 0);
        inclock     : in std_logic := '0';
        inclocken   : in std_logic := '1';
        rden_a      : in std_logic := '1';
    rden_b      : in std_logic := '1';
        rdaddress_a : in std_logic_vector(widthad-1 downto 0);
    rdaddress_b : in std_logic_vector(widthad-1 downto 0);
        outclock    : in std_logic := '0';
        outclocken  : in std_logic := '1';
        aclr        : in std_logic := '0';
    qa          : out std_logic_vector(width-1 downto 0);
        qb          : out std_logic_vector(width-1 downto 0) );
end component;

component altqpram
    generic
      ( operation_mode            : string := "QUAD_PORT";
        width_write_a             : natural := 1;
        widthad_write_a           : natural := 1;
        numwords_write_a          : natural := 0;  -- default = 2^widthad_write_a
        indata_reg_a              : string := "INCLOCK_A";
        indata_aclr_a             : string := "INACLR_A";
        wrcontrol_wraddress_reg_a : string := "INCLOCK_A";
        wrcontrol_aclr_a          : string := "INACLR_A";
        wraddress_aclr_a          : string := "INACLR_A";

        width_write_b             : natural := 1;  -- default = width_write_a
        widthad_write_b           : natural := 1;  -- default = widthad_write_a
        numwords_write_b          : natural := 0;  -- default = 2^widthad_write_b
        indata_reg_b              : string := "INCLOCK_B";
        indata_aclr_b             : string := "INACLR_B";
        wrcontrol_wraddress_reg_b : string := "INCLOCK_B";
        wrcontrol_aclr_b          : string := "INACLR_B";
        wraddress_aclr_b          : string := "INACLR_B";

        width_read_a              : natural := 1;
        widthad_read_a            : natural := 1;
        numwords_read_a           : natural := 0;  -- default = 2^widthad_read_a
        rdcontrol_reg_a           : string := "OUTCLOCK_A";
        rdcontrol_aclr_a          : string := "OUTACLR_A";
        rdaddress_reg_a           : string := "OUTCLOCK_A";
        rdaddress_aclr_a          : string := "OUTACLR_A";
        outdata_reg_a             : string := "UNREGISTERED";
        outdata_aclr_a            : string := "OUTACLR_A";

        width_read_b              : natural := 1;  -- default = width_read_a
        widthad_read_b            : natural := 1;  -- default = widthad_read_a
        numwords_read_b           : natural := 0;  -- default = 2^widthad_read_b
        rdcontrol_reg_b           : string := "OUTCLOCK_B";
        rdcontrol_aclr_b          : string := "OUTACLR_B";
        rdaddress_reg_b           : string := "OUTCLOCK_B";
        rdaddress_aclr_b          : string := "OUTACLR_B";
        outdata_reg_b             : string := "UNREGISTERED";
        outdata_aclr_b            : string := "OUTACLR_B";

        init_file                 : string := "UNUSED";
        lpm_hint                  : string := "UNUSED";
    lpm_type                  : string := "altqpram" );

    port
      ( wren_a       : in std_logic := '0';
        wren_b       : in std_logic := '0';
        data_a       : in std_logic_vector(width_write_a-1 downto 0) := (OTHERS => '0');
        data_b       : in std_logic_vector(width_write_b-1 downto 0) := (OTHERS => '0');
        wraddress_a  : in std_logic_vector(widthad_write_a-1 downto 0) := (OTHERS => '0');
        wraddress_b  : in std_logic_vector(widthad_write_b-1 downto 0) := (OTHERS => '0');
        inclock_a    : in std_logic := '0';
        inclock_b    : in std_logic := '0';
        inclocken_a  : in std_logic := '1';
        inclocken_b  : in std_logic := '1';
        rden_a       : in std_logic := '1';
        rden_b       : in std_logic := '1';
        rdaddress_a  : in std_logic_vector(widthad_read_a-1 downto 0) := (OTHERS => '0');
        rdaddress_b  : in std_logic_vector(widthad_read_b-1 downto 0) := (OTHERS => '0');
        outclock_a   : in std_logic := '0';
        outclock_b   : in std_logic := '0';
        outclocken_a : in std_logic := '1';
        outclocken_b : in std_logic := '1';
        inaclr_a     : in std_logic := '0';
        inaclr_b     : in std_logic := '0';
        outaclr_a    : in std_logic := '0';
        outaclr_b    : in std_logic := '0';
        q_a          : out std_logic_vector(width_read_a-1 downto 0);
        q_b          : out std_logic_vector(width_read_b-1 downto 0) );
end component;

component scfifo
    generic
      ( lpm_width               : natural;
        lpm_widthu              : natural;
        lpm_numwords            : natural;
        lpm_showahead           : string := "OFF";
        lpm_hint                : string := "USE_EAB=ON";
        intended_device_family  : string := "NON_STRATIX";
        almost_full_value       : natural := 0;
        almost_empty_value      : natural := 0;
        overflow_checking       : string := "ON";
        underflow_checking      : string := "ON";
        allow_rwcycle_when_full : string := "OFF";
        use_eab                 : string := "ON";
        lpm_type                : string := "scfifo"
    );
    port
      ( data         : in std_logic_vector(lpm_width-1 downto 0);
        clock        : in std_logic;
        wrreq        : in std_logic;
        rdreq        : in std_logic;
        aclr         : in std_logic := '0';
        sclr         : in std_logic := '0';
        full         : out std_logic;
        almost_full  : out std_logic;
        empty        : out std_logic;
        almost_empty : out std_logic;
        q            : out std_logic_vector(lpm_width-1 downto 0);
        usedw        : out std_logic_vector(lpm_widthu-1 downto 0)
     );
end component;

component dcfifo
    generic
      ( lpm_width               : natural;
        lpm_widthu              : natural;
        lpm_numwords            : natural;
        lpm_showahead           : string := "OFF";
        lpm_hint                : string := "USE_EAB=ON";
        overflow_checking       : string := "ON";
        underflow_checking      : string := "ON";
        delay_rdusedw           : natural := 1;
        delay_wrusedw           : natural := 1;
        rdsync_delaypipe        : natural := 3;
        wrsync_delaypipe        : natural := 3;
        use_eab                 : string := "ON";
        add_ram_output_register : string := "OFF";
    add_width       : natural := 1;
        clocks_are_synchronized : string := "FALSE";
    lpm_type                : string := "dcfifo";
    intended_device_family  : string := "NON_STRATIX" );
    port
      ( data    : in std_logic_vector(lpm_width-1 downto 0);
        rdclk   : in std_logic;
        wrclk   : in std_logic;
        wrreq   : in std_logic;
        rdreq   : in std_logic;
        aclr    : in std_logic := '0';
        rdfull  : out std_logic;
        wrfull  : out std_logic;
        wrempty : out std_logic;
        rdempty : out std_logic;
        q       : out std_logic_vector(lpm_width-1 downto 0);
        rdusedw : out std_logic_vector(lpm_widthu-1 downto 0);
        wrusedw : out std_logic_vector(lpm_widthu-1 downto 0));
end component;

component alt_exc_dpram
    generic 
      ( width          : integer;
        addrwidth      : integer;
        depth          : integer;
        ramblock       : integer := 65535;
        operation_mode : string := "SINGLE_PORT";
        output_mode    : string := "REG";
        lpm_file       : string := "NONE";
        lpm_type       : string := "alt_exc_dpram" 
       );


    port
      ( portaclk     : in std_logic := '0';
        portaena     : in std_logic := '0';
        portawe      : in std_logic := '0';
        portaaddr    : in std_logic_vector(addrwidth-1 downto 0) := (others =>'0');
        portadatain  : in std_logic_vector(width-1 downto 0) := (others =>'0');
        portadataout : out std_logic_vector(width-1 downto 0);
        portbclk     : in std_logic := '0';
        portbena     : in std_logic := '0';
        portbwe      : in std_logic := '0';
        portbaddr    : in std_logic_vector(addrwidth-1 downto 0) := (others =>'0');
        portbdatain  : in std_logic_vector(width-1 downto 0) := (others =>'0');
        portbdataout : out std_logic_vector(width-1 downto 0));
end component;

component alt_exc_upcore
    generic
      ( processor      : string := "ARM";
        source         : string := "";
        sdram_width    : integer := 32;
        sdramdqm_width : integer := 4;
        gpio_width     : integer := 4;
        lpm_type       : string := "alt_exc_upcore" 
      );


    port
      ( npor           : in    std_logic                     := '1';
        clk_ref        : in    std_logic                     := '0';
        nreset         : inout std_logic                     := '1';

        intpld         : in  std_logic_vector(5 downto 0)  := (others => '0');
        intnmi         : in  std_logic                     := '0';
        intuart        : out std_logic;
        inttimer0      : out std_logic;
        inttimer1      : out std_logic;
        intcommtx      : out std_logic;
        intcommrx      : out std_logic;
        intproctimer   : out std_logic;
        intprocbridge  : out std_logic;
        perreset       : out std_logic;

        debugrq      : in  std_logic := '0';
        debugext0    : in  std_logic := '0';
        debugext1    : in  std_logic := '0';
        debugiebrkpt : in  std_logic := '0';
        debugdewpt   : in  std_logic := '0';
        debugextin   : in  std_logic_vector(3 downto 0) := (others => '0');
        debugack     : out std_logic;
        debugrng0    : out std_logic;
        debugrng1    : out std_logic;
        debugextout  : out std_logic_vector(3 downto 0);

        slavehclk      : in  std_logic := '0';
        slavehwrite    : in  std_logic := '0';
        slavehreadyi   : in  std_logic := '0';
        slavehselreg   : in  std_logic := '0';
        slavehsel      : in  std_logic := '0';
        slavehmastlock : in  std_logic := '0';
        slavehaddr     : in  std_logic_vector(31 downto 0) := (others => '0');
        slavehwdata    : in  std_logic_vector(31 downto 0) := (others => '0');
        slavehtrans    : in  std_logic_vector(1 downto 0) := (others => '0');
        slavehsize     : in  std_logic_vector(1 downto 0) := (others => '0');
        slavehburst    : in  std_logic_vector(2 downto 0) := (others => '0');
        slavehreadyo   : out std_logic;
        slavebuserrint : out std_logic;
        slavehrdata    : out std_logic_vector(31 downto 0);
        slavehresp     : out std_logic_vector(1 downto 0);

        masterhclk     : in  std_logic := '0';
        masterhrdata   : in  std_logic_vector(31 downto 0) := (others => '0');
        masterhresp    : in  std_logic_vector(1 downto 0) := (others => '0');
        masterhwrite   : out std_logic;
        masterhlock    : out std_logic;
        masterhbusreq  : out std_logic;
        masterhaddr    : out std_logic_vector(31 downto 0);
        masterhwdata   : out std_logic_vector(31 downto 0);
        masterhtrans   : out std_logic_vector(1 downto 0);
        masterhsize    : out std_logic_vector(1 downto 0);
        masterhready   : in  std_logic := '0';
        masterhburst   : out std_logic_vector(2 downto 0);
        masterhgrant   : in  std_logic := '0';

        lockreqdp0   : in  std_logic := '0';
        lockreqdp1   : in  std_logic := '0';
        lockgrantdp0 : out std_logic;
        lockgrantdp1 : out std_logic;

        ebiack  : in  std_logic := '0';
        ebiwen  : out std_logic;
        ebioen  : out std_logic;
        ebiclk  : out std_logic;
        ebibe   : out std_logic_vector(1 downto 0);
        ebicsn  : out std_logic_vector(3 downto 0);
        ebiaddr : out std_logic_vector(24 downto 0);

        ebidq : inout std_logic_vector(15 downto 0) := (others => '0');

        uarttxd  : out   std_logic;
        uartrtsn : out   std_logic;
        uartdtrn : out   std_logic;
        uartctsn : in    std_logic := '0';
        uartdsrn : in    std_logic := '0';
        uartrxd  : in    std_logic := '0';
        uartdcdn : inout std_logic := '0';
        uartrin  : inout std_logic := '0';

        sdramclk  : out std_logic;
        sdramclkn : out std_logic;
        sdramclke : out std_logic;
        sdramwen  : out std_logic;
        sdramcasn : out std_logic;
        sdramrasn : out std_logic;
        sdramdqm  : out std_logic_vector(sdramdqm_width-1 downto 0);
        sdramaddr : out std_logic_vector(14 downto 0);
        sdramcsn  : out std_logic_vector(1 downto 0);

        sdramdq  : inout std_logic_vector(sdram_width-1 downto 0) := (others => '0');
        sdramdqs : inout std_logic_vector(sdramdqm_width-1 downto 0) := (others => '0');

        intextpin     : in  std_logic := '0';
        traceclk      : out std_logic;
        tracesync     : out std_logic;
        tracepipestat : out std_logic_vector(2 downto 0);
        tracepkt      : out std_logic_vector(15 downto 0);

        gpi           : in  std_logic_vector(gpio_width-1 downto 0) := (others => '0');
        gpo           : out std_logic_vector(gpio_width-1 downto 0));
end component;

component alt_exc_stripe
  generic
    ( processor        :       string                                   := "ARM";
      sdram_width      :       integer                                  := 32;
      sdramdqm_width   :       integer                                  := 4;
      gpio_width       :       integer                                  := 4;
      device_size      :       integer                                  := 1000;
      boot_from_flash  :       string                                   := "TRUE";
      debug_extensions :       string                                   := "TRUE";
      use_short_reset  :       string                                   := "TRUE";
      use_initialisation_files  :       string                          := "FALSE";
      dp0_mode         :       string                                   := "COMBINEDx32";
      dp1_mode         :       string                                   := "UNUSED";
      dp0_width        :       integer                                  := 32;
      dp0_widthad      :       integer                                  := 15;
      dp1_width        :       integer                                  := 32;
      dp1_widthad      :       integer                                  := 15;
      ebi0_width       :       integer                                  := 16;
      dp0_output_mode  :       string                                   := "UNREG";
      dp1_output_mode  :       string                                   := "UNREG";
      dp0_lpm_file     :       string                                   := "";
      dp1_lpm_file     :       string                                   := "";
      dp2_lpm_file     :       string                                   := "";
      dp3_lpm_file     :       string                                   := ""; 
      lpm_type         : string := "alt_exc_stripe" 
      );

  port
    ( clk_ref          : in    std_logic                                := '0';
      nreset           : inout std_logic                                := '1';
      npor             : in    std_logic                                := '1';

      proc_ntrst       : in    std_logic                                := '0';
      proc_tck         : in    std_logic                                := '0';
      proc_tdi         : in    std_logic                                := '0';
      proc_tdo         : inout std_logic                                := '0';
      proc_tms         : in    std_logic                                := '0';

      intpld           : in    std_logic_vector(5 downto 0)             := (others => '0');
      intnmi           : in    std_logic                                := '0';
      intuart          : out   std_logic;
      inttimer0        : out   std_logic;
      inttimer1        : out   std_logic;
      intcommtx        : out   std_logic;
      intcommrx        : out   std_logic;
      intproctimer     : out   std_logic;
      intprocbridge    : out   std_logic;
      perreset         : out   std_logic;

      debugrq          : in    std_logic                                := '0';
      debugext0        : in    std_logic;
      debugext1        : in    std_logic;
      debugiebrkpt     : in    std_logic                                := '0';
      debugdewpt       : in    std_logic                                := '0';
      debugack         : out   std_logic;
      debugrng0        : out   std_logic;
      debugrng1        : out   std_logic;
      debugextin       : in    std_logic_vector(3 downto 0);
      debugextout      : out   std_logic_vector(3 downto 0);

      slavehclk        : in    std_logic                                := '0';
      slavehmastlock   : in    std_logic                                := '0';
      slavehsel        : in    std_logic                                := '0';
      slavehselreg     : in    std_logic                                := '0';
      slavehreadyi     : in    std_logic                                := '0';
      slavehwrite      : in    std_logic                                := '0';
      slavehaddr       : in    std_logic_vector(31 downto 0)            := (others => '0');
      slavehburst      : in    std_logic_vector(2 downto 0)             := (others => '0');
      slavehsize       : in    std_logic_vector(1 downto 0)             := (others => '0');
      slavehtrans      : in    std_logic_vector(1 downto 0)             := (others => '0');
      slavehwdata      : in    std_logic_vector(31 downto 0)            := (others => '0');
      slavehreadyo     : out   std_logic;
      slavehrdata      : out   std_logic_vector(31 downto 0);
      slavehresp       : out   std_logic_vector(1 downto 0);
      slavebuserrint   : out   std_logic;

      masterhclk       : in    std_logic                                := '0';
      masterhgrant     : in    std_logic                                := '0';
      masterhready     : in    std_logic                                := '0';
      masterhrdata     : in    std_logic_vector(31 downto 0)            := (others => '0');
      masterhresp      : in    std_logic_vector(1 downto 0)             := (others => '0');
      masterhwrite     : out   std_logic;
      masterhlock      : out   std_logic;
      masterhbusreq    : out   std_logic;
      masterhaddr      : out   std_logic_vector(31 downto 0);
      masterhburst     : out   std_logic_vector(2 downto 0);
      masterhsize      : out   std_logic_vector(1 downto 0);
      masterhtrans     : out   std_logic_vector(1 downto 0);
      masterhwdata     : out   std_logic_vector(31 downto 0);

      lockreqdp0       : in    std_logic                                := '0';
      lockreqdp1       : in    std_logic                                := '0';
      lockgrantdp0     : out   std_logic;
      lockgrantdp1     : out   std_logic;

      ebiack           : in    std_logic                                := '0';
      ebiclk           : out   std_logic                                := '0';
      ebiwen           : out   std_logic                                := '0';
      ebiaddr          : out   std_logic_vector(24 downto 0);
      ebibe            : out   std_logic_vector(1 downto 0);
      ebicsn           : out   std_logic_vector(3 downto 0);
      ebioen           : out   std_logic                                := '0';
      ebidq            : inout std_logic_vector(15 downto 0)            := (others => '0');

      uartctsn         : in    std_logic                                := '0';
      uartdsrn         : in    std_logic                                := '0';
      uartrxd          : in    std_logic                                := '0';
      uarttxd          : out   std_logic                                := '0';
      uartrtsn         : out   std_logic                                := '0';
      uartrin          : inout std_logic                                := '0';
      uartdcdn         : inout std_logic                                := '0';
      uartdtrn         : out   std_logic                                := '0';

      sdramclk         : out   std_logic                                := '0';
      sdramaddr        : out   std_logic_vector(14 downto 0);
      sdramcsn         : out   std_logic_vector(1 downto 0);
      sdramdq          : inout std_logic_vector(sdram_width-1 downto 0) := (others => '0');
      sdramdqm         : out   std_logic_vector(sdramdqm_width-1 downto 0);
      sdramdqs         : inout std_logic_vector(sdramdqm_width-1 downto 0) := (others => '0');
      sdramclke        : out   std_logic                                := '0';
      sdramclkn        : out   std_logic                                := '0';
      sdramwen         : out   std_logic                                := '0';
      sdramcasn        : out   std_logic                                := '0';
      sdramrasn        : out   std_logic                                := '0';

      intextpin        : in    std_logic                                := '0';
      traceclk         : out   std_logic                                := '0';
      tracesync        : out   std_logic                                := '0';
      tracepipestat    : out   std_logic_vector(2 downto 0);
      tracepkt         : out   std_logic_vector(15 downto 0);

      dp0_2_portaclk   : in    std_logic                                := '0';
      dp0_portaena     : in    std_logic                                := '0';
      dp0_portawe      : in    std_logic                                := '0';
      dp0_portaaddr    : in    std_logic_vector(dp0_widthad-1 downto 0) := (others => '0');
      dp0_portadatain  : in    std_logic_vector(dp0_width-1 downto 0)   := (others => '0');
      dp0_portadataout : out   std_logic_vector(dp0_width-1 downto 0);
      dp0_portbclk     : in    std_logic                                := '0';
      dp0_portbena     : in    std_logic                                := '0';
      dp0_portbwe      : in    std_logic                                := '0';
      dp0_portbaddr    : in    std_logic_vector(dp0_widthad-1 downto 0) := (others => '0');
      dp0_portbdatain  : in    std_logic_vector(dp0_width-1 downto 0)   := (others => '0');
      dp0_portbdataout : out   std_logic_vector(dp0_width-1 downto 0);

      dp1_3_portaclk   : in    std_logic                                := '0';
      dp1_portaena     : in    std_logic                                := '0';
      dp1_portawe      : in    std_logic                                := '0';
      dp1_portaaddr    : in    std_logic_vector(dp1_widthad-1 downto 0) := (others => '0');
      dp1_portadatain  : in    std_logic_vector(dp1_width-1 downto 0)   := (others => '0');
      dp1_portadataout : out   std_logic_vector(dp1_width-1 downto 0);
      dp1_portbclk     : in    std_logic                                := '0';
      dp1_portbena     : in    std_logic                                := '0';
      dp1_portbwe      : in    std_logic                                := '0';
      dp1_portbaddr    : in    std_logic_vector(dp1_widthad-1 downto 0) := (others => '0');
      dp1_portbdatain  : in    std_logic_vector(dp1_width-1 downto 0)   := (others => '0');
      dp1_portbdataout : out   std_logic_vector(dp1_width-1 downto 0);

      dp2_portaena     : in    std_logic                                := '0';
      dp2_portawe      : in    std_logic                                := '0';
      dp2_portaaddr    : in    std_logic_vector(dp0_widthad-1 downto 0) := (others => '0');
      dp2_portadatain  : in    std_logic_vector(dp0_width-1 downto 0)   := (others => '0');
      dp2_portadataout : out   std_logic_vector(dp0_width-1 downto 0);

      dp3_portaena     : in    std_logic                                := '0';
      dp3_portawe      : in    std_logic                                := '0';
      dp3_portaaddr    : in    std_logic_vector(dp1_widthad-1 downto 0) := (others => '0');
      dp3_portadatain  : in    std_logic_vector(dp1_width-1 downto 0)   := (others => '0');
      dp3_portadataout : out   std_logic_vector(dp1_width-1 downto 0);

      gpi           : in  std_logic_vector(gpio_width-1 downto 0) := (others => '0');
      gpo           : out std_logic_vector(gpio_width-1 downto 0));
end component;

component altddio_in
generic (
    width                  : positive; -- required parameter
    intended_device_family : string := "MERCURY";
    power_up_high          : string := "OFF";
    lpm_type               : string := "altddio_in"
);
port (
    datain    : in std_logic_vector(width-1 downto 0);
    inclock   : in std_logic;
    inclocken : in std_logic := '1';
    aset      : in std_logic := '0';
    aclr      : in std_logic := '0';

    dataout_h : out std_logic_vector(width-1 downto 0);
    dataout_l : out std_logic_vector(width-1 downto 0)
);
end component;

component altddio_out
generic (
    width                  : positive;  -- required parameter
    power_up_high          : string := "OFF";
    oe_reg                 : string := "UNUSED";
    extend_oe_disable      : string := "UNUSED";
    intended_device_family : string := "MERCURY";
    lpm_type               : string := "altddio_out"
    );
port (
    datain_h   : in std_logic_vector(width-1 downto 0);
    datain_l   : in std_logic_vector(width-1 downto 0);
    outclock   : in std_logic;
    outclocken : in std_logic := '1';
    aset       : in std_logic := '0';
    aclr       : in std_logic := '0';
    oe         : in std_logic := '1';

    dataout    : out std_logic_vector(width-1 downto 0)
);
end component;

component altddio_bidir
generic(
    width                    : positive; -- required parameter
    power_up_high            : string := "OFF";
    oe_reg                   : string := "UNUSED";
    extend_oe_disable        : string := "UNUSED";
    implement_input_in_lcell : string := "UNUSED";
    intended_device_family   : string := "MERCURY";
    lpm_type                 : string := "altddio_bidir"
);
port (
    datain_h   : in std_logic_vector(width-1 downto 0);
    datain_l   : in std_logic_vector(width-1 downto 0);
    inclock    : in std_logic;
    inclocken  : in std_logic := '1';
    outclock   : in std_logic;
    outclocken : in std_logic := '1';
    aset       : in std_logic := '0';
    aclr       : in std_logic := '0';
    oe         : in std_logic := '1';

    dataout_h  : out std_logic_vector(width-1 downto 0);
    dataout_l  : out std_logic_vector(width-1 downto 0);
    combout    : out std_logic_vector(width-1 downto 0);
    dqsundelayedout : out std_logic_vector(width-1 downto 0);
    padio      : inout std_logic_vector(width-1 downto 0)
);
end component;

component altcdr_rx
generic (
        number_of_channels     : positive := 1;
        deserialization_factor : positive := 1;
        inclock_period         : positive;
        inclock_boost          : positive := 1;
        run_length             : integer := 62;
        bypass_fifo            : string := "OFF";
        intended_device_family : string := "MERCURY";
        lpm_type               : string := "altcdr_rx"
        );
port (
        rx_in        : in std_logic_vector(number_of_channels-1 downto 0);
        rx_inclock   : in std_logic;
        rx_coreclock : in std_logic;
        rx_aclr      : in std_logic := '0';
        rx_pll_aclr  : in std_logic := '0';
        rx_fifo_rden : in std_logic_vector(number_of_channels-1 downto 0) := (others => '1');
        rx_out       : out std_logic_vector(deserialization_factor*number_of_channels-1 downto 0);
        rx_outclock  : out std_logic;
        rx_pll_locked: out std_logic;
        rx_locklost  : out std_logic_vector(number_of_channels-1 downto 0);
        rx_rlv       : out std_logic_vector(number_of_channels-1 downto 0);
        rx_full      : out std_logic_vector(number_of_channels-1 downto 0);
        rx_empty     : out std_logic_vector(number_of_channels-1 downto 0);
        rx_rec_clk   : out std_logic_vector(number_of_channels-1 downto 0)
      );
end component;

component altcdr_tx
generic (
    number_of_channels     : positive := 1;
    deserialization_factor : positive := 1;
    inclock_period         : positive;  -- required parameter
    inclock_boost          : positive := 1;
    bypass_fifo            : string := "OFF";
    intended_device_family : string := "MERCURY";
    lpm_type               : string := "altcdr_tx"
);
port (
    tx_in        : in std_logic_vector(deserialization_factor*number_of_channels-1 downto 0);
    tx_inclock   : in std_logic;
    tx_coreclock : in std_logic;
    tx_aclr      : in std_logic := '0';
    tx_pll_aclr  : in std_logic := '0';
    tx_fifo_wren : in std_logic_vector(number_of_channels-1 downto 0) := (others => '1');

    tx_out       : out std_logic_vector(number_of_channels-1 downto 0);
    tx_outclock  : out std_logic;
    tx_pll_locked: out std_logic;
    tx_empty     : out std_logic_vector(number_of_channels-1 downto 0);
    tx_full      : out std_logic_vector(number_of_channels-1 downto 0)
);
end component;

component CARRY
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component CASCADE
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component LCELL
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component GLOBAL
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component CARRY_SUM
        port ( sin : in STD_LOGIC;
               cin : in STD_LOGIC;
               sout : out STD_LOGIC;
               cout : out STD_LOGIC);
end component;

component EXP
        port ( a_in : in STD_LOGIC;
               a_out : out STD_LOGIC);
end component;

component altshift_taps
generic (
         number_of_taps    : integer := 4;
         tap_distance      : integer := 3;
         width             : integer := 8;
         power_up_state : string := "CLEARED";
         lpm_hint          : string := "UNUSED";
         lpm_type          : string := "altshift_taps" );

port   (
        shiftin  : in std_logic_vector (width-1 downto 0);
        clock    : in std_logic;
        clken    : in std_logic := '1';
        shiftout : out std_logic_vector (width-1 downto 0);
        taps     : out std_logic_vector ((width*number_of_taps)-1 downto 0));

end component;



component altmult_add 
    generic (
        WIDTH_A                      : integer := 1;
        WIDTH_B                      : integer := 1;
        WIDTH_RESULT                 : integer := 1;
        NUMBER_OF_MULTIPLIERS        : integer := 1;

    -- A inputs
        INPUT_REGISTER_A0            : string := "CLOCK0";
        INPUT_ACLR_A0                : string := "ACLR3";
        INPUT_SOURCE_A0              : string := "DATAA";

        INPUT_REGISTER_A1            : string := "CLOCK0";
        INPUT_ACLR_A1                : string := "ACLR3";
        INPUT_SOURCE_A1              : string := "DATAA";

        INPUT_REGISTER_A2            : string := "CLOCK0";
        INPUT_ACLR_A2                : string := "ACLR3";
        INPUT_SOURCE_A2              : string := "DATAA";

        INPUT_REGISTER_A3            : string := "CLOCK0";
        INPUT_ACLR_A3                : string := "ACLR3";
        INPUT_SOURCE_A3              : string := "DATAA";

        REPRESENTATION_A             : string := "UNSIGNED";
        SIGNED_REGISTER_A            : string := "CLOCK0";
        SIGNED_ACLR_A                : string := "ACLR3";
        SIGNED_PIPELINE_REGISTER_A   : string := "CLOCK0";
        SIGNED_PIPELINE_ACLR_A       : string := "ACLR3";

    -- B inputs
        INPUT_REGISTER_B0            : string := "CLOCK0";
        INPUT_ACLR_B0                : string := "ACLR3";
        INPUT_SOURCE_B0              : string := "DATAB";

        INPUT_REGISTER_B1            : string := "CLOCK0";
        INPUT_ACLR_B1                : string := "ACLR3";
        INPUT_SOURCE_B1              : string := "DATAB";

        INPUT_REGISTER_B2            : string := "CLOCK0";
        INPUT_ACLR_B2                : string := "ACLR3";
        INPUT_SOURCE_B2              : string := "DATAB";

        INPUT_REGISTER_B3            : string := "CLOCK0";
        INPUT_ACLR_B3                : string := "ACLR3";
        INPUT_SOURCE_B3              : string := "DATAB";

        REPRESENTATION_B             : string := "UNSIGNED";
        SIGNED_REGISTER_B            : string := "CLOCK0";
        SIGNED_ACLR_B                : string := "ACLR3";
        SIGNED_PIPELINE_REGISTER_B   : string := "CLOCK0";
        SIGNED_PIPELINE_ACLR_B       : string := "ACLR3";

        MULTIPLIER_REGISTER0         : string := "CLOCK0";
        MULTIPLIER_ACLR0             : string := "ACLR3";
        MULTIPLIER_REGISTER1         : string := "CLOCK0";
        MULTIPLIER_ACLR1             : string := "ACLR3";
        MULTIPLIER_REGISTER2         : string := "CLOCK0";
        MULTIPLIER_ACLR2             : string := "ACLR3";
        MULTIPLIER_REGISTER3         : string := "CLOCK0";
        MULTIPLIER_ACLR3             : string := "ACLR3";

        ADDNSUB_MULTIPLIER_REGISTER1 : string := "CLOCK0";
        ADDNSUB_MULTIPLIER_ACLR1     : string := "ACLR3";
        ADDNSUB_MULTIPLIER_PIPELINE_REGISTER1 : string := "CLOCK0";
        ADDNSUB_MULTIPLIER_PIPELINE_ACLR1 : string := "ACLR3";
                
        ADDNSUB_MULTIPLIER_REGISTER3 : string := "CLOCK0";
        ADDNSUB_MULTIPLIER_ACLR3     : string := "ACLR3";
        ADDNSUB_MULTIPLIER_PIPELINE_REGISTER3: string := "CLOCK0";
        ADDNSUB_MULTIPLIER_PIPELINE_ACLR3 : string := "ACLR3";

        ADDNSUB1_ROUND_ACLR                   : string := "ACLR3";
        ADDNSUB1_ROUND_PIPELINE_ACLR          : string := "ACLR3";
        ADDNSUB1_ROUND_REGISTER               : string := "CLOCK0";
        ADDNSUB1_ROUND_PIPELINE_REGISTER      : string := "CLOCK0";
        ADDNSUB3_ROUND_ACLR                   : string := "ACLR3";
        ADDNSUB3_ROUND_PIPELINE_ACLR          : string := "ACLR3";
        ADDNSUB3_ROUND_REGISTER               : string := "CLOCK0";
        ADDNSUB3_ROUND_PIPELINE_REGISTER      : string := "CLOCK0";

        MULT01_ROUND_ACLR                     : string := "ACLR3";
        MULT01_ROUND_REGISTER                 : string := "CLOCK0";
        MULT01_SATURATION_REGISTER            : string := "CLOCK0";
	MULT01_SATURATION_ACLR                : string := "ACLR3";
        MULT23_ROUND_REGISTER                 : string := "CLOCK0";
        MULT23_ROUND_ACLR                     : string := "ACLR3";
        MULT23_SATURATION_REGISTER            : string := "CLOCK0";
        MULT23_SATURATION_ACLR                : string := "ACLR3";

        multiplier1_direction        : string := "ADD";
        multiplier3_direction        : string := "ADD";

        OUTPUT_REGISTER              : string := "CLOCK0";
        OUTPUT_ACLR                  : string := "ACLR0";

        -- StratixII parameters
        multiplier01_rounding    : string := "NO";
        multiplier01_saturation : string := "NO";
        multiplier23_rounding    : string := "NO";
        multiplier23_saturation : string := "NO";
        adder1_rounding         : string := "NO";
        adder3_rounding         : string := "NO";
        port_mult0_is_saturated : string := "UNUSED";
        port_mult1_is_saturated : string := "UNUSED";
        port_mult2_is_saturated : string := "UNUSED";
        port_mult3_is_saturated : string := "UNUSED";

        EXTRA_LATENCY                : integer :=0;
        DEDICATED_MULTIPLIER_CIRCUITRY:string  := "AUTO";
        DSP_BLOCK_BALANCING          : string := "AUTO";
        lpm_hint                     : string := "UNUSED";
        lpm_type                     : string := "altmult_add";
        intended_device_family       : string := "Stratix"
        );
                        
    port (
           dataa : in std_logic_vector(NUMBER_OF_MULTIPLIERS * WIDTH_A -1 downto 0);
           datab : in std_logic_vector(NUMBER_OF_MULTIPLIERS * WIDTH_B -1 downto 0);

           scanina : in std_logic_vector(width_a -1 downto 0) := (others => '0');
           scaninb : in std_logic_vector(width_b -1 downto 0) := (others => '0');

           sourcea : in std_logic_vector((number_of_multipliers -1) downto 0) := (others => '0');
           sourceb : in std_logic_vector((number_of_multipliers -1) downto 0) := (others => '0');
                
           -- clock ports
           clock3     : in std_logic := '1';
           clock2     : in std_logic := '1';
           clock1     : in std_logic := '1';
           clock0     : in std_logic := '1';
           aclr3      : in std_logic := '0';
           aclr2      : in std_logic := '0';
           aclr1      : in std_logic := '0';
           aclr0      : in std_logic := '0';
           ena3       : in std_logic := '1';
           ena2       : in std_logic := '1';
           ena1       : in std_logic := '1';
           ena0       : in std_logic := '1';

           -- control signals
           signa      : in std_logic := 'Z';
           signb      : in std_logic := 'Z';
           addnsub1   : in std_logic := 'Z';
           addnsub3   : in std_logic := 'Z';

           -- StratixII only input ports
           mult01_round        : in std_logic := '0';
           mult23_round        : in std_logic := '0';
           mult01_saturation   : in std_logic := '0';
           mult23_saturation   : in std_logic := '0';
           addnsub1_round      : in std_logic := '0';
           addnsub3_round      : in std_logic := '0';

           -- output ports
           result     : out std_logic_vector(WIDTH_RESULT -1 downto 0);
           scanouta   : out std_logic_vector (WIDTH_A -1 downto 0);
           scanoutb   : out std_logic_vector (WIDTH_B -1 downto 0);

           -- StratixII only output ports
           mult0_is_saturated : out std_logic := '0';
           mult1_is_saturated : out std_logic := '0';
           mult2_is_saturated : out std_logic := '0';
           mult3_is_saturated : out std_logic := '0'
           );

end component;

component altmult_accum 
    generic (
        width_a                        : integer := 1;
        width_b                        : integer := 1;
        width_result                   : integer := 2;
        width_upper_data               : integer := 1;
        input_source_a                 : string  := "DATAA";
        input_source_b                 : string  := "DATAB";
        input_reg_a                    : string := "CLOKC0";
        input_aclr_a                   : string := "ACLR3";
        input_reg_b                    : string := "CLOCK0";
        input_aclr_b                   : string := "ACLR3";
        addnsub_reg                    : string := "CLOCK0";
        addnsub_aclr                   : string := "ACLR3";
        addnsub_pipeline_reg           : string := "CLOCK0";
        addnsub_pipeline_aclr          : string := "ACLR3";
        accum_direction                : string := "ADD";
        accum_sload_reg                : string := "CLOCK0";
        accum_sload_aclr               : string := "ACLR3";
        accum_sload_pipeline_reg       : string := "CLOCK0";
        accum_sload_pipeline_aclr      : string := "ACLR3";
        representation_a               : string := "UNSIGNED";
        sign_reg_a                     : string := "CLOCK0";
        sign_aclr_a                    : string := "ACLR3";
        sign_pipeline_reg_a            : string := "CLOCK0";
        sign_pipeline_aclr_a           : string := "ACLR3";
        representation_b               : string := "UNSIGNED";
        sign_reg_b                     : string := "CLOCK0";
        sign_aclr_b                    : string := "ACLR3";
        sign_pipeline_reg_b            : string := "CLOCK0";
        sign_pipeline_aclr_b           : string := "ACLR3";
        multiplier_reg                 : string := "CLOCK0";
        multiplier_aclr                : string := "ACLR3";
        output_reg                     : string := "CLOCK0";
        output_aclr                    : string := "ACLR0";
        extra_multiplier_latency       : integer := 0;
        extra_accumulator_latency      : integer := 0;
        dedicated_multiplier_circuitry : string  := "AUTO"; 
        dsp_block_balancing            : string := "AUTO";
        lpm_hint                       : string := "UNUSED";
        lpm_type                       : string  := "altmult_accum";
        intended_device_family         : string  := "Stratix";
        multiplier_rounding            : string  := "NO";
        multiplier_saturation          : string  := "NO";
        accumulator_rounding           : string  := "NO";
        accumulator_saturation         : string  := "NO";
        port_mult_is_saturated         : string  := "UNUSED";
        port_accum_is_saturated        : string  := "UNUSED";
	mult_round_aclr                : string  := "ACLR3";
        mult_round_reg                 : string  := "CLOCK0";
	mult_saturation_aclr           : string  := "ACLR3";
        mult_saturation_reg            : string  := "CLOCK0";
	accum_round_aclr              : string  := "ACLR3";
        accum_round_reg                : string  := "CLOCK3";
        accum_round_pipeline_aclr      : string  := "ACLR3";
        accum_round_pipeline_reg       : string  := "CLOCK0";
	accum_saturation_aclr          : string  := "ACLR3";
        accum_saturation_reg           : string  := "CLOCK0";
        accum_saturation_pipeline_aclr : string  := "ACLR3";
        accum_saturation_pipeline_reg  : string  := "CLOCK0";
	accum_sload_upper_data_aclr    : string  := "ACLR3";
        accum_sload_upper_data_pipeline_aclr : string  := "ACLR3";
        accum_sload_upper_data_pipeline_reg  : string  := "CLOCK0";
        accum_sload_upper_data_reg     : string  := "CLOCK0"
    );

    port (
        dataa        : in std_logic_vector(width_a -1 downto 0);
        datab        : in std_logic_vector(width_b -1 downto 0);
        scanina      : in std_logic_vector(width_a -1 downto 0) := (others => 'Z');
        scaninb      : in std_logic_vector(width_b -1 downto 0) := (others => 'Z');
        accum_sload_upper_data : in std_logic_vector(width_result -1 downto width_result - width_upper_data) := (others => 'Z');
        sourcea      : in std_logic := '1';
        sourceb      : in std_logic := '1';
        -- control signals
        addnsub      : in std_logic := 'Z';
        accum_sload  : in std_logic := '0';
        signa        : in std_logic := 'Z';
        signb        : in std_logic := 'Z';
        -- clock ports
        clock0       : in std_logic := '1';
        clock1       : in std_logic := '1';
        clock2       : in std_logic := '1';
        clock3       : in std_logic := '1';
        ena0         : in std_logic := '1';
        ena1         : in std_logic := '1';
        ena2         : in std_logic := '1';
        ena3         : in std_logic := '1';
        aclr0        : in std_logic := '0';
        aclr1        : in std_logic := '0';
        aclr2        : in std_logic := '0';
        aclr3        : in std_logic := '0';
        -- round and saturation ports
        mult_round       : in std_logic := '0';
        mult_saturation  : in std_logic := '0';
        accum_round      : in std_logic := '0';
        accum_saturation : in std_logic := '0';
        -- output ports
        result       : out std_logic_vector(width_result -1 downto 0);
        overflow     : out std_logic;
        scanouta     : out std_logic_vector (width_a -1 downto 0);
        scanoutb     : out std_logic_vector (width_b -1 downto 0);
        mult_is_saturated  : out std_logic := '0';
        accum_is_saturated : out std_logic := '0'
    );

end component;

component altaccumulate
    generic (
        width_in           : integer:=4;
        width_out          : integer:=8;
        lpm_representation : string := "UNSIGNED";
        extra_latency      : integer:=0;
        use_wys            : string := "ON";
        lpm_hint           : string := "UNUSED";
        lpm_type           : string := "altaccumulate"
    );

    port (
        -- Input ports
        cin       : in std_logic := 'Z';
        data      : in std_logic_vector(width_in -1 downto 0);  -- Required port
        add_sub   : in std_logic := '1';
        clock     : in std_logic;   -- Required port
        sload     : in std_logic := '0';
        clken     : in std_logic := '1';
        sign_data : in std_logic := '0';
        aclr      : in std_logic := '0';

        -- Output ports
        result    : out std_logic_vector(width_out -1 downto 0) := (others => '0');
        cout      : out std_logic := '0';
        overflow  : out std_logic := '0'
    );
end component;

component altsyncram 
   GENERIC (
      operation_mode                 :  string := "SINGLE_PORT";
      -- port a parameters
      width_a                        :  integer := 8;
      widthad_a                      :  integer := 2;
      numwords_a                     :  integer := 4;
      -- registering parameters
      -- port a read parameters
      outdata_reg_a                  :  string := "UNREGISTERED";    
      -- clearing parameters
      address_aclr_a                 :  string := "NONE";    
      outdata_aclr_a                 :  string := "NONE";    
      -- clearing parameters
      -- port a write parameters
      indata_aclr_a                  :  string := "CLEAR0";    
      wrcontrol_aclr_a               :  string := "CLEAR0";    
      -- clear for the byte enable port reigsters which are clocked by clk0
      byteena_aclr_a                 :  string := "NONE";    
      -- width of the byte enable ports. if it is used, must be WIDTH_WRITE_A/8 or /9
      width_byteena_a                :  integer := 1;    
      -- port b parameters
      width_b                        :  integer := 8;
      widthad_b                      :  integer := 4;
      numwords_b                     :  integer := 4;
      -- registering parameters
      -- port b read parameters
      rdcontrol_reg_b                :  string := "CLOCK1";    
      address_reg_b                  :  string := "CLOCK1";    
      outdata_reg_b                  :  string := "UNREGISTERED";    
      -- clearing parameters
      outdata_aclr_b                 :  string := "NONE";    
      rdcontrol_aclr_b               :  string := "NONE";    
      -- registering parameters
      -- port b write parameters
      indata_reg_b                   :  string := "CLOCK1";    
      wrcontrol_wraddress_reg_b      :  string := "CLOCK1";    
      -- registering parameter for the byte enable reister for port b
      byteena_reg_b                  :  string := "CLOCK1";    
      -- clearing parameters
      indata_aclr_b                  :  string := "NONE";    
      wrcontrol_aclr_b               :  string := "NONE";    
      address_aclr_b                 :  string := "NONE";    
      -- clear parameter for byte enable port register
      byteena_aclr_b                 :  string := "NONE";    
      -- StratixII only : to bypass clock enable or using clock enable
      clock_enable_input_a           :  string := "NORMAL";
      clock_enable_output_a          :  string := "NORMAL";
      clock_enable_input_b           :  string := "NORMAL";
      clock_enable_output_b          :  string := "NORMAL";
      -- width of the byte enable ports. if it is used, must be WIDTH_WRITE_A/8 or /9
      width_byteena_b                :  integer := 1;    
      -- width of a byte for byte enables
      -- global parameters
      byte_size                      :  integer := 8; 
      read_during_write_mode_mixed_ports: string := "DONT_CARE";    
      -- ram block type choices are "AUTO", "M512", "M4K" and "MEGARAM"
      ram_block_type                 :  string := "AUTO";    
      -- general operation parameters
      init_file                      :  string := "UNUSED";    
      init_file_layout               :  string := "UNUSED";    
      maximum_depth                  :  integer := 0;    
      intended_device_family         : string  := "Stratix";
      -- bogus lpm_hint parameter?
      lpm_hint                       :  string := "UNUSED";
         lpm_type                        : string := "altsyncram" );
   PORT (
      wren_a                  : IN std_logic := '0';   
      wren_b                  : IN std_logic := '0';   
      rden_b                  : IN std_logic := '1';   
      data_a                  : IN std_logic_vector(width_a - 1 DOWNTO 0):= (others => '0');   
      data_b                  : IN std_logic_vector(width_b - 1 DOWNTO 0):= (others => '0');   
      address_a               : IN std_logic_vector(widthad_a - 1 DOWNTO 0) := (others => '0');   
      address_b               : IN std_logic_vector(widthad_b - 1 DOWNTO 0) := (others => '0');   
      -- two clocks only

      clock0                  : IN std_logic := '1';   
      clock1                  : IN std_logic := '1';   
      clocken0                : IN std_logic := '1';   
      clocken1                : IN std_logic := '1';   
      aclr0                   : IN std_logic := '0';   
      aclr1                   : IN std_logic := '0';   
      byteena_a               : IN std_logic_vector( (width_byteena_a  - 1) downTO 0) := (others => 'Z');   
      byteena_b               : IN std_logic_vector( (width_byteena_b  - 1) downTO 0) := (others => 'Z');   
        
      addressstall_a          : IN std_logic := '0';
      addressstall_b          : IN std_logic := '0';
        
      q_a                     : OUT std_logic_vector(width_a - 1 DOWNTO 0);   
      q_b                     : OUT std_logic_vector(width_b - 1 DOWNTO 0));   
END component;

component altpll
generic (   
        intended_device_family     : string := "Stratix" ;
        operation_mode             : string := "NORMAL" ;
        pll_type                   : string := "AUTO" ;
        qualify_conf_done          : string := "OFF" ;
        compensate_clock           : string := "CLK0" ;
        scan_chain                 : string := "LONG";
        primary_clock              : string := "inclk0" ;
        inclk0_input_frequency     : positive;   -- required parameter
        inclk1_input_frequency     : natural := 0;
        gate_lock_signal           : string := "NO";
        gate_lock_counter          : integer := 0;
        lock_high                  : natural := 1;
        lock_low                   : natural := 5;
        valid_lock_multiplier      : natural := 1;
        invalid_lock_multiplier    : natural := 5;
        switch_over_type           : string := "AUTO";
        switch_over_on_lossclk     : string := "OFF" ;
        switch_over_on_gated_lock  : string := "OFF" ;
        enable_switch_over_counter : string := "OFF";
        switch_over_counter        : natural := 0;
        feedback_source            : string := "EXTCLK0" ;
        bandwidth                  : natural := 0;
        bandwidth_type             : string := "UNUSED";
        spread_frequency           : natural := 0;
        down_spread                : string := "0.0";
        -- simulation-only parameters 
        simulation_type            : string := "functional";
        source_is_pll              : string := "off";
        skip_vco                    : string := "off";

        -- internal clock specifications
        clk5_multiply_by           : positive := 1;
        clk4_multiply_by           : positive := 1;
        clk3_multiply_by           : positive := 1;
        clk2_multiply_by           : positive := 1;
        clk1_multiply_by           : positive := 1;
        clk0_multiply_by           : positive := 1;
        clk5_divide_by             : positive := 1;
        clk4_divide_by             : positive := 1;
        clk3_divide_by             : positive := 1;
        clk2_divide_by             : positive := 1;
        clk1_divide_by             : positive := 1;
        clk0_divide_by             : positive := 1;
        clk5_phase_shift           : string := "0";
        clk4_phase_shift           : string := "0";
        clk3_phase_shift           : string := "0";
        clk2_phase_shift           : string := "0";
        clk1_phase_shift           : string := "0";
        clk0_phase_shift           : string := "0";
        clk5_time_delay            : string := "0";
        clk4_time_delay            : string := "0";
        clk3_time_delay            : string := "0";
        clk2_time_delay            : string := "0";
        clk1_time_delay            : string := "0";
        clk0_time_delay            : string := "0";
        clk5_duty_cycle            : natural := 50;
        clk4_duty_cycle            : natural := 50;
        clk3_duty_cycle            : natural := 50;
        clk2_duty_cycle            : natural := 50;
        clk1_duty_cycle            : natural := 50;
        clk0_duty_cycle            : natural := 50;
        -- external clock specifications
        extclk3_multiply_by        : positive := 1;
        extclk2_multiply_by        : positive := 1;
        extclk1_multiply_by        : positive := 1;
        extclk0_multiply_by        : positive := 1;
        extclk3_divide_by          : positive := 1;
        extclk2_divide_by          : positive := 1;
        extclk1_divide_by          : positive := 1;
        extclk0_divide_by          : positive := 1;
        extclk3_phase_shift        : string := "0";
        extclk2_phase_shift        : string := "0";
        extclk1_phase_shift        : string := "0";
        extclk0_phase_shift        : string := "0";
        extclk3_time_delay         : string := "0";
        extclk2_time_delay         : string := "0";
        extclk1_time_delay         : string := "0";
        extclk0_time_delay         : string := "0";
        extclk3_duty_cycle         : natural := 50;
        extclk2_duty_cycle         : natural := 50;
        extclk1_duty_cycle         : natural := 50;
        extclk0_duty_cycle         : natural := 50;
        vco_multiply_by            : integer := 1;
        vco_divide_by              : integer := 1;
        sclkout0_phase_shift       : string := "0";
        sclkout1_phase_shift       : string := "0";

        -- advanced user parameters
        vco_min                    : natural := 0;
        vco_max                    : natural := 0;
        vco_center                 : natural := 0;
        pfd_min                    : natural := 0;
        pfd_max                    : natural := 0;
        m_initial                  : natural := 1;
        m                          : natural := 0; -- m must default to 0 to force altpll to calculate the internal parameters for itself
        n                          : natural := 1;
        m2                         : natural := 1;
        n2                         : natural := 1;
        ss                         : natural := 0;
        c0_high                    : natural := 1;
        c1_high                    : natural := 1;
        c2_high                    : natural := 1;
        c3_high                    : natural := 1;
        c4_high                    : natural := 1;
        c5_high                    : natural := 1;
        l0_high                    : natural := 1;
        l1_high                    : natural := 1;
        g0_high                    : natural := 1;
        g1_high                    : natural := 1;
        g2_high                    : natural := 1;
        g3_high                    : natural := 1;
        e0_high                    : natural := 1;
        e1_high                    : natural := 1;
        e2_high                    : natural := 1;
        e3_high                    : natural := 1;
        c0_low                     : natural := 1;
        c1_low                     : natural := 1;
        c2_low                     : natural := 1;
        c3_low                     : natural := 1;
        c4_low                     : natural := 1;
        c5_low                     : natural := 1;
        l0_low                     : natural := 1;
        l1_low                     : natural := 1;
        g0_low                     : natural := 1;
        g1_low                     : natural := 1;
        g2_low                     : natural := 1;
        g3_low                     : natural := 1;
        e0_low                     : natural := 1;
        e1_low                     : natural := 1;
        e2_low                     : natural := 1;
        e3_low                     : natural := 1;
        c0_initial                 : natural := 1;
        c1_initial                 : natural := 1;
        c2_initial                 : natural := 1;
        c3_initial                 : natural := 1;
        c4_initial                 : natural := 1;
        c5_initial                 : natural := 1;
        l0_initial                 : natural := 1;
        l1_initial                 : natural := 1;
        g0_initial                 : natural := 1;
        g1_initial                 : natural := 1;
        g2_initial                 : natural := 1;
        g3_initial                 : natural := 1;
        e0_initial                 : natural := 1;
        e1_initial                 : natural := 1;
        e2_initial                 : natural := 1;
        e3_initial                 : natural := 1;
        c0_mode                    : string := "bypass" ;
        c1_mode                    : string := "bypass" ;
        c2_mode                    : string := "bypass" ;
        c3_mode                    : string := "bypass" ;
        c4_mode                    : string := "bypass" ;
        c5_mode                    : string := "bypass" ;
        l0_mode                    : string := "bypass" ;
        l1_mode                    : string := "bypass" ;
        g0_mode                    : string := "bypass" ;
        g1_mode                    : string := "bypass" ;
        g2_mode                    : string := "bypass" ;
        g3_mode                    : string := "bypass" ;
        e0_mode                    : string := "bypass" ;
        e1_mode                    : string := "bypass" ;
        e2_mode                    : string := "bypass" ;
        e3_mode                    : string := "bypass" ;
        c0_ph                      : natural := 0;
        c1_ph                      : natural := 0;
        c2_ph                      : natural := 0;
        c3_ph                      : natural := 0;
        c4_ph                      : natural := 0;
        c5_ph                      : natural := 0;
        l0_ph                      : natural := 0;
        l1_ph                      : natural := 0;
        g0_ph                      : natural := 0;
        g1_ph                      : natural := 0;
        g2_ph                      : natural := 0;
        g3_ph                      : natural := 0;
        e0_ph                      : natural := 0;
        e1_ph                      : natural := 0;
        e2_ph                      : natural := 0;
        e3_ph                      : natural := 0;
        m_ph                       : natural := 0;
        l0_time_delay              : natural := 0;
        l1_time_delay              : natural := 0;
        g0_time_delay              : natural := 0;
        g1_time_delay              : natural := 0;
        g2_time_delay              : natural := 0;
        g3_time_delay              : natural := 0;
        e0_time_delay              : natural := 0;
        e1_time_delay              : natural := 0;
        e2_time_delay              : natural := 0;
        e3_time_delay              : natural := 0;
        m_time_delay               : natural := 0;
        n_time_delay               : natural := 0;
        c1_use_casc_in             : string := "off";
        c2_use_casc_in             : string := "off";
        c3_use_casc_in             : string := "off";
        c4_use_casc_in             : string := "off";
        c5_use_casc_in             : string := "off";
        extclk3_counter            : string := "e3" ;
        extclk2_counter            : string := "e2" ;
        extclk1_counter            : string := "e1" ;
        extclk0_counter            : string := "e0" ;
        clk5_counter               : string := "l1" ;
        clk4_counter               : string := "l0" ;
        clk3_counter               : string := "g3" ;
        clk2_counter               : string := "g2" ;
        clk1_counter               : string := "g1" ;
        clk0_counter               : string := "g0" ;
        enable0_counter            : string := "l0";
        enable1_counter            : string := "l0";
        charge_pump_current        : natural := 2;
        loop_filter_r              : string := "1.0";
        loop_filter_c              : natural := 5;
        vco_post_scale             : natural := 0;
        lpm_type                   : string := "altpll"
);
port (
        inclk       : in std_logic_vector(1 downto 0) := (others => '0');
        fbin        : in std_logic := '1';
        pllena      : in std_logic := '1';
        clkswitch   : in std_logic := '0';
        areset      : in std_logic := '0';
        pfdena      : in std_logic := '1';
        clkena      : in std_logic_vector(5 downto 0) := (others => '1');
        extclkena   : in std_logic_vector(3 downto 0) := (others => '1');
        scanclk     : in std_logic := '0';
        scanaclr    : in std_logic := '0';
        scanread    : in std_logic := '0';
        scanwrite   : in std_logic := '0';
        scandata    : in std_logic := '0';

        clk         : out std_logic_vector(5 downto 0);
        extclk      : out std_logic_vector(3 downto 0);
        clkbad      : out std_logic_vector(1 downto 0);
        enable0     : out std_logic;
        enable1     : out std_logic;
        activeclock : out std_logic;
        clkloss     : out std_logic;
        locked      : out std_logic;
        scandataout : out std_logic;
        scandone    : out std_logic;
        sclkout0     : out std_logic;
        sclkout1     : out std_logic
);
end component;

component altfp_mult
    generic 
      ( width_exp               : integer := 11;
        width_man               : integer := 31;
        dedicated_multiplier_circuitry  : string := "AUTO";
        reduced_functionality           : string := "NO";
        pipeline                        : natural := 5;
        lpm_hint                        : string := "UNUSED";
        lpm_type                        : string := "altfp_mult"
      );

    port
      ( clock       : in std_logic;
        clk_en      : in std_logic := '1';
        aclr        : in std_logic := '0';
        dataa       : in std_logic_vector(WIDTH_EXP + WIDTH_MAN downto 0) ;
        datab       : in std_logic_vector(WIDTH_EXP + WIDTH_MAN downto 0) ;
        result      : out std_logic_vector(WIDTH_EXP + WIDTH_MAN downto 0) ;
        overflow    : out std_logic ;
        underflow   : out std_logic ;
        zero        : out std_logic ;
        denormal    : out std_logic ;
        indefinite  : out std_logic ;
        nan     : out std_logic );
end component;


component altsqrt
    generic 
      ( 
    q_port_width    : integer := 1;
    r_port_width    : integer := 1;
    width       : integer := 1;
    pipeline    : integer := 0;
    lpm_hint    : string := "UNUSED";
    lpm_type        : string := "altsqrt"
      );

    port
      ( 
    radical     : in std_logic_vector(width - 1 downto 0) ;
    clk         : in std_logic;
    ena         : in std_logic := '1';
    aclr        : in std_logic := '0';    
    q           : out std_logic_vector( q_port_width - 1 downto 0) ;
    remainder   : out std_logic_vector( r_port_width - 1 downto 0) 
      );
end component;

component parallel_add 

   generic (
      width                   :  integer := 4;    
      size                    :  integer := 2;    
      widthr                  :  integer := 4;    
      shift                   :  integer := 0;    
      msw_subtract            :  string  := "NO";    
      representation          :  string  := "UNSIGNED";    
      pipeline                :  integer := 0;    
      result_alignment        :  string  := "LSB";    
      lpm_type                :  string  := "parallel_add"
      );

   port (
      data                    : in altera_mf_logic_2D(size - 1 downto 0, width- 1 downto 0);   
      clock                   : in std_logic := '1';
      aclr                    : in std_logic := '0';
      clken                   : in std_logic := '1';
      result                  : out std_logic_vector(widthr - 1 downto 0));   
end component;

component a_graycounter
    generic (
    width               : natural;
    pvalue              : natural;
    lpm_type            : string := "a_graycounter"
	);

    port (
    clock   : in std_logic;
    clk_en  : in std_logic := '1';
    cnt_en  : in std_logic := '1';
    updown  : in std_logic := '1';
    aclr    : in std_logic := '0';
    sclr    : in std_logic := '0';
    qbin    : out std_logic_vector(width-1 downto 0);
    q       : out std_logic_vector(width-1 downto 0));
end component;


end altera_mf_components;






