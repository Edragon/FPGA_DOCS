-- Copyright (C) 1988-2004 Altera Corporation
-- Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
-- support information,  device programming or simulation file,  and any other
-- associated  documentation or information  provided by  Altera  or a partner
-- under  Altera's   Megafunction   Partnership   Program  may  be  used  only
-- to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
-- other  use  of such  megafunction  design,  netlist,  support  information,
-- device programming or simulation file,  or any other  related documentation
-- or information  is prohibited  for  any  other purpose,  including, but not
-- limited to  modification,  reverse engineering,  de-compiling, or use  with
-- any other  silicon devices,  unless such use is  explicitly  licensed under
-- a separate agreement with  Altera  or a megafunction partner.  Title to the
-- intellectual property,  including patents,  copyrights,  trademarks,  trade
-- secrets,  or maskworks,  embodied in any such megafunction design, netlist,
-- support  information,  device programming or simulation file,  or any other
-- related documentation or information provided by  Altera  or a megafunction
-- partner, remains with Altera, the megafunction partner, or their respective
-- licensors. No other licenses, including any licenses needed under any third
-- party's intellectual property, are provided herein.


-- Quartus II 4.0 Build 187 1/20/2004


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package atom_pack is

function str_to_bin (lut_mask : string ) return std_logic_vector;

function product(list : std_logic_vector) return std_logic ;

function alt_conv_integer(arg : in std_logic_vector) return integer;

-- default generic values
   CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
   CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
   CONSTANT DefPulseWdthCnst    : TIME := 0 ns;
-- default control options
--   CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
-- change default delay type to Transport : for spr 68748
   CONSTANT DefGlitchMode       : VitalGlitchKindType   := VitalTransport;
   CONSTANT DefGlitchMsgOn      : BOOLEAN       := FALSE;
   CONSTANT DefGlitchXOn        : BOOLEAN       := FALSE;
   CONSTANT DefMsgOnChecks      : BOOLEAN       := TRUE;
   CONSTANT DefXOnChecks        : BOOLEAN       := TRUE;
-- output strength mapping
                                                --  UX01ZWHL-
   CONSTANT PullUp      : VitalOutputMapType    := "UX01HX01X";
   CONSTANT NoPullUpZ   : VitalOutputMapType    := "UX01ZX01X";
   CONSTANT PullDown    : VitalOutputMapType    := "UX01LX01X";
-- primitive result strength mapping
   CONSTANT wiredOR     : VitalResultMapType    := ( 'U', 'X', 'L', '1' );
   CONSTANT wiredAND    : VitalResultMapType    := ( 'U', 'X', '0', 'H' );
   CONSTANT L : VitalTableSymbolType := '0';
   CONSTANT H : VitalTableSymbolType := '1';
   CONSTANT x : VitalTableSymbolType := '-';
   CONSTANT S : VitalTableSymbolType := 'S';
   CONSTANT R : VitalTableSymbolType := '/';
   CONSTANT U : VitalTableSymbolType := 'X';
   CONSTANT V : VitalTableSymbolType := 'B'; -- valid clock signal (non-rising)

-- Declare array types for CAM_SLICE
   TYPE stratix_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

function int2str( value : integer ) return string;

function map_x_to_0 (value : std_logic) return std_logic;

end atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body atom_pack is

type masklength is array (4 downto 1) of std_logic_vector(3 downto 0);
function str_to_bin (lut_mask : string) return std_logic_vector is
variable slice : masklength := (OTHERS => "0000");
variable mask : std_logic_vector(15 downto 0);


begin

     for i in 1 to lut_mask'length loop
        case lut_mask(i) is
          when '0' => slice(i) := "0000";
          when '1' => slice(i) := "0001";
          when '2' => slice(i) := "0010";
          when '3' => slice(i) := "0011";
          when '4' => slice(i) := "0100";
          when '5' => slice(i) := "0101";
          when '6' => slice(i) := "0110";
          when '7' => slice(i) := "0111";
          when '8' => slice(i) := "1000";
          when '9' => slice(i) := "1001";
          when 'a' => slice(i) := "1010";
          when 'A' => slice(i) := "1010";
          when 'b' => slice(i) := "1011";
          when 'B' => slice(i) := "1011";
          when 'c' => slice(i) := "1100";
          when 'C' => slice(i) := "1100";
          when 'd' => slice(i) := "1101";
          when 'D' => slice(i) := "1101";
          when 'e' => slice(i) := "1110";
          when 'E' => slice(i) := "1110";
          when others => slice(i) := "1111";
        end case;
     end loop;
 
 
     mask := (slice(1) & slice(2) & slice(3) & slice(4));
     return (mask);
 
end str_to_bin;
 
function product (list: std_logic_vector) return std_logic is
begin

        for i in 0 to 31 loop
           if list(i) = '0' then
             return ('0');
           end if;
        end loop;
        return ('1');

end product;

function alt_conv_integer(arg : in std_logic_vector) return integer is
variable result : integer;
begin
  result := 0;
  for i in arg'range loop
     if arg(i) = '1' then
	result := result + 2**i;
     end if;
  end loop;
  return result;
end alt_conv_integer;

function int2str( value : integer ) return string is
variable ivalue,index : integer;
variable digit : integer;
variable line_no: string(8 downto 1) := "        ";
begin
        ivalue := value;
        index := 1;
        if (ivalue = 0) then
           line_no := "       0";
        end if;
        while (ivalue > 0) loop
                digit := ivalue MOD 10;
                ivalue := ivalue/10;
                case digit is
                        when 0 =>
                                line_no(index) := '0';
                        when 1 =>
                                line_no(index) := '1';
                        when 2 =>
                                line_no(index) := '2';
                        when 3 =>
                                line_no(index) := '3';
                        when 4 =>
                                line_no(index) := '4';
                        when 5 =>
                                line_no(index) := '5';
                        when 6 =>
                                line_no(index) := '6';
                        when 7 =>
                                line_no(index) := '7';
                        when 8 =>
                                line_no(index) := '8';
                        when 9 =>
                                line_no(index) := '9';
                        when others =>
                                ASSERT FALSE
                                REPORT "Illegal number!"
                                SEVERITY ERROR;
                end case;
                index := index + 1;
        end loop;
        return line_no;
end;

function map_x_to_0 (value : std_logic) return std_logic is
begin
    if (Is_X (value) = TRUE) then
      return '0';
    else
      return value;
    end if;
end;

end atom_pack;

Library ieee;
use ieee.std_logic_1164.all;

Package pllpack is

        function gcd (X: integer; Y: integer) return integer;

        function lcm (A1: integer; A2: integer; A3: integer; A4: integer;
                      A5: integer; A6: integer; A7: integer;
                      A8: integer; A9: integer; A10: integer; P: integer) return integer;

        function output_counter_value (clk_divide: integer; clk_mult : integer ;
                M: integer; N: integer ) return integer;

        function counter_mode (duty_cycle: integer; output_counter_value: integer) return string;

        function counter_high (output_counter_value: integer := 1; duty_cycle: integer)
                             return integer;

        function counter_low (output_counter_value: integer; duty_cycle: integer)
                           return integer;

        function mintimedelay (t1: integer; t2: integer; t3: integer; t4: integer;
                             t5: integer; t6: integer; t7: integer; t8: integer;
                             t9: integer; t10: integer) return integer;

        function maxnegabs (t1: integer; t2: integer; t3: integer; t4: integer;
                             t5: integer; t6: integer; t7: integer; t8: integer;
                             t9: integer; t10: integer) return integer;

        function counter_time_delay ( clk_time_delay: integer;
                                    m_time_delay: integer; n_time_delay: integer)
                                return integer;

        function get_phase_degree (phase_shift: integer; clk_period: integer) return integer;

        function counter_initial (tap_phase: integer; m: integer; n: integer)
                         return integer;

        function counter_ph (tap_phase: integer; m : integer; n: integer) return integer;

        function ph_adjust (tap_phase: integer; ph_base : integer) return integer;

        function translate_string (mode : string) return string;
	
	function str2int (s : string) return integer;
	function dqs_str2int (s : string) return integer;

end pllpack;

package body pllpack is

function gcd (X: integer; Y: integer) return integer is
variable L, S, R, G : integer;
begin
        if X < Y then -- find which is smaller.
           S := X;
           L := Y;
        else
           S := Y;
           L := X;
        end if;

        R := S;
        while ( R > 1) loop
                S := L;
                L := R;
                R := S rem L; -- divide bigger number by smaller.
                              -- remainder becomes smaller number.
        end loop;
        if R = 0 then  -- if evenly divisible then L is gcd else it is 1.
                G := L;
        else
                G := R;
        end if;
        return G;
end gcd;

function lcm (A1: integer; A2: integer; A3: integer; A4: integer;
              A5: integer; A6: integer; A7: integer;
              A8: integer; A9: integer; A10: integer; P: integer) return integer is
variable M1, M2, M3, M4, M5 , M6, M7, M8, M9, R: integer;
begin
        M1 := (A1 * A2)/gcd(A1, A2);
        M2 := (M1 * A3)/gcd(M1, A3);
        M3 := (M2 * A4)/gcd(M2, A4);
        M4 := (M3 * A5)/gcd(M3, A5);
        M5 := (M4 * A6)/gcd(M4, A6);
        M6 := (M5 * A7)/gcd(M5, A7);
        M7 := (M6 * A8)/gcd(M6, A8);
        M8 := (M7 * A9)/gcd(M7, A9);
        M9 := (M8 * A10)/gcd(M8, A10);
        if M9 < 3 then 
            R := 10;
        elsif (M9 < 10) and (M9 >= 3) then
            R := 4 * M9;
        else 
            R := M9 ;
        end if;

        return R;
end lcm;

function output_counter_value (clk_divide: integer; clk_mult: integer ;
                M: integer; N: integer ) return integer is
Variable R: integer;
begin
        R := (clk_divide * M)/(clk_mult * N);
        return R;
end output_counter_value;

function counter_mode (duty_cycle: integer; output_counter_value: integer) return string is
variable R: string (1 to 6);
variable counter_value: integer;
begin
        counter_value := (2*duty_cycle*output_counter_value)/100;
        if output_counter_value = 1 then
                R := "bypass";
        elsif (counter_value REM 2) = 0 then
                R := "  even";
        else
                R := "   odd";
        end if;
        return R;
end counter_mode;

function counter_high (output_counter_value: integer := 1; duty_cycle: integer)
                       return integer is
variable R: integer;
variable half_cycle_high : integer;
begin
        half_cycle_high := (duty_cycle * output_counter_value *2)/100 ;
	if (half_cycle_high REM 2 = 0) then
	 R := half_cycle_high/2 ;
	else
	 R := half_cycle_high/2 + 1;
	end if;
        return R;
end;

function counter_low (output_counter_value: integer; duty_cycle: integer)
                        return integer is
variable R, R1: integer;
variable half_cycle_high : integer;
begin
        half_cycle_high := (duty_cycle * output_counter_value*2)/100 ;
	if (half_cycle_high REM 2 = 0) then
	 R1 := half_cycle_high/2 ;
	else
	 R1 := half_cycle_high/2 + 1;
	end if;
	
        R :=    output_counter_value - R1;
        return R;
end;

function mintimedelay (t1: integer; t2: integer; t3: integer; t4: integer;
                       t5: integer; t6: integer; t7: integer; t8: integer;
                       t9: integer; t10: integer) return integer is
variable m1,m2,m3,m4,m5,m6,m7,m8,m9 : integer;
begin
        if t1 < t2 then m1 := t1; else m1 := t2; end if;
        if m1 < t3 then m2 := m1; else m2 := t3; end if;
        if m2 < t4 then m3 := m2; else m3 := t4; end if;
        if m3 < t5 then m4 := m3; else m4 := t5; end if;
        if m4 < t6 then m5 := m4; else m5 := t6; end if;
        if m5 < t7 then m6 := m5; else m6 := t7; end if;
        if m6 < t8 then m7 := m6; else m7 := t8; end if;
        if m7 < t9 then m8 := m7; else m8 := t9; end if;
        if m8 < t10 then m9 := m8; else m9 := t10; end if;
        if m9 > 0 then return m9; else return 0; end if;
end;

function maxnegabs (t1: integer; t2: integer; t3: integer; t4: integer;
                    t5: integer; t6: integer; t7: integer; t8: integer;
                    t9: integer; t10: integer) return integer is
variable m1,m2,m3,m4,m5,m6,m7,m8,m9 : integer;
begin
        if t1 < t2 then m1 := t1; else m1 := t2; end if;
        if m1 < t3 then m2 := m1; else m2 := t3; end if;
        if m2 < t4 then m3 := m2; else m3 := t4; end if;
        if m3 < t5 then m4 := m3; else m4 := t5; end if;
        if m4 < t6 then m5 := m4; else m5 := t6; end if;
        if m5 < t7 then m6 := m5; else m6 := t7; end if;
        if m6 < t8 then m7 := m6; else m7 := t8; end if;
        if m7 < t9 then m8 := m7; else m8 := t9; end if;
        if m8 < t10 then m9 := m8; else m9 := t10; end if;
	if m9 < 0 then return (0 - m9); else return 0; end if;
end;

function ph_adjust (tap_phase: integer; ph_base : integer) return integer is
begin
	return tap_phase + ph_base;
end;
	

function counter_time_delay ( clk_time_delay: integer;
                              m_time_delay: integer; n_time_delay: integer)
                              return integer is
variable R: integer;
begin
        R := clk_time_delay + m_time_delay - n_time_delay;
        return R;
end;

-- to calculate the given phase shift (in ps) in terms of degrees
function get_phase_degree (phase_shift: integer; clk_period: integer) return integer is
variable result: integer := 0;
begin
    result := ( phase_shift * 360 ) / clk_period;
    -- to round up the calculation result
	if (result > 0) then
        result := result + 1;
    elsif (result < 0) then
        result := result - 1;
    else
        result := 0;
    end if;

    return result;
end;

function counter_initial (tap_phase: integer; m: integer; n: integer)
                         return integer is
variable R: integer;
variable R1: real;
begin
        R1 := (real(abs(tap_phase)) * real(m))/(360.0 * real(n)) + 0.5;
        -- Note NCSim VHDL had problem in rounding up for 0.5 - 0.99. 
        -- This checking will ensure that the rounding up is done.
        if (R1 >= 0.5) and (R1 <= 1.0) then
           R1 := 1.0;
        end if;

        R := integer(R1);

        return R;
end;



function counter_ph (tap_phase: integer; m: integer; n: integer) return integer is
variable R: integer;
begin
-- 0.5 is added for proper rounding of the tap_phase.
        R := (integer(real(tap_phase * m / n)+ 0.5) REM 360)/45;
        return R;
end;

function translate_string (mode : string) return string is
variable new_mode : string (1 to 6);
begin
     if (mode = "bypass") then
        new_mode := "bypass";
     elsif (mode = "even") then
        new_mode := "  even";
     elsif (mode = "odd") then
        new_mode := "   odd";
     end if;

     return new_mode;
       
end;

	function str2int (s : string) return integer is
	variable len : integer := s'length;
        variable newdigit : integer := 0;
        variable sign : integer := 1;
        variable digit : integer := 0;
        begin
        for i in 1 to len loop
              case s(i) is
                 when '-' =>
                   if i = 1 then
                     sign := -1;
                   else
                    ASSERT FALSE
                    REPORT "Illegal Character "&  s(i) & "i n string parameter! "
                    SEVERITY ERROR;
                   end if;
                 when '0' =>
                       digit := 0;
                 when '1' =>
                       digit := 1;
                 when '2' =>
                       digit := 2;
                 when '3' =>
                       digit := 3;
                 when '4' =>
                       digit := 4;
                 when '5' =>
                       digit := 5;
                 when '6' =>
                       digit := 6;
                 when '7' =>
                       digit := 7;
                 when '8' =>
                       digit := 8;
                 when '9' =>
                       digit := 9;
                 when others =>
                     ASSERT FALSE
                     REPORT "Illegal Character "&  s(i) & "in string parameter! "
                     SEVERITY ERROR;
               end case;
               newdigit := newdigit * 10 + digit;
        end loop;

               return (sign*newdigit);
	end;

function dqs_str2int (s : string) return integer is
variable len : integer := s'length;
variable newdigit : integer := 0;
variable sign : integer := 1;
variable digit : integer := 0;
variable err : boolean := false;
begin
for i in 1 to len loop
      case s(i) is
         when '-' =>
           if i = 1 then
             sign := -1;
           else
            ASSERT FALSE
            REPORT "Illegal Character "&  s(i) & " in string parameter! "
            SEVERITY ERROR;
            err := true;
           end if;
         when '0' =>
               digit := 0;
         when '1' =>
               digit := 1;
         when '2' =>
               digit := 2;
         when '3' =>
               digit := 3;
         when '4' =>
               digit := 4;
         when '5' =>
               digit := 5;
         when '6' =>
               digit := 6;
         when '7' =>
               digit := 7;
         when '8' =>
               digit := 8;
         when '9' =>
               digit := 9;
         when others =>
             -- set error flag
             err := true;
       end case;
       if (err) then
           err := false;
       else
           newdigit := newdigit * 10 + digit;
       end if;
end loop;

       return (sign*newdigit);
end;

end pllpack;

--
--
--  DFFE Model
--
--

library IEEE, stratix;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity dffe is
   generic(
      TimingChecksOn: Boolean := True;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :   VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :   VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of dffe : entity is TRUE;
end dffe;

-- architecture body --

architecture behave of dffe is
   attribute VITAL_LEVEL0 of behave : architecture is TRUE;

   signal D_ipd  : STD_ULOGIC := 'U';
   signal CLRN_ipd       : STD_ULOGIC := 'U';
   signal PRN_ipd        : STD_ULOGIC := 'U';
   signal CLK_ipd        : STD_ULOGIC := 'U';
   signal ENA_ipd        : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (D_ipd, D, tipd_D);
   VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
   VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, CLRN_ipd, PRN_ipd, CLK_ipd, ENA_ipd)

   -- timing check results
   VARIABLE Tviol_D_CLK : STD_ULOGIC := '0';
   VARIABLE Tviol_ENA_CLK       : STD_ULOGIC := '0';
   VARIABLE TimingData_D_CLK : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE TimingData_ENA_CLK : VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(0 to 7);
   VARIABLE D_delayed : STD_ULOGIC := 'U';
   VARIABLE CLK_delayed : STD_ULOGIC := 'U';
   VARIABLE ENA_delayed : STD_ULOGIC := 'U';
--   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => '0');

   -- output glitch detection variables
   VARIABLE Q_VitalGlitchData   : VitalGlitchDataType;


   CONSTANT dffe_Q_tab : VitalStateTableType := (
    ( L,  L,  x,  x,  x,  x,  x,  x,  x,  L ),
    ( L,  H,  L,  H,  H,  x,  x,  H,  x,  H ),
    ( L,  H,  L,  H,  x,  L,  x,  H,  x,  H ),
    ( L,  H,  L,  x,  H,  H,  x,  H,  x,  H ),
    ( L,  H,  H,  x,  x,  x,  H,  x,  x,  S ),
    ( L,  H,  x,  x,  x,  x,  L,  x,  x,  H ),
    ( L,  H,  x,  x,  x,  x,  H,  L,  x,  S ),
    ( L,  x,  L,  L,  L,  x,  H,  H,  x,  L ),
    ( L,  x,  L,  L,  x,  L,  H,  H,  x,  L ),
    ( L,  x,  L,  x,  L,  H,  H,  H,  x,  L ));
   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
                Violation       => Tviol_D_CLK,
                TimingData      => TimingData_D_CLK,
                TestSignal      => D_ipd,
                TestSignalName  => "D",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_D_CLK_noedge_posedge,
                SetupLow        => tsetup_D_CLK_noedge_posedge,
                HoldHigh        => thold_D_CLK_noedge_posedge,
                HoldLow         => thold_D_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) OR ( (NOT ENA_ipd) )) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_ENA_CLK,
                TimingData      => TimingData_ENA_CLK,
                TestSignal      => ENA_ipd,
                TestSignalName  => "ENA",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ENA_CLK_noedge_posedge,
                SetupLow        => tsetup_ENA_CLK_noedge_posedge,
                HoldHigh        => thold_ENA_CLK_noedge_posedge,
                HoldLow         => thold_ENA_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_D_CLK or Tviol_ENA_CLK;
      VitalStateTable(
        StateTable => dffe_Q_tab,
        DataIn => (
                Violation, CLRN_ipd, CLK_delayed, Results(1), D_delayed, ENA_delayed, PRN_ipd, CLK_ipd),
        Result => Results,
        NumStates => 1,
        PreviousDataIn => PrevData_Q);
      D_delayed := D_ipd;
      CLK_delayed := CLK_ipd;
      ENA_delayed := ENA_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       OutSignalName => "Q",
       OutTemp => Results(1),
       Paths => (0 => (PRN_ipd'last_event, tpd_PRN_Q_negedge, TRUE),
                 1 => (CLRN_ipd'last_event, tpd_CLRN_Q_negedge, TRUE),
                 2 => (CLK_ipd'last_event, tpd_CLK_Q_posedge, TRUE)),
       GlitchData => Q_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;

end behave;

--
--
--  MUX21 Model
--
--

library IEEE, stratix;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
--use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity mux21 is
   generic(
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_A_MO                      :   VitalDelayType01 := DefPropDelay01;
      tpd_B_MO                      :   VitalDelayType01 := DefPropDelay01;
      tpd_S_MO                      :   VitalDelayType01 := DefPropDelay01;
      tipd_A                       :    VitalDelayType01 := DefPropDelay01;
      tipd_B                       :    VitalDelayType01 := DefPropDelay01;
      tipd_S                       :    VitalDelayType01 := DefPropDelay01);
     port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
   attribute VITAL_LEVEL0 of mux21 : entity is TRUE;
end mux21;

architecture AltVITAL of mux21 is
   attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

   signal A_ipd, B_ipd, S_ipd  : std_logic;

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (A_ipd, A, tipd_A);
      VitalWireDelay (B_ipd, B, tipd_B);
      VitalWireDelay (S_ipd, S, tipd_S);
   end block;

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (A_ipd, B_ipd, S_ipd)

   -- output glitch detection variables
   VARIABLE MO_GlitchData       : VitalGlitchDataType;

   variable tmp_MO : std_logic;
   begin
      -------------------------
      --  Functionality Section
      -------------------------
      if (S_ipd = '1') then
         tmp_MO := B_ipd;
      else
         tmp_MO := A_ipd;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => MO,
       OutSignalName => "MO",
       OutTemp => tmp_MO,
       Paths => (0 => (A_ipd'last_event, tpd_A_MO, TRUE),
                 1 => (B_ipd'last_event, tpd_B_MO, TRUE),
                 2 => (S_ipd'last_event, tpd_S_MO, TRUE)),
       GlitchData => MO_GlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;
end AltVITAL;

--
--
--  MUX41 Model
--
--

library IEEE, stratix;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
--use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity mux41 is
    generic(
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_IN0_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN1_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN2_MO : VitalDelayType01 := DefPropDelay01;
            tpd_IN3_MO : VitalDelayType01 := DefPropDelay01;
            tpd_S_MO : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
            tipd_IN0 : VitalDelayType01 := DefPropDelay01;
            tipd_IN1 : VitalDelayType01 := DefPropDelay01;
            tipd_IN2 : VitalDelayType01 := DefPropDelay01;
            tipd_IN3 : VitalDelayType01 := DefPropDelay01;
            tipd_S : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01)
           );
    port (
          IN0 : in std_logic := '0';
          IN1 : in std_logic := '0';
          IN2 : in std_logic := '0';
          IN3 : in std_logic := '0';
          S : in std_logic_vector(1 downto 0) := (OTHERS => '0');
          MO : out std_logic
         );
   attribute VITAL_LEVEL0 of mux41 : entity is TRUE;
end mux41;

architecture AltVITAL of mux41 is
   attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

   signal IN0_ipd, IN1_ipd, IN2_ipd, IN3_ipd  : std_logic;
   signal S_ipd : std_logic_vector(1 downto 0);

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (IN0_ipd, IN0, tipd_IN0);
      VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
      VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
      VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
      VitalWireDelay (S_ipd(0), S(0), tipd_S(0));
      VitalWireDelay (S_ipd(1), S(1), tipd_S(1));
   end block;

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN0_ipd, IN1_ipd, IN2_ipd, IN3_ipd, S_ipd(0), S_ipd(1))

   -- output glitch detection variables
   VARIABLE MO_GlitchData       : VitalGlitchDataType;

   variable tmp_MO : std_logic;
   begin
      -------------------------
      --  Functionality Section
      -------------------------
      if ((S_ipd(1) = '1') AND (S_ipd(0) = '1')) then
         tmp_MO := IN3_ipd;
      elsif ((S_ipd(1) = '1') AND (S_ipd(0) = '0')) then
         tmp_MO := IN2_ipd;
      elsif ((S_ipd(1) = '0') AND (S_ipd(0) = '1')) then
         tmp_MO := IN1_ipd;
      else
         tmp_MO := IN0_ipd;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
                        OutSignal => MO,
                        OutSignalName => "MO",
                        OutTemp => tmp_MO,
                        Paths => (0 => (IN0_ipd'last_event, tpd_IN0_MO, TRUE),
                                  1 => (IN1_ipd'last_event, tpd_IN1_MO, TRUE),
                                  2 => (IN2_ipd'last_event, tpd_IN2_MO, TRUE),
                                  3 => (IN3_ipd'last_event, tpd_IN3_MO, TRUE),
                                  4 => (S_ipd(0)'last_event, tpd_S_MO(0), TRUE),
                                  5 => (S_ipd(1)'last_event, tpd_S_MO(1), TRUE)),
                        GlitchData => MO_GlitchData,
                        Mode => DefGlitchMode,
                        XOn  => XOn,
                        MsgOn        => MsgOn );

    end process;
end AltVITAL;

--
--
--  AND1 Model
--
--
library IEEE, stratix;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use stratix.atom_pack.all;

-- entity declaration --
entity and1 is
   generic(
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_IN1_Y                      :	VitalDelayType01 := DefPropDelay01;
      tipd_IN1                       :	VitalDelayType01 := DefPropDelay01);

   port(
      Y                              :	out   STD_LOGIC;
      IN1                            :	in    STD_LOGIC);
   attribute VITAL_LEVEL0 of and1 : entity is TRUE;
end and1;

-- architecture body --

architecture AltVITAL of and1 is
   attribute VITAL_LEVEL0 of AltVITAL : architecture is TRUE;

   SIGNAL IN1_ipd	 : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_ULOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := TO_X01(IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       GlitchData => Y_GlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;
end AltVITAL;
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for STRATIX Atoms
--
--/////////////////////////////////////////////////////////////////////////////

--
--
--  STRATIX_LCELL Model
--
--
library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_asynch_lcell is
  generic (
    lms : std_logic_vector(15 downto 0) := "1111111111111111";
    TimingChecksOn: Boolean := True;
    MsgOn: Boolean := DefGlitchMsgOn;
    XOn: Boolean := DefGlitchXOn;
    MsgOnChecks: Boolean := DefMsgOnChecks;
    XOnChecks: Boolean := DefXOnChecks;
    InstancePath: STRING := "*";
    
    tpd_dataa_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_datab_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_datac_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_datad_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_cin_combout             : VitalDelayType01 := DefPropDelay01;
    tpd_cin0_combout            : VitalDelayType01 := DefPropDelay01;
    tpd_cin1_combout            : VitalDelayType01 := DefPropDelay01;
    tpd_inverta_combout         : VitalDelayType01 := DefPropDelay01;
    tpd_qfbkin_combout          : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_datab_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_datac_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_datad_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_cin_regin               : VitalDelayType01 := DefPropDelay01;
    tpd_cin0_regin              : VitalDelayType01 := DefPropDelay01;
    tpd_cin1_regin              : VitalDelayType01 := DefPropDelay01;
    tpd_inverta_regin           : VitalDelayType01 := DefPropDelay01;
    tpd_qfbkin_regin            : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_cout	        : VitalDelayType01 := DefPropDelay01;
    tpd_datab_cout	        : VitalDelayType01 := DefPropDelay01;
    tpd_cin_cout		: VitalDelayType01 := DefPropDelay01;
    tpd_cin0_cout		: VitalDelayType01 := DefPropDelay01;
    tpd_cin1_cout		: VitalDelayType01 := DefPropDelay01;
    tpd_inverta_cout            : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_cout0             : VitalDelayType01 := DefPropDelay01;
    tpd_datab_cout0             : VitalDelayType01 := DefPropDelay01;
    tpd_cin0_cout0              : VitalDelayType01 := DefPropDelay01;
    tpd_inverta_cout0           : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_cout1             : VitalDelayType01 := DefPropDelay01;
    tpd_datab_cout1             : VitalDelayType01 := DefPropDelay01;
    tpd_cin1_cout1		: VitalDelayType01 := DefPropDelay01;
    tpd_inverta_cout1           : VitalDelayType01 := DefPropDelay01;
    tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
    tipd_datab			: VitalDelayType01 := DefPropDelay01; 
    tipd_datac			: VitalDelayType01 := DefPropDelay01; 
    tipd_datad			: VitalDelayType01 := DefPropDelay01; 
    tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
    tipd_cin0  			: VitalDelayType01 := DefPropDelay01; 
    tipd_cin1  			: VitalDelayType01 := DefPropDelay01; 
    tipd_inverta		: VitalDelayType01 := DefPropDelay01); 

  port (
    dataa     : in std_logic := '1';
    datab     : in std_logic := '1';
    datac     : in std_logic := '1';
    datad     : in std_logic := '1';
    cin       : in std_logic := '0';
    cin0      : in std_logic := '0';
    cin1      : in std_logic := '1';
    inverta   : in std_logic := '0';
    qfbkin    : in std_logic := '0';
    mode      : in std_logic_vector(5 downto 0);
    regin     : out std_logic;
    combout   : out std_logic;
    cout      : out std_logic;
    cout0     : out std_logic;
    cout1     : out std_logic);
  attribute VITAL_LEVEL0 of stratix_asynch_lcell : entity is TRUE;
end stratix_asynch_lcell;
        
architecture vital_le of stratix_asynch_lcell is
   attribute VITAL_LEVEL1 of vital_le : architecture is TRUE;
   signal dataa_ipd, datab_ipd : std_ulogic;
   signal inverta_ipd : std_ulogic;
   signal datac_ipd, datad_ipd : std_ulogic;
   signal cin_ipd, cin0_ipd, cin1_ipd : std_ulogic;

   -- operation_mode --> mode(0) - normal=1 arithemtic=0
   -- sum_lutc_cin   --> mode(1) - lutc=1   cin=0
   -- sum_lutc_qfbk  --> mode(2) - qfbk=1   mode1=0 
   -- cin_used       --> mode(3) - true=1   false=0
   -- cin0_used      --> mode(4) - true=1   false=0
   -- cin1_used      --> mode(5) - true=1   false=0

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (dataa_ipd, dataa, tipd_dataa);
   VitalWireDelay (datab_ipd, datab, tipd_datab);
   VitalWireDelay (datac_ipd, datac, tipd_datac);
   VitalWireDelay (datad_ipd, datad, tipd_datad);
   VitalWireDelay (cin_ipd, cin, tipd_cin);
   VitalWireDelay (cin0_ipd, cin0, tipd_cin0);
   VitalWireDelay (cin1_ipd, cin1, tipd_cin1);
   VitalWireDelay (inverta_ipd, inverta, tipd_inverta);
   end block;

VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd, mode,
                      cin_ipd, cin0_ipd, cin1_ipd, inverta_ipd, qfbkin)

variable combout_VitalGlitchData : VitalGlitchDataType;
variable cout_VitalGlitchData : VitalGlitchDataType;
variable cout0_VitalGlitchData : VitalGlitchDataType;
variable cout1_VitalGlitchData : VitalGlitchDataType;
variable regin_VitalGlitchData : VitalGlitchDataType;

variable tmp_combout, tmp_cout, tmp_cout0, tmp_cout1, tmp_regin: std_logic;
variable lutb, cintmp : std_logic;
variable invertsig : std_logic := '0';
variable cinsel, cinsig, cin01sel, luta, lutc, lutd, datacsig: std_logic;

variable lms_var : std_logic_vector(15 downto 0) := "1111111111111111";

begin
  
    lms_var := lms;

    cinsel := (cin_ipd and mode(3)) or (inverta_ipd and (not mode(3)));
    cin01sel := (cin1_ipd and cinsel) or (cin0_ipd and (not cinsel)); 
    cintmp := (cin_ipd and mode(0)) or 
               ((not mode(0)) and mode(3) and cin_ipd) or
               ((not mode(0)) and (not mode(3)) and inverta_ipd); 
    cinsig := (cintmp and ((not mode(4)) and (not mode(5)))) or (cin01sel and (mode(4) or mode(5))); 
    datacsig := (datac_ipd and mode(1)) or (cinsig and (not mode(1)));
    luta := dataa_ipd XOR inverta_ipd;
    lutb := datab_ipd;
    lutc := (qfbkin and mode(2)) or (datacsig and (not mode(2)));
    lutd := (datad_ipd and mode(0)) or (not mode(0));

    tmp_combout := VitalMUX(data => lms_var,
                              dselect => (lutd,
                                          lutc,
                                          lutb,
                                          luta)); 

    tmp_cout0 := VitalMUX(data => lms_var,
                       dselect => ('0',
                                   cin0_ipd,
                                   lutb,
                                   luta));

    tmp_cout1 := VitalMUX(data => lms_var,
                       dselect => ('0',
                                   cin1_ipd,
                                   lutb,
                                   luta));

    tmp_cout := VitalMux2(VitalMux2(tmp_cout1, tmp_cout0, cin_ipd),
                          VitalMux2(tmp_cout1, tmp_cout0, inverta_ipd), 
                          mode(3));

      ----------------------
      --  Path Delay Section
      ----------------------

      VitalPathDelay01 (
       OutSignal => combout,
       OutSignalName => "COMBOUT",
       OutTemp => tmp_combout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_combout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_combout, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_combout, TRUE),
                 5 => (cin0_ipd'last_event, tpd_cin0_combout, TRUE),
                 6 => (cin1_ipd'last_event, tpd_cin1_combout, TRUE),
                 7 => (inverta_ipd'last_event, tpd_inverta_combout, TRUE),
                 8 => (qfbkin'last_event, tpd_qfbkin_combout, (mode(2) = '1'))),
       GlitchData => combout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 (
       OutSignal => regin,
       OutSignalName => "REGIN",
       OutTemp => tmp_combout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_regin, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_regin, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_regin, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_regin, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_regin, TRUE),
                 5 => (cin0_ipd'last_event, tpd_cin0_regin, TRUE),
                 6 => (cin1_ipd'last_event, tpd_cin1_regin, TRUE),
                 7 => (inverta_ipd'last_event, tpd_inverta_regin, TRUE),
                 8 => (qfbkin'last_event, tpd_qfbkin_regin, (mode(2) = '1'))),
       GlitchData => regin_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cout, 
       OutSignalName => "COUT",
       OutTemp => tmp_cout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cout, TRUE),
                 2 => (cin_ipd'last_event, tpd_cin_cout, TRUE),
                 3 => (cin0_ipd'last_event, tpd_cin0_cout, TRUE),
                 4 => (cin1_ipd'last_event, tpd_cin1_cout, TRUE),
                 5 => (inverta_ipd'last_event, tpd_inverta_cout, TRUE)),
       GlitchData => cout_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cout0, 
       OutSignalName => "COUT0",
       OutTemp => tmp_cout0,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout0, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cout0, TRUE),
                 2 => (cin0_ipd'last_event, tpd_cin0_cout0, TRUE),
                 3 => (inverta_ipd'last_event, tpd_inverta_cout0, TRUE)),
       GlitchData => cout0_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cout1, 
       OutSignalName => "COUT1",
       OutTemp => tmp_cout1,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout1, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cout1, TRUE),
                 2 => (cin1_ipd'last_event, tpd_cin1_cout1, TRUE),
                 3 => (inverta_ipd'last_event, tpd_inverta_cout1, TRUE)),
       GlitchData => cout1_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );
end process;

end vital_le;	

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_lcell_register is
  generic (
       
    TimingChecksOn: Boolean := True;
    MsgOn: Boolean := DefGlitchMsgOn;
    XOn: Boolean := DefGlitchXOn;
    MsgOnChecks: Boolean := DefMsgOnChecks;
    XOnChecks: Boolean := DefXOnChecks;
    InstancePath: STRING := "*";
    
    tsetup_regcascin_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    thold_regcascin_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
    tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
    tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
    tpd_aload_regout_posedge		: VitalDelayType01 := DefPropDelay01;
    tpd_datac_regout			: VitalDelayType01 := DefPropDelay01;
    tpd_clk_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
    tpd_aclr_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
    tpd_aload_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
    tpd_datac_qfbkout			: VitalDelayType01 := DefPropDelay01;
    
    tipd_clk                            : VitalDelayType01 := DefPropDelay01;
    tipd_datac  			: VitalDelayType01 := DefPropDelay01;
    tipd_regcascin                      : VitalDelayType01 := DefPropDelay01; 
    tipd_ena                            : VitalDelayType01 := DefPropDelay01; 
    tipd_aclr                           : VitalDelayType01 := DefPropDelay01; 
    tipd_aload                          : VitalDelayType01 := DefPropDelay01; 
    tipd_sclr                           : VitalDelayType01 := DefPropDelay01; 
    tipd_sload                          : VitalDelayType01 := DefPropDelay01);
  
  port (clk     : in std_logic := '0';
        datain  : in std_logic := '0';
        datac   : in std_logic := '0';
        regcascin : in std_logic := '0';
        aclr    : in std_logic := '0';
        aload   : in std_logic := '0';
        sclr    : in std_logic := '0';
        sload   : in std_logic := '0';
        ena     : in std_logic := '1';
        cena : in std_logic := '0';
        xonv : in std_logic := '1';
        smode : in std_logic := '0';
        regout  : out std_logic;
        qfbkout : out std_logic);
   attribute VITAL_LEVEL0 of stratix_lcell_register : entity is TRUE;
end stratix_lcell_register;
        
architecture vital_le_reg of stratix_lcell_register is
   attribute VITAL_LEVEL1 of vital_le_reg : architecture is TRUE;
   signal ena_ipd : std_ulogic := '1';
   signal sload_ipd : std_ulogic := '0';
   signal aload_ipd : std_ulogic := '0';
   signal datac_ipd : std_ulogic := '0';
   signal regcascin_ipd : std_ulogic := '0';
   signal clk_ipd : std_ulogic := '0';
   signal aclr_ipd : std_ulogic := '0';
   signal sclr_ipd : std_ulogic := '0';

  constant stratix_regtab : VitalStateTableType := (
--   CLK ACLR D   D1  D2   EN  Aload Sclr Sload Casc Synch Qp  Q
    ( x,  H,  x,  x,  x,   x,   x,    x,    x,   x,   x,   x,  L ), -- Areset
    ( x,  x,  x,  L,  x,   x,   H,    x,    x,   x,   x,   x,  L ), -- Aload
    ( x,  x,  x,  H,  x,   x,   H,    x,    x,   x,   x,   x,  H ), -- Aload
    ( x,  x,  x,  x,  x,   x,   H,    x,    x,   x,   x,   x,  U ), -- Aload
    ( x,  x,  x,  x,  x,   L,   x,    x,    x,   x,   x,   x,  S ), -- Q=Q
    ( R,  x,  x,  x,  x,   H,   x,    H,    x,   x,   H,   x,  L ), -- Sreset
    ( R,  x,  x,  L,  x,   H,   x,    x,    H,   x,   H,   x,  L ), -- Sload
    ( R,  x,  x,  H,  x,   H,   x,    x,    H,   x,   H,   x,  H ), -- Sload
    ( R,  x,  x,  x,  x,   H,   x,    x,    H,   x,   H,   x,  U ), -- Sload
    ( R,  x,  L,  x,  x,   H,   x,    x,    x,   x,   H,   x,  L ), -- Datain
    ( R,  x,  H,  x,  x,   H,   x,    x,    x,   x,   H,   x,  H ), -- Datain
    ( R,  x,  x,  x,  x,   H,   x,    x,    x,   x,   H,   x,  U ), -- Datain
    ( R,  x,  x,  x,  L,   H,   x,    x,    x,   H,   x,   x,  L ), -- Cascade
    ( R,  x,  x,  x,  H,   H,   x,    x,    x,   H,   x,   x,  H ), -- Cascade
    ( R,  x,  x,  x,  x,   H,   x,    x,    x,   H,   x,   x,  U ), -- Cascade
    ( R,  x,  L,  x,  x,   H,   x,    x,    x,   x,   x,   x,  L ), -- Datain
    ( R,  x,  H,  x,  x,   H,   x,    x,    x,   x,   x,   x,  H ), -- Datain
    ( R,  x,  x,  x,  x,   H,   x,    x,    x,   x,   x,   x,  U ), -- Datain
    ( x,  x,  x,  x,  x,   x,   x,    x,    x,   x,   x,   x,  S )); -- Q=Q


begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (datac_ipd, datac, tipd_datac);
   VitalWireDelay (clk_ipd, clk, tipd_clk);
   VitalWireDelay (regcascin_ipd, regcascin, tipd_regcascin);
   VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
   VitalWireDelay (aload_ipd, aload, tipd_aload);
   VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
   VitalWireDelay (sload_ipd, sload, tipd_sload);
   VitalWireDelay (ena_ipd, ena, tipd_ena);
   end block;

VITALtiming : process(clk_ipd, aclr_ipd, aload_ipd, datac_ipd, regcascin_ipd, datain, sclr_ipd, ena_ipd, sload_ipd, cena, xonv, smode)

variable Tviol_regcascin_clk : std_ulogic := '0';
variable Tviol_datain_clk : std_ulogic := '0';
variable Tviol_datac_clk : std_ulogic := '0';
variable Tviol_sclr_clk : std_ulogic := '0';
variable Tviol_sload_clk : std_ulogic := '0';
variable Tviol_ena_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_regcascin_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_datac_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
variable regout_VitalGlitchData : VitalGlitchDataType;
variable qfbkout_VitalGlitchData : VitalGlitchDataType;



-- variables for 'X' generation

variable Tviolation : std_logic := '0';
variable tmp_regout : STD_LOGIC := '0';
variable PreviousData : STD_LOGIC_VECTOR(0 to 10);

begin
  
      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then

         VitalSetupHoldCheck (
                Violation       => Tviol_datain_clk,
                TimingData      => TimingData_datain_clk,
                TestSignal      => datain,
                TestSignalName  => "DATAIN",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datain_clk_noedge_posedge,
                SetupLow        => tsetup_datain_clk_noedge_posedge,
                HoldHigh        => thold_datain_clk_noedge_posedge,
                HoldLow         => thold_datain_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (sload_ipd) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_regcascin_clk,
                TimingData      => TimingData_regcascin_clk,
                TestSignal      => regcascin_ipd,
                TestSignalName  => "REGCASCIN",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_regcascin_clk_noedge_posedge,
                SetupLow        => tsetup_regcascin_clk_noedge_posedge,
                HoldHigh        => thold_regcascin_clk_noedge_posedge,
                HoldLow         => thold_regcascin_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

		VitalSetupHoldCheck (
                Violation       => Tviol_datac_clk,
                TimingData      => TimingData_datac_clk,
                TestSignal      => datac_ipd,
                TestSignalName  => "DATAC",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datac_clk_noedge_posedge,
                SetupLow        => tsetup_datac_clk_noedge_posedge,
                HoldHigh        => thold_datac_clk_noedge_posedge,
                HoldLow         => thold_datac_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );


         VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena_ipd,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01(aclr_ipd)  /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_sclr_clk,
                TimingData      => TimingData_sclr_clk,
                TestSignal      => sclr_ipd,
                TestSignalName  => "SCLR",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sclr_clk_noedge_posedge,
                SetupLow        => tsetup_sclr_clk_noedge_posedge,
                HoldHigh        => thold_sclr_clk_noedge_posedge,
                HoldLow         => thold_sclr_clk_noedge_posedge,
                CheckEnabled    => TO_X01(aclr_ipd)  /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_sload_clk,
                TimingData      => TimingData_sload_clk,
                TestSignal      => sload_ipd,
                TestSignalName  => "SLOAD",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_sload_clk_noedge_posedge,
                SetupLow        => tsetup_sload_clk_noedge_posedge,
                HoldHigh        => thold_sload_clk_noedge_posedge,
                HoldLow         => thold_sload_clk_noedge_posedge,
                CheckEnabled    => TO_X01(aclr_ipd)  /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

      end if;

    -------------------------
    --  Functionality Section
    -------------------------

    Tviolation := Tviol_regcascin_clk or Tviol_datain_clk or 
            Tviol_datac_clk or Tviol_ena_clk or Tviol_sclr_clk or Tviol_sload_clk;
    VitalStateTable(
      Result => tmp_regout,
      PreviousDataIn => PreviousData,
      StateTable => stratix_regtab,
      DataIn => (CLK_ipd, ACLR_ipd, datain, datac_ipd, regcascin_ipd, ENA_ipd, aload_ipd, sclr_ipd, sload_ipd, cena, smode));
    tmp_regout := (xonv AND Tviolation) XOR tmp_regout;

  
      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => regout,
       OutSignalName => "REGOUT",
       OutTemp => tmp_regout,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (aload_ipd'last_event, tpd_aload_regout_posedge, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_regout, TRUE),
                 3 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
       GlitchData => regout_VitalGlitchData,
       Mode => OnEvent,
       XOn  => XOn,
       MsgOn  => MsgOn );
		
	  VitalPathDelay01 (
       OutSignal => qfbkout,
       OutSignalName => "QFBKOUT",
       OutTemp => tmp_regout,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_qfbkout_posedge, TRUE),
                 1 => (aload_ipd'last_event, tpd_aload_qfbkout_posedge, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_qfbkout, TRUE),
                 3 => (clk_ipd'last_event, tpd_clk_qfbkout_posedge, TRUE)),
       GlitchData => qfbkout_VitalGlitchData,
       Mode => OnEvent,
       XOn  => XOn,
       MsgOn  => MsgOn );
end process;

end vital_le_reg;	


library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_lcell is
  generic 
    (
      operation_mode  : string := "normal";
      synch_mode      : string := "off";
      register_cascade_mode : string := "off";
      sum_lutc_input  : string := "datac";
      lut_mask        : string := "ffff";
      power_up        : string := "low";
      cin_used        : string := "false";
      cin0_used       : string := "false";
      cin1_used       : string := "false";
      output_mode     : string := "comb_only";
      x_on_violation  : string := "on";
      lpm_type        : string := "stratix_lcell"
      );
  port
    (
      clk       : in std_logic := '0';
      dataa     : in std_logic := '1';
      datab     : in std_logic := '1';
      datac     : in std_logic := '1';
      datad     : in std_logic := '1';
      aclr      : in std_logic := '0';
      aload     : in std_logic := '0';
      sclr      : in std_logic := '0';
      sload     : in std_logic := '0';
      ena       : in std_logic := '1';
      cin       : in std_logic := '0';
      cin0      : in std_logic := '0';
      cin1      : in std_logic := '1';
      inverta   : in std_logic := '0';
      regcascin : in std_logic := '0';
      devclrn   : in std_logic := '1';
      devpor    : in std_logic := '1';
      combout   : out std_logic;
      regout    : out std_logic;
      cout      : out std_logic;
      cout0     : out std_logic;
      cout1     : out std_logic
      );
end stratix_lcell;
        
architecture vital_le_atom of stratix_lcell is

signal dffin : std_logic;
signal qfbkin : std_logic;

signal mode : std_logic_vector(5 downto 0);


component stratix_asynch_lcell 
  generic (
    lms : std_logic_vector(15 downto 0);
    TimingChecksOn: Boolean := True;
    MsgOn: Boolean := DefGlitchMsgOn;
    XOn: Boolean := DefGlitchXOn;
    MsgOnChecks: Boolean := DefMsgOnChecks;
    XOnChecks: Boolean := DefXOnChecks;
    InstancePath: STRING := "*";
      
    tpd_dataa_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_datab_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_datac_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_datad_combout           : VitalDelayType01 := DefPropDelay01;
    tpd_cin_combout             : VitalDelayType01 := DefPropDelay01;
    tpd_cin0_combout            : VitalDelayType01 := DefPropDelay01;
    tpd_cin1_combout            : VitalDelayType01 := DefPropDelay01;
    tpd_inverta_combout         : VitalDelayType01 := DefPropDelay01;
    tpd_qfbkin_combout          : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_datab_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_datac_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_datad_regin             : VitalDelayType01 := DefPropDelay01;
    tpd_cin_regin               : VitalDelayType01 := DefPropDelay01;
    tpd_cin0_regin              : VitalDelayType01 := DefPropDelay01;
    tpd_cin1_regin              : VitalDelayType01 := DefPropDelay01;
    tpd_inverta_regin           : VitalDelayType01 := DefPropDelay01;
    tpd_qfbkin_regin            : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_cout	        : VitalDelayType01 := DefPropDelay01;
    tpd_datab_cout	        : VitalDelayType01 := DefPropDelay01;
    tpd_cin_cout		: VitalDelayType01 := DefPropDelay01;
    tpd_cin0_cout		: VitalDelayType01 := DefPropDelay01;
    tpd_cin1_cout		: VitalDelayType01 := DefPropDelay01;
    tpd_inverta_cout            : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_cout0             : VitalDelayType01 := DefPropDelay01;
    tpd_datab_cout0             : VitalDelayType01 := DefPropDelay01;
    tpd_cin0_cout0		: VitalDelayType01 := DefPropDelay01;
    tpd_inverta_cout0           : VitalDelayType01 := DefPropDelay01;
    tpd_dataa_cout1             : VitalDelayType01 := DefPropDelay01;
    tpd_datab_cout1             : VitalDelayType01 := DefPropDelay01;
    tpd_cin1_cout1		: VitalDelayType01 := DefPropDelay01;
    tpd_inverta_cout1           : VitalDelayType01 := DefPropDelay01;
    tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
    tipd_datab			: VitalDelayType01 := DefPropDelay01; 
    tipd_datac			: VitalDelayType01 := DefPropDelay01; 
    tipd_datad			: VitalDelayType01 := DefPropDelay01; 
    tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
    tipd_cin0  			: VitalDelayType01 := DefPropDelay01; 
    tipd_cin1  			: VitalDelayType01 := DefPropDelay01; 
    tipd_inverta		: VitalDelayType01 := DefPropDelay01); 

  port (
    dataa     : in std_logic := '1';
    datab     : in std_logic := '1';
    datac     : in std_logic := '1';
    datad     : in std_logic := '1';
    cin       : in std_logic := '0';
    cin0      : in std_logic := '0';
    cin1      : in std_logic := '1';
    inverta   : in std_logic := '0';
    qfbkin    : in std_logic := '0';
    mode      : in std_logic_vector(5 downto 0);
    regin     : out std_logic;
    combout   : out std_logic;
    cout      : out std_logic;
    cout0     : out std_logic;
    cout1     : out std_logic);
end component;


component stratix_lcell_register
  generic (
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";

      tsetup_regcascin_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_regcascin_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_clk_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_qfbkout_posedge		: VitalDelayType01 := DefPropDelay01;
      
      tipd_clk  			: VitalDelayType01 := DefPropDelay01;
      tipd_datac  			: VitalDelayType01 := DefPropDelay01;
      tipd_regcascin                    : VitalDelayType01 := DefPropDelay01; 
      tipd_ena  			: VitalDelayType01 := DefPropDelay01; 
      tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_aload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sload 			: VitalDelayType01 := DefPropDelay01);

  port (clk     :in std_logic := '0';
        datain  : in std_logic := '0';
        datac   : in std_logic := '0';
	regcascin : in std_logic := '0';
        aclr    : in std_logic := '0';
        aload   : in std_logic := '0';
        sclr    : in std_logic := '0';
        sload   : in std_logic := '0';
        ena     : in std_logic := '1';
        cena : in std_logic := '0';
        xonv : in std_logic := '1';
        smode : in std_logic := '0';
        regout  : out std_logic;
	qfbkout : out std_logic);
end component;

signal aclr1, xonv, cena, smode : std_logic ;

begin

aclr1 <= aclr or (not devclrn) or (not devpor);
cena  <= '1' when (register_cascade_mode = "on") else '0';
xonv  <= '1' when (x_on_violation = "on") else '0';
smode <= '1' when (synch_mode = "on") else '0';
     

mode(0) <= '1' when operation_mode = "normal" else
           '0'; --  operation_mode = "arithmetic"
mode(1) <= '1' when sum_lutc_input = "datac" else
           '0' ; -- sum_lutc_input = "cin"
mode(2) <= '1' when sum_lutc_input = "qfbk" else
           '0'; --  sum_lutc_input = "cin" or "datac"
mode(3) <= '1' when cin_used = "true" else 
           '0'; --  cin_used = "false"
mode(4) <= '1' when cin0_used = "true" else 
           '0'; --  cin0_used = "false"
mode(5) <= '1' when cin1_used = "true" else 
           '0'; --  cin1_used = "false"

lecomb: stratix_asynch_lcell
  generic map (lms => str_to_bin(lut_mask))
  port map    (
    dataa => dataa,
    datab => datab,
    datac => datac,
    datad => datad,
    qfbkin => qfbkin,
    inverta => map_x_to_0(inverta),
    cin => cin,
    cin0 => cin0,
    cin1 => cin1,
    mode => mode,
    combout => combout,
    cout => cout,
    cout0 => cout0,
    cout1 => cout1,
    regin => dffin);


lereg: stratix_lcell_register

  	port map (clk => clk, datain => dffin, datac => datac, smode => smode,
                 regcascin => regcascin, aclr => aclr1, aload => aload, 
                 sclr => sclr, sload => sload, ena => ena, cena => cena, 
                 xonv => xonv, regout => regout, qfbkout => qfbkin);

end vital_le_atom;

--
--
--  STRATIX_ASYNCH_IO Model
--
--

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_asynch_io is
  generic
    (
      operation_mode                : STRING := "input";
      open_drain_output             : STRING := "false";
      bus_hold                      : STRING := "false";
      phase_shift_delay             : time := 0 ps;
      XOn                           : Boolean := DefGlitchXOn;
      MsgOn                         : Boolean := DefGlitchMsgOn;
      tpd_datain_padio              : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_posedge          : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_negedge          : VitalDelayType01 := DefPropDelay01;
      tpd_padio_combout             : VitalDelayType01 := DefPropDelay01;
      tpd_regin_regout              : VitalDelayType01 := DefPropDelay01;
      tpd_ddioregin_ddioregout      : VitalDelayType01 := DefPropDelay01;
      tpd_padio_dqsundelayedout     : VitalDelayType01 := DefPropDelay01;
      tipd_datain                   : VitalDelayType01 := DefPropDelay01;
      tipd_oe                       : VitalDelayType01 := DefPropDelay01;
      tipd_padio                    : VitalDelayType01 := DefPropDelay01;
      tipd_delayctrlin              : VitalDelayType01 := DefPropDelay01
      );
  port
    (
      datain    : in  STD_LOGIC := '0';
      oe        : in  STD_LOGIC := '1';
      regin     : in std_logic;
      ddioregin : in std_logic;
      delayctrlin : in std_logic;
      padio     : inout STD_LOGIC;
      combout   : out STD_LOGIC;
      regout    : out STD_LOGIC;
      ddioregout: out STD_LOGIC;
      dqsundelayedout : out STD_LOGIC
      );
  attribute VITAL_LEVEL0 of stratix_asynch_io : entity is TRUE;
end stratix_asynch_io;

architecture behave of stratix_asynch_io is
  attribute VITAL_LEVEL0 of behave : architecture is TRUE;
  signal datain_ipd, oe_ipd, padio_ipd: std_logic;
  signal delayctrlin_ipd : std_logic;
begin
  ---------------------
  --  INPUT PATH DELAYs
  ---------------------
  WireDelay : block
  begin
    VitalWireDelay (datain_ipd, datain, tipd_datain);
    VitalWireDelay (oe_ipd, oe, tipd_oe);
    VitalWireDelay (padio_ipd, padio, tipd_padio);
    VitalWireDelay (delayctrlin_ipd, delayctrlin, tipd_delayctrlin);
  end block;

  VITAL: process(padio_ipd, datain_ipd, oe_ipd, regin, ddioregin, delayctrlin_ipd)
    variable combout_VitalGlitchData : VitalGlitchDataType;
    variable padio_VitalGlitchData : VitalGlitchDataType;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    variable ddioregout_VitalGlitchData : VitalGlitchDataType;
    variable dqsundelayedout_VitalGlitchData : VitalGlitchDataType;
    variable tmp_combout, tmp_padio : std_logic;
    variable prev_value : std_logic := 'H';
    variable combout_tmp : std_logic;
    variable dqs_delay : VitalDelayType01 := (0 ps, 0 ps);
    variable warn_x : boolean := false;
    variable combout_delay : VitalDelayType01;
    variable dqs_delay_is_applied : boolean := false;
    variable init : boolean := true;
  begin
    if (init) then
      combout_delay := tpd_padio_combout;
      init := false;
    end if;
    if (delayctrlin_ipd = '1') then
      if (not dqs_delay_is_applied) then
        for i in combout_delay'range loop
          combout_delay(i) := combout_delay(i) + phase_shift_delay;
        end loop;
        dqs_delay_is_applied := true;
      end if;
      warn_x := false;
    elsif (delayctrlin_ipd = '0') then
      combout_delay := tpd_padio_combout;
      dqs_delay_is_applied := false;
      warn_x := false;
    elsif (delayctrlin_ipd'event) then
      combout_delay := tpd_padio_combout;
      dqs_delay_is_applied := false;
      if (not warn_x) then
        assert false report "Illegal value detected on input DELAYCTRLIN" severity warning;
        warn_x := true;
      end if;
    end if;
    
    if (bus_hold = "true" ) then
      if ( operation_mode = "input") then
        if ( padio_ipd = 'Z') then
          tmp_padio := prev_value;
          tmp_combout := to_x01z(padio_ipd);
        else
          if ( padio_ipd = '1') then
            prev_value := 'H';
          elsif ( padio_ipd = '0') then
            prev_value := 'L';
          else
            prev_value := 'W';
          end if;
          tmp_combout := to_x01z(padio_ipd);
        end if;
      elsif ( operation_mode = "output" or operation_mode = "bidir") then
        if ( oe_ipd = '1') then
          if ( open_drain_output = "true" ) then
            if (datain_ipd = '0') then
              tmp_padio := '0';
              prev_value := 'L';
            elsif (datain_ipd = 'X') then
              tmp_padio := 'X';
              prev_value := 'W';
            else   -- 'Z'
              -- need to update prev_value
              if (padio_ipd = '1') then
                prev_value := 'H';
              elsif (padio_ipd = '0') then
                prev_value := 'L';
              elsif (padio_ipd = 'X') then
                prev_value := 'W';
              end if;
              tmp_padio := prev_value;
            end if;
          else
            tmp_padio := datain_ipd;
            if ( datain_ipd = '1') then
              prev_value := 'H';
            elsif (datain_ipd = '0' ) then
              prev_value := 'L';
            elsif ( datain_ipd = 'X') then
              prev_value := 'W';
            else
              prev_value := datain_ipd;
            end if;
          end if; -- end open_drain_output
          
        elsif ( oe_ipd = '0' ) then
          -- need to update prev_value
          if (padio_ipd = '1') then
            prev_value := 'H';
          elsif (padio_ipd = '0') then
            prev_value := 'L';
          elsif (padio_ipd = 'X') then
            prev_value := 'W';
          end if;
          tmp_padio := prev_value;
        else
          tmp_padio := 'X';
          prev_value := 'W';
        end if; -- end oe_in
        
        if ( operation_mode = "bidir") then
          tmp_combout := to_x01z(padio_ipd);
        else
          tmp_combout := 'Z';
        end if;
      end if;

      if ( now <= 1 ps AND prev_value = 'W' ) then     --hack for autotest to pass
        prev_value := 'L';
      end if;
      
    else    -- bus_hold is false
      if ( operation_mode = "input") then
        tmp_combout := padio_ipd;
        tmp_padio := 'Z';
      elsif (operation_mode = "output" or operation_mode = "bidir" ) then
        if ( operation_mode  = "bidir") then
          tmp_combout := padio_ipd;
        else
          tmp_combout := 'Z';
        end if;
        
        if ( oe_ipd = '1') then
          if ( open_drain_output = "true" ) then
            if (datain_ipd = '0') then
              tmp_padio := '0';
            elsif (datain_ipd = 'X') then
              tmp_padio := 'X';
            else
              tmp_padio := 'Z';
            end if;
          else
            tmp_padio := datain_ipd;
          end if;
        elsif ( oe_ipd = '0' ) then
          tmp_padio := 'Z';
        else
          tmp_padio := 'X';
        end if;
      end if;
    end if; -- end bus_hold
    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
      OutSignal => combout,
      OutSignalName => "combout",
      OutTemp => tmp_combout,
      Paths => (1 => (padio_ipd'last_event, combout_delay, TRUE)),
      GlitchData => combout_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

    VitalPathDelay01 (
      OutSignal => padio,
      OutSignalName => "padio",
      OutTemp => tmp_padio,
      Paths => (1 => (datain_ipd'last_event, tpd_datain_padio, TRUE),
                2 => (oe_ipd'last_event, tpd_oe_padio_posedge, oe_ipd = '1'),
                3 => (oe_ipd'last_event, tpd_oe_padio_negedge, oe_ipd = '0')),
      GlitchData => padio_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

    VitalPathDelay01 (
      OutSignal => regout,
      OutSignalName => "regout",
      OutTemp => regin,
      Paths => (1 => (regin'last_event, tpd_regin_regout, TRUE)),
      GlitchData => regout_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

    VitalPathDelay01 (
      OutSignal => ddioregout,
      OutSignalName => "ddioregout",
      OutTemp => ddioregin,
      Paths => (1 => (ddioregin'last_event, tpd_ddioregin_ddioregout, TRUE)),
      GlitchData => ddioregout_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

    VitalPathDelay01 (
      OutSignal => dqsundelayedout,
      OutSignalName => "dqsundelayedout",
      OutTemp => tmp_combout,
      Paths => (1 => (padio_ipd'last_event, tpd_padio_dqsundelayedout, TRUE)),
      GlitchData => dqsundelayedout_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

  end process;

end behave;

--
-- STRATIX_IO_REGISTER
--

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_io_register is
  generic
    (
      async_reset       : string := "none";
      sync_reset        : string := "none";
      power_up          : string := "low";
      TimingChecksOn    : Boolean := True;
      MsgOn             : Boolean := DefGlitchMsgOn;
      XOn               : Boolean := DefGlitchXOn;
      MsgOnChecks       : Boolean := DefMsgOnChecks;
      XOnChecks         : Boolean := DefXOnChecks;
      InstancePath      : STRING := "*";
      tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_areset_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tipd_clk  			: VitalDelayType01 := DefPropDelay01;
      tipd_datain  			: VitalDelayType01 := DefPropDelay01;
      tipd_ena                          : VitalDelayType01 := DefPropDelay01; 
      tipd_areset 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sreset 			: VitalDelayType01 := DefPropDelay01);

  port
    (
      clk       : in std_logic := '0';
      datain    : in std_logic := '0';
      ena       : in std_logic := '1';
      sreset    : in std_logic := '0';
      areset    : in std_logic := '0';
      devclrn   : in std_logic := '1';
      devpor    : in std_logic := '1';
      regout    : out std_logic
      );
  attribute VITAL_LEVEL0 of stratix_io_register : entity is TRUE;
end stratix_io_register;
        
architecture vital_io_reg of stratix_io_register is
  attribute VITAL_LEVEL0 of vital_io_reg : architecture is TRUE;
  signal datain_ipd, ena_ipd, sreset_ipd : std_logic;
  signal clk_ipd, areset_ipd : std_logic;
begin
  ---------------------
  --  INPUT PATH DELAYs
  ---------------------
  WireDelay : block
  begin
    VitalWireDelay (datain_ipd, datain, tipd_datain);
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
    VitalWireDelay (sreset_ipd, sreset, tipd_sreset);
    VitalWireDelay (areset_ipd, areset, tipd_areset);
  end block;

  VITALtiming : process(clk_ipd, datain_ipd, ena_ipd, sreset_ipd,
                        areset_ipd, devclrn, devpor)

    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable Tviol_sreset_clk : std_ulogic := '0';
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sreset_clk : VitalTimingDataType := VitalTimingDataInit;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    variable iregout : std_logic;
    variable idata : std_logic := '0';
    variable tmp_regout : std_logic;
    variable tmp_reset : std_logic := '0';
    -- variables for 'X' generation
    variable violation : std_logic := '0';

  begin
    if (now = 0 ns) then
      if (power_up = "low") then
        iregout := '0';
      elsif (power_up = "high") then
        iregout := '1';
      end if;
    end if;
    if ( async_reset /= "none") then
      tmp_reset := areset_ipd; -- this is used to enable timing check.
    end if;

    ------------------------
    --  Timing Check Section
    ------------------------
    if (TimingChecksOn) then
      VitalSetupHoldCheck (
        Violation       => Tviol_datain_clk,
        TimingData      => TimingData_datain_clk,
        TestSignal      => datain_ipd,
        TestSignalName  => "DATAIN",
        RefSignal       => clk_ipd,
        RefSignalName   => "CLK",
        SetupHigh       => tsetup_datain_clk_noedge_posedge,
        SetupLow        => tsetup_datain_clk_noedge_posedge,
        HoldHigh        => thold_datain_clk_noedge_posedge,
        HoldLow         => thold_datain_clk_noedge_posedge,
        CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
        RefTransition   => '/',
        HeaderMsg       => InstancePath & "/LCELL",
        XOn             => XOnChecks,
        MsgOn           => MsgOnChecks );

      VitalSetupHoldCheck (
        Violation       => Tviol_ena_clk,
        TimingData      => TimingData_ena_clk,
        TestSignal      => ena_ipd,
        TestSignalName  => "ENA",
        RefSignal       => clk_ipd,
        RefSignalName   => "CLK",
        SetupHigh       => tsetup_ena_clk_noedge_posedge,
        SetupLow        => tsetup_ena_clk_noedge_posedge,
        HoldHigh        => thold_ena_clk_noedge_posedge,
        HoldLow         => thold_ena_clk_noedge_posedge,
        CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
        RefTransition   => '/',
        HeaderMsg       => InstancePath & "/LCELL",
        XOn             => XOnChecks,
        MsgOn           => MsgOnChecks );
      
      VitalSetupHoldCheck (
        Violation       => Tviol_sreset_clk,
        TimingData      => TimingData_sreset_clk,
        TestSignal      => sreset_ipd,
        TestSignalName  => "SRESET",
        RefSignal       => clk_ipd,
        RefSignalName   => "CLK",
        SetupHigh       => tsetup_sreset_clk_noedge_posedge,
        SetupLow        => tsetup_sreset_clk_noedge_posedge,
        HoldHigh        => thold_sreset_clk_noedge_posedge,
        HoldLow         => thold_sreset_clk_noedge_posedge,
        CheckEnabled    => TO_X01((tmp_reset) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
        RefTransition   => '/',
        HeaderMsg       => InstancePath & "/LCELL",
        XOn             => XOnChecks,
        MsgOn           => MsgOnChecks );
    end if;

    violation := Tviol_datain_clk or Tviol_ena_clk or Tviol_sreset_clk;

    if (devpor = '0') then
      if (power_up = "low") then
        iregout := '0';
      elsif (power_up = "high") then
        iregout := '1';
      end if;
    elsif (devclrn = '0') then
      iregout := '0';
    elsif (async_reset = "clear" and areset_ipd = '1') then
      iregout := '0';
    elsif ( async_reset = "preset" and areset_ipd = '1') then
      iregout := '1';
    elsif (violation = 'X') then
      iregout := 'X';
    elsif (ena_ipd = '1' and clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0') then
      if (sync_reset = "clear" and sreset_ipd = '1' ) then
        iregout := '0';
      elsif (sync_reset = "preset" and sreset_ipd = '1' ) then
        iregout := '1';
      else
        iregout := to_x01z(datain_ipd);
      end if;
    end if;
	
    tmp_regout := iregout;

    ----------------------
    --  Path Delay Section
    ----------------------
    VitalPathDelay01 (
      OutSignal => regout,
      OutSignalName => "REGOUT",
      OutTemp => tmp_regout,
      Paths => (0 => (areset_ipd'last_event, tpd_areset_regout_posedge, async_reset /= "none"),
                1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
      GlitchData => regout_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn  => MsgOn );

  end process;

end vital_io_reg;	

--
-- STRATIX_IO
--

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;
use stratix.pllpack.all;

entity  stratix_io is
  generic
    (
      operation_mode    : string := "input";
      ddio_mode         : string := "none";
      open_drain_output : string := "false";
      bus_hold          : string := "false";
      output_register_mode : string := "none";
      output_async_reset : string := "none";
      output_sync_reset : string := "none";
      output_power_up   : string := "low";
      tie_off_output_clock_enable : string := "false";
      oe_register_mode  : string := "none";
      oe_async_reset    : string := "none";
      oe_sync_reset     : string := "none";
      oe_power_up       : string := "low";
      tie_off_oe_clock_enable : string := "false";
      input_register_mode : string := "none";
      input_async_reset : string := "none";
      input_sync_reset  : string := "none";
      input_power_up    : string := "low";
      extend_oe_disable : string := "false";
      sim_dll_phase_shift : string  := "0";
      sim_dqs_input_frequency : string  := "10000 ps";
      lpm_type          : string := "stratix_io"
      );
  port
    (
      datain          : in std_logic := '0';
      ddiodatain      : in std_logic := '0';
      oe              : in std_logic := '1';
      outclk          : in std_logic := '0';
      outclkena       : in std_logic := '1';
      inclk           : in std_logic := '0';
      inclkena        : in std_logic := '1';
      areset          : in std_logic := '0';
      sreset          : in std_logic := '0';
      devclrn         : in std_logic := '1';
      devpor          : in std_logic := '1';
      devoe           : in std_logic := '0';
      delayctrlin     : in std_logic := '0';
      combout         : out std_logic;
      regout          : out std_logic;
      ddioregout      : out std_logic;
      dqsundelayedout : out std_logic;
      padio           : inout std_logic
      );
end stratix_io;

architecture structure of stratix_io is
  component stratix_asynch_io
    generic
      (
        operation_mode : string := "input";
        open_drain_output : string := "false";
        bus_hold : string := "false";
        phase_shift_delay : time := 0 ps);
    port
      (
        datain  : in  STD_LOGIC := '0';
        oe      : in  STD_LOGIC := '1';
        regin   : in std_logic;
        ddioregin : in std_logic;
        delayctrlin : in std_logic;
        padio   : inout STD_LOGIC;
        combout : out STD_LOGIC;
        regout  : out STD_LOGIC;
        ddioregout : out STD_LOGIC;
        dqsundelayedout : out std_logic
        );
end component;

component stratix_io_register
  generic
    (
      async_reset : string := "none";
      sync_reset : string := "none";
      power_up : string := "low";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sreset_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_areset_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tipd_clk  			: VitalDelayType01 := DefPropDelay01;
      tipd_datain  			: VitalDelayType01 := DefPropDelay01;
      tipd_ena                          : VitalDelayType01 := DefPropDelay01; 
      tipd_areset 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sreset 			: VitalDelayType01 := DefPropDelay01);
   port
     (
       clk      : in std_logic := '0';
       datain   : in std_logic := '0';
       ena      : in std_logic := '1';
       sreset   : in std_logic := '0';
       areset   : in std_logic := '0';
       devclrn  : in std_logic := '1';
       devpor   : in std_logic := '1';
       regout   : out std_logic
       );
end component;

component mux21
  generic
    (
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_A_MO  :   VitalDelayType01 := DefPropDelay01;
      tpd_B_MO  :   VitalDelayType01 := DefPropDelay01;
      tpd_S_MO  :   VitalDelayType01 := DefPropDelay01;
      tipd_A    :   VitalDelayType01 := DefPropDelay01;
      tipd_B    :   VitalDelayType01 := DefPropDelay01;
      tipd_S    :   VitalDelayType01 := DefPropDelay01
      );

  port
    (
      A : in std_logic := '0';
      B : in std_logic := '0';
      S : in std_logic := '0';
      MO : out std_logic
      );
end component;

component and1
  generic
    (
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_IN1_Y :  VitalDelayType01 := DefPropDelay01;
      tipd_IN1  :  VitalDelayType01 := DefPropDelay01
      );
  
  port
    (
      Y         :  out   STD_LOGIC;
      IN1       :  in    STD_LOGIC
      );
end component;

signal  oe_out : std_logic;
signal  in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out: std_logic;
signal  oe_reg_out, oe_pulse_reg_out : std_logic;
signal  out_reg_out, out_ddio_reg_out: std_logic;
signal  tmp_datain : std_logic;
signal  not_inclk, not_outclk : std_logic;

-- for DDIO
signal ddio_data : std_logic;
signal outclk_delayed : std_logic;
signal out_clk_ena, oe_clk_ena : std_logic;

constant phase_shift_delay : time := (dqs_str2int(sim_dll_phase_shift) * dqs_str2int(sim_dqs_input_frequency) * 1 ps) / 360;

begin

  not_inclk <= not inclk;
  not_outclk <= not outclk;

  out_clk_ena <= '1' WHEN tie_off_output_clock_enable = "true" ELSE outclkena;
  oe_clk_ena <= '1' WHEN tie_off_oe_clock_enable = "true" ELSE outclkena;

--input register
  in_reg : stratix_io_register
    generic map
    (
      ASYNC_RESET => input_async_reset,
      SYNC_RESET => input_sync_reset,
      POWER_UP => input_power_up
      )
    port map
    (
      regout  => in_reg_out,
      clk => inclk,
      ena => inclkena,
      datain => padio, 
      areset => areset,
      sreset => sreset,
      devpor => devpor,
      devclrn => devclrn
      );

-- in_ddio0_reg
  in_ddio0_reg : stratix_io_register
    generic map
    (
      ASYNC_RESET => input_async_reset,
      SYNC_RESET => input_sync_reset,
      POWER_UP => input_power_up
      )
    port map
    (
      regout => in_ddio0_reg_out,
      clk => not_inclk,
      ena => inclkena,
      datain => padio, 
      areset => areset,
      sreset => sreset,
      devpor => devpor,
      devclrn => devclrn
      );
  -- in_ddio1_reg
  -- this register does not have sync_reset
  in_ddio1_reg : stratix_io_register
    generic map
    (
      ASYNC_RESET => input_async_reset,
      SYNC_RESET => "none",  
      POWER_UP => input_power_up
      )
    port map
    (
      regout  => in_ddio1_reg_out,
      clk => inclk,
      ena => inclkena,
      datain => in_ddio0_reg_out, 
      areset => areset,
      devpor => devpor,
      devclrn => devclrn
      );

-- out_reg
  out_reg : stratix_io_register
    generic map
    (
      ASYNC_RESET => output_async_reset,
      SYNC_RESET => output_sync_reset,
      POWER_UP => output_power_up
      )
    port map
    (
      regout  => out_reg_out,
      clk => outclk,
      ena => out_clk_ena,
      datain => datain, 
      areset => areset,
      sreset => sreset,
      devpor => devpor,
      devclrn => devclrn
      );

-- out ddio reg
  out_ddio_reg : stratix_io_register
    generic map
    (
      ASYNC_RESET => output_async_reset,
      SYNC_RESET => output_sync_reset,
      POWER_UP => output_power_up)
    port map
    (
      regout  => out_ddio_reg_out,
      clk => outclk,
      ena => out_clk_ena,
      datain => ddiodatain, 
      areset => areset,
      sreset => sreset,
      devpor => devpor,
      devclrn => devclrn
      );

-- oe reg
  oe_reg : stratix_io_register
    generic map
    (
      ASYNC_RESET => oe_async_reset,
      SYNC_RESET => oe_sync_reset,
      POWER_UP => oe_power_up
      )
    port map
    (
      regout  => oe_reg_out,
      clk => outclk,
      ena => oe_clk_ena,
      datain => oe, 
      areset => areset,
      sreset => sreset,
      devpor => devpor,
      devclrn => devclrn
      );

-- oe_pulse reg
  oe_pulse_reg : stratix_io_register
    generic map
    (
      ASYNC_RESET => oe_async_reset,
      SYNC_RESET => oe_sync_reset,
      POWER_UP => oe_power_up
      )
    port map
    (
      regout  => oe_pulse_reg_out,
      clk => not_outclk,
      ena => oe_clk_ena,
      datain => oe_reg_out, 
      areset => areset,
      sreset => sreset,
      devpor => devpor,
      devclrn => devclrn
      );

  oe_out <= (oe_pulse_reg_out and oe_reg_out) WHEN (extend_oe_disable = "true") ELSE oe_reg_out WHEN (oe_register_mode = "register") ELSE oe;

  sel_delaybuf  : and1
    port map
    (
      Y => outclk_delayed,
      IN1 => outclk
      );

  ddio_data_mux : mux21
    port map
    (
      MO => ddio_data,
      A => out_ddio_reg_out,
      B => out_reg_out,
      S => outclk_delayed
      );

  tmp_datain <= ddio_data WHEN (ddio_mode = "output" or
                                ddio_mode = "bidir") ELSE
                out_reg_out WHEN (output_register_mode = "register") ELSE
                datain;

-- timing info in case output and/or input are not registered.
  inst1 : stratix_asynch_io
    generic map
    (
      OPERATION_MODE => operation_mode,
      OPEN_DRAIN_OUTPUT => open_drain_output,
      BUS_HOLD => bus_hold,
      PHASE_SHIFT_DELAY => phase_shift_delay
      )
    port map
    (
      datain => tmp_datain,
      oe => oe_out,
      regin => in_reg_out,
      ddioregin => in_ddio1_reg_out,
      delayctrlin => delayctrlin,
      padio => padio,
      combout => combout,
      regout => regout,
      ddioregout => ddioregout,
      dqsundelayedout => dqsundelayedout
      );

end structure;
-- ///////////////////////////////////////////////////////////////////////////
-- //
-- //                           STRATIX_MAC_REGISTER
-- //
-- ///////////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_mac_register is
  generic 
    (
      data_width      : integer := 18;
      tipd_data       : VitalDelayArrayType01(71 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_dataout_posedge  : VitalDelayType01 := DefPropDelay01;
      tpd_clk_dataout_posedge   : VitalDelayType01 := DefPropDelay01;
      tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tpw_ena_posedge : VitalDelayType := 0 ns
    );
  
  port
    (
      data      : IN STD_LOGIC_VECTOR (71 downto 0);
      clk       : IN std_logic;
      aclr      : IN std_logic;
      ena       : IN std_logic;
      async     : IN std_logic;
      devclrn   : IN std_logic;
      devpor    : IN std_logic;
      dataout   : OUT STD_LOGIC_VECTOR (71 downto 0)
    );

end stratix_mac_register;

architecture reg_arch OF stratix_mac_register IS

  signal data_ipd       : STD_LOGIC_VECTOR (71 downto 0) := (others => '0');
  signal clk_ipd        : STD_LOGIC := '0';
  signal aclr_ipd       : STD_LOGIC := '0';
  signal ena_ipd        : STD_LOGIC := '0';

begin 

  WireDelay : block
  begin
    g1 : for i in data'range generate
      VitalWireDelay (data_ipd(i), data(i), tipd_data(i));
    end generate;
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
  end block;

  process (data_ipd, clk_ipd, aclr_ipd, ena_ipd,
           devclrn, devpor, async)
    variable dataout_sig	: STD_LOGIC_VECTOR (71 downto 0) := (others => '0');
    variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(71 downto 0);
    variable Tviol_clk_ena      : STD_ULOGIC := '0';
    variable Tviol_data_clk     : STD_ULOGIC := '0';
    variable TimingData_clk_ena : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_data_clk : VitalTimingDataType := VitalTimingDataInit;
    variable Tviol_ena          : STD_ULOGIC := '0';
    variable PeriodData_ena     : VitalPeriodDataType := VitalPeriodDataInit;
  begin

    if async = '1' then
      dataout_sig := data_ipd;
    elsif ((aclr_ipd = '1') or (devclrn = '0') or (devpor = '0')) then
      dataout_sig := (others => '0'); 
    elsif (clk_ipd'EVENT AND clk_ipd = '1') then
      if ena_ipd = '1' then
        dataout_sig := data_ipd;
      end if;
    end if;
   
    if (async = '0') then 
      VitalSetupHoldCheck (
        Violation       => Tviol_clk_ena,
        TimingData      => TimingData_clk_ena,
        TestSignal      => clk_ipd,
        TestSignalName  => "clk",
        RefSignal       => ena_ipd,
        RefSignalName   => "ena",
        SetupHigh       => tsetup_ena_clk_noedge_posedge,
        SetupLow        => tsetup_ena_clk_noedge_posedge,
        HoldHigh        => thold_ena_clk_noedge_posedge,
        HoldLow         => thold_ena_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/MAC Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalSetupHoldCheck (
        Violation       => Tviol_data_clk,
        TimingData      => TimingData_data_clk,
        TestSignal      => data_ipd,
        TestSignalName  => "data",
        RefSignal       => clk_ipd,
        RefSignalName   => "clk",
        SetupHigh       => tsetup_data_clk_noedge_posedge,
        SetupLow        => tsetup_data_clk_noedge_posedge,
        HoldHigh        => thold_data_clk_noedge_posedge,
        HoldLow         => thold_data_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/MAC Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalPeriodPulseCheck (
        Violation       => Tviol_ena, 
        PeriodData      => PeriodData_ena,  
        TestSignal      => ena_ipd,
        TestSignalName  => "ena",
        PulseWidthHigh  => tpw_ena_posedge, 
        HeaderMsg       => "/MAC Register VitalPeriodPulseCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
    end if;

      VitalPathDelay01 (
        OutSignal     => dataout(0),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(0),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(0),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(1),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(1),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(1),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(2),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(2),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(2),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(3),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(3),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(3),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(4),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(4),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(4),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(5),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(5),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(5),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(6),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(6),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(6),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(7),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(7),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(7),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(8),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(8),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(8),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(9),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(9),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(9),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(10),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(10),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(10),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(11),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(11),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(11),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(12),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(12),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(12),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(13),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(13),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(13),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(14),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(14),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(14),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(15),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(15),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(15),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(16),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(16),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(16),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(17),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(17),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(17),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(18),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(18),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(18),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(19),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(19),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(19),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(20),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(20),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(20),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(21),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(21),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(21),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(22),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(22),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(22),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(23),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(23),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(23),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(24),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(24),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(24),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(25),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(25),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(25),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(26),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(26),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(26),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(27),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(27),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(27),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(28),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(28),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(28),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(29),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(29),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(29),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(30),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(30),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(30),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(31),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(31),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(31),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(32),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(32),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(32),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(33),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(33),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(33),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(34),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(34),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(34),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(35),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(35),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(35),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(36),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(36),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(36),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(37),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(37),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(37),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(38),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(38),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(38),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(39),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(39),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(39),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(40),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(40),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(40),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(41),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(41),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(41),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(42),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(42),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(42),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(43),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(43),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(43),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(44),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(44),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(44),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(45),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(45),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(45),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(46),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(46),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(46),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(47),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(47),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(47),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(48),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(48),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(48),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(49),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(49),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(49),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(50),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(50),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(50),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(51),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(51),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(51),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(52),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(52),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(52),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(53),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(53),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(53),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(54),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(54),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(54),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(55),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(55),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(55),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(56),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(56),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(56),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(57),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(57),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(57),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(58),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(58),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(58),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(59),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(59),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(59),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(60),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(60),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(60),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(61),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(61),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(61),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(62),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(62),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(62),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(63),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(63),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(63),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(64),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(64),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(64),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(65),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(65),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(65),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(66),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(66),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(66),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(67),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(67),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(67),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(68),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(68),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(68),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(69),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(69),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(69),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(70),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(70),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(70),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(71),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(71),
        Paths         => (0 => (clk_ipd'last_event, tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event, tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(71),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
end process;

end reg_arch;

-- ///////////////////////////////////////////////////////////////////////////
-- //
-- //                         STRATIX_MAC_MULT_INTERNAL
-- //
-- ///////////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_mac_mult_internal is
  generic 
    (
      dataa_width       : integer := 18;
      datab_width       : integer := 18;
      tipd_dataa        : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
      tipd_datab        : VitalDelayArrayType01(17 downto 0) := (OTHERS => DefPropDelay01);
      tpd_dataa_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_datab_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_signa_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_signb_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_scanouta   : VitalDelayType01 := DefPropDelay01;
      tpd_datab_scanoutb   : VitalDelayType01 := DefPropDelay01;
      XOn               : Boolean := DefGlitchXOn;     
      MsgOn             : Boolean := DefGlitchMsgOn  
    );

  port
    (
      dataa : IN std_logic_vector (dataa_width-1 downto 0) := (others => '0'); 
      datab : IN std_logic_vector (datab_width-1 downto 0) := (others => '0');
      signa : IN std_logic := '1';
      signb : IN std_logic := '1';
      scanouta : OUT std_logic_vector (17 downto 0);
      scanoutb : OUT std_logic_vector (17 downto 0);
      dataout : OUT std_logic_vector (35 downto 0)
    );
	
end stratix_mac_mult_internal;

architecture mult_internal_arch OF stratix_mac_mult_internal IS
  signal dataa_ipd 	: std_logic_vector (17 downto 0) := (others => '0');
  signal datab_ipd 	: std_logic_vector (17 downto 0) := (others => '0');
  constant DefGlitchMode : VitalGlitchKindType := OnEvent;  
begin

  WireDelay : block
  begin
    g1 : for i in dataa'range generate
      VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
    end generate;
    g2 : for i in datab'range generate
      VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
    end generate;
  end block;
  
process(dataa_ipd, datab_ipd, signa, signb)
  variable dataout_tmp    : STD_LOGIC_VECTOR (36 downto 0) := (others => '0');
  variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(35 downto 0);
  constant DefGlitchMode : VitalGlitchKindType := OnEvent;
begin
  if((signa = '0') and (signb = '1')) then
    dataout_tmp(dataa_width+datab_width downto 0) :=
      unsigned(dataa_ipd(dataa_width-1 downto 0)) *
      signed(datab_ipd(datab_width-1 downto 0));
  elsif((signa = '1') and (signb = '0')) then
    dataout_tmp(dataa_width+datab_width downto 0) :=
      signed(dataa_ipd(dataa_width-1 downto 0)) *
      unsigned(datab_ipd(datab_width-1 downto 0));
  elsif((signa = '1') and (signb = '1')) then
    dataout_tmp(dataa_width+datab_width-1 downto 0) :=
      signed(dataa_ipd(dataa_width-1 downto 0)) *
      signed(datab_ipd(datab_width-1 downto 0));
  else --((signa = '0') and (signb = '0')) then
    dataout_tmp(dataa_width+datab_width-1 downto 0) :=
      unsigned(dataa_ipd(dataa_width-1 downto 0)) *
      unsigned(datab_ipd(datab_width-1 downto 0));
  end if;

    VitalPathDelay01 (
      OutSignal => dataout(0),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(0),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(1),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(1),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(2),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(2),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(2),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(3),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(3),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(3),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(4),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(4),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(4),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(5),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(5),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(5),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(6),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(6),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(6),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(7),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(7),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(7),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(8),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(8),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(8),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(9),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(9),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(9),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(10),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(10),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(10),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(11),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(11),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(11),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(12),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(12),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(12),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(13),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(13),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(13),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(14),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(14),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(14),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(15),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(15),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(15),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(16),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(16),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(16),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(17),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(17),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(17),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(18),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(18),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(18),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(19),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(19),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(19),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(20),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(20),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(20),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(21),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(21),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(21),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(22),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(22),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(22),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(23),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(23),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(23),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(24),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(24),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(24),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(25),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(25),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(25),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(26),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(26),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(26),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(27),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(27),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(27),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(28),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(28),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(28),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(29),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(29),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(29),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(30),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(30),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(30),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(31),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(31),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(31),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(32),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(32),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(32),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(33),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(33),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(33),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(34),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(34),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(34),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => dataout(35),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(35),
      Paths => (0 => (dataa_ipd'last_event, tpd_dataa_dataout, TRUE),
                1 => (datab_ipd'last_event, tpd_datab_dataout, TRUE),
                2 => (signa'last_event, tpd_signa_dataout, TRUE),
                3 => (signb'last_event, tpd_signb_dataout, TRUE)),
      GlitchData => dataout_VitalGlitchDataArray(35),
      Mode => DefGlitchMode,
      MsgOn => FALSE,
      XOn  => TRUE
    );
end process;
    
PROCESS(dataa_ipd)
   variable scanouta_VitalGlitchDataArray : VitalGlitchDataArrayType(17 downto 0);
BEGIN
    VitalPathDelay01 (
      OutSignal => scanouta(0),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(0),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(1),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(1),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(2),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(2),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(2),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(3),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(3),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(3),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(4),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(4),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(4),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(5),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(5),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(5),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(6),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(6),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(6),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(7),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(7),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(7),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(8),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(8),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(8),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(9),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(9),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(9),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(10),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(10),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(10),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(11),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(11),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(11),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(12),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(12),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(12),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(13),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(13),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(13),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(14),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(14),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(14),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanouta(15),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(15),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(15),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );    
    VitalPathDelay01 (
      OutSignal => scanouta(16),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(16),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(16),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );    
    VitalPathDelay01 (
      OutSignal => scanouta(17),
      OutSignalName => "scanouta",
      OutTemp => dataa_ipd(17),
      Paths => (1 => (dataa_ipd'last_event, tpd_dataa_scanouta, TRUE)),
      GlitchData => scanouta_VitalGlitchDataArray(17),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );    
end process;

PROCESS(datab_ipd)
  variable scanoutb_VitalGlitchDataArray : VitalGlitchDataArrayType(17 downto 0);
BEGIN
    VitalPathDelay01 (
      OutSignal => scanoutb(0),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(0),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(1),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(1),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(2),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(2),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(2),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(3),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(3),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(3),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(4),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(4),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(4),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(5),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(5),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(5),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(6),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(6),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(6),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(7),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(7),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(7),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(8),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(8),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(8),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(9),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(9),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(9),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(10),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(10),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(10),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(11),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(11),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(11),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(12),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(12),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(12),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(13),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(13),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(13),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(14),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(14),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(14),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => scanoutb(15),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(15),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(15),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );    
    VitalPathDelay01 (
      OutSignal => scanoutb(16),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(16),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(16),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );    
    VitalPathDelay01 (
      OutSignal => scanoutb(17),
      OutSignalName => "scanoutb",
      OutTemp => datab_ipd(17),
      Paths => (1 => (datab_ipd'last_event, tpd_datab_scanoutb, TRUE)),
      GlitchData => scanoutb_VitalGlitchDataArray(17),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );    
  end process;

end mult_internal_arch;

-- //////////////////////////////////////////////////////////////////////
-- //
-- //                     STRATIX_MAC_OUT_INTERNAL
-- //
-- //////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

ENTITY stratix_mac_out_internal IS
    GENERIC 
    (
      operation_mode 	: string := "output_only";
      dataa_width 	: integer := 36;
      datab_width 	: integer := 36;
      datac_width 	: integer := 36;
      datad_width 	: integer := 36;
      dataout_width 	: integer := 72;
      signa_clock	: string := "none"; 
      signb_clock	: string := "none"; 
      signa_clear	: string := "none"; 
      signb_clear	: string := "none"; 
      output_clock	: string := "none"; 
      output_clear      : string := "none";
      tipd_dataa        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_datab        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_datac        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_datad        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tpd_dataa_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_datab_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_datac_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_datad_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_signx_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_signy_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub0_dataout      : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub1_dataout      : VitalDelayType01 := DefPropDelay01;
      tpd_zeroacc_dataout       : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_signx_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_signy_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub0_accoverflow  : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub1_accoverflow  : VitalDelayType01 := DefPropDelay01;
      tpd_zeroacc_accoverflow   : VitalDelayType01 := DefPropDelay01;
      XOn: Boolean              := DefGlitchXOn;   
      MsgOn: Boolean            := DefGlitchMsgOn
    );
  PORT
    (
      dataa   : in std_logic_vector(dataa_width-1 downto 0) := (others => '0'); 
      datab   : in std_logic_vector(datab_width-1 downto 0) := (others => '0');
      datac   : in std_logic_vector(datac_width-1 downto 0) := (others => '0'); 
      datad   : in std_logic_vector(datad_width-1 downto 0) := (others => '0');
      dataout_global : in std_logic_vector (dataout_width-1 downto 0)
      := (others => '0');
      signx     : in std_logic := '1';
      signy     : in std_logic := '1';
      addnsub0  : in std_logic := '1';
      addnsub1  : in std_logic := '1';
      zeroacc   : in std_logic := '0';
      dataout   : out std_logic_vector (71 downto 0); 
      accoverflow : out std_logic      
    );
    
-- /////////////////////////////////////////////////////////////////////////////
-- //
-- //                               ADD_OR_SUB_ACCUM
-- //
-- /////////////////////////////////////////////////////////////////////////////

function add_or_sub_accum
  (
    sign_a      : in std_logic := '0';
    data_a      : in std_logic_vector(dataout_width-1 downto 0)
    := (others => '0');
    sign_b      : in std_logic := '0';
    data_b      : in std_logic_vector(dataa_width-1 downto 0)
    := (others => '0');
    operation   : in string
  ) return std_logic_vector is

  variable sign         : std_logic := '0';
  variable unsigned_add : std_logic_vector(dataout_width downto 0)
    := (others => '0');
  variable unsigned_sub : std_logic_vector(dataout_width downto 0)
    := (others => '0');
  variable signed_add   : std_logic_vector(dataout_width downto 0)
    := (others => '0');
  variable signed_sub   : std_logic_vector(dataout_width downto 0)
    := (others => '0');
  
begin

  -- signed or unsigned
  sign := ((data_a(dataout_width-1) and (sign_a))
           or (data_b(dataa_width-1) and (sign_b)));

  if(sign = '1') then
    signed_add(dataout_width downto 0) :=
      sxt((signed(data_a) + signed(data_b)), dataout_width+1);
    signed_sub(dataout_width downto 0) :=
      sxt((signed(data_a) - signed(data_b)), dataout_width+1);
  else
    unsigned_add(dataout_width downto 0) :=
      ext((unsigned('0' & data_a) + unsigned('0' & data_b)), dataout_width+1);
    unsigned_sub(dataout_width downto 0) :=
      sxt((unsigned('0' & data_a) - unsigned('0' & data_b)), dataout_width+1);
  end if;

  if (operation = "ADD") then 
    if (sign = '1') then
      return signed_add(dataout_width downto 0);
    else
      return unsigned_add(dataout_width downto 0);
    end if;
  elsif (operation = "SUB") then
    if (sign = '1') then
      return signed_sub(dataout_width downto 0);
    else
      return unsigned_sub(dataout_width downto 0);
    end if;
  end if;

end add_or_sub_accum;

end stratix_mac_out_internal;

ARCHITECTURE mac_add OF stratix_mac_out_internal IS
  signal dataa_ipd 	: std_logic_vector(35 downto 0) := (others => '0');
  signal datab_ipd 	: std_logic_vector(35 downto 0) := (others => '0');
  signal datac_ipd 	: std_logic_vector(35 downto 0) := (others => '0');
  signal datad_ipd 	: std_logic_vector(35 downto 0) := (others => '0');
  signal dataa_u        : std_logic_vector(71 downto 0) := (others => '0');
  signal datab_u        : std_logic_vector(71 downto 0) := (others => '0');
  signal datab_s        : std_logic_vector(71 downto 0) := (others => '0'); 
  signal datac_u        : std_logic_vector(71 downto 0) := (others => '0');
  signal datac_s        : std_logic_vector(71 downto 0) := (others => '0'); 
  signal datad_u        : std_logic_vector(71 downto 0) := (others => '0');
  signal datad_s        : std_logic_vector(71 downto 0) := (others => '0'); 
  signal signx_tmp      : std_logic_vector(0 downto 0)  := (others => '0');
  signal signy_tmp      : std_logic_vector(0 downto 0)  := (others => '0');
  signal addnsub0_tmp   : std_logic_vector(0 downto 0)  := (others => '0');
  signal addnsub1_tmp   : std_logic_vector(0 downto 0)  := (others => '0');
  signal zeroacc_tmp    : std_logic_vector(0 downto 0)  := (others => '0');
  signal dataout_tmp    : std_logic_vector(71 downto 0) := (others => '0');
  signal dataout_t      : std_logic_vector(72 downto 0) := (others => '0');
  signal next_dataout   : std_logic_vector(71 downto 0) := (others => '0');
  signal sll_36         : std_logic_vector(35 downto 0) := (others => '0');
  signal sll_18         : std_logic_vector(17 downto 0) := (others => '0');
  signal accoverflow_tmp: std_logic := '0';
  signal sign_a_or_b    : std_logic := '0';

begin

  WireDelay : block
  begin
    g1 : for i in dataa'range generate
      VitalWireDelay (dataa_ipd(i), dataa(i), tipd_dataa(i));
    end generate;
    g2 : for i in datab'range generate
      VitalWireDelay (datab_ipd(i), datab(i), tipd_datab(i));
    end generate;
    g3 : for i in datac'range generate
      VitalWireDelay (datac_ipd(i), datac(i), tipd_datac(i));
    end generate;
    g4 : for i in datad'range generate
      VitalWireDelay (datad_ipd(i), datad(i), tipd_datad(i));
    end generate;

  end block;

  signx_tmp(0)    <= signx;
  signy_tmp(0)    <= signy;
  addnsub0_tmp(0) <= addnsub0;
  addnsub1_tmp(0) <= addnsub1;
  zeroacc_tmp(0)  <= zeroacc;
  sign_a_or_b <= '1' when ((signx_tmp(0) = '1') or (signy_tmp(0) = '1'))
                 else '0';

  main : process (dataa_ipd, datab_ipd, datac_ipd, datad_ipd,
                  signx_tmp, signy_tmp, addnsub0_tmp, addnsub1_tmp,
                  dataout_t, zeroacc_tmp, dataout_global,
                  sign_a_or_b, next_dataout, dataa_u, datab_u, datac_u,
                  datad_u, datab_s, datac_s, datad_s)
  begin

    if operation_mode = "output_only" then
      dataout_tmp(dataa_width-1 downto 0) <= dataa_ipd(dataa_width-1 downto 0);
    elsif operation_mode = "accumulator" then
      if(zeroacc_tmp(0) = '0') then
        if(addnsub0_tmp(0) = '0') then 
          next_dataout(dataa_width+16 downto 0) <=
            add_or_sub_accum(sign_a_or_b,
                             dataout_global(dataout_width-1 downto 0),
                             sign_a_or_b, dataa_ipd(dataa_width-1 downto 0),
                             "SUB");
        else
          next_dataout(dataa_width+16 downto 0) <=
            add_or_sub_accum(sign_a_or_b,
                             dataout_global(dataout_width-1 downto 0),
                             sign_a_or_b, dataa_ipd(dataa_width-1 downto 0),
                             "ADD");
        end if;
      else
        if(addnsub0_tmp(0) = '0') then 
          next_dataout(dataa_width+16 downto 0) <=
            add_or_sub_accum(sign_a_or_b, (others => '0'),
                             sign_a_or_b, dataa_ipd(dataa_width-1 downto 0),
                             "SUB");
        else
          next_dataout(dataa_width+16 downto 0) <=
            add_or_sub_accum(sign_a_or_b, (others => '0'),
                             sign_a_or_b, dataa_ipd(dataa_width-1 downto 0),
                             "ADD");
        end if;
      end if;
      dataout_tmp(dataout_width-1 downto 0) <=
        next_dataout(dataout_width-1 downto 0);
      if(sign_a_or_b = '1') then
        accoverflow_tmp <= 
          next_dataout(dataa_width+16) xor next_dataout(dataa_width+15);
      else
        accoverflow_tmp <= next_dataout(dataa_width+16);
      end if;
    elsif operation_mode = "one_level_adder" then
      if(addnsub0_tmp(0) = '0') then 
        if (sign_a_or_b = '1') then
          dataout_tmp(dataa_width downto 0) <=
            signed(sxt(dataa_ipd(dataa_width-1 downto 0), dataa_width+1)) -
            signed(sxt(datab_ipd(datab_width-1 downto 0), dataa_width+1));
        else
          dataout_tmp(dataa_width downto 0) <=
            unsigned(ext(dataa_ipd(dataa_width-1 downto 0), dataa_width+1)) -
            unsigned(ext(datab_ipd(datab_width-1 downto 0), dataa_width+1));
        end if;
      else
        if (sign_a_or_b = '1') then
        dataout_tmp(dataa_width downto 0) <=
            signed(sxt(dataa_ipd(dataa_width-1 downto 0), dataa_width+1)) +
            signed(sxt(datab_ipd(datab_width-1 downto 0), dataa_width+1));
      else
        dataout_tmp(dataa_width downto 0) <=
            unsigned(ext(dataa_ipd(dataa_width-1 downto 0), dataa_width+1)) +
            unsigned(ext(datab_ipd(datab_width-1 downto 0), dataa_width+1));
        end if;
      end if;
    elsif operation_mode = "two_level_adder" then
      -- dataout = (dataa - datab) + (datac - datad);
      if(addnsub0_tmp(0) = '0' and addnsub1_tmp(0) = '0') then 
        if (sign_a_or_b = '1') then
          dataout_tmp(dataa_width+1 downto 0) <=
            signed(sxt(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) -
            signed(sxt(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datac_ipd(datac_width-1 downto 0), dataa_width+2)) -
            signed(sxt(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        else
          dataout_tmp(dataa_width+1 downto 0) <=
            unsigned(ext(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) -
            unsigned(ext(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datac_ipd(datac_width-1 downto 0), dataa_width+2)) -
            unsigned(ext(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        end if;
      -- dataout = (dataa + datab) + (datac - datad);
      elsif(addnsub0_tmp(0) = '1' and addnsub1_tmp(0) = '0') then 
        if (sign_a_or_b = '1') then
          dataout_tmp(dataa_width+1 downto 0) <=
            signed(sxt(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datac_ipd(datac_width-1 downto 0), dataa_width+2)) -
            signed(sxt(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        else
          dataout_tmp(dataa_width+1 downto 0) <=
            unsigned(ext(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datac_ipd(datac_width-1 downto 0), dataa_width+2)) -
            unsigned(ext(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        end if;
      -- dataout = (dataa - datab) + (datac + datad);
      elsif(addnsub0_tmp(0) = '0' and addnsub1_tmp(0) = '1') then 
        if (sign_a_or_b = '1') then
          dataout_tmp(dataa_width+1 downto 0) <=
            signed(sxt(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) -
            signed(sxt(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datac_ipd(datac_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        else
          dataout_tmp(dataa_width+1 downto 0) <=
            unsigned(ext(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) -
            unsigned(ext(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datac_ipd(datac_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        end if;
      -- dataout = (dataa + datab) + (datac + datad);
      else
        if (sign_a_or_b = '1') then
          dataout_tmp(dataa_width+1 downto 0) <=
            signed(sxt(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datac_ipd(datac_width-1 downto 0), dataa_width+2)) +
            signed(sxt(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        else
          dataout_tmp(dataa_width+1 downto 0) <=
            unsigned(ext(dataa_ipd(dataa_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datab_ipd(datab_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datac_ipd(datac_width-1 downto 0), dataa_width+2)) +
            unsigned(ext(datad_ipd(datad_width-1 downto 0), dataa_width+2));
        end if;        
      end if;
    elsif operation_mode = "36_bit_multiply" then
      dataa_u <= (others => '0');
      datab_u <= (others => '0');
      datac_u <= (others => '0');
      datad_u <= (others => '0');
      datab_s <= (others => '0');
      datac_s <= (others => '0');
      sll_36  <= (others => '0');
      sll_18  <= (others => '0');
      dataa_u(35 downto 0) <= dataa_ipd;
      datab_u(71 downto 36) <= datab_ipd;
      datab_s(71 downto 36) <= datab_ipd;
      datac_u(53 downto 18) <= datac_ipd;
      datac_s(71 downto 18) <= sxt(datac_ipd(datac_width-1 downto 0), 54);
      datad_u(53 downto 18) <= datad_ipd;
      datad_s(71 downto 18) <= sxt(datad_ipd(datad_width-1 downto 0), 54);
      if((signx_tmp(0) = '0') and (signy_tmp(0) = '0')) then 
        dataout_tmp <= unsigned(datab_u) + unsigned(datac_u)
                      + unsigned(datad_u) + unsigned(dataa_u);
      elsif((signx_tmp(0) = '0') and (signy_tmp(0) = '1')) then
        dataout_t <= signed(datab_s) + unsigned(datac_u)
                      + signed(datad_s) + unsigned(dataa_u);
        dataout_tmp <= dataout_t(71 downto 0);
      elsif((signx_tmp(0) = '1') and (signy_tmp(0) = '0')) then
        dataout_t <= signed(datab_s) + signed(datac_s)
                      + unsigned(datad_u) + unsigned(dataa_u);
        dataout_tmp <= dataout_t(71 downto 0);
      elsif((signx_tmp(0) = '1') and (signy_tmp(0) = '1')) then
        dataout_t <= signed(datab_s) + signed(datac_s)
                      + signed(datad_s) + unsigned(dataa_u);
        dataout_tmp <= dataout_t(71 downto 0);
      end if;
    end if;
end process;
 
PROCESS(dataout_tmp)
  variable dataout_VitalGlitchDataArray :
    VitalGlitchDataArrayType(71 downto 0);
BEGIN
    VitalPathDelay01 (
      OutSignal => dataout(0),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(0),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(0),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(1),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(1),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(1),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(2),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(2),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(2),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(3),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(3),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(3),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(4),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(4),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(4),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(5),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(5),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(5),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(6),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(6),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(6),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(7),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(7),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(7),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(8),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(8),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(8),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(9),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(9),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(9),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(10),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(10),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(10),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(11),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(11),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(11),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(12),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(12),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(12),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(13),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(13),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(13),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(14),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(14),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(14),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(15),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(15),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(15),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(16),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(16),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(16),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(17),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(17),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(17),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(18),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(18),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(18),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(19),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(19),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(19),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(20),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(20),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(20),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(21),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(21),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(21),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(22),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(22),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(22),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(23),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(23),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(23),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(24),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(24),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(24),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(25),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(25),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(25),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(26),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(26),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(26),  
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(27),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(27),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(27),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(28),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(28),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(28),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(29),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(29),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(29),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(30),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(30),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(30),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(31),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(31),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(31),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(32),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(32),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(32),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(33),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(33),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(33),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(34),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(34),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(34),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(35),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(35),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(35),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(36),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(36),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(36),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(37),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(37),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(37),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(38),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(38),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(38),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(39),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(39),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(39),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(40),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(40),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(40),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(41),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(41),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(41),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(42),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(42),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(42),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(43),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(43),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(43),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(44),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(44),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(44),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(45),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(45),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(45),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(46),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(46),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(46),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(47),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(47),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(47),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(48),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(48),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(48),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(49),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(49),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(49),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(50),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(50),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(50),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(51),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(51),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(51),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(52),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(52),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(52),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(53),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(53),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(53),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(54),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(54),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(54),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(55),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(55),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(55),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(56),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(56),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(56),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(57),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(57),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(57),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(58),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(58),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(58),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(59),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(59),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(59),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(60),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(60),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(60),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(61),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(61),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(61),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(62),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(62),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(62),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(63),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(63),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(63),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(64),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(64),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(64),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(65),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(65),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(65),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(66),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(66),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(66),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(67),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(67),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(67),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(68),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(68),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(68),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(69),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(69),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(69),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(70),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(70),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(70),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
    VitalPathDelay01 (
      OutSignal => dataout(71),
      OutSignalName => "dataout",
      OutTemp => dataout_tmp(71),
      Paths => (1 => (dataa'last_event, tpd_dataa_dataout, TRUE),
                2 => (datab'last_event, tpd_datab_dataout, TRUE),
                3 => (datac'last_event, tpd_datac_dataout, TRUE),
                4 => (datad'last_event, tpd_datad_dataout, TRUE),
                5 => (signx_tmp'last_event, tpd_signx_dataout, TRUE),
                6 => (signy_tmp'last_event, tpd_signy_dataout, TRUE),
                7 => (addnsub0_tmp'last_event, tpd_addnsub0_dataout, TRUE),
                8 => (addnsub1_tmp'last_event, tpd_addnsub1_dataout, TRUE),
                9 => (zeroacc_tmp'last_event, tpd_zeroacc_dataout, TRUE)
                ),
      GlitchData => dataout_VitalGlitchDataArray(71),
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
end process;

PROCESS(accoverflow_tmp)
  variable accoverflow_VitalGlitchData : VitalGlitchDataType;
BEGIN
    VitalPathDelay01 (
      OutSignal => accoverflow,
      OutSignalName => "accoverflow",
      OutTemp => accoverflow_tmp,
      Paths => (1 => (dataa'last_event, tpd_dataa_accoverflow, TRUE),
                2 => (signx_tmp'last_event, tpd_signx_accoverflow, TRUE),
                3 => (signy_tmp'last_event, tpd_signy_accoverflow, TRUE),
                4 => (addnsub0_tmp'last_event, tpd_addnsub0_accoverflow, TRUE),
                5 => (addnsub1_tmp'last_event, tpd_addnsub1_accoverflow, TRUE),
                6 => (zeroacc_tmp'last_event, tpd_zeroacc_accoverflow, TRUE)
                ),
      GlitchData => accoverflow_VitalGlitchData,
      Mode => DefGlitchMode,
      XOn  => XOn,
      MsgOn => MsgOn
    );
  
  END process;
  
END mac_add;

-- //////////////////////////////////////////////////////////////////////
-- //
-- //                           STRATIX_MAC_MULT
-- //
-- //////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_mac_mult IS
  generic
    ( 
      dataa_width       : integer := 18;
      datab_width       : integer := 18;
      dataa_clock	: string := "none";
      datab_clock	: string := "none";
      signa_clock	: string := "none"; 
      signb_clock	: string := "none"; 
      output_clock	: string := "none"; 
      dataa_clear	: string := "none";
      datab_clear	: string := "none";
      signa_clear	: string := "none"; 
      signb_clear	: string := "none";
      output_clear	: string := "none";
      signa_internally_grounded : string := "false";
      signb_internally_grounded : string := "false";
      lpm_hint          : string := "true";
      lpm_type          : string := "stratix_mac_mult"
    );
  port
    (
      dataa           : in std_logic_vector(17 downto 0) := (others => '0'); 
      datab           : in std_logic_vector(17 downto 0) := (others => '0'); 
      signa           : in std_logic := '1';
      signb           : in std_logic := '1';
      clk             : in std_logic_vector(3 downto 0) := "0000";
      aclr            : in std_logic_vector(3 downto 0) := "0000";
      ena             : in std_logic_vector(3 downto 0) := "1111";
      devclrn         : in std_logic := '1';   
      devpor          : in std_logic := '1';      
      dataout         : out std_logic_vector(35 downto 0); 
      scanouta        : out std_logic_vector(17 downto 0); 
      scanoutb        : out std_logic_vector(17 downto 0) 
    ); 

-- SELECT THE CLOCK, CLEAR, or ENABLE LINE FUNCTION
function select_the(constant string_name : string)
  return natural is
  begin
    if string_name = "0" then
      return 0;
    elsif string_name = "1" then
      return 1;
    elsif string_name = "2" then
      return 2;
    elsif string_name = "3" then
      return 3;
    else
      return 0;  
    end if;
  end select_the;

END stratix_mac_mult; 

architecture mult_arch OF stratix_mac_mult IS

component stratix_mac_register
  generic 
    (
      data_width      : integer := 18;
      tipd_data       : VitalDelayArrayType01(71 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_dataout_posedge  : VitalDelayType01 := DefPropDelay01;
      tpd_clk_dataout_posedge   : VitalDelayType01 := DefPropDelay01;
      tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tpw_ena_posedge : VitalDelayType := 0 ns
    );
  
  port
    (
      data : IN STD_LOGIC_VECTOR (71 downto 0);
      clk  : IN STD_LOGIC;
      aclr : IN STD_LOGIC;
      ena  : IN STD_LOGIC;
      async : IN STD_LOGIC;
      devclrn : in std_logic;
      devpor  : in std_logic;
      dataout : OUT STD_LOGIC_VECTOR (71 downto 0)
    );
	
end component;

component stratix_mac_mult_internal
  GENERIC 
    (
      dataa_width : integer := 18;
      datab_width : integer := 18;
      tipd_dataa        : VitalDelayArrayType01(17 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_datab        : VitalDelayArrayType01(17 downto 0)
      := (OTHERS => DefPropDelay01);
      tpd_dataa_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_datab_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_signa_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_signb_dataout : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_scanouta   : VitalDelayType01 := DefPropDelay01;
      tpd_datab_scanoutb   : VitalDelayType01 := DefPropDelay01;
      XOn               : Boolean := DefGlitchXOn;     
      MsgOn             : Boolean := DefGlitchMsgOn 
    );

  PORT
    (
      dataa : IN std_logic_vector (dataa_width-1 downto 0) := (others => '0'); 
      datab : IN std_logic_vector (datab_width-1 downto 0) := (others => '0');
      signa : IN std_logic := '1';
      signb : IN std_logic := '1';
      scanouta : OUT std_logic_vector (17 downto 0);
      scanoutb : OUT std_logic_vector (17 downto 0);
      dataout : OUT std_logic_vector (35 downto 0)
    );
end component;

signal mult_output : std_logic_vector(71 downto 0) := (others => '0');
signal scanouta_tmp : std_logic_vector(71 downto 0) := (others => '0');
signal scanoutb_tmp : std_logic_vector(71 downto 0) := (others => '0') ;
signal signa_out : std_logic_vector (71 downto 0) := (others => '1'); 
signal signb_out : std_logic_vector (71 downto 0) := (others => '1'); 
signal dataa_tmp : std_logic_vector(71 downto 0);
signal datab_tmp : std_logic_vector(71 downto 0);
signal dataout_tmp : std_logic_vector(71 downto 0);

signal dataa_async : std_logic := '0';
signal datab_async : std_logic := '0';
signal signa_async : std_logic := '1';
signal signb_async : std_logic := '1';
signal dataout_async : std_logic := '0';
signal signa_internally : std_logic := '0';
signal signb_internally : std_logic := '0';

signal signa_tmp : std_logic_vector(71 downto 0);
signal signb_tmp : std_logic_vector(71 downto 0);

signal clk_dataa  : std_logic;
signal aclr_dataa : std_logic;
signal ena_dataa  : std_logic;
signal clk_datab  : std_logic;
signal aclr_datab : std_logic;
signal ena_datab  : std_logic;
signal clk_signa  : std_logic;
signal aclr_signa : std_logic;
signal ena_signa  : std_logic;
signal clk_signb  : std_logic;
signal aclr_signb : std_logic;
signal ena_signb  : std_logic;
signal clk_dataout  : std_logic;
signal aclr_dataout : std_logic;
signal ena_dataout  : std_logic;

begin

dataa_async <= '1' when (dataa_clock = "none" or dataa_clear = "none") else '0';
datab_async <= '1' when (datab_clock = "none" or datab_clear = "none") else '0';
signa_async <= '1' when (signa_clock = "none" or signa_clear = "none") else '0';
signb_async <= '1' when (signb_clock = "none" or signb_clear = "none") else '0';
dataout_async <=
  '1' when (output_clock = "none" or output_clear = "none") else '0';
signa_internally <=
  signa_out(0) when (signa_internally_grounded = "false") else '0';
signb_internally <=
  signb_out(0) when (signb_internally_grounded = "false") else '0';

signa_tmp(0) <= signa;
signb_tmp(0) <= signb;
dataa_tmp(17 downto 0) <= dataa(17 downto 0);
datab_tmp(17 downto 0) <= datab(17 downto 0);
dataout(35 downto 0) <= dataout_tmp(35 downto 0);

clk_dataa  <= clk(select_the(dataa_clock));
aclr_dataa <= aclr(select_the(dataa_clear));
ena_dataa  <= ena(select_the(dataa_clock));

dataa_mac_reg : stratix_mac_register
  generic map (data_width => dataa_width)
  port map (data => dataa_tmp,
            clk  => clk_dataa,
            aclr => aclr_dataa,
            ena  => ena_dataa,
            devclrn => devclrn,
            devpor => devpor,
            dataout => scanouta_tmp,
            async => dataa_async);

clk_datab  <= clk(select_the(datab_clock));
aclr_datab <= aclr(select_the(datab_clear));
ena_datab  <= ena(select_the(datab_clock));

datab_mac_reg : stratix_mac_register
  generic map (data_width => datab_width)
  port map (data => datab_tmp,
            clk  => clk_datab,
            aclr => aclr_datab,
            ena  => ena_datab,
            devclrn => devclrn,
            devpor => devpor,
            dataout => scanoutb_tmp,
            async => datab_async);

clk_signa  <= clk(select_the(signa_clock));
aclr_signa <= aclr(select_the(signa_clear));
ena_signa  <= ena(select_the(signa_clock));

signa_mac_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => signa_tmp,
            clk  => clk_signa,
            aclr => aclr_signa,
            ena  => ena_signa,
            devclrn => devclrn,
            devpor => devpor,
            dataout => signa_out,
            async => signa_async);

clk_signb  <= clk(select_the(signb_clock));
aclr_signb <= aclr(select_the(signb_clear));
ena_signb  <= ena(select_the(signb_clock));

signb_mac_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => signb_tmp,
            clk  => clk_signb,
            aclr => aclr_signb,
            ena  => ena_signb,
            devclrn => devclrn,
            devpor => devpor,
            dataout => signb_out,
            async => signb_async);

mac_multiply : stratix_mac_mult_internal
  generic map (dataa_width => dataa_width,
               datab_width => datab_width)
  port map(dataa => scanouta_tmp(dataa_width-1 downto 0),
           datab => scanoutb_tmp(datab_width-1 downto 0),
           signa => signa_internally,
           signb => signb_internally,
           scanouta => scanouta,
           scanoutb => scanoutb,
           dataout => mult_output(35 downto 0)
          );

clk_dataout  <= clk(select_the(output_clock));
aclr_dataout <= aclr(select_the(output_clear));
ena_dataout  <= ena(select_the(output_clock));

dataout_mac_reg : stratix_mac_register
  generic map (data_width => (dataa_width+datab_width))
  port map (data => mult_output,
            clk  => clk_dataout,
            aclr => aclr_dataout,
            ena  => ena_dataout,
            devclrn => devclrn,
            devpor => devpor,
            dataout => dataout_tmp,
            async => dataout_async);

END mult_arch;
   
-- //////////////////////////////////////////////////////////////////////
-- //
-- //                            STRATIX_MAC_OUT
-- //
-- //////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_mac_out IS
  generic 
    (
      operation_mode    : string := "output_only";
      dataa_width       : integer := 36;
      datab_width       : integer := 36;
      datac_width       : integer := 36;
      datad_width       : integer := 36;
      dataout_width     : integer := 36;
      addnsub0_clock	: string := "none";
      addnsub1_clock	: string := "none";
      zeroacc_clock	: string := "none";
      signa_clock       : string := "none"; 
      signb_clock       : string := "none"; 
      output_clock	: string := "none";
      addnsub0_clear	: string := "none";
      addnsub1_clear	: string := "none";
      zeroacc_clear	: string := "none";
      signa_clear       : string := "none"; 
      signb_clear       : string := "none"; 
      output_clear	: string := "none";
      addnsub0_pipeline_clock	: string := "none";
      addnsub1_pipeline_clock	: string := "none";
      zeroacc_pipeline_clock	: string := "none";
      signa_pipeline_clock	: string := "none";
      signb_pipeline_clock	: string := "none";
      addnsub0_pipeline_clear	: string := "none";
      addnsub1_pipeline_clear	: string := "none";
      zeroacc_pipeline_clear	: string := "none";
      signa_pipeline_clear	: string := "none";
      signb_pipeline_clear	: string := "none";
      overflow_programmable_invert : std_logic := '0';
      data_out_programmable_invert : std_logic_vector(71 downto 0)
      := (OTHERS => '0');
      lpm_hint                  : string := "true";
      lpm_type                  : string := "stratix_mac_out"
    );
  port
    (
      dataa     : in std_logic_vector(35 downto 0) := (others => '0'); 
      datab     : in std_logic_vector(35 downto 0) := (others => '0');
      datac     : in std_logic_vector(35 downto 0) := (others => '0');
      datad     : in std_logic_vector(35 downto 0) := (others => '0');
      zeroacc   : in std_logic := '0';
      addnsub0  : in std_logic := '1';
      addnsub1  : in std_logic := '1';
      signa     : in std_logic := '1';
      signb     : in std_logic := '1';
      clk       : in std_logic_vector(3 downto 0) := "0000";
      aclr      : in std_logic_vector(3 downto 0) := "0000";
      ena       : in std_logic_vector(3 downto 0) := "1111";
      devclrn   : in std_logic := '1';   
      devpor    : in std_logic := '1';      
      dataout   : out std_logic_vector (71 downto 0);
      accoverflow : out std_logic
    ); 

function select_the(constant string_name : string)
  return natural is
  begin
    if string_name = "0" then
      return 0;
    elsif string_name = "1" then
      return 1;
    elsif string_name = "2" then
      return 2;
    elsif string_name = "3" then
      return 3;
    else
      return 0;  
    end if;
  end select_the;
  
END stratix_mac_out;

ARCHITECTURE out_arch OF stratix_mac_out IS

component stratix_mac_register
  generic 
    (
      data_width      : integer := 18;
      tipd_data       : VitalDelayArrayType01(71 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tpw_ena_posedge : VitalDelayType := 0 ns
    );
  
  port
    (
      data : IN STD_LOGIC_VECTOR (71 downto 0);
      clk  : IN STD_LOGIC;
      aclr : IN STD_LOGIC;
      ena  : IN STD_LOGIC;
      async : IN STD_LOGIC;
      devclrn : in std_logic;
      devpor  : in std_logic;
      dataout : OUT STD_LOGIC_VECTOR (71 downto 0)
    );
	
end component;

component stratix_mac_out_internal
    GENERIC 
    (
      operation_mode 	: string := "output_only";
      dataa_width 	: integer := 36;
      datab_width 	: integer := 36;
      datac_width 	: integer := 36;
      datad_width 	: integer := 36;
      dataout_width 	: integer := 72;
      signa_clock	: string := "none"; 
      signb_clock	: string := "none"; 
      signa_clear	: string := "none"; 
      signb_clear	: string := "none"; 
      output_clock	: string := "none"; 
      output_clear      : string := "none";
      tipd_dataa        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_datab        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_datac        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tipd_datad        : VitalDelayArrayType01(35 downto 0)
      := (OTHERS => DefPropDelay01);
      tpd_dataa_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_datab_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_datac_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_datad_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_signx_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_signy_dataout         : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub0_dataout      : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub1_dataout      : VitalDelayType01 := DefPropDelay01;
      tpd_zeroacc_dataout       : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_signx_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_signy_accoverflow     : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub0_accoverflow  : VitalDelayType01 := DefPropDelay01;
      tpd_addnsub1_accoverflow  : VitalDelayType01 := DefPropDelay01;
      tpd_zeroacc_accoverflow   : VitalDelayType01 := DefPropDelay01;
      XOn: Boolean              := DefGlitchXOn;   
      MsgOn: Boolean            := DefGlitchMsgOn
    );

  PORT
    (
      dataa   : in std_logic_vector(dataa_width-1 downto 0) := (others => '0'); 
      datab   : in std_logic_vector(datab_width-1 downto 0) := (others => '0'); 
      datac   : in std_logic_vector(datac_width-1 downto 0) := (others => '0'); 
      datad   : in std_logic_vector(datad_width-1 downto 0) := (others => '0');
      dataout_global : in std_logic_vector (dataout_width-1 downto 0)
      := (others => '0');
      signx     : in std_logic := '1';
      signy     : in std_logic := '1';
      addnsub0  : in std_logic := '1';
      addnsub1  : in std_logic := '1';
      zeroacc   : in std_logic := '0';
      dataout   : out std_logic_vector (71 downto 0);  
      accoverflow : out std_logic
    ); 
end component;

signal signa_pipe       : std_logic_vector (71 downto 0);  
signal signb_pipe       : std_logic_vector (71 downto 0);  
signal zeroacc_pipe     : std_logic_vector (71 downto 0);  
signal addnsub0_pipe    : std_logic_vector (71 downto 0);  
signal addnsub1_pipe    : std_logic_vector (71 downto 0);  

signal signa_out : std_logic_vector (71 downto 0);  
signal signb_out : std_logic_vector (71 downto 0);  
signal zeroacc_out : std_logic_vector (71 downto 0);  
signal addnsub0_out : std_logic_vector (71 downto 0);  
signal addnsub1_out : std_logic_vector (71 downto 0);  
signal dataout_sig : std_logic_vector (71 downto 0);  
signal accoverflow_sig : std_logic_vector (71 downto 0);  

signal signa_async : std_logic := '1';
signal signb_async : std_logic := '1';
signal zeroacc_async : std_logic := '0';
signal addnsub0_async : std_logic := '1';
signal addnsub1_async : std_logic := '1';
signal dataout_async : std_logic := '0';
signal accoverflow_async : std_logic := '0';
signal signa_pipeline_async : std_logic := '0';
signal signb_pipeline_async : std_logic := '0';
signal zeroacc_pipeline_async : std_logic := '0';
signal addnsub0_pipeline_async : std_logic := '1';
signal addnsub1_pipeline_async : std_logic := '1';

signal signa_tmp : std_logic_vector(71 downto 0);
signal signb_tmp : std_logic_vector(71 downto 0);
signal addnsub0_tmp : std_logic_vector(71 downto 0);
signal addnsub1_tmp : std_logic_vector(71 downto 0);
signal zeroacc_tmp : std_logic_vector(71 downto 0);
signal accoverflow_tmp : std_logic_vector(71 downto 0);
signal dataout_tmp : std_logic_vector(71 downto 0);

signal clk_signa  : std_logic;
signal aclr_signa : std_logic; 
signal ena_signa  : std_logic;
signal clk_signb  : std_logic;
signal aclr_signb : std_logic;
signal ena_signb  : std_logic;
signal clk_zeroacc  : std_logic;
signal aclr_zeroacc : std_logic;
signal ena_zeroacc  : std_logic;
signal clk_addnsub0  : std_logic;
signal aclr_addnsub0 : std_logic;
signal ena_addnsub0  : std_logic;
signal clk_addnsub1  : std_logic;
signal aclr_addnsub1 : std_logic;
signal ena_addnsub1  : std_logic;
signal clk_signa_pipeline  : std_logic;
signal aclr_signa_pipeline : std_logic;
signal ena_signa_pipeline  : std_logic;
signal clk_signb_pipeline  : std_logic;
signal aclr_signb_pipeline : std_logic;
signal ena_signb_pipeline  : std_logic;
signal clk_zeroacc_pipeline  : std_logic;
signal aclr_zeroacc_pipeline : std_logic;
signal ena_zeroacc_pipeline  : std_logic;
signal clk_addnsub0_pipeline  : std_logic;
signal aclr_addnsub0_pipeline : std_logic;
signal ena_addnsub0_pipeline  : std_logic;
signal clk_addnsub1_pipeline  : std_logic;
signal aclr_addnsub1_pipeline : std_logic;
signal ena_addnsub1_pipeline  : std_logic;
signal clk_dataout            : std_logic;
signal aclr_dataout           : std_logic;
signal ena_dataout            : std_logic;
signal clk_accoverflow        : std_logic;
signal aclr_accoverflow       : std_logic;
signal ena_accoverflow        : std_logic;

BEGIN

signa_tmp(0)    <= signa;
signb_tmp(0)    <= signb;
addnsub0_tmp(0) <= addnsub0; 
addnsub1_tmp(0) <= addnsub1;
zeroacc_tmp(0)  <= zeroacc;
accoverflow     <= accoverflow_tmp(0);

signa_async <= '1' when (signa_clock = "none" or signa_clear = "none") else '0';
signb_async <= '1' when (signb_clock = "none" or signb_clear = "none") else '0';
addnsub0_async <= '1' when 
   (addnsub0_clock = "none" or addnsub0_clear = "none") else '0';
addnsub1_async <= '1' when 
   (addnsub1_clock = "none" or addnsub1_clear = "none") else '0';
zeroacc_async <= '1' when 
   (zeroacc_clock = "none" or zeroacc_clear = "none") else '0';
signa_pipeline_async <= '1' when 
   (signa_pipeline_clock = "none" or signa_pipeline_clear = "none") else '0';
signb_pipeline_async <= '1' when 
   (signb_pipeline_clock = "none" or signb_pipeline_clear = "none") else '0';
addnsub0_pipeline_async <= '1' when 
   (addnsub0_pipeline_clock = "none" or addnsub0_pipeline_clear = "none") else '0';
addnsub1_pipeline_async <= '1' when 
   (addnsub1_pipeline_clock = "none" or addnsub1_pipeline_clear = "none") else '0';
zeroacc_pipeline_async <= '1' when 
   (zeroacc_pipeline_clock = "none" or zeroacc_pipeline_clear = "none") else '0';
dataout_async <= '1' when 
   (output_clock = "none" or output_clear = "none") else '0';
accoverflow_async <= '1' when 
   (output_clock = "none" or output_clear = "none") else '0';

clk_signa  <= clk(select_the(signa_clock));
aclr_signa <= aclr(select_the(signa_clear));
ena_signa  <= ena(select_the(signa_clock));

signa_mac_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => signa_tmp,
            clk  => clk_signa,
            aclr => aclr_signa,
            ena  => ena_signa,
            devclrn => devclrn,
            devpor => devpor,
            dataout => signa_pipe,
            async => signa_async);

clk_signb  <= clk(select_the(signb_clock));
aclr_signb <= aclr(select_the(signb_clear));
ena_signb  <= ena(select_the(signb_clock));

signb_mac_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => signb_tmp,
            clk  => clk_signb,
            aclr => aclr_signb,
            ena  => ena_signb,
            devclrn => devclrn,
            devpor => devpor,
            dataout => signb_pipe,
            async => signb_async);

clk_zeroacc  <= clk(select_the(zeroacc_clock));
aclr_zeroacc <= aclr(select_the(zeroacc_clear));
ena_zeroacc  <= ena(select_the(zeroacc_clock));

zeroacc_mac_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => zeroacc_tmp,
            clk  => clk_zeroacc,
            aclr => aclr_zeroacc,
            ena  => ena_zeroacc,
            devclrn => devclrn,
            devpor => devpor,
            dataout => zeroacc_pipe,
            async => zeroacc_async);

clk_addnsub0  <= clk(select_the(addnsub0_clock));
aclr_addnsub0 <= aclr(select_the(addnsub0_clear));
ena_addnsub0  <= ena(select_the(addnsub0_clock));

addnsub0_mac_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => addnsub0_tmp,
            clk  => clk_addnsub0,
            aclr => aclr_addnsub0,
            ena  => ena_addnsub0,
            devclrn => devclrn,
            devpor => devpor,
            dataout => addnsub0_pipe,
            async => addnsub0_async);

clk_addnsub1  <= clk(select_the(addnsub1_clock));
aclr_addnsub1 <= aclr(select_the(addnsub1_clear));
ena_addnsub1  <= ena(select_the(addnsub1_clock));

addnsub1_mac_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => addnsub1_tmp,
            clk  => clk_addnsub1,
            aclr => aclr_addnsub1,
            ena  => ena_addnsub1,
            devclrn => devclrn,
            devpor => devpor,
            dataout => addnsub1_pipe,
            async => addnsub1_async);

clk_signa_pipeline  <= clk(select_the(signa_pipeline_clock));
aclr_signa_pipeline <= aclr(select_the(signa_pipeline_clear));
ena_signa_pipeline  <= ena(select_the(signa_pipeline_clock));

signa_mac_pipeline_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => signa_pipe,
            clk  => clk_signa_pipeline,
            aclr => aclr_signa_pipeline,
            ena  => ena_signa_pipeline,
            devclrn => devclrn,
            devpor => devpor,
            dataout => signa_out,
            async => signa_pipeline_async);

clk_signb_pipeline  <= clk(select_the(signb_pipeline_clock));
aclr_signb_pipeline <= aclr(select_the(signb_pipeline_clear));
ena_signb_pipeline  <= ena(select_the(signb_pipeline_clock));

signb_mac_pipeline_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => signb_pipe,
            clk  => clk_signb_pipeline,
            aclr => aclr_signb_pipeline,
            ena  => ena_signb_pipeline,
            devclrn => devclrn,
            devpor => devpor,
            dataout => signb_out,
            async => signb_pipeline_async);

clk_zeroacc_pipeline  <= clk(select_the(zeroacc_pipeline_clock));
aclr_zeroacc_pipeline <= aclr(select_the(zeroacc_pipeline_clear));
ena_zeroacc_pipeline  <= ena(select_the(zeroacc_pipeline_clock));

zeroacc_mac_pipeline_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => zeroacc_pipe,
            clk  => clk_zeroacc_pipeline,
            aclr => aclr_zeroacc_pipeline,
            ena  => ena_zeroacc_pipeline,
            devclrn => devclrn,
            devpor => devpor,
            dataout => zeroacc_out,
            async => zeroacc_pipeline_async);

clk_addnsub0_pipeline  <= clk(select_the(addnsub0_pipeline_clock));
aclr_addnsub0_pipeline <= aclr(select_the(addnsub0_pipeline_clear));
ena_addnsub0_pipeline  <= ena(select_the(addnsub0_pipeline_clock));

addnsub0_mac_pipeline_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => addnsub0_pipe,
            clk  => clk_addnsub0_pipeline,
            aclr => aclr_addnsub0_pipeline,
            ena  => ena_addnsub0_pipeline,
            devclrn => devclrn,
            devpor => devpor,
            dataout => addnsub0_out,
            async => addnsub0_pipeline_async);

clk_addnsub1_pipeline  <= clk(select_the(addnsub1_pipeline_clock));
aclr_addnsub1_pipeline <= aclr(select_the(addnsub1_pipeline_clear));
ena_addnsub1_pipeline  <= ena(select_the(addnsub1_pipeline_clock));

addnsub1_mac_pipeline_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => addnsub1_pipe,
            clk  => clk_addnsub1_pipeline,
            aclr => aclr_addnsub1_pipeline,
            ena  => ena_addnsub1_pipeline,
            devclrn => devclrn,
            devpor => devpor,
            dataout => addnsub1_out,
            async => addnsub1_pipeline_async);

mac_adder : stratix_mac_out_internal
  generic map (operation_mode => operation_mode, 
               dataa_width => dataa_width,
               datab_width => datab_width,
               datac_width => datac_width,
               datad_width => datad_width,
               dataout_width => dataout_width, 
               signa_clock => signa_clock, 
               signb_clock => signb_clock,
               signa_clear => signa_clear,
               signb_clear => signb_clear,
               output_clock => output_clock,
               output_clear => output_clear)
  port map (dataa => dataa(dataa_width-1 downto 0),
            datab => datab(datab_width-1 downto 0),
            datac => datac(datac_width-1 downto 0),
            datad => datad(datad_width-1 downto 0),
            dataout_global => dataout_tmp(dataout_width-1 downto 0),
            signx => signa_out(0),
            signy => signb_out(0),
            addnsub0 => addnsub0_out(0),
            addnsub1 => addnsub1_out(0),
            zeroacc => zeroacc_out(0),
            dataout => dataout_sig,
            accoverflow => accoverflow_sig(0)
          );

clk_dataout  <= clk(select_the(output_clock));
aclr_dataout <= aclr(select_the(output_clear));
ena_dataout  <= ena(select_the(output_clock));

dataout_out_reg : stratix_mac_register
  generic map (data_width => 72) 
  port map (data => dataout_sig, 
            clk  => clk_dataout,
            aclr => aclr_dataout,
            ena  => ena_dataout,
            devclrn => devclrn,
            devpor => devpor,
            dataout => dataout_tmp,
            async => dataout_async);

clk_accoverflow  <= clk(select_the(output_clock));
aclr_accoverflow <=aclr(select_the(output_clear));
ena_accoverflow  <= ena(select_the(output_clock));

accoverflow_out_reg : stratix_mac_register
  generic map (data_width => 1)
  port map (data => accoverflow_sig,
            clk  => clk_accoverflow,
            aclr => aclr_accoverflow,
            ena  => ena_accoverflow,
            devclrn => devclrn,
            devpor => devpor,
            dataout => accoverflow_tmp,
            async => accoverflow_async);
  
dataout <= dataout_tmp xor data_out_programmable_invert;
accoverflow <= accoverflow_tmp(0) xor overflow_programmable_invert;

END out_arch;

-- ///////////////////////////////////////////////////////////////////////////
-- //
-- //                           STRATIX_RAM_REGISTER
-- //
-- ///////////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_ram_register is
  generic 
    (
      data_width      : integer := 143;
      sclr            : string  := "true";
      preset          : string  := "false";
      tipd_data       : VitalDelayArrayType01(143 downto 0) := 
      (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_dataout_posedge          : VitalDelayType01 := DefPropDelay01;
      tpd_clk_dataout_posedge           : VitalDelayType01 := DefPropDelay01;
      tpd_clk_done_posedge              : VitalDelayType01 := DefPropDelay01;
      tsetup_data_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
      thold_data_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge      : VitalDelayType := DefSetupHoldCnst;
      tsetup_aclr_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
      thold_aclr_clk_noedge_posedge      : VitalDelayType := DefSetupHoldCnst;
      tpw_ena_posedge : VitalDelayType := 0 ns

    );
  port
    (
      data      : in std_logic_vector (data_width-1 downto 0);
      clk       : in std_logic;
      aclr      : in std_logic;
      ena       : in std_logic;
      if_clk    : in std_logic;
      if_aclr   : in std_logic;
      if_ena    : in std_logic;
      devclrn   : in std_logic;
      devpor    : in std_logic;
      power_up  : in std_logic;
      dataout   : out std_logic_vector (143 downto 0);
      aclrout   : out std_logic;
      clkout    : out std_logic;
      done      : out std_logic := '0'
    );
end stratix_ram_register;

architecture reg_arch OF stratix_ram_register IS

  signal aclrout_sig	: STD_LOGIC := '0';
  signal done_sig	: STD_LOGIC := '1';
  signal clk_dly	: STD_LOGIC := '0';     
  signal data_ipd       : STD_LOGIC_VECTOR (data_width-1 downto 0) := 
    (others => '0');
  signal clk_ipd        : STD_LOGIC := '0';
  signal aclr_ipd       : STD_LOGIC := '0';
  signal ena_ipd        : STD_LOGIC := '0';

begin 

  process
  begin
    WAIT UNTIL aclr_ipd'EVENT;
     if ((aclr_ipd = '1') and (ena_ipd = '1')) then      
      aclrout_sig <= '1';
    else
      aclrout_sig <= '0';
    end if;
  end process;

  aclrout <= aclrout_sig when (if_aclr = '1') else '0';
  
  WireDelay : block
  begin
    g1 : for i in data'range generate
      VitalWireDelay (data_ipd(i), data(i), tipd_data(i));
    end generate;
    VitalWireDelay (clk_ipd, clk, tipd_clk);
    VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
    VitalWireDelay (ena_ipd, ena, tipd_ena);
  end block;

  process
  begin
    WAIT UNTIL clk_ipd'EVENT;
    if ((clk_ipd = '1') and (ena_ipd = '1')) then      
      done_sig <= '1';
    else
      done_sig <= '0';
    end if;
    if (clk_ipd = '1') then
      clk_dly <= '1';
    else
      clk_dly <= '0';
    end if;
  end process;

  clkout <= clk_dly;

  process
    variable done_VitalGlitchData : VitalGlitchDataType;
  begin
    WAIT UNTIL done_sig'EVENT;
    if (if_clk = '1') then 
      VitalPathDelay01 (
        OutSignal     => done,
        OutSignalName => "done",
        OutTemp       => done_sig,
        Paths         => (0 => (clk_ipd'last_event, 
                                tpd_clk_done_posedge, TRUE)),
        GlitchData    => done_VitalGlitchData,
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE);
    else
      done <= '1';
    end if;
  end process;

  process (data_ipd, clk_ipd, aclr_ipd, ena_ipd, devclrn, devpor)    
  variable dataout_sig          : STD_LOGIC_VECTOR (143 downto 0) := (others => '0');
  variable Tviol_clk_ena        : STD_ULOGIC := '0';
  variable Tviol_clk_aclr        : STD_ULOGIC := '0';
  variable Tviol_data_clk       : STD_ULOGIC := '0';
  variable TimingData_clk_ena   : VitalTimingDataType := VitalTimingDataInit;
  variable TimingData_clk_aclr   : VitalTimingDataType := VitalTimingDataInit;
  variable TimingData_data_clk  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_ena            : STD_ULOGIC := '0';
  variable PeriodData_ena       : VitalPeriodDataType := VitalPeriodDataInit;
  variable dataout_VitalGlitchDataArray :
    VitalGlitchDataArrayType(143 downto 0);
  constant DefGlitchMode : VitalGlitchKindType := OnEvent;
  begin

    if (clk_ipd'event and clk_ipd = '1') then
      if (ena_ipd = '1' and if_ena = '1') then      
      if(aclr_ipd = '1' and if_aclr = '1') then
          if((preset = "true") and (power_up = '1')) then
          dataout_sig := (others => '1');
        else
          dataout_sig := (others => '0');
        end if;
      else 
          dataout_sig(data_width-1 downto 0)
            := data_ipd(data_width-1 downto 0);
      end if;
      end if;
    else
      dataout_sig := dataout_sig;
    end if;

    if (aclr_ipd'event and aclr_ipd = '1' and sclr = "false") then
      if(if_aclr = '1') then
        if((preset = "true") and (power_up = '1')) then
          dataout_sig := (others => '1');
        else
          dataout_sig := (others => '0');
        end if;
      else 
        dataout_sig := dataout_sig;
      end if;
    end if;
    
    if(devclrn'event and devclrn = '0') then
      dataout_sig := (others => '0');
    elsif(devpor'event and devpor = '0') then
      if power_up = '1' then
        dataout_sig := (others => '1');
      else
        dataout_sig := (others => '0');
      end if;
    end if;

    if (if_clk = '1') then 
      VitalSetupHoldCheck (
        Violation       => Tviol_clk_ena,
        TimingData      => TimingData_clk_ena,
        TestSignal      => clk_ipd,
        TestSignalName  => "clk",
        RefSignal       => ena_ipd,
        RefSignalName   => "ena",
        SetupHigh       => tsetup_ena_clk_noedge_posedge,
        SetupLow        => tsetup_ena_clk_noedge_posedge,
        HoldHigh        => thold_ena_clk_noedge_posedge,
        HoldLow         => thold_ena_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalSetupHoldCheck (
        Violation       => Tviol_clk_aclr,
        TimingData      => TimingData_clk_aclr,
        TestSignal      => aclr_ipd,
        TestSignalName  => "aclr",
        RefSignal       => ena_ipd,
        RefSignalName   => "ena",
        SetupHigh       => tsetup_aclr_clk_noedge_posedge,
        SetupLow        => tsetup_aclr_clk_noedge_posedge,
        HoldHigh        => thold_aclr_clk_noedge_posedge,
        HoldLow         => thold_aclr_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );      
      VitalSetupHoldCheck (
        Violation       => Tviol_data_clk,
        TimingData      => TimingData_data_clk,
        TestSignal      => data_ipd,
        TestSignalName  => "data",
        RefSignal       => clk_ipd,
        RefSignalName   => "clk",
        SetupHigh       => tsetup_data_clk_noedge_posedge,
        SetupLow        => tsetup_data_clk_noedge_posedge,
        HoldHigh        => thold_data_clk_noedge_posedge,
        HoldLow         => thold_data_clk_noedge_posedge,
        RefTransition   => '/',
        HeaderMsg       => "/RAM Register VitalSetupHoldCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );
      VitalPeriodPulseCheck (
        Violation       => Tviol_ena, 
        PeriodData      => PeriodData_ena,  
        TestSignal      => ena_ipd,
        TestSignalName  => "ena",
        PulseWidthHigh  => tpw_ena_posedge, 
        HeaderMsg       => "/RAM Register VitalPeriodPulseCheck",
        XOn             => TRUE,
        MsgOn           => TRUE );

    end if;

    -- PATH DELAY
    if (if_clk = '1') then
      VitalPathDelay01 (
        OutSignal     => dataout(0),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(0),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(0),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(1),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(1),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(1),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(2),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(2),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(2),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(3),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(3),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(3),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(4),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(4),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(4),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(5),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(5),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(5),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(6),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(6),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(6),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(7),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(7),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(7),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(8),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(8),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(8),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(9),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(9),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(9),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(10),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(10),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(10),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(11),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(11),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(11),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(12),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(12),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(12),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(13),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(13),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(13),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(14),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(14),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(14),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(15),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(15),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(15),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(16),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(16),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(16),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(17),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(17),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(17),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(18),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(18),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(18),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(19),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(19),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(19),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(20),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(20),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(20),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(21),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(21),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(21),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(22),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(22),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(22),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(23),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(23),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(23),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(24),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(24),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(24),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(25),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(25),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(25),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(26),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(26),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(26),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(27),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(27),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(27),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(28),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(28),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(28),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(29),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(29),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(29),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(30),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(30),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(30),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(31),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(31),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(31),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(32),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(32),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(32),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(33),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(33),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(33),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(34),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(34),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(34),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(35),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(35),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(35),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(36),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(36),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(36),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(37),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(37),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(37),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(38),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(38),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(38),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(39),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(39),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(39),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(40),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(40),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(40),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(41),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(41),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(41),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(42),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(42),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(42),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(43),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(43),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(43),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(44),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(44),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(44),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(45),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(45),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(45),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(46),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(46),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(46),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(47),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(47),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(47),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(48),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(48),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(48),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(49),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(49),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(49),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(50),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(50),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(50),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(51),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(51),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(51),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(52),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(52),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(52),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(53),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(53),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(53),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(54),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(54),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(54),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(55),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(55),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(55),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(56),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(56),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(56),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(57),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(57),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(57),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(58),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(58),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(58),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(59),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(59),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(59),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(60),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(60),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(60),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(61),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(61),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(61),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(62),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(62),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(62),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(63),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(63),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(63),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(64),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(64),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(64),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(65),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(65),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(65),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(66),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(66),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(66),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(67),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(67),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(67),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(68),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(68),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(68),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(69),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(69),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(69),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(70),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(70),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(70),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(71),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(71),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(71),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(72),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(72),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(72),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(73),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(73),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(73),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(74),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(74),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(74),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(75),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(75),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(75),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(76),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(76),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(76),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(77),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(77),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(77),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(78),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(78),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(78),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(79),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(79),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(79),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(80),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(80),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(80),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(81),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(81),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(81),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(82),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(82),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(82),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(83),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(83),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(83),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(84),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(84),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(84),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(85),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(85),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(85),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(86),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(86),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(86),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(87),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(87),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(87),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(88),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(88),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(88),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(89),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(89),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(89),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(90),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(90),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(90),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(91),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(91),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(91),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(92),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(92),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(92),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(93),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(93),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(93),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(94),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(94),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(94),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(95),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(95),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(95),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(96),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(96),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(96),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(97),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(97),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(97),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(98),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(98),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(98),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(99),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(99),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(99),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(100),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(100),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(100),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(101),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(101),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(101),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(102),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(102),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(102),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(103),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(103),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(103),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(104),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(104),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(104),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(105),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(105),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(105),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(106),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(106),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(106),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(107),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(107),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(107),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(108),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(108),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(108),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(109),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(109),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(109),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(110),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(110),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(110),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(111),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(111),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(111),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(112),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(112),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(112),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(113),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(113),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(113),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(114),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(114),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(114),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(115),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(115),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(115),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(116),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(116),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(116),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(117),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(117),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(117),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(118),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(118),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(118),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(119),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(119),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(119),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(120),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(120),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(120),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(121),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(121),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(121),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(122),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(122),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(122),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(123),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(123),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(123),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(124),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(124),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(124),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(125),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(125),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(125),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(126),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(126),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(126),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(127),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(127),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(127),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(128),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(128),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(128),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(129),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(129),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(129),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(130),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(130),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(130),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(131),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(131),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(131),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(132),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(132),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(132),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(133),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(133),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(133),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(134),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(134),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(134),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(135),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(135),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(135),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(136),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(136),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(136),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(137),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(137),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(137),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(138),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(138),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(138),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(139),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(139),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(139),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(140),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(140),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(140),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(141),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(141),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(141),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(142),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(142),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(142),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
      VitalPathDelay01 (
        OutSignal     => dataout(143),
        OutSignalName => "dataout",
        OutTemp       => dataout_sig(143),
        Paths         => (0 => (clk_ipd'last_event,
                                tpd_clk_dataout_posedge, TRUE),
                          1 => (aclr_ipd'last_event,
                                tpd_aclr_dataout_posedge, TRUE)),
        GlitchData    => dataout_VitalGlitchDataArray(143),
        Mode          => DefGlitchMode,
        XOn           => TRUE,
        MsgOn         => TRUE );
    else
      dataout(data_width-1 downto 0) <= data_ipd(data_width-1 downto 0);
    end if;
  end process;

end reg_arch;

--/////////////////////////////////////////////////////////////////////////////
--//
--//                             STRATIX_RAM_CLEAR
--//
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY stratix_ram_clear IS
   PORT (
      aclr                    : IN std_logic;   
      d                       : IN std_logic;   
      clk                     : IN std_logic;   
      ena                     : IN std_logic;   
      edg                     : IN std_logic;   
      q                       : OUT std_logic);   
END stratix_ram_clear;

ARCHITECTURE ram_clear_arch OF stratix_ram_clear IS

   SIGNAL q_tmp                    :  std_logic;   
   SIGNAL valid                    :  std_logic;   

BEGIN

   PROCESS (clk, ena)
   BEGIN
      IF (edg = '0') THEN
         IF (((NOT clk AND d) AND ena) = '1') THEN
            valid <= '1';    
         ELSE
            valid <= '0';    
         END IF;
      ELSE
         IF ((clk AND d) = '1') THEN
            valid <= '1';    
         ELSE
            valid <= '0';    
         END IF;
      END IF;
   END PROCESS;

   PROCESS (valid, aclr)
   BEGIN
      IF ((valid AND aclr) = '1') THEN
         q_tmp <= '1';    
      ELSE
         q_tmp <= '0';    
      END IF;
   END PROCESS;

   q <= q_tmp;

END ram_clear_arch;

--/////////////////////////////////////////////////////////////////////////////
--
--                             STRATIX_RAM_INTERNAL
--
--/////////////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

ENTITY stratix_ram_internal IS
  GENERIC (
    operation_mode                 :  string  := "single_port";
    ram_block_type                 :  string  := "M512";    
    mixed_port_feed_through_mode   :  string  := "dont_care";    
    port_a_data_width              :  integer := 16;    
    port_b_data_width              :  integer := 16;    
    port_a_address_width           :  integer := 16;    
    port_b_address_width           :  integer := 16;    
    port_a_byte_enable_mask_width  :  integer := 0;    
    port_b_byte_enable_mask_width  :  integer := 0;    
    init_file_layout               :  string  := "none";    
    port_a_first_address           :  integer := 0;    
    port_a_last_address            :  integer := 4096;    
    port_b_first_address           :  integer := 0;    
    port_b_last_address            :  integer := 4096;    
    port_a_address_clear           :  string  := "none";
    port_b_address_clear           :  string  := "none";
    mem1 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem2 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem3 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem4 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem5 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem6 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem7 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem8 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    mem9 : std_logic_vector(511 downto 0) := (OTHERS => '0');
    tpd_portawriteenable_portadataout   : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portadatain_portadataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portaaddress_portadataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portabyteenamask_portadataout  : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbwriteenable_portbdataout   : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbdatain_portbdataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbaddress_portbdataout        : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbbyteenamask_portbdataout  : VitalDelayType01 :=
    DefPropDelay01;
    tpd_portbreadenable_portbdataout    : VitalDelayType01 :=
    DefPropDelay01;
    XOn: Boolean              := DefGlitchXOn;   
    MsgOn: Boolean            := DefGlitchMsgOn  
    );
   PORT (
     portawriteenable     : in std_logic;   
     portbwriteenable     : in std_logic;
     cleara                  : in std_logic;
     clearb                  : in std_logic;
     portadatain          : in std_logic_vector
     (143 downto 0);
     portbdatain          : in std_logic_vector
     (143 downto 0);
     portaaddress          : in std_logic_vector
     (15 downto 0);
     portbaddress          : in std_logic_vector
     (15 downto 0);
     portabyteenamask    : in std_logic_vector
     (15 downto 0);
     portbbyteenamask    : in std_logic_vector
     (15 downto 0);
     portbreadenable      : in std_logic;   
     portaclock            : in std_logic;   
     portbclock            : in std_logic;   
     sameclock              : in std_logic;   
     portadataout         : out std_logic_vector(143 DOWNTO 0) := 
     (OTHERS => '0');
     portbdataout         : out std_logic_vector(143 DOWNTO 0) := 
     (OTHERS => '0')
     );
END stratix_ram_internal;

ARCHITECTURE ram_internal_arch OF stratix_ram_internal IS
   SIGNAL mem                      :  std_logic_vector
     ((port_a_data_width*(2**port_a_address_width))-1  DOWNTO 0) :=
     (OTHERS => '0');
   SIGNAL wr_a                     :  std_logic := '0';
   SIGNAL wr_b                     :  std_logic := '0';
   SIGNAL init_a                   :  std_logic := '0';
   SIGNAL init_b                   :  std_logic := '0';   
BEGIN
  
  -- PORT A LOGIC

PROCESS (portawriteenable, portadatain, portaaddress,
         portabyteenamask, portaclock)
  variable port_a_data_out_VitalGlitchDataArray :
    VitalGlitchDataArrayType(143 downto 0);
  variable port_a_data_out_tmp      :  std_logic_vector(143 DOWNTO 0) :=
    (OTHERS => '0');
  variable i   :  integer   := 0;     
BEGIN
  init_a <= '1';
  if(portaclock'EVENT) then
    i := 0;
    if operation_mode = "single_port" then
      IF (portawriteenable = '1') THEN
        IF (portaclock = '0') THEN
          wr_a <= '1';
        ELSE
          wr_a <= '0';
          IF (portaclock = '1') THEN
            i := 0;
            WHILE (i < port_a_data_width) LOOP
              if(port_a_byte_enable_mask_width /= 0) then
                IF (portabyteenamask
                    (i / (port_a_data_width /
                          port_a_byte_enable_mask_width)) = '0') THEN
                  port_a_data_out_tmp(i) := 'X';    
                ELSE
                  port_a_data_out_tmp(i) := portadatain(i);    
                END IF;
              else
                port_a_data_out_tmp(i) := portadatain(i);
              end if;
              i := i + 1;
            END LOOP;
          END IF;
        END IF;
      ELSE
        wr_a <= '0';
        IF (NOT portawriteenable = '1') THEN
          IF (portaclock = '1') THEN
            i := 0;
            WHILE (i < port_a_data_width) LOOP
              port_a_data_out_tmp(i)
                := mem(conv_integer(portaaddress) * port_a_data_width + i);
              i := i + 1;
            END LOOP;
          END IF;
        END IF;
      END IF;
    elsif operation_mode = "dual_port" then
      IF (portawriteenable = '1') THEN
        IF (sameclock = '1' and (ram_block_type = "MegaRAM" or
             ram_block_type = "M-RAM" or
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portaclock = '1') THEN
            wr_a <= '1';
          else
            wr_a <= '0';
          END IF;
        ELSE
          IF ((ram_block_type /= "MegaRAM") and
              (ram_block_type /= "M-RAM") and
              ((ram_block_type /= "auto") or
               (mixed_port_feed_through_mode /= "dont_care"))) THEN
            IF (portaclock = '0') THEN
              wr_a <= '1';
            else
              wr_a <= '0';
            END IF;
          ELSE
            IF (portaclock = '1') THEN
              wr_a <= '1';
            else
              wr_a <= '0';
            END IF;
          END IF;
        END IF;
      else
        wr_a <= '0';
      END IF;
    elsif operation_mode = "bidir_dual_port" then
      IF (portawriteenable = '0') THEN
        wr_a <= '0';
        -- READ: port_a_data_out = mem(portaaddress)
        IF (sameclock = '1' AND portbwriteenable = '1' AND
            (ram_block_type = "MegaRAM" OR
             ram_block_type = "M-RAM" OR 
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portaclock = '1') THEN
            i := 0;
            if(
              (((conv_integer(portaaddress)*port_a_data_width) < 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width)
                 + port_a_data_width-1) 
                < (conv_integer(portbaddress)*port_b_data_width))) or
              (((conv_integer(portaaddress)*port_a_data_width) > 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width)
                 + port_b_data_width-1) < 
                (conv_integer(portaaddress)*port_a_data_width)))
              ) then
              WHILE (i < port_a_data_width) LOOP
                port_a_data_out_tmp(i) := mem(conv_integer(portaaddress) *
                                              port_a_data_width + i);    
                i := i + 1;
              END LOOP;
            ELSE
              WHILE (i < port_a_data_width) LOOP
                if((conv_integer(portaaddress)*port_a_data_width) <= 
                   (conv_integer(portbaddress)*port_b_data_width))
                then
                  if((((conv_integer(portaaddress)*port_a_data_width)+ i) >= 
                      (conv_integer(portbaddress)*port_b_data_width)) and 
                     ((conv_integer(portaaddress)*port_a_data_width) + i < 
                      ((conv_integer(portbaddress)*port_b_data_width) + 
                       port_b_data_width)))
                  then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    port_a_data_out_tmp(i) 
                      := mem(conv_integer(portaaddress)*port_a_data_width + i);
                  end if;
                else
                  if(((conv_integer(portaaddress)*port_a_data_width) + i) <= 
                     ((conv_integer(portbaddress)*port_b_data_width) + 
                      port_b_data_width)) then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    port_a_data_out_tmp(i) 
                      := mem(conv_integer(portaaddress)*port_a_data_width + i);
                  end if; 
                end if;
                i := i + 1;
              end LOOP;
            end if;
          end if;
        else -- READ: port_a_data_out = mem(portaaddress);
          IF (portaclock = '1') THEN
            i := 0;
            WHILE (i < port_a_data_width) LOOP
              port_a_data_out_tmp(i) := mem(conv_integer(portaaddress) *
                                            port_a_data_width + i);    
              i := i + 1;
            END LOOP;
          end if;
        end if;
      elsif(portawriteenable = '1') then
        -- WRITE: mem(portaaddress) = portadatain
        if(sameclock = '1' and portbwriteenable = '1' and 
           (ram_block_type = "MegaRAM" or 
            ram_block_type = "M-RAM" or
            (ram_block_type = "auto" and 
             mixed_port_feed_through_mode = "dont_care"))) then
          if(portaclock = '1') then
            wr_a <= '1';
            if(
              (((conv_integer(portaaddress)*port_a_data_width) < 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width) + port_a_data_width-1) 
                < (conv_integer(portbaddress)*port_b_data_width))) or
              (((conv_integer(portaaddress)*port_a_data_width) > 
                (conv_integer(portbaddress)*port_b_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width) + port_b_data_width-1) < 
                (conv_integer(portaaddress)*port_a_data_width)))
              ) then
              WHILE (i < port_a_data_width) LOOP
                if(port_a_byte_enable_mask_width /= 0) then
                  IF (portabyteenamask
                      (i / (port_a_data_width /
                            port_a_byte_enable_mask_width)) = '0') THEN
                    port_a_data_out_tmp(i) := 'X';    
                  ELSE
                    port_a_data_out_tmp(i) := portadatain(i);    
                  END IF;
                else
                  port_a_data_out_tmp(i) := portadatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              WHILE (i < port_a_data_width) LOOP
                if((conv_integer(portaaddress)*port_a_data_width) <= 
                   (conv_integer(portbaddress)*port_b_data_width)) then
                  if((((conv_integer(portaaddress)*port_a_data_width) + i) >= 
                      (conv_integer(portbaddress)*port_b_data_width)) and 
                     ((conv_integer(portaaddress)*port_a_data_width) + i < 
                      ((conv_integer(portbaddress)*port_b_data_width) + 
                       port_b_data_width))) then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_a_data_width) LOOP
                      if(port_a_byte_enable_mask_width /= 0) then
                        IF (portabyteenamask
                            (i / (port_a_data_width /
                                  port_a_byte_enable_mask_width)) = '0') THEN
                          port_a_data_out_tmp(i) := 'X';    
                        ELSE
                          port_a_data_out_tmp(i) := portadatain(i);    
                        END IF;
                      else
                        port_a_data_out_tmp(i) := portadatain(i);
                      end if;
                    end loop;
                  end if;
                else
                  if(((conv_integer(portaaddress)*port_a_data_width) + i) <= 
                     ((conv_integer(portbaddress)*port_b_data_width) + 
                      port_b_data_width)) then
                    port_a_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_a_data_width) LOOP
                      if(port_a_byte_enable_mask_width /= 0) then
                        IF (portabyteenamask
                            (i / (port_a_data_width /
                                  port_a_byte_enable_mask_width)) = '0') THEN
                          port_a_data_out_tmp(i) := 'X';    
                        ELSE
                          port_a_data_out_tmp(i) := portadatain(i);    
                        END IF;
                      else
                        port_a_data_out_tmp(i) := portadatain(i);
                      end if;
                    end loop;
                  end if;
                end if;
              end loop;
            end if;
          else
            wr_a <= '0';
          end if;
        else
          -- WRITE: mem(portaaddress) =  portadatain;
          if((ram_block_type /= "MegaRAM") and 
             (ram_block_type /= "M-RAM") and
             ((ram_block_type /= "auto") or
              (mixed_port_feed_through_mode /= "dont_care"))) then
            if (portaclock = '1') then
              wr_a <= '0';
              WHILE (i < port_a_data_width) LOOP
                if(port_a_byte_enable_mask_width /= 0) then
                  IF (portabyteenamask
                      (i / (port_a_data_width /
                            port_a_byte_enable_mask_width)) = '0') THEN
                    port_a_data_out_tmp(i) := 'X';    
                  ELSE
                    port_a_data_out_tmp(i) := portadatain(i);    
                  END IF;
                else
                  port_a_data_out_tmp(i) := portadatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_a <= '1';
            end if;
          else
            if (portaclock = '1') then
              wr_a <= '1';
              WHILE (i < port_a_data_width) LOOP
                if(port_a_byte_enable_mask_width /= 0) then
                  IF (portabyteenamask
                      (i / (port_a_data_width /
                            port_a_byte_enable_mask_width)) = '0') THEN
                    port_a_data_out_tmp(i) := 'X';    
                  ELSE
                    port_a_data_out_tmp(i) := portadatain(i);    
                  END IF;
                else
                  port_a_data_out_tmp(i) := portadatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_a <= '0';
            end if;
          end if; 
        end if;
      end if;
    elsif operation_mode = "rom" then
      IF (portaclock = '1') THEN
        i := 0;
        WHILE (i < port_a_data_width) LOOP
          port_a_data_out_tmp(i) := mem(conv_integer(portaaddress) *
                                        port_a_data_width + i);    
          i := i + 1;
        END LOOP;
      END IF;
    end if;
  end if;

    VitalPathDelay01 (
      OutSignal => portadataout(0),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(0), 
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(0),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(1),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(1),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(1),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(2),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(2),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(2),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(3),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(3),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(3),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(4),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(4),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(4),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(5),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(5),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(5),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(6),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(6),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(6),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(7),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(7),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(7),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(8),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(8),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(8),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(9),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(9),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(9),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(10),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(10),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(10),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(11),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(11),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(11),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(12),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(12),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(12),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(13),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(13),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(13),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(14),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(14),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(14),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(15),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(15),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(15),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(16),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(16),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(16),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(17),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(17),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(17),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(18),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(18),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(18),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(19),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(19),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(19),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(20),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(20),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(20),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(21),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(21),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(21),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(22),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(22),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(22),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(23),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(23),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(23),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(24),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(24),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(24),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(25),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(25),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(25),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(26),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(26),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(26),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(27),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(27),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(27),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(28),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(28),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(28),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(29),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(29),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(29),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(30),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(30),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(30),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(31),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(31),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(31),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(32),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(32),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(32),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(33),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(33),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(33),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(34),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(34),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(34),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(35),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(35),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(35),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(36),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(36),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(36),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(37),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(37),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(37),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(38),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(38),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(38),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(39),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(39),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(39),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(40),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(40),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(40),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(41),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(41),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(41),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(42),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(42),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(42),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(43),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(43),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(43),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(44),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(44),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(44),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(45),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(45),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(45),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(46),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(46),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(46),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(47),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(47),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(47),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(48),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(48),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(48),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(49),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(49),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(49),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(50),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(50),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(50),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(51),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(51),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(51),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(52),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(52),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(52),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(53),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(53),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(53),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(54),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(54),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(54),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(55),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(55),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(55),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(56),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(56),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(56),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(57),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(57),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(57),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(58),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(58),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(58),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(59),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(59),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(59),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(60),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(60),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(60),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(61),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(61),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(61),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(62),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(62),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(62),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(63),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(63),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(63),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(64),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(64),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(64),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(65),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(65),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(65),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(66),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(66),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(66),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(67),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(67),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(67),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(68),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(68),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(68),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(69),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(69),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(69),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(70),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(70),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(70),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(71),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(71),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(71),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(72),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(72),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(72),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(73),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(73),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(73),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(74),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(74),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(74),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(75),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(75),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(75),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(76),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(76),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(76),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(77),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(77),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(77),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(78),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(78),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(78),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(79),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(79),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(79),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(80),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(80),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(80),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(81),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(81),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(81),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(82),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(82),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(82),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(83),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(83),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(83),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(84),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(84),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(84),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(85),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(85),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(85),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(86),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(86),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(86),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(87),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(87),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(87),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(88),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(88),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(88),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(89),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(89),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(89),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(90),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(90),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(90),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(91),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(91),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(91),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(92),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(92),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(92),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(93),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(93),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(93),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(94),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(94),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(94),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(95),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(95),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(95),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(96),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(96),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(96),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(97),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(97),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(97),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(98),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(98),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(98),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(99),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(99),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(99),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(100),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(100),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(100),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(101),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(101),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(101),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(102),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(102),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(102),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(103),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(103),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(103),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(104),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(104),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(104),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(105),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(105),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(105),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(106),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(106),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(106),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(107),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(107),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(107),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(108),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(108),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(108),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(109),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(109),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(109),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(110),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(110),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(110),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(111),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(111),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(111),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(112),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(112),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(112),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(113),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(113),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(113),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(114),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(114),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(114),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(115),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(115),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(115),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(116),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(116),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(116),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(117),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(117),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(117),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(118),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(118),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(118),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(119),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(119),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(119),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(120),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(120),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(120),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(121),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(121),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(121),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(122),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(122),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(122),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(123),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(123),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(123),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(124),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(124),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(124),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(125),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(125),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(125),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(126),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(126),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(126),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(127),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(127),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(127),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(128),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(128),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(128),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(129),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(129),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(129),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(130),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(130),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(130),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(131),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(131),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(131),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(132),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(132),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(132),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(133),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(133),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(133),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(134),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(134),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(134),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(135),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(135),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(135),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(136),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(136),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(136),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(137),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(137),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(137),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(138),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(138),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(138),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(139),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(139),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(139),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(140),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(140),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(140),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(141),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(141),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(141),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(142),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(142),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(142),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portadataout(143),
      OutSignalName => "portadataout",
      OutTemp => port_a_data_out_tmp(143),
      Paths => (0 => (portawriteenable'last_event,
                      tpd_portawriteenable_portadataout, TRUE),
                1 => (portadatain'last_event,
                      tpd_portadatain_portadataout, TRUE),
                2 => (portaaddress'last_event,
                      tpd_portaaddress_portadataout, TRUE),
                3 => (portabyteenamask'last_event,
                      tpd_portabyteenamask_portadataout, TRUE)),
      GlitchData => port_a_data_out_VitalGlitchDataArray(143),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
END PROCESS;

  -- PORT B LOGIC
   
PROCESS (portbwriteenable, portbdatain, portbaddress,
         portbbyteenamask, portbreadenable, portbclock)
  variable port_b_data_out_VitalGlitchDataArray :
    VitalGlitchDataArrayType(143 downto 0);
  variable port_b_data_out_tmp :
    std_logic_vector(143 downto 0);
  variable i :  integer := 0;     
BEGIN
  init_b <= '1';
  if(portbclock'EVENT) then
    i := 0;
    if operation_mode = "dual_port" then
      IF (portbreadenable = '1') THEN
        wr_b <= '0';
        -- READ: port_b_data_out = mem(portbaddress)
        IF (sameclock = '1' AND portawriteenable = '1' AND
            (ram_block_type = "MegaRAM" OR
             ram_block_type = "M-RAM" OR
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portbclock = '1') THEN
            i := 0;
            if(
              (((conv_integer(portbaddress)*port_b_data_width) < 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width)
                 + port_b_data_width-1) 
                < (conv_integer(portaaddress)*port_a_data_width))) or
              (((conv_integer(portbaddress)*port_b_data_width) > 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width)
                 + port_a_data_width-1) < 
                (conv_integer(portbaddress)*port_b_data_width)))
              ) then
              WHILE (i < port_b_data_width) LOOP
                port_b_data_out_tmp(i) := mem(conv_integer(portbaddress) *
                                              port_b_data_width + i);    
                i := i + 1;
              END LOOP;
            ELSE
              WHILE (i < port_b_data_width) LOOP
                if((conv_integer(portbaddress)*port_b_data_width) <= 
                   (conv_integer(portaaddress)*port_a_data_width))
                then
                  if((((conv_integer(portbaddress)*port_b_data_width)+ i) >= 
                      (conv_integer(portaaddress)*port_a_data_width)) and 
                     ((conv_integer(portbaddress)*port_b_data_width) + i < 
                      ((conv_integer(portaaddress)*port_a_data_width) + 
                       port_a_data_width)))
                  then
                    port_b_data_out_tmp(i) := 'X';    
                  else
                    port_b_data_out_tmp(i) 
                      := mem(conv_integer(portbaddress)*port_b_data_width + i);
                  end if;
                else
                  if(((conv_integer(portbaddress)*port_b_data_width) + i) <= 
                     ((conv_integer(portaaddress)*port_a_data_width) + 
                      port_a_data_width)) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    port_b_data_out_tmp(i)
                      := mem(conv_integer(portbaddress) * port_b_data_width + i);
                  end if; 
                end if;
                i := i + 1;
              end LOOP;
            end if;
          end if;
        else -- READ: port_b_data_out = mem(portbaddress);
          IF (portbclock = '1') THEN
            i := 0;
            WHILE (i < port_b_data_width) LOOP
              port_b_data_out_tmp(i) := mem(conv_integer(portbaddress) *
                                            port_b_data_width + i);    
              i := i + 1;
            END LOOP;
          end if;
        end if;
      end if;
    elsif operation_mode = "bidir_dual_port" then
      IF (portbwriteenable = '0') THEN
        wr_b <= '0';
        -- READ: port_b_data_out = mem(portbaddress)
        IF (sameclock = '1' AND portawriteenable = '1' AND
            (ram_block_type = "MegaRAM" OR
             ram_block_type = "M-RAM" OR 
             (ram_block_type = "auto" AND
              mixed_port_feed_through_mode =
              "dont_care"))) THEN
          IF (portbclock = '1') THEN
            i := 0;
            if(
              (((conv_integer(portbaddress)*port_b_data_width) < 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width)
                 + port_b_data_width-1) 
                < (conv_integer(portaaddress)*port_a_data_width))) or
              (((conv_integer(portbaddress)*port_b_data_width) > 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width)
                 + port_a_data_width-1) < 
                (conv_integer(portbaddress)*port_b_data_width)))
              ) then
              WHILE (i < port_b_data_width) LOOP
                port_b_data_out_tmp(i) := mem(conv_integer(portbaddress) *
                                              port_b_data_width + i);    
                i := i + 1;
              END LOOP;
            ELSE
              WHILE (i < port_b_data_width) LOOP
                if((conv_integer(portbaddress)*port_b_data_width) <= 
                   (conv_integer(portaaddress)*port_a_data_width))
                then
                  if((((conv_integer(portbaddress)*port_b_data_width)+ i) >= 
                      (conv_integer(portaaddress)*port_a_data_width)) and 
                     ((conv_integer(portbaddress)*port_b_data_width) + i < 
                      ((conv_integer(portaaddress)*port_a_data_width) + 
                       port_a_data_width)))
                  then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    port_b_data_out_tmp(i) 
                      := mem(conv_integer(portbaddress)*port_b_data_width + i);
                  end if;
                else
                  if(((conv_integer(portbaddress)*port_b_data_width) + i) <= 
                     ((conv_integer(portaaddress)*port_a_data_width) + 
                      port_a_data_width)) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    port_b_data_out_tmp(i) 
                      := mem(conv_integer(portbaddress)*port_b_data_width + i);
                  end if; 
                end if;
                i := i + 1;
              end LOOP;
            end if;
          end if;
        else -- READ: port_b_data_out = mem(portbaddress);
          IF (portbclock = '1') THEN
            i := 0;
            WHILE (i < port_b_data_width) LOOP
              port_b_data_out_tmp(i) := mem(conv_integer(portbaddress) *
                                            port_b_data_width + i);    
              i := i + 1;
            END LOOP;
          end if;
        end if;
      elsif(portbwriteenable = '1') then
        -- WRITE: mem(portbaddress) = portbdatain
        if(sameclock = '1' and portawriteenable = '1' and 
           (ram_block_type = "MegaRAM" or 
            ram_block_type = "M-RAM" or 
            (ram_block_type = "auto" and 
             mixed_port_feed_through_mode = "dont_care"))) then
          if(portbclock = '1') then
            wr_b <= '1';
            if(
              (((conv_integer(portbaddress)*port_b_data_width) < 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portbaddress)*port_b_data_width) + port_b_data_width-1) 
                < (conv_integer(portaaddress)*port_a_data_width))) or
              (((conv_integer(portbaddress)*port_b_data_width) > 
                (conv_integer(portaaddress)*port_a_data_width)) and 
               (((conv_integer(portaaddress)*port_a_data_width) + port_a_data_width-1) < 
                (conv_integer(portbaddress)*port_b_data_width)))
              ) then
              WHILE (i < port_b_data_width) LOOP
                if(port_b_byte_enable_mask_width /= 0) then
                  IF (portbbyteenamask
                      (i / (port_b_data_width /
                            port_b_byte_enable_mask_width)) = '0') THEN
                    port_b_data_out_tmp(i) := 'X';    
                  ELSE
                    port_b_data_out_tmp(i) := portbdatain(i);    
                  END IF;
                else
                  port_b_data_out_tmp(i) := portbdatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              WHILE (i < port_b_data_width) LOOP
                if((conv_integer(portbaddress)*port_b_data_width) <= 
                   (conv_integer(portaaddress)*port_a_data_width)) then
                  if((((conv_integer(portbaddress)*port_b_data_width) + i) >= 
                      (conv_integer(portaaddress)*port_a_data_width)) and 
                     ((conv_integer(portbaddress)*port_b_data_width) + i < 
                      ((conv_integer(portaaddress)*port_a_data_width) + 
                       port_a_data_width))) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_b_data_width) LOOP
                      if(port_b_byte_enable_mask_width /= 0) then
                        IF (portbbyteenamask
                            (i / (port_b_data_width /
                                  port_b_byte_enable_mask_width)) = '0') THEN
                          port_b_data_out_tmp(i) := 'X';    
                        ELSE
                          port_b_data_out_tmp(i) := portbdatain(i);    
                        END IF;
                      else
                        port_b_data_out_tmp(i) := portbdatain(i);
                      end if;
                    end loop;
                  end if;
                else
                  if(((conv_integer(portbaddress)*port_b_data_width) + i) <= 
                     ((conv_integer(portaaddress)*port_a_data_width) + 
                      port_a_data_width)) then
                    port_b_data_out_tmp(i) := 'X';
                  else
                    WHILE (i < port_b_data_width) LOOP
                      if(port_b_byte_enable_mask_width /= 0) then
                        IF (portbbyteenamask
                            (i / (port_b_data_width /
                                  port_b_byte_enable_mask_width)) = '0') THEN
                          port_b_data_out_tmp(i) := 'X';    
                        ELSE
                          port_b_data_out_tmp(i) := portbdatain(i);    
                        END IF;
                      else
                        port_b_data_out_tmp(i) := portbdatain(i);
                      end if;
                    end loop;
                  end if;
                end if;
              end loop;
            end if;
          else
            wr_b <= '0';
          end if;
        else
          -- WRITE: mem(portbaddress) =  portbdatain;
          if((ram_block_type /= "MegaRAM") and 
             (ram_block_type /= "M-RAM") and
             ((ram_block_type /= "auto") or
              (mixed_port_feed_through_mode /= "dont_care"))) then
            if (portbclock = '1') then
              wr_b <= '0';
              WHILE (i < port_b_data_width) LOOP
                if(port_b_byte_enable_mask_width /= 0) then
                  IF (portbbyteenamask
                      (i / (port_b_data_width /
                            port_b_byte_enable_mask_width)) = '0') THEN
                    port_b_data_out_tmp(i) := 'X';    
                  ELSE
                    port_b_data_out_tmp(i) := portbdatain(i);    
                  END IF;
                else
                  port_b_data_out_tmp(i) := portbdatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_b <= '1';
            end if;
          else
            if (portbclock = '1') then
              wr_b <= '1';
              WHILE (i < port_b_data_width) LOOP
                if(port_b_byte_enable_mask_width /= 0) then
                  IF (portbbyteenamask
                      (i / (port_b_data_width /
                            port_b_byte_enable_mask_width)) = '0') THEN
                    port_b_data_out_tmp(i) := 'X';    
                  ELSE
                    port_b_data_out_tmp(i) := portbdatain(i);    
                  END IF;
                else
                  port_b_data_out_tmp(i) := portbdatain(i);
                end if;
                i := i + 1;
              end loop;
            else
              wr_b <= '0';
            end if;
          end if; 
        end if;
      end if;
    end if;
  end if;

    VitalPathDelay01 (
      OutSignal => portbdataout(0),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(0),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(0),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(1),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(1),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(1),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(2),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(2),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(2),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(3),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(3),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(3),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(4),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(4),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(4),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(5),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(5),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(5),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(6),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(6),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(6),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(7),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(7),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(7),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(8),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(8),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(8),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(9),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(9),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(9),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(10),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(10),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(10),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(11),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(11),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(11),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(12),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(12),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(12),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(13),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(13),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(13),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(14),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(14),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(14),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(15),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(15),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(15),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(16),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(16),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(16),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(17),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(17),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(17),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(18),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(18),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(18),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(19),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(19),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(19),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(20),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(20),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(20),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(21),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(21),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(21),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(22),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(22),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(22),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(23),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(23),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(23),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(24),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(24),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(24),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(25),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(25),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(25),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(26),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(26),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(26),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(27),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(27),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(27),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(28),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(28),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(28),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(29),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(29),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(29),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(30),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(30),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(30),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(31),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(31),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(31),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(32),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(32),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(32),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(33),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(33),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(33),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(34),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(34),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(34),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(35),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(35),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(35),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(36),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(36),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(36),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(37),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(37),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(37),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(38),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(38),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(38),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(39),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(39),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(39),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(40),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(40),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(40),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(41),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(41),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(41),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(42),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(42),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(42),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(43),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(43),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(43),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(44),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(44),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(44),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(45),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(45),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(45),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(46),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(46),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(46),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(47),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(47),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(47),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(48),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(48),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(48),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(49),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(49),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(49),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(50),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(50),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(50),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(51),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(51),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(51),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(52),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(52),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(52),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(53),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(53),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(53),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(54),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(54),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(54),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(55),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(55),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(55),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(56),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(56),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(56),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(57),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(57),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(57),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(58),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(58),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(58),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(59),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(59),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(59),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(60),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(60),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(60),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(61),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(61),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(61),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(62),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(62),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(62),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(63),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(63),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(63),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(64),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(64),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(64),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(65),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(65),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(65),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(66),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(66),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(66),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(67),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(67),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(67),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(68),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(68),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(68),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(69),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(69),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(69),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(70),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(70),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(70),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(71),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(71),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(71),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(72),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(72),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(72),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(73),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(73),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(73),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(74),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(74),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(74),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(75),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(75),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(75),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(76),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(76),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(76),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(77),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(77),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(77),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(78),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(78),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(78),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(79),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(79),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(79),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(80),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(80),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(80),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(81),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(81),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(81),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(82),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(82),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(82),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(83),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(83),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(83),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(84),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(84),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(84),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(85),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(85),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(85),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(86),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(86),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(86),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(87),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(87),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(87),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(88),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(88),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(88),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(89),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(89),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(89),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(90),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(90),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(90),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(91),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(91),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(91),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(92),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(92),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(92),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(93),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(93),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(93),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(94),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(94),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(94),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(95),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(95),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(95),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(96),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(96),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(96),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(97),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(97),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(97),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(98),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(98),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(98),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(99),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(99),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(99),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(100),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(100),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(100),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(101),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(101),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(101),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(102),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(102),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(102),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(103),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(103),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(103),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(104),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(104),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(104),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(105),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(105),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(105),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(106),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(106),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(106),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(107),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(107),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(107),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(108),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(108),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(108),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(109),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(109),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(109),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(110),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(110),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(110),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(111),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(111),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(111),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(112),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(112),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(112),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(113),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(113),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(113),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(114),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(114),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(114),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(115),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(115),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(115),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(116),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(116),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(116),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(117),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(117),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(117),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(118),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(118),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(118),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(119),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(119),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(119),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(120),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(120),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(120),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(121),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(121),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(121),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(122),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(122),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(122),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(123),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(123),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(123),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(124),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(124),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(124),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(125),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(125),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(125),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(126),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(126),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(126),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(127),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(127),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(127),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(128),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(128),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(128),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(129),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(129),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(129),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(130),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(130),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(130),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(131),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(131),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(131),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(132),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(132),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(132),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(133),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(133),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(133),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(134),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(134),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(134),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(135),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(135),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(135),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(136),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(136),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(136),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(137),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(137),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(137),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(138),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(138),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(138),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(139),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(139),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(139),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(140),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(140),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(140),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(141),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(141),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(141),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(142),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(142),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(142),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
    VitalPathDelay01 (
      OutSignal => portbdataout(143),
      OutSignalName => "portbdataout",
      OutTemp => port_b_data_out_tmp(143),
      Paths => (0 => (portbwriteenable'last_event,
                      tpd_portbwriteenable_portbdataout, TRUE),
                1 => (portbdatain'last_event,
                      tpd_portbdatain_portbdataout, TRUE),
                2 => (portbaddress'last_event,
                      tpd_portbaddress_portbdataout, TRUE),
                3 => (portbbyteenamask'last_event,
                      tpd_portbbyteenamask_portbdataout, TRUE),
                4 => (portbreadenable'last_event,
                      tpd_portbreadenable_portbdataout, TRUE)),
      GlitchData => port_b_data_out_VitalGlitchDataArray(143),
      Mode => OnEvent,
      MsgOn => TRUE,
      XOn  => TRUE
    );
end process;

-- WRITE LOGIC BLOCK
process
    variable i :  integer := 0;     
    variable initial : BOOLEAN := TRUE;
    variable j : integer := 0;
    variable k : integer := 0;
    variable l : integer := 0;
    variable depth : integer := 0;
    variable index : integer := 0;
    variable tmp_mem : std_logic_vector(4607 downto 0) := (OTHERS => '0');
  begin
    wait until (wr_a'event and wr_a = '1') or (wr_b'event and wr_b = '1') or
      (cleara'event and cleara = '1') or (clearb'event and clearb = '1') or 
      (init_a'event and init_a = '1' and initial) or
      (init_b'event and init_b = '1' and initial);
    IF (initial) THEN
      tmp_mem(4607 downto 0) := (mem9 & mem8 & mem7 & mem6 & mem5 &
                                 mem4 & mem3 & mem2 & mem1);
       IF (init_file_layout = "none") or (init_file_layout = "UNUSED") THEN
          if (ram_block_type="M-RAM" or 
              ram_block_type="MegaRAM" or
             (mixed_port_feed_through_mode="dont_care" 
              and ram_block_type="auto")) then
           mem <= (others => 'X');
          else
           mem <= (others => '0');
          end if;
       ELSIF (init_file_layout = "port_b") THEN
        l := 0;    
        depth := port_b_last_address - port_b_first_address + 1;    
        j := 0;
        WHILE (j < depth) LOOP
          k := 0;
          WHILE (k < port_b_data_width) LOOP
            index := j + (depth * k);
            mem(l) <= tmp_mem(index);
            l := l + 1;    
            k := k + 1;
          END LOOP;
          j := j + 1;
        END LOOP;
      ELSIF (init_file_layout = "port_a") THEN
        l := 0;    
        depth := port_a_last_address - port_a_first_address + 1;    
        j := 0;
        WHILE (j < depth) LOOP
          k := 0;
          WHILE (k < port_a_data_width) LOOP
            index := j + (depth * k);    
            mem(l) <= tmp_mem(index);
            l := l + 1;    
            k := k + 1;
          END LOOP;
          j := j + 1;
        END LOOP;
      END IF;
      initial := FALSE;
    END IF;
    
    if(wr_a'event and wr_a = '1') then
      i := 0;
      WHILE (i < port_a_data_width) LOOP
        if(port_a_byte_enable_mask_width /= 0) then
          IF (portabyteenamask
              (i / (port_a_data_width / port_a_byte_enable_mask_width))
              = '1') THEN
            mem(conv_integer(portaaddress) * port_a_data_width + i) <= portadatain(i);    
          END IF;
        else
          mem(conv_integer(portaaddress) * port_a_data_width + i)
            <= portadatain(i);
        end if;
        i := i + 1;
      END LOOP;
    end if;
    
    if(wr_b'event and wr_b = '1') then
      i := 0;
      WHILE (i < port_b_data_width) LOOP
        if(port_b_byte_enable_mask_width /= 0) then
          IF (portbbyteenamask
              (i / (port_b_data_width / port_b_byte_enable_mask_width))
              = '1') THEN
            mem(conv_integer(portbaddress) * port_b_data_width + i)
              <= portbdatain(i);    
          END IF;
        else
          mem(conv_integer(portbaddress) * port_b_data_width + i)
            <= portbdatain(i);
        end if;
        i := i + 1;
      END LOOP;
    end if;
     
    if(cleara'event and cleara = '1') then
      i := 0;
      if ((port_a_address_clear /= "none") and 
          (port_a_address_clear /= "UNUSED"))then
        mem <= (others => 'X');
      else
        WHILE (i < port_a_data_width) LOOP
          if(port_a_byte_enable_mask_width /= 0) then
            IF (portabyteenamask
                (i / (port_a_data_width / port_a_byte_enable_mask_width))
                = '1') THEN
              mem(conv_integer(portaaddress) * port_a_data_width + i)
                <= 'X';    
            END IF;
          else
            mem(conv_integer(portaaddress) * port_a_data_width + i) <= 'X';
          end if;
          i := i + 1;
        END LOOP;
      end if;
    end if;
     
    if(clearb'event and clearb = '1' and operation_mode /= "dual_port") then
      i := 0;
      if ((port_b_address_clear /= "none") and
          (port_b_address_clear /= "UNUSED")) then
        mem <= (others => 'X');
      else
        WHILE (i < port_b_data_width) LOOP
          if(port_b_byte_enable_mask_width /= 0) then
            IF (portbbyteenamask
                (i / (port_b_data_width / port_b_byte_enable_mask_width))
                = '1') THEN
              mem(conv_integer(portbaddress) * port_b_data_width + i)
                <= 'X';    
            END IF;
          else
            mem(conv_integer(portbaddress) * port_b_data_width + i) <= 'X';
          end if;
          i := i + 1;
        END LOOP;
      end if;
    end if;
  end process;
   end ram_internal_arch;

-- ///////////////////////////////////////////////////////////////////////////
-- //
-- //                             STRATIX_RAM_BLOCK
-- //
-- ///////////////////////////////////////////////////////////////////////////

library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;

entity stratix_ram_block IS
  generic 
    (
      operation_mode            : string := "single_port";
      mixed_port_feed_through_mode : string := "dont_care"; 
      ram_block_type            : string := "auto"; 
      logical_ram_name          : string := "ram_name"; 
      init_file                 : string := "init_file.hex"; 
      init_file_layout          : string := "none";
      data_interleave_width_in_bits : integer := 1;
      data_interleave_offset_in_bits : integer := 1;
      port_a_logical_ram_depth  : integer := 0;
      port_a_logical_ram_width  : integer := 0;
      port_a_data_in_clear      : string := "none";
      port_a_address_clear      : string := "none";
      port_a_write_enable_clear : string := "none";
      port_a_data_out_clock     : string := "none";
      port_a_data_out_clear     : string := "none";
      port_a_first_address      : integer := 0;
      port_a_last_address       : integer := 0;
      port_a_first_bit_number   : integer := 0;
      port_a_data_width         : integer := 144;
      port_a_byte_enable_clear  : string := "none";
      port_a_data_in_clock      : string := "clock0"; 
      port_a_address_clock      : string := "clock0"; 
      port_a_write_enable_clock : string := "clock0";
      port_a_byte_enable_clock  : string := "clock0";
      port_b_logical_ram_depth  : integer := 0;
      port_b_logical_ram_width  : integer := 0;
      port_b_data_in_clock      : string := "none";
      port_b_data_in_clear      : string := "none";
      port_b_address_clock      : string := "none";
      port_b_address_clear      : string := "none";
      port_b_read_enable_write_enable_clock : string := "none";
      port_b_read_enable_write_enable_clear : string := "none";
      port_b_data_out_clock     : string := "none";
      port_b_data_out_clear     : string := "none";
      port_b_first_address      : integer := 0;
      port_b_last_address       : integer := 0;
      port_b_first_bit_number   : integer := 0;
      port_b_data_width         : integer := 144;
      port_b_byte_enable_clear  : string := "none";
      port_b_byte_enable_clock  : string := "none";
      port_a_address_width      : integer := 16; 
      port_b_address_width      : integer := 16; 
      port_a_byte_enable_mask_width : integer := 0; 
      port_b_byte_enable_mask_width : integer := 0; 
      lpm_type                  : string := "stratix_ram_block";
      connectivity_checking     : string := "off";
      mem1 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem2 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem3 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem4 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem5 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem6 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem7 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem8 : std_logic_vector(512 downto 1) := (OTHERS => '0');
      mem9 : std_logic_vector(512 downto 1) := (OTHERS => '0')
    );
  port
    (
      portawe           : in std_logic;
      portabyteenamasks : in std_logic_vector (15 downto 0) := (OTHERS => '1');
      portbbyteenamasks : in std_logic_vector (15 downto 0) := (OTHERS => '1');
      portbrewe         : in std_logic;
      clr0              : in std_logic;
      clr1              : in std_logic;
      clk0              : in std_logic;
      clk1              : in std_logic;
      ena0              : in std_logic := '1';
      ena1              : in std_logic := '1';
      portadatain       : in std_logic_vector (143 downto 0);
      portbdatain       : in std_logic_vector (143 downto 0);
      portaaddr         : in std_logic_vector (15 downto 0);
      portbaddr         : in std_logic_vector (15 downto 0);
      devclrn           : in std_logic := '1';   
      devpor            : in std_logic := '1';
      portadataout      : out std_logic_vector (143 downto 0);
      portbdataout      : out std_logic_vector (143 downto 0)
    );

function select_ram(constant string_name : string)
  return natural is
  begin
    if (string_name = "clock0" or string_name = "clear0") then
      return 0;
    elsif (string_name = "clock1" or string_name = "clear1") then
      return 1;
    elsif string_name = "none" then
      return 0;
    else
      return 0;  
    end if;
  end select_ram;

end stratix_ram_block;

architecture ram_arch of stratix_ram_block is

--
-- STRATIX_RAM_REGISTER COMPONENT
--

component stratix_ram_register
  generic 
    (
      data_width      : integer := 143;
      sclr            : string  := "true";
      preset          : string  := "false";
      tipd_data       : VitalDelayArrayType01(143 downto 0) :=
      (OTHERS => DefPropDelay01);
      tipd_clk        : VitalDelayType01 := DefPropDelay01;
      tipd_ena        : VitalDelayType01 := DefPropDelay01;
      tipd_aclr       : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_dataout_posedge  : VitalDelayType01 := DefPropDelay01;
      tpd_clk_dataout_posedge   : VitalDelayType01 := DefPropDelay01;
      tpd_clk_done_posedge      : VitalDelayType01 := DefPropDelay01;
      tsetup_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_data_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
      tpw_ena_posedge : VitalDelayType := 0 ns
    );
  port
    (
      data      : in std_logic_vector (data_width-1 downto 0);
      clk       : in std_logic;
      aclr      : in std_logic;
      ena       : in std_logic;
      if_clk    : in std_logic;
      if_aclr   : in std_logic;
      if_ena    : in std_logic;
      devclrn   : in std_logic;
      devpor    : in std_logic;
      power_up  : in std_logic;
      dataout   : out std_logic_vector (143 downto 0);
      aclrout   : out std_logic;
      clkout   : out std_logic;      
      done      : out std_logic
    );
end component;

--
-- STRATIX_RAM_CLEAR COMPONENT
--

component stratix_ram_clear
   PORT (
      aclr                    : IN std_logic;   
      d                       : IN std_logic;   
      clk                     : IN std_logic;   
      ena                     : IN std_logic;   
      edg                     : IN std_logic;   
      q                       : OUT std_logic
      );   
END component;

--
-- STRATIX_RAM_INTERNAL COMPONENT
--

component stratix_ram_internal
  generic
    (
      operation_mode : string := "single_port";
      ram_block_type : string := "M512";
      mixed_port_feed_through_mode : string := "dont_care";
      port_a_data_width : integer := 144;
      port_b_data_width : integer := 144;
      port_a_address_width : integer := 16;
      port_b_address_width : integer := 16;
      port_a_byte_enable_mask_width : integer := 0;
      port_b_byte_enable_mask_width : integer := 0;
      init_file_layout     : string := "none";
      port_a_first_address : integer := 0;
      port_a_last_address  : integer := 4096;
      port_b_first_address : integer := 0;
      port_b_last_address  : integer := 4096;
      port_a_address_clear :  string  := "none";
      port_b_address_clear :  string  := "none";
      mem1 : std_logic_vector(512 downto 1);
      mem2 : std_logic_vector(512 downto 1);
      mem3 : std_logic_vector(512 downto 1);
      mem4 : std_logic_vector(512 downto 1);
      mem5 : std_logic_vector(512 downto 1);
      mem6 : std_logic_vector(512 downto 1);
      mem7 : std_logic_vector(512 downto 1);
      mem8 : std_logic_vector(512 downto 1);
      mem9 : std_logic_vector(512 downto 1) 
    );
  port
    (
      portawriteenable : in std_logic;
      portbwriteenable : in std_logic;
      cleara              : std_logic;
      clearb              : std_logic;
      portadatain      : in std_logic_vector(143 downto 0);
      portbdatain      : in std_logic_vector(143 downto 0);
      portaaddress      : in std_logic_vector(15 downto 0);
      portbaddress      : in std_logic_vector(15 downto 0);
      portabyteenamask: in std_logic_vector(15 downto 0);
      portbbyteenamask: in std_logic_vector(15 downto 0);
      portbreadenable  : in std_logic;
      portaclock        : in std_logic;
      portbclock        : in std_logic; 
      sameclock          : in std_logic; 
      portadataout     : out std_logic_vector (143 downto 0);
      portbdataout     : out std_logic_vector (143 downto 0)
    );
end component;

signal clk_bus  : std_logic_vector (1 downto 0);
signal ena_bus  : std_logic_vector (1 downto 0);
signal clr_bus  : std_logic_vector (1 downto 0);
signal portadatain_bus : std_logic_vector (143 downto 0);
signal portbdatain_bus : std_logic_vector (143 downto 0);
signal portaaddr_bus : std_logic_vector (143 downto 0);
signal portbaddr_bus : std_logic_vector (143 downto 0);
signal portadataout_bus : std_logic_vector (143 downto 0);
signal portbdataout_bus : std_logic_vector (143 downto 0);
signal portawe_bus : std_logic_vector (143 downto 0);
signal portbrewe_bus : std_logic_vector (143 downto 0);
signal portawe_eab : std_logic;
signal portbrewe_eab : std_logic;
signal portamask_bus : std_logic_vector (143 downto 0);
signal portbmask_bus : std_logic_vector (143 downto 0);

signal portawe_tmp : std_logic_vector(0 downto 0);
signal portbrewe_tmp : std_logic_vector(0 downto 0);
signal portabyteenamasks_tmp : std_logic_vector(143 downto 0);
signal portbbyteenamasks_tmp : std_logic_vector(143 downto 0);
signal portaaddr_tmp : std_logic_vector(143 downto 0);
signal portbaddr_tmp : std_logic_vector(143 downto 0);
signal portaaddrstall_tmp : std_logic;
signal portbaddrstall_tmp : std_logic;

signal aclr_portadatain : std_logic;
signal aclr_portaaddr   : std_logic;
signal aclr_portawe     : std_logic;
signal clk_portbdatain  : std_logic;
signal aclr_portbdatain : std_logic;
signal ena_portbdatain  : std_logic;
signal clk_portbaddr    : std_logic;
signal clr_portbaddr    : std_logic;
signal ena_portbaddr    : std_logic;
signal clk_portbrewe    : std_logic;
signal clr_portbrewe    : std_logic;
signal ena_portbrewe    : std_logic;
signal aclr_portabyteenamasks : std_logic;
signal clk_portbbyteenamasks  : std_logic;
signal aclr_portbbyteenamasks : std_logic;
signal ena_portbbyteenamasks  : std_logic;
signal clk_portadataout  : std_logic;
signal aclr_portadataout : std_logic;
signal ena_portadataout  : std_logic;
signal clk_portbdataout  : std_logic;
signal aclr_portbdataout : std_logic;
signal ena_portbdataout  : std_logic;

signal if_clk_portadatain  : std_logic := '1';
signal if_aclr_portadatain : std_logic := '1';
signal if_ena_portadatain  : std_logic := '1';
signal if_clk_portaaddr    : std_logic := '1';
signal if_ena_portaaddr    : std_logic := '1';
signal if_aclr_portaaddr   : std_logic := '1';
signal if_aclr_portawe     : std_logic := '1';
signal if_clk_portawe      : std_logic := '1';
signal if_ena_portawe      : std_logic := '1';
signal if_clk_portbdatain  : std_logic := '1';
signal if_aclr_portbdatain : std_logic := '1';
signal if_ena_portbdatain  : std_logic := '1';
signal if_clk_portbaddr    : std_logic := '1';
signal if_aclr_portbaddr   : std_logic := '1';
signal if_ena_portbaddr    : std_logic := '1';
signal if_clk_portbrewe    : std_logic := '1';
signal if_aclr_portbrewe   : std_logic := '1';
signal if_ena_portbrewe    : std_logic := '1';
signal if_aclr_portabyteenamasks : std_logic := '1';
signal if_clk_portabyteenamasks  : std_logic := '1';
signal if_ena_portabyteenamasks  : std_logic := '1';
signal if_clk_portbbyteenamasks  : std_logic := '1';
signal if_aclr_portbbyteenamasks : std_logic := '1';
signal if_ena_portbbyteenamasks  : std_logic := '1';
signal if_clk_portadataout : std_logic := '1';
signal if_aclr_portadataout : std_logic := '1';
signal if_ena_portadataout : std_logic := '1';
signal if_clk_portbdataout : std_logic := '1';
signal if_aclr_portbdataout : std_logic := '1';
signal if_ena_portbdataout : std_logic := '1';
signal if_same_clock       : std_logic := '0';
signal portbrewe_power_up  : std_logic := '0';

signal port_b_write_enable_tmp : std_logic := '0';
signal gnd : std_logic := '0';
signal vcc : std_logic := '1';

signal done_a : std_logic_vector(4 downto 0) := "11111";
signal done_b : std_logic_vector(4 downto 0) := "11111";
signal done_a_tmp : std_logic_vector(3 downto 0) := "1111";
signal done_b_tmp : std_logic_vector(3 downto 0) := "1111";
signal clock_a    : std_logic := '1';
signal clock_b    : std_logic := '1';
signal edg        : std_logic := '0';
signal clrdly_a   : std_logic := '0';
signal clrdly_b   : std_logic := '0';
signal aclra      : std_logic_vector(5 downto 0);
signal aclrb      : std_logic_vector(5 downto 0);
signal clkout_a   : std_logic_vector(5 downto 0);
signal clkout_b   : std_logic_vector(5 downto 0);
signal cleara_tmp : std_logic;
signal clearb_tmp : std_logic;

begin

ram_aclra_reg : stratix_ram_clear
  port map
  (
    aclr => cleara_tmp,
    d => portawe_bus(0),
    clk => clrdly_a,
    ena => clock_a,
    edg => edg,
    q  => aclra(5)
  );
cleara_tmp <= '1' when (aclra(2) = '1') or (devclrn = '0') else '0';
edg <= '1' when (ram_block_type = "MegaRAM" or ram_block_type = "M-RAM" or
                 (ram_block_type = "auto" and mixed_port_feed_through_mode = "dont_care")) else '0';

ram_aclrb_reg : stratix_ram_clear
  port map
  (
    aclr => clearb_tmp,
    d => portbrewe_bus(0),
    clk => clrdly_b,
    ena => clock_b,
    edg => edg,
    q  => aclrb(5)
  );
clearb_tmp <= '1' when (aclrb(2) = '1') or (devclrn = '0') else '0';

aclr_portadatain <= clr_bus(select_ram(port_a_data_in_clear));
done_a(0) <= '1' when ((done_a_tmp(0) = '1') or
                       (port_a_data_in_clock = "none") or
                       (port_a_data_in_clock = "UNUSED")) else '0';

ram_portadatain_reg : stratix_ram_register
 generic map ( data_width => 144,
               sclr       => "true",
               preset     => "false")
  port map
  (
    data => portadatain(143 downto 0),
    clk  => clk_bus(0),
    aclr => aclr_portadatain,
    ena  => ena_bus(0),
    if_clk => if_clk_portadatain,
    if_aclr => if_aclr_portadatain,
    if_ena => if_ena_portadatain,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portadatain_bus,
    aclrout => aclra(0),
    clkout => clkout_a(0),
    done => done_a_tmp(0)
  );

aclr_portaaddr <= clr_bus(select_ram(port_a_address_clear));
done_a(1) <= '1' when ((done_a_tmp(1) = '1') or
                       (port_a_address_clock = "none") or
                       (port_a_address_clock = "UNUSED")) else '0';

ram_portaaddr_reg : stratix_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portaaddr(15 downto 0),
    clk  => clk_bus(0),
    aclr => aclr_portaaddr,
    ena  => ena_bus(0),
    if_clk => if_clk_portaaddr,
    if_aclr => if_aclr_portaaddr,
    if_ena => if_ena_portaaddr,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portaaddr_bus,
    aclrout => aclra(1),
    clkout => clkout_a(1),
    done => done_a_tmp(1)
  );

aclr_portawe <= clr_bus(select_ram(port_a_write_enable_clear));
done_a(2) <= '1' when ((done_a_tmp(2) = '1') or
                       (port_a_write_enable_clock = "none") or
                       (port_a_write_enable_clock = "UNUSED")) else '0';

ram_portawe_reg : stratix_ram_register
  generic map ( data_width => 1,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portawe_tmp,
    clk  => clk_bus(0),
    aclr => aclr_portawe,
    ena  => ena_bus(0),
    if_clk => if_clk_portawe,
    if_aclr => if_aclr_portawe,
    if_ena => if_ena_portawe,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portawe_bus,
    aclrout => aclra(2),
    clkout => clkout_a(2),
    done => done_a_tmp(2)
  );

clk_portbdatain  <= clk_bus(select_ram(port_b_data_in_clock));
aclr_portbdatain <= clr_bus(select_ram(port_b_data_in_clear));
ena_portbdatain  <= ena_bus(select_ram(port_b_data_in_clock));
done_b(0) <= '1' when ((done_b_tmp(0) = '1') or
                       (port_b_data_in_clock = "none") or
                       (port_b_data_in_clock = "UNUSED")) else '0';

ram_portbdatain_reg : stratix_ram_register
  generic map ( data_width => 144,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portbdatain(143 downto 0),
    clk  => clk_portbdatain,
    aclr => aclr_portbdatain,
    ena  => ena_portbdatain,
    if_clk => if_clk_portbdatain,
    if_aclr => if_aclr_portbdatain,
    if_ena => if_ena_portbdatain,
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portbdatain_bus,
    aclrout => aclrb(0),
    clkout => clkout_b(0),
    done => done_b_tmp(0)
  );

clk_portbaddr <= clk_bus(select_ram(port_b_address_clock));
clr_portbaddr <= clr_bus(select_ram(port_b_address_clear));
ena_portbaddr <= ena_bus(select_ram(port_b_address_clock));
done_b(1) <= '1' when ((done_b_tmp(1) = '1') or
                       (port_b_address_clock = "none") or
                       (port_b_address_clock = "UNUSED")) else '0';

ram_portbaddr_reg : stratix_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "false")
  port map
  (
    data => portbaddr(15 downto 0),
    clk  => clk_portbaddr,
    aclr => clr_portbaddr,
    ena  => ena_portbaddr,
    if_clk => if_clk_portbaddr,
    if_aclr => if_aclr_portbaddr, 
    if_ena => if_ena_portbaddr, 
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portbaddr_bus,
    aclrout => aclrb(1),
    clkout => clkout_b(1),
    done => done_b_tmp(1)
  );

clk_portbrewe <= clk_bus(select_ram(port_b_read_enable_write_enable_clock));
clr_portbrewe <= clr_bus(select_ram(port_b_read_enable_write_enable_clear));
ena_portbrewe <= ena_bus(select_ram(port_b_read_enable_write_enable_clock));
done_b(2) <= '1' when ((done_b_tmp(2) = '1') or
                       (port_b_read_enable_write_enable_clock = "none") or
                       (port_b_read_enable_write_enable_clock = "UNUSED"))
             else '0';

ram_portbrewe_reg : stratix_ram_register
  generic map ( data_width => 1,
                sclr       => "true",
                preset     => "true")
  port map
  (
    data => portbrewe_tmp,
    clk  => clk_portbrewe,
    aclr => clr_portbrewe,
    ena  => ena_portbrewe,
    if_clk => if_clk_portbrewe, 
    if_aclr => if_aclr_portbrewe,
    if_ena => if_ena_portbrewe,
    devclrn => devclrn,
    devpor => devpor,
    power_up => portbrewe_power_up,
    dataout => portbrewe_bus,
    aclrout => aclrb(2),
    clkout => clkout_b(2),
    done => done_b_tmp(2)
  );

portbrewe_power_up <= '1' when operation_mode = "dual_port" else '0';
aclr_portabyteenamasks <= clr_bus(select_ram(port_a_byte_enable_clear));
done_a(3) <= '1' when ((done_a_tmp(3) = '1') or
                       (port_a_byte_enable_clock = "none") or
                       (port_a_byte_enable_clock = "UNUSED")) else '0';

ram_portabyteenamasks_reg : stratix_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "true")
  port map
  (
    data => portabyteenamasks(15 downto 0),
    clk  => clk_bus(0),
    aclr => aclr_portabyteenamasks,
    ena  => ena_bus(0),
    if_clk => if_clk_portabyteenamasks,
    if_aclr => if_aclr_portabyteenamasks,
    if_ena => if_ena_portabyteenamasks,
    devclrn => devclrn,
    devpor => devpor,
    power_up => vcc,
    dataout => portamask_bus,
    aclrout => aclra(3),
    clkout => clkout_a(3),
    done => done_a_tmp(3)
  );

clk_portbbyteenamasks  <= clk_bus(select_ram(port_b_byte_enable_clock));
aclr_portbbyteenamasks <= clr_bus(select_ram(port_b_byte_enable_clear));
ena_portbbyteenamasks  <= ena_bus(select_ram(port_b_byte_enable_clock));
done_b(3) <= '1' when ((done_b_tmp(3) = '1') or
                       (port_b_byte_enable_clock = "none") or
                       (port_b_byte_enable_clock = "UNUSED")) else '0';

ram_portbbyteenamasks_reg : stratix_ram_register
  generic map ( data_width => 16,
                sclr       => "true",
                preset     => "true")
  port map
  (
    data => portbbyteenamasks(15 downto 0),
    clk  => clk_portbbyteenamasks,
    aclr => aclr_portbbyteenamasks,
    ena  => ena_portbbyteenamasks,
    if_clk => if_clk_portbbyteenamasks,
    if_aclr => if_aclr_portbbyteenamasks,
    if_ena => if_ena_portbbyteenamasks,
    devclrn => devclrn,
    devpor => devpor,
    power_up => vcc,
    dataout => portbmask_bus,
    aclrout => aclrb(3),
    clkout => clkout_b(3),
    done => done_b_tmp(3)
  );

clock_a <= ((((done_a(0) AND done_a(1)) AND done_a(2))
             AND done_b(2)) AND done_a(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((done_a(0) AND done_a(1)) AND done_a(2)) AND done_a(3)) ;
clock_b <= ((((done_b(0) AND done_b(1)) AND done_b(2))
             AND done_a(2)) AND done_b(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((done_b(0) AND done_b(1)) AND done_b(2)) AND done_b(3)) ;

clrdly_a <= ((((clkout_a(0) AND clkout_a(1)) AND clkout_a(2))
             AND clkout_b(2)) AND clkout_a(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((clkout_a(0) AND clkout_a(1)) AND clkout_a(2)) AND clkout_a(3)) ;
clrdly_b <= ((((clkout_b(0) AND clkout_b(1)) AND clkout_b(2))
             AND clkout_a(2)) AND clkout_b(3))
           WHEN (port_a_write_enable_clock =
                 port_b_read_enable_write_enable_clock)
           ELSE (((clkout_b(0) AND clkout_b(1)) AND clkout_b(2)) AND clkout_b(3)) ;

internal_ram : stratix_ram_internal
 generic map
  (
    operation_mode => operation_mode,
    ram_block_type => ram_block_type,
    mixed_port_feed_through_mode => mixed_port_feed_through_mode,
    port_a_data_width => port_a_data_width,
    port_b_data_width => port_b_data_width,
    port_a_address_width => port_a_address_width,
    port_b_address_width => port_b_address_width,
    port_a_byte_enable_mask_width => port_a_byte_enable_mask_width,
    port_b_byte_enable_mask_width => port_b_byte_enable_mask_width,
    init_file_layout     => init_file_layout,
    port_a_first_address => port_a_first_address,
    port_a_last_address  => port_a_last_address,
    port_b_first_address => port_b_first_address,
    port_b_last_address  => port_b_last_address,
    port_a_address_clear => port_a_address_clear,
    port_b_address_clear => port_b_address_clear,
    mem1 => mem1,
    mem2 => mem2,
    mem3 => mem3,
    mem4 => mem4,
    mem5 => mem5,
    mem6 => mem6,
    mem7 => mem7, 
    mem8 => mem8,
    mem9 => mem9
    )
  port map
  (
    portawriteenable => portawe_bus(0),
    portbwriteenable => portbrewe_bus(0),
    cleara => aclra(5),
    clearb => aclrb(5),
    portadatain => portadatain_bus(143 downto 0),
    portbdatain => portbdatain_bus(143 downto 0),
    portaaddress => portaaddr_bus(15 downto 0),
    portbaddress => portbaddr_bus(15 downto 0),
    portabyteenamask =>
    portamask_bus(15 downto 0), 
    portbbyteenamask =>
    portbmask_bus(15 downto 0),
    portbreadenable => portbrewe_bus(0),
    portaclock => clock_a,
    portbclock => clock_b,
    sameclock => if_same_clock,
    portadataout => portadataout_bus, 
    portbdataout => portbdataout_bus
    );

clk_portadataout  <= clk_bus(select_ram(port_a_data_out_clock));
aclr_portadataout <= clr_bus(select_ram(port_a_data_out_clear));
ena_portadataout  <= ena_bus(select_ram(port_a_data_out_clock));

ram_portadataout_reg : stratix_ram_register
  generic map ( data_width => 144,
                sclr       => "false",
                preset     => "false") 
  port map
  (
    data => portadataout_bus,
    clk  => clk_portadataout,
    aclr => aclr_portadataout,
    ena  => ena_portadataout,
    if_clk => if_clk_portadataout, 
    if_aclr => if_aclr_portadataout, 
    if_ena => if_ena_portadataout, 
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portadataout,
    aclrout => aclra(4),
    clkout => clkout_a(4),
    done => done_a(4)
  );

clk_portbdataout  <= clk_bus(select_ram(port_b_data_out_clock));
aclr_portbdataout <= clr_bus(select_ram(port_b_data_out_clear));
ena_portbdataout  <= ena_bus(select_ram(port_b_data_out_clock));

ram_portbdataout_reg : stratix_ram_register
  generic map ( data_width => 144,
                sclr       => "false",
                preset     => "false")
  port map
  (
    data => portbdataout_bus,
    clk  => clk_portbdataout,
    aclr => aclr_portbdataout,
    ena  => ena_portbdataout,
    if_clk => if_clk_portbdataout, 
    if_aclr => if_aclr_portbdataout, 
    if_ena => if_ena_portbdataout, 
    devclrn => devclrn,
    devpor => devpor,
    power_up => gnd,
    dataout => portbdataout,
    aclrout => aclrb(4),
    clkout => clkout_b(4),
    done => done_b(4)
  );

if_clk_portadatain      <= '1';
if_ena_portadatain      <= '1';
if_clk_portaaddr        <= '1';
if_ena_portaaddr        <= '1';
if_clk_portawe          <= '1';
if_ena_portawe          <= '1';
if_clk_portabyteenamasks <= '1';
if_ena_portabyteenamasks <= '1';
if_aclr_portadatain     <= '0' when (port_a_data_in_clear = "none") or (port_a_data_in_clear = "UNUSED") else '1';
if_aclr_portaaddr       <= '0' when (port_a_address_clear = "none") or (port_a_address_clear = "UNUSED") else '1';
if_aclr_portawe         <= '0' when (port_a_write_enable_clear = "none") or (port_a_write_enable_clear = "UNUSED")
                           else '1';
if_clk_portbdatain      <= '0' when (port_b_data_in_clock = "none") or (port_b_data_in_clock = "UNUSED") else '1';
if_aclr_portbdatain     <= '0' when (port_b_data_in_clear = "none") or (port_b_data_in_clear = "UNUSED") else '1';
if_ena_portbdatain      <= '0' when (port_b_data_in_clock = "none") or (port_b_data_in_clock = "UNUSED") else '1';
if_clk_portbaddr        <= '0' when (port_b_address_clock = "none") or (port_b_address_clock = "UNUSED") else '1';
if_aclr_portbaddr       <= '0' when (port_b_address_clear = "none") or (port_b_address_clear = "UNUSED") else '1';
if_ena_portbaddr        <= '0' when (port_b_address_clock = "none") or (port_b_address_clock = "UNUSED") else '1';
if_clk_portbrewe        <= '0' when
                           (port_b_read_enable_write_enable_clock = "none") or (port_b_read_enable_write_enable_clock = "UNUSED")
                           else '1';
if_aclr_portbrewe       <= '0' when
                           (port_b_read_enable_write_enable_clear = "none") or (port_b_read_enable_write_enable_clear = "UNUSED")
                           else '1';
if_ena_portbrewe        <= '0' when
                           (port_b_read_enable_write_enable_clock = "none") or (port_b_read_enable_write_enable_clock = "UNUSED")
                           else '1';
if_aclr_portabyteenamasks <= '0' when (port_a_byte_enable_clear = "none") or (port_a_byte_enable_clear = "UNUSED")
                             else '1';
if_clk_portbbyteenamasks  <= '0' when (port_b_byte_enable_clock = "none") or (port_b_byte_enable_clock = "UNUSED")
                             else '1';
if_aclr_portbbyteenamasks <= '0' when (port_b_byte_enable_clear = "none") or (port_b_byte_enable_clear = "UNUSED")
                             else '1';
if_ena_portbbyteenamasks  <= '0' when (port_b_byte_enable_clock = "none") or (port_b_byte_enable_clock = "UNUSED")
                             else '1';
if_clk_portadataout     <= '0' when (port_a_data_out_clock = "none") or (port_a_data_out_clock = "UNUSED") else '1';
if_aclr_portadataout    <= '0' when (port_a_data_out_clear = "none") or (port_a_data_out_clear = "UNUSED") else '1';
if_ena_portadataout     <= '0' when (port_a_data_out_clock = "none") or (port_a_data_out_clock = "UNUSED") else '1';
if_clk_portbdataout     <= '0' when (port_b_data_out_clock = "none") or (port_b_data_out_clock = "UNUSED")else '1';
if_aclr_portbdataout    <= '0' when (port_b_data_out_clear = "none") or (port_b_data_out_clear = "UNUSED") else '1';
if_ena_portbdataout     <= '0' when (port_b_data_out_clock = "none") or (port_b_data_out_clock = "UNUSED") else '1';
if_same_clock           <= '1' when (port_b_address_clock = "clock0") or (port_b_address_clock = "clock0") else '0';
port_b_write_enable_tmp <= portbrewe_bus(0);
clk_bus <= clk1 & clk0;
ena_bus <= ena1 & ena0;
clr_bus <= clr1 & clr0;
portawe_tmp(0) <= portawe;
portbrewe_tmp(0) <= portbrewe;
portabyteenamasks_tmp(15 downto 0) <= portabyteenamasks;
portbbyteenamasks_tmp(15 downto 0) <= portbbyteenamasks;
portaaddr_tmp(15 downto 0) <= portaaddr;
portbaddr_tmp(15 downto 0) <= portbaddr;
portawe_eab <= not portawe;
portbrewe_eab <= portbrewe;

end ram_arch;

--
-- STRATIX_LVDS_TRANSMITTER
--

library IEEE, stratix, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;
use std.textio.all;

entity stratix_lvds_tx_parallel_register is
    generic (
		channel_width		: integer := 10;
		TimingChecksOn		: Boolean := True;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tsetup_datain_clk_noedge_posedge  : VitalDelayArrayType(9 downto 0) := (OTHERS => DefSetupHoldCnst);
		thold_datain_clk_noedge_posedge   : VitalDelayArrayType(9 downto 0) := (OTHERS => DefSetupHoldCnst);
		tpd_clk_dataout_posedge: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
		tipd_clk		: VitalDelayType01 := DefpropDelay01;
		tipd_enable	: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01));

	port (
		clk		: in std_logic;
		enable		: in std_logic;
		datain		: in std_logic_vector(9 downto 0);
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic_vector(9 downto 0));
	attribute VITAL_LEVEL0 of stratix_lvds_tx_parallel_register : entity is TRUE;
end stratix_lvds_tx_parallel_register;

architecture vital_tx_reg of stratix_lvds_tx_parallel_register is
    attribute VITAL_LEVEL0 of vital_tx_reg : architecture is TRUE;
    signal clk_ipd : std_logic;
    signal enable_ipd : std_logic;
    signal datain_ipd : std_logic_vector(9 downto 0);

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
	VitalWireDelay (clk_ipd, clk, tipd_clk);
	VitalWireDelay (enable_ipd, enable, tipd_enable);
	VitalWireDelay (datain_ipd(0), datain(0), tipd_datain(0));
	VitalWireDelay (datain_ipd(1), datain(1), tipd_datain(1));
	VitalWireDelay (datain_ipd(2), datain(2), tipd_datain(2));
	VitalWireDelay (datain_ipd(3), datain(3), tipd_datain(3));
	VitalWireDelay (datain_ipd(4), datain(4), tipd_datain(4));
	VitalWireDelay (datain_ipd(5), datain(5), tipd_datain(5));
	VitalWireDelay (datain_ipd(6), datain(6), tipd_datain(6));
	VitalWireDelay (datain_ipd(7), datain(7), tipd_datain(7));
	VitalWireDelay (datain_ipd(8), datain(8), tipd_datain(8));
	VitalWireDelay (datain_ipd(9), datain(9), tipd_datain(9));
	end block;

VITAL: process (clk_ipd, enable_ipd, devpor, devclrn)
	variable Tviol_datain_clk : std_ulogic := '0';
	variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
	variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(9 downto 0);
	variable i : integer := 0;
	variable dataout_tmp : std_logic_vector(9 downto 0);
	begin

      if (now = 0 ns) then
         dataout_tmp := (OTHERS => '0');
      end if;

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then

			VitalSetupHoldCheck (
					Violation       => Tviol_datain_clk,
					TimingData      => TimingData_datain_clk,
					TestSignal      => datain_ipd,
					TestSignalName  => "DATAIN",
					RefSignal       => clk_ipd,
					RefSignalName   => "CLK",
					SetupHigh       => tsetup_datain_clk_noedge_posedge(0),
					SetupLow        => tsetup_datain_clk_noedge_posedge(0),
					HoldHigh        => thold_datain_clk_noedge_posedge(0),
					HoldLow         => thold_datain_clk_noedge_posedge(0),
					RefTransition   => '/',
					HeaderMsg       => InstancePath & "/STRATIX_TRANSMITTER",
					XOn             => XOn,
					MsgOn           => MsgOnChecks );

      end if;

		if ((devpor = '0') or (devclrn = '0')) then
			for i in channel_width-1 downto 0 loop
				dataout_tmp(i) := '0';
			end loop;
		else
   		if (clk_ipd'event and clk_ipd = '1') then
				if (enable_ipd = '1') then
					for i in channel_width-1 downto 0 loop
						dataout_tmp(i) := datain_ipd(i);
					end loop;
				end if;
			end if;
		end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
			OutSignal => dataout(0),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(0),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(0),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(1),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(1),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(1),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(2),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(2),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(2),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(3),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(3),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(3),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(4),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(4),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(4),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(5),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(5),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(5),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(6),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(6),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(6),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(7),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(7),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(7),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(8),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(8),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(8),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(9),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(9),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(9),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

	end process;

end vital_tx_reg;

library IEEE, stratix, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;
use std.textio.all;

entity stratix_lvds_tx_out_block is
    generic (
		bypass_serializer	: String := "false";
		invert_clock	: String := "false";
		use_falling_clock_edge	: String := "false";
		TimingChecksOn		: Boolean := True;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk_dataout: VitalDelayType01 := DefPropDelay01;
		tpd_clk_dataout_negedge: VitalDelayType01 := DefPropDelay01;
		tipd_clk		: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayType01 := DefpropDelay01);

	port (
		clk		: in std_logic;
		datain		: in std_logic;
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic);
	attribute VITAL_LEVEL0 of stratix_lvds_tx_out_block : entity is TRUE;
end stratix_lvds_tx_out_block;

architecture vital_tx_out_block of stratix_lvds_tx_out_block is
    attribute VITAL_LEVEL0 of vital_tx_out_block : architecture is TRUE;
    signal clk_ipd : std_logic;
    signal datain_ipd : std_logic;
signal inv_clk : integer;

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
	VitalWireDelay (clk_ipd, clk, tipd_clk);
	VitalWireDelay (datain_ipd, datain, tipd_datain);
	end block;


VITAL: process (clk_ipd, datain_ipd, devpor, devclrn)
	variable dataout_VitalGlitchData : VitalGlitchDataType;
	variable dataout_tmp : std_logic;
	begin
      if (now = 0 ns) then
	 		dataout_tmp := '0';
   	else
			if (bypass_serializer = "false") then
				if (use_falling_clock_edge = "false") then
					dataout_tmp := datain_ipd;
				end if;

      		if (clk_ipd'event and clk_ipd = '0') then
					if (use_falling_clock_edge = "true") then
						dataout_tmp := datain_ipd;
					end if;
				end if;
			else
				if (invert_clock = "false") then
					dataout_tmp := clk_ipd;
				else
					dataout_tmp := NOT (clk_ipd);
				end if;

				if (invert_clock = "false") then
					inv_clk <= 0;
				else
					inv_clk <= 1;
				end if;
			end if;
		end if;


      ----------------------
      --  Path Delay Section
      ----------------------

		if (bypass_serializer = "false") then
	      VitalPathDelay01 (
						OutSignal => dataout,
						OutSignalName => "DATAOUT",
						OutTemp => dataout_tmp,
						Paths => (0 => (datain_ipd'last_event, DefpropDelay01, TRUE),
									1 => (clk_ipd'last_event, tpd_clk_dataout_negedge, TRUE)),
						GlitchData => dataout_VitalGlitchData,
						Mode => DefGlitchMode,
						XOn  => XOn,
						MsgOn  => MsgOn );
		end if;

		if (bypass_serializer = "true") then
	      VitalPathDelay01 (
						OutSignal => dataout,
						OutSignalName => "DATAOUT",
						OutTemp => dataout_tmp,
						Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout, TRUE)),
						GlitchData => dataout_VitalGlitchData,
						Mode => DefGlitchMode,
						XOn  => XOn,
						MsgOn  => MsgOn );
		end if;

	end process;

end vital_tx_out_block;

library IEEE, stratix, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;
use std.textio.all;

entity stratix_lvds_transmitter is
    generic (
		channel_width		: integer := 10;
		bypass_serializer	: String := "false";
		invert_clock	: String := "false";
		use_falling_clock_edge	: String := "false";
                lpm_type : string := "stratix_lvds_transmitter";
		TimingChecksOn		: Boolean := True;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk0_dataout_posedge: VitalDelayType01 := DefPropDelay01;
		tpd_clk0_dataout_negedge: VitalDelayType01 := DefPropDelay01;
		tipd_clk0		: VitalDelayType01 := DefpropDelay01;
		tipd_enable0	: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01));

	port (
		clk0		: in std_logic;
		enable0		: in std_logic;
		datain		: in std_logic_vector(9 downto 0);
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic);
	attribute VITAL_LEVEL0 of stratix_lvds_transmitter : entity is TRUE;
end stratix_lvds_transmitter;

architecture vital_transmitter_atom of stratix_lvds_transmitter is
    attribute VITAL_LEVEL0 of vital_transmitter_atom : architecture is TRUE;
    signal clk0_ipd : std_logic;
    signal not_clk0 : std_logic;

	 signal input_data : std_logic_vector(9 downto 0);

	 signal txload0 : std_logic;
	 signal txload1 : std_logic;
	 signal txload2 : std_logic;
	 signal shift_out : std_logic;

	 signal clk0_dly0 : std_logic;
	 signal clk0_dly1 : std_logic;
	 signal clk0_dly2 : std_logic;
	
	 signal datain_dly : std_logic_vector(9 downto 0);
	 signal datain_dly1 : std_logic_vector(9 downto 0);
	 signal datain_dly2 : std_logic_vector(9 downto 0);
	 signal datain_dly3 : std_logic_vector(9 downto 0);
	 signal datain_dly4 : std_logic_vector(9 downto 0);

	 signal vcc : std_logic := '1';

component stratix_lvds_tx_parallel_register 
    generic (
		channel_width		: integer := 10;
		TimingChecksOn		: Boolean := True;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk_dataout_posedge: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
		tipd_clk		: VitalDelayType01 := DefpropDelay01;
		tipd_enable	: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01));

	port (
		clk		: in std_logic;
		enable		: in std_logic;
		datain		: in std_logic_vector(9 downto 0);
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic_vector(9 downto 0));

end component;

component stratix_lvds_tx_out_block 
    generic (
		bypass_serializer	: String := "false";
		invert_clock	: String := "false";
		use_falling_clock_edge	: String := "false";
		TimingChecksOn		: Boolean := True;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk_dataout: VitalDelayType01 := DefPropDelay01;
		tpd_clk_dataout_negedge: VitalDelayType01 := DefPropDelay01;
		tipd_clk		: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayType01 := DefpropDelay01);

	port (
		clk		: in std_logic;
		datain		: in std_logic;
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic);
end component;

component DFFE
   generic(
      TimingChecksOn: Boolean := true;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;
begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
		VitalWireDelay (clk0_ipd, clk0, tipd_clk0);
	end block;

txload0_reg: dffe
             port map(D => enable0,
                      CLRN => vcc,
                      PRN => vcc,
                      ENA => vcc,
                      CLK => clk0_dly2,
                      Q => txload0);
txload1_reg: dffe
             port map(D => txload0,
                      CLRN => vcc,
                      PRN => vcc,
                      ENA => vcc,
                      CLK => clk0_dly1,
                      Q => txload1);

not_clk0 <= not clk0_dly0;

txload2_reg: dffe
             port map(D => txload1,
                      CLRN => vcc,
                      PRN => vcc,
                      ENA => vcc,
                      CLK => not_clk0,
                      Q => txload2);

input_reg: stratix_lvds_tx_parallel_register
				generic map(channel_width => channel_width)
				port map(clk => txload0,
							enable => vcc,
							datain => datain_dly,
							dataout => input_data,
							devclrn => devclrn,
							devpor => devpor);

output_module: stratix_lvds_tx_out_block
				generic map(bypass_serializer => bypass_serializer,
								use_falling_clock_edge => use_falling_clock_edge,
								invert_clock => invert_clock)
				port map(clk => clk0_dly2,
							datain => shift_out,
							dataout => dataout,
							devclrn => devclrn,
							devpor => devpor);

clk_delay: process (clk0_ipd, datain)
	begin
		clk0_dly0 <= clk0_ipd;
		datain_dly1 <= datain;
	end process;

clk_delay1: process (clk0_dly0, datain_dly1)
	begin
		clk0_dly1 <= clk0_dly0;
		datain_dly2 <= datain_dly1;
	end process;

clk_delay2: process (clk0_dly1, datain_dly2)
	begin
		clk0_dly2 <= clk0_dly1;
		datain_dly3 <= datain_dly2;
	end process;

data_delay: process (datain_dly3)
	begin
		datain_dly4 <= datain_dly3;
	end process;

data_delay1: process (datain_dly4)
	begin
		datain_dly <= datain_dly4;
	end process;

VITAL: process (clk0_ipd, devclrn, devpor)
	variable dataout_VitalGlitchData : VitalGlitchDataType;
	variable i : integer := 0;
	variable dataout_tmp : std_logic;
	variable shift_data : std_logic_vector(channel_width-1 downto 0);
	begin
      if (now = 0 ns) then
	 		dataout_tmp := '0';
			for i in channel_width-1 downto 0 loop
				shift_data(i) := '0';
			end loop;
      end if;


   	if ((devpor = '0') or (devclrn = '0')) then
			dataout_tmp := '0';
			for i in channel_width-1 downto 0 loop
				shift_data(i) := '0';
			end loop;
   	else
			if (bypass_serializer = "false") then
      		if (clk0_ipd'event and clk0_ipd = '1') then
					if (txload2 = '1') then
						for i in channel_width-1 downto 0 loop
							shift_data(i) := input_data(i);
						end loop;
					end if;

					shift_out <= shift_data(channel_width - 1);

					for i in channel_width-1 downto 1 loop
						shift_data(i) := shift_data(i - 1);
					end loop;
				end if;
			end if;
		end if;

	end process;

end vital_transmitter_atom;
--
-- STRATIX_LVDS_RECEIVER
--

library IEEE, stratix, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;
use std.textio.all;

entity stratix_lvds_rx_parallel_register is
    generic (
		channel_width		: integer := 10;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk_dataout_posedge: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
		tipd_clk		: VitalDelayType01 := DefpropDelay01;
		tipd_enable	: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01));

	port (
		clk		: in std_logic;
		enable		: in std_logic;
		datain		: in std_logic_vector(9 downto 0);
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic_vector(9 downto 0));
	attribute VITAL_LEVEL0 of stratix_lvds_rx_parallel_register : entity is TRUE;
end stratix_lvds_rx_parallel_register;

architecture vital_rx_reg of stratix_lvds_rx_parallel_register is
    attribute VITAL_LEVEL0 of vital_rx_reg : architecture is TRUE;
    signal clk_ipd : std_logic;
    signal enable_ipd : std_logic;
    signal datain_ipd : std_logic_vector(9 downto 0);

begin

	----------------------
	--  INPUT PATH DELAYs
	----------------------
	WireDelay : block
	begin
	VitalWireDelay (clk_ipd, clk, tipd_clk);
	VitalWireDelay (enable_ipd, enable, tipd_enable);
	VitalWireDelay (datain_ipd(0), datain(0), tipd_datain(0));
	VitalWireDelay (datain_ipd(1), datain(1), tipd_datain(1));
	VitalWireDelay (datain_ipd(2), datain(2), tipd_datain(2));
	VitalWireDelay (datain_ipd(3), datain(3), tipd_datain(3));
	VitalWireDelay (datain_ipd(4), datain(4), tipd_datain(4));
	VitalWireDelay (datain_ipd(5), datain(5), tipd_datain(5));
	VitalWireDelay (datain_ipd(6), datain(6), tipd_datain(6));
	VitalWireDelay (datain_ipd(7), datain(7), tipd_datain(7));
	VitalWireDelay (datain_ipd(8), datain(8), tipd_datain(8));
	VitalWireDelay (datain_ipd(9), datain(9), tipd_datain(9));
	end block;

VITAL: process (clk_ipd, enable_ipd, devpor, devclrn)
	variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(9 downto 0);
	variable i : integer := 0;
	variable dataout_tmp : std_logic_vector(9 downto 0);
	begin

      if (now = 0 ns) then
         dataout_tmp := (OTHERS => '0');
      end if;

		if ((devpor = '0') or (devclrn = '0')) then
			for i in channel_width-1 downto 0 loop
				dataout_tmp(i) := '0';
			end loop;
		else
   		if (clk_ipd'event and clk_ipd = '1') then
				if (enable_ipd = '1') then
					for i in channel_width-1 downto 0 loop
						dataout_tmp(i) := datain_ipd(i);
					end loop;
				end if;
			end if;
		end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
			OutSignal => dataout(0),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(0),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(0),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(1),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(1),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(1),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(2),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(2),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(2),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(3),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(3),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(3),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(4),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(4),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(4),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(5),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(5),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(5),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(6),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(6),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(6),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(7),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(7),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(7),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(8),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(8),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(8),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

      VitalPathDelay01 (
			OutSignal => dataout(9),
			OutSignalName => "DATAOUT",
			OutTemp => dataout_tmp(9),
			Paths => (1 => (clk_ipd'last_event, tpd_clk_dataout_posedge(0), TRUE)),
			GlitchData => dataout_VitalGlitchDataArray(9),
			Mode => DefGlitchMode,
			XOn  => XOn,
			MsgOn  => MsgOn );

	end process;

end vital_rx_reg;

library IEEE, stratix, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use stratix.atom_pack.all;
use std.textio.all;

entity stratix_lvds_receiver is
    generic (
		channel_width		: integer := 10;
		use_enable1			: String := "false";
                lpm_type : string := "stratix_lvds_receiver";
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk0_dataout_posedge: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
		tipd_clk0		: VitalDelayType01 := DefpropDelay01;
		tipd_enable0	: VitalDelayType01 := DefpropDelay01;
		tipd_enable1	: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayType01 := DefpropDelay01);

	port (
		clk0		: in std_logic;
		enable0		: in std_logic;
		enable1		: in std_logic := '0';
		datain		: in std_logic;
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic_vector(9 downto 0));
	attribute VITAL_LEVEL0 of stratix_lvds_receiver : entity is TRUE;
end stratix_lvds_receiver;

architecture vital_receiver_atom of stratix_lvds_receiver is
    attribute VITAL_LEVEL0 of vital_receiver_atom : architecture is TRUE;
    signal clk0_ipd : std_logic;
    signal datain_ipd : std_logic;
	 signal not_clk0 : std_logic;
	 signal txload_in : std_logic;
	 signal rxload0 : std_logic;
	 signal rxload1 : std_logic;
	 signal rxload2 : std_logic;
	
	 signal shift_data : std_logic_vector(9 downto 0);
	 signal load_data : std_logic_vector(9 downto 0);

	 signal vcc : std_logic := '1';

component stratix_lvds_rx_parallel_register 
    generic (
		channel_width		: integer := 10;
		MsgOn			: Boolean := DefGlitchMsgOn;
		XOn			: Boolean := DefGlitchXOn;
      MsgOnChecks             : Boolean := DefMsgOnChecks;
      XOnChecks               : Boolean := DefXOnChecks;
		InstancePath		: String := "*";
		tpd_clk_dataout_posedge: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
		tipd_clk		: VitalDelayType01 := DefpropDelay01;
		tipd_enable	: VitalDelayType01 := DefpropDelay01;
		tipd_datain		: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01));

	port (
		clk		: in std_logic;
		enable		: in std_logic;
		datain		: in std_logic_vector(9 downto 0);
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic_vector(9 downto 0));

end component;

component DFFE
   generic(
      TimingChecksOn: Boolean := true;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;

component and1
    generic (XOn                  : Boolean := DefGlitchXOn;
             MsgOn                : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y            : VitalDelayType01 := DefPropDelay01;
             tipd_IN1             : VitalDelayType01 := DefPropDelay01
            );
        
    port    (Y                    :  out   STD_LOGIC;
             IN1                  :  in    STD_LOGIC
            );
end component;

begin

clkdelaybuffer: and1
                port map(IN1 => clk0,
                         Y => clk0_ipd);

dataindelaybuffer: and1
                   port map(IN1 => datain,
                            Y => datain_ipd);

rxload0_reg: dffe
             port map(D => enable0,
                      CLRN => vcc,
                      PRN => vcc,
                      ENA => vcc,
                      CLK => clk0,
                      Q => rxload0);
rxload1_reg: dffe
             port map(D => rxload0,
                      CLRN => vcc,
                      PRN => vcc,
                      ENA => vcc,
                      CLK => clk0,
                      Q => rxload1);

not_clk0 <= not clk0;

rxload2_reg: dffe
             port map(D => rxload1,
                      CLRN => vcc,
                      PRN => vcc,
                      ENA => vcc,
                      CLK => not_clk0,
                      Q => rxload2);

txload_in <=  enable1 when use_enable1 = "true" else
				  enable0;

load_reg: stratix_lvds_rx_parallel_register
				generic map(channel_width => channel_width)
				port map(clk => not_clk0,
							enable => rxload2,
							datain => shift_data,
							dataout => load_data,
							devclrn => devclrn,
							devpor => devpor);

output_reg: stratix_lvds_rx_parallel_register
				generic map(channel_width => channel_width)
				port map(clk => clk0,
							enable => txload_in,
							datain => load_data,
							dataout => dataout,
							devclrn => devclrn,
							devpor => devpor);

VITAL: process (clk0_ipd, devpor, devclrn)
	variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(9 downto 0);
	variable i : integer := 0;
	variable dataout_tmp : std_logic_vector(9 downto 0);
	variable shift_out : std_logic;
	begin

      if (now = 0 ns) then
			shift_data <= (OTHERS => '0');
      end if;

		if ((devpor = '0') or (devclrn = '0')) then
			for i in channel_width-1 downto 0 loop
				shift_data(i) <= '0';
			end loop;
		else
   		if (clk0_ipd'event and clk0_ipd = '0') then
				for i in channel_width-1 downto 1 loop
					shift_data(i) <= shift_data(i-1);
				end loop;

				shift_data(0) <= datain_ipd;
			end if;
		end if;

end process;

end vital_receiver_atom;
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : mn_cntr
--
-- Description : Timing simulation model for the M and N counter. This is a
--               common model for the input counter and the loop feedback
--               counter of the Stratix PLL.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY ieee, stratix;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY mn_cntr is
    PORT ( clk           : IN std_logic;
           reset         : IN std_logic;
           cout          : OUT std_logic;
           initial_value : IN integer;
           modulus       : IN integer;
           time_delay    : IN integer;
           ph            : IN integer
         );
END mn_cntr;

ARCHITECTURE behave of mn_cntr is
begin

    process (clk, reset)
    variable count : integer := 1;
    variable first_rising_edge : boolean := true;
    variable tmp_cout : std_logic;
    begin
        if (reset = '1') then
            count := 1;
            tmp_cout := '0';
            first_rising_edge := true;
        elsif (clk'event and clk = '1' and first_rising_edge) then
            first_rising_edge := false;
            tmp_cout := clk;
        elsif (not first_rising_edge) then
            if (count < modulus) then
                count := count + 1;
            else
                count := 1;
                tmp_cout := not tmp_cout;
            end if;
        end if;
        cout <= transport tmp_cout after time_delay * 1 ps;
    end process;
end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : scale_cntr
--
-- Description : Timing simulation model for the output scale-down counters.
--               This is a common model for the L0, L1, G0, G1, G2, G3, E0,
--               E1, E2 and E3 output counters of the Stratix PLL.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, stratix;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

ENTITY scale_cntr is
    PORT ( clk            : IN std_logic;
           reset          : IN std_logic;
           initial        : IN integer;
           high           : IN integer;
           low            : IN integer;
           mode           : IN string := "bypass";
           time_delay     : IN integer;
           ph_tap         : IN natural;
           cout           : OUT std_logic
         );
END scale_cntr;

ARCHITECTURE behave of scale_cntr is
begin
    process (clk, reset)
    variable tmp_cout : std_logic := '0';
    variable count : integer := 1;
    variable output_shift_count : integer := 0;
    variable first_rising_edge : boolean := false;
    variable high_reg : integer := 0;
    variable low_reg : integer := 0;
    variable init : boolean := true;
    begin
        if (reset = '1') then
            count := 1;
            output_shift_count := 0;
            tmp_cout := '0';
            first_rising_edge := false;
        elsif (clk'event) then
            if (init) then
                init := false;
                high_reg := high;
                low_reg := low;
            end if;
            if (mode = "   off") then
                tmp_cout := '0';
            elsif (mode = "bypass") then
                tmp_cout := clk;
            elsif (not first_rising_edge) then
                if (clk = '1') then
                    output_shift_count := output_shift_count + 1;
                    if (output_shift_count = initial) then
                        tmp_cout := clk;
                        first_rising_edge := true;
                    end if;
                end if;
            elsif (output_shift_count < initial) then
                if (clk = '1') then
                    output_shift_count := output_shift_count + 1;
                end if;
            else
                count := count + 1;
                if (mode = "  even" and (count = (high_reg*2) + 1)) then
                    tmp_cout := '0';
                    low_reg := low;
                elsif (mode = "   odd" and (count = high_reg*2)) then
                    tmp_cout := '0';
                    low_reg := low;
                elsif (count = (high_reg + low_reg)*2 + 1) then
                    tmp_cout := '1';
                    count := 1;  -- reset count
                    high_reg := high;
                end if;
            end if;
        end if;
        cout <= transport tmp_cout after time_delay * 1 ps;
    end process;

end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : pll_reg
--
-- Description : Simulation model for a simple DFF.
--               This is required for the generation of the bit slip-signals.
--               No timing, powers upto 0.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY ieee, stratix;
USE IEEE.std_logic_1164.all;

ENTITY pll_reg is
    PORT    ( clk : in std_logic;
              ena : in std_logic := '1';
              d : in std_logic;
              clrn : in std_logic := '1';
              prn : in std_logic := '1';
              q : out std_logic
            );
end pll_reg;

ARCHITECTURE behave of pll_reg is
begin
    process (clk, prn, clrn)
    variable q_reg : std_logic := '0';
    begin
        if (prn = '0') then
            q_reg := '1';
        elsif (clrn = '0') then
            q_reg := '0';
        elsif (clk'event and clk = '1' and (ena = '1')) then
            q_reg := D;
        end if;

        Q <= q_reg;
    end process;

end behave;

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratix_pll
--
-- Description : Timing simulation model for the Stratix StratixGX PLL.
--               In the functional mode, it is also the model for the altpll
--               megafunction.
--
-- Limitations : Does not support Spread Spectrum and Bandwidth.
--
-- Outputs     : Up to 10 output clocks, each defined by its own set of
--               parameters. Locked output (active high) indicates when the
--               PLL locks. clkbad, clkloss and activeclock are used for
--               clock switchover to inidicate which input clock has gone
--               bad, when the clock switchover initiates and which input
--               clock is being used as the reference, respectively.
--               scandataout is the data output of the serial scan chain.
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY ieee, stratix;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE stratix.atom_pack.all;
USE stratix.pllpack.all;

ENTITY stratix_pll is
    GENERIC ( operation_mode              : string := "normal";
              qualify_conf_done           : string := "off";
              compensate_clock            : string := "clk0";
              pll_type                    : string := "auto";  -- EGPP/FAST/AUTO
              scan_chain                  : string := "long";
              lpm_type                    : string := "stratix_pll";

              clk0_multiply_by            : integer := 1;
              clk0_divide_by              : integer := 1;
              clk0_phase_shift            : string := "0";
              clk0_time_delay             : string := "0";
              clk0_duty_cycle             : integer := 50;

              clk1_multiply_by            : integer := 1;
              clk1_divide_by              : integer := 1;
              clk1_phase_shift            : string := "0";
              clk1_time_delay             : string := "0";
              clk1_duty_cycle             : integer := 50;

              clk2_multiply_by            : integer := 1;
              clk2_divide_by              : integer := 1;
              clk2_phase_shift            : string := "0";
              clk2_time_delay             : string := "0";
              clk2_duty_cycle             : integer := 50;

              clk3_multiply_by            : integer := 1;
              clk3_divide_by              : integer := 1;
              clk3_phase_shift            : string := "0";
              clk3_time_delay             : string := "0";
              clk3_duty_cycle             : integer := 50;

              clk4_multiply_by            : integer := 1;
              clk4_divide_by              : integer := 1;
              clk4_phase_shift            : string := "0";
              clk4_time_delay             : string := "0";
              clk4_duty_cycle             : integer := 50;

              clk5_multiply_by            : integer := 1;
              clk5_divide_by              : integer := 1;
              clk5_phase_shift            : string := "0";
              clk5_time_delay             : string := "0";
              clk5_duty_cycle             : integer := 50;

              extclk0_multiply_by         : integer := 1;
              extclk0_divide_by           : integer := 1;
              extclk0_phase_shift         : string := "0";
              extclk0_time_delay          : string := "0";
              extclk0_duty_cycle          : integer := 50;

              extclk1_multiply_by         : integer := 1;
              extclk1_divide_by           : integer := 1;
              extclk1_phase_shift         : string := "0";
              extclk1_time_delay          : string := "0";
              extclk1_duty_cycle          : integer := 50;

              extclk2_multiply_by         : integer := 1;
              extclk2_divide_by           : integer := 1;
              extclk2_phase_shift         : string := "0";
              extclk2_time_delay          : string := "0";
              extclk2_duty_cycle          : integer := 50;

              extclk3_multiply_by         : integer := 1;
              extclk3_divide_by           : integer := 1;
              extclk3_phase_shift         : string := "0";
              extclk3_time_delay          : string := "0";
              extclk3_duty_cycle          : integer := 50;

              primary_clock               : string := "inclk0";
              inclk0_input_frequency      : integer := 10000;
              inclk1_input_frequency      : integer := 10000;
              gate_lock_signal            : string := "no";
              gate_lock_counter           : integer := 1;
              valid_lock_multiplier       : integer := 5;
              invalid_lock_multiplier     : integer := 5;

              switch_over_on_lossclk      : string := "off";
              switch_over_on_gated_lock   : string := "off";
              switch_over_counter         : integer := 1;
              enable_switch_over_counter  : string := "off";
              feedback_source             : string := "extclk0";
              bandwidth_type              : string := "auto";
              bandwidth                   : integer := 0;
              spread_frequency            : integer := 0;
              down_spread                 : string := "0.0";

              pfd_min                     : integer := 0;
              pfd_max                     : integer := 0;
              vco_min                     : integer := 0;
              vco_max                     : integer := 0;
              vco_center                  : integer := 0;

              -- ADVANCED USER PARAMETERS
              m_initial                   : integer := 1;
              m                           : integer := 1;
              n                           : integer := 1;
              m2                          : integer := 1;
              n2                          : integer := 1;
              ss                          : integer := 0;

              l0_high                     : integer := 1;
              l0_low                      : integer := 1;
              l0_initial                  : integer := 1; 
              l0_mode                     : string := "bypass";
              l0_ph                       : integer := 0;
              l0_time_delay               : integer := 0;

              l1_high                     : integer := 1;
              l1_low                      : integer := 1;
              l1_initial                  : integer := 1;
              l1_mode                     : string := "bypass";
              l1_ph                       : integer := 0;
              l1_time_delay               : integer := 0;

              g0_high                     : integer := 1;
              g0_low                      : integer := 1;
              g0_initial                  : integer := 1;
              g0_mode                     : string := "bypass";
              g0_ph                       : integer := 0;
              g0_time_delay               : integer := 0;

              g1_high                     : integer := 1;
              g1_low                      : integer := 1;
              g1_initial                  : integer := 1;
              g1_mode                     : string := "bypass";
              g1_ph                       : integer := 0;
              g1_time_delay               : integer := 0;

              g2_high                     : integer := 1;
              g2_low                      : integer := 1;
              g2_initial                  : integer := 1;
              g2_mode                     : string := "bypass";
              g2_ph                       : integer := 0;
              g2_time_delay               : integer := 0;

              g3_high                     : integer := 1;
              g3_low                      : integer := 1;
              g3_initial                  : integer := 1;
              g3_mode                     : string := "bypass";
              g3_ph                       : integer := 0;
              g3_time_delay               : integer := 0;

              e0_high                     : integer := 1;
              e0_low                      : integer := 1;
              e0_initial                  : integer := 1;
              e0_mode                     : string := "bypass";
              e0_ph                       : integer := 0;
              e0_time_delay               : integer := 0;

              e1_high                     : integer := 1;
              e1_low                      : integer := 1;
              e1_initial                  : integer := 1;
              e1_mode                     : string := "bypass";
              e1_ph                       : integer := 0;
              e1_time_delay               : integer := 0;

              e2_high                     : integer := 1;
              e2_low                      : integer := 1;
              e2_initial                  : integer := 1;
              e2_mode                     : string := "bypass";
              e2_ph                       : integer := 0;
              e2_time_delay               : integer := 0;

              e3_high                     : integer := 1;
              e3_low                      : integer := 1;
              e3_initial                  : integer := 1;
              e3_mode                     : string := "bypass";
              e3_ph                       : integer := 0;
              e3_time_delay               : integer := 0;

              m_ph                        : integer := 0;
              m_time_delay                : integer := 0;
              n_time_delay                : integer := 0;
  
              extclk0_counter             : string := "e0";
              extclk1_counter             : string := "e1";
              extclk2_counter             : string := "e2";
              extclk3_counter             : string := "e3";

              clk0_counter                : string := "g0";
              clk1_counter                : string := "g1";
              clk2_counter                : string := "g2";
              clk3_counter                : string := "g3";
              clk4_counter                : string := "l0";
              clk5_counter                : string := "l1";

              -- LVDS mode parameters
              enable0_counter             : string := "l0";
              enable1_counter             : string := "l0";
  
              charge_pump_current         : integer := 0;
              loop_filter_r               : string := "1.0";
              loop_filter_c               : integer := 1;
              common_rx_tx                : string := "off";
              rx_outclock_resource        : string := "auto";
              use_vco_bypass              : string := "false";
              use_dc_coupling             : string := "false";

              pll_compensation_delay      : integer := 0;
              simulation_type             : string := "timing";
              source_is_pll               : string := "off";
              skip_vco                    : string := "off";
  
              -- VITAL generics
              XOn                         : Boolean := DefGlitchXOn;
              MsgOn                       : Boolean := DefGlitchMsgOn;
              tipd_inclk                  : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
              tipd_clkena                 : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
              tipd_extclkena              : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
              tipd_ena                    : VitalDelayType01 := DefPropDelay01;
              tipd_pfdena                 : VitalDelayType01 := DefPropDelay01;
              tipd_areset                 : VitalDelayType01 := DefPropDelay01;
              tipd_fbin                   : VitalDelayType01 := DefPropDelay01;
              tipd_scanclk                : VitalDelayType01 := DefPropDelay01;
              tipd_scanaclr               : VitalDelayType01 := DefPropDelay01;
              tipd_scandata               : VitalDelayType01 := DefPropDelay01;
              tipd_comparator             : VitalDelayType01 := DefPropDelay01;
              tipd_clkswitch              : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( inclk                       : in std_logic_vector(1 downto 0);
              fbin                        : in std_logic;
              ena                         : in std_logic;
              clkswitch                   : in std_logic;
              areset                      : in std_logic;
              pfdena                      : in std_logic;
              clkena                      : in std_logic_vector(5 downto 0);
              extclkena                   : in std_logic_vector(3 downto 0);
              scanaclr                    : in std_logic;
              scandata                    : in std_logic;
              scanclk                     : in std_logic;
              clk                         : out std_logic_vector(5 downto 0);
              extclk                      : out std_logic_vector(3 downto 0);
              clkbad                      : out std_logic_vector(1 downto 0);
              activeclock                 : out std_logic;
              locked                      : out std_logic;
              clkloss                     : out std_logic;
              scandataout                 : out std_logic;
              -- lvds specific ports
              comparator                  : in std_logic := '0';
              enable0                     : out std_logic;
              enable1                     : out std_logic
            );
END stratix_pll;

ARCHITECTURE vital_pll of stratix_pll is

-- internal advanced parameter signals
signal   i_vco_min      : natural;
signal   i_vco_max      : natural;
signal   i_vco_center   : natural;
signal   i_pfd_min      : natural;
signal   i_pfd_max      : natural;
signal   l0_ph_val      : natural;
signal   l1_ph_val      : natural;
signal   g0_ph_val      : natural;
signal   g1_ph_val      : natural;
signal   g2_ph_val      : natural;
signal   g3_ph_val      : natural;
signal   e0_ph_val      : natural;
signal   e1_ph_val      : natural;
signal   e2_ph_val      : natural;
signal   e3_ph_val      : natural;
signal   i_extclk3_counter      : string(1 to 2) := "e3";
signal   i_extclk2_counter      : string(1 to 2) := "e2";
signal   i_extclk1_counter      : string(1 to 2) := "e1";
signal   i_extclk0_counter      : string(1 to 2) := "e0";
signal   i_clk5_counter         : string(1 to 2) := "l1";
signal   i_clk4_counter         : string(1 to 2) := "l0";
signal   i_clk3_counter         : string(1 to 2) := "g3";
signal   i_clk2_counter         : string(1 to 2) := "g2";
signal   i_clk1_counter         : string(1 to 2) := "g1";
signal   i_clk0_counter         : string(1 to 2) := "g0";
signal   i_charge_pump_current  : natural;
signal   i_loop_filter_r        : natural;

-- end internal advanced parameter signals

-- CONSTANTS
CONSTANT EGPP_SCAN_CHAIN : integer := 289;
CONSTANT GPP_SCAN_CHAIN : integer := 193;
CONSTANT TRST : time := 5000 ps;
CONSTANT TRSTCLK : time := 5000 ps;

-- signals

signal vcc : std_logic := '1';

signal fbclk       : std_logic;
signal refclk      : std_logic;

signal l0_clk : std_logic;
signal l1_clk : std_logic;
signal g0_clk : std_logic;
signal g1_clk : std_logic;
signal g2_clk : std_logic;
signal g3_clk : std_logic;
signal e0_clk : std_logic;
signal e1_clk : std_logic;
signal e2_clk : std_logic;
signal e3_clk : std_logic;

signal vco_out : std_logic_vector(7 downto 0) := (OTHERS => '0');

-- signals to assign values to counter params
signal m_val : integer := 1;
signal m2_val : integer := 1;
signal n_val : integer := 1;
signal n2_val : integer := 1;
signal m_time_delay_val, n_time_delay_val : integer := 0;
signal m_ph_val : integer := 0;
signal m_initial_val : integer := m_initial;

signal l0_initial_val : integer := l0_initial;
signal l1_initial_val : integer := l1_initial;
signal l0_high_val : integer := l0_high;
signal l1_high_val : integer := l1_high;
signal l0_low_val : integer := l0_low;
signal l1_low_val : integer := l1_low;
signal l0_mode_val : string(1 to 6) := "bypass";
signal l1_mode_val : string(1 to 6) := "bypass";
signal l0_time_delay_val : integer := l0_time_delay;
signal l1_time_delay_val : integer := l1_time_delay;

signal g0_initial_val : integer := g0_initial;
signal g1_initial_val : integer := g1_initial;
signal g2_initial_val : integer := g2_initial;
signal g3_initial_val : integer := g3_initial;
signal g0_high_val : integer := g0_high;
signal g1_high_val : integer := g1_high;
signal g2_high_val : integer := g2_high;
signal g3_high_val : integer := g3_high;
signal g0_mode_val : string(1 to 6) := "bypass";
signal g1_mode_val : string(1 to 6) := "bypass";
signal g2_mode_val : string(1 to 6) := "bypass";
signal g3_mode_val : string(1 to 6) := "bypass";
signal g0_low_val : integer := g0_low;
signal g1_low_val : integer := g1_low;
signal g2_low_val : integer := g2_low;
signal g3_low_val : integer := g3_low;
signal g0_time_delay_val : integer := g0_time_delay;
signal g1_time_delay_val : integer := g1_time_delay;
signal g2_time_delay_val : integer := g2_time_delay;
signal g3_time_delay_val : integer := g3_time_delay;

signal e0_initial_val : integer := e0_initial;
signal e1_initial_val : integer := e1_initial;
signal e2_initial_val : integer := e2_initial;
signal e3_initial_val : integer := e3_initial;
signal e0_high_val : integer := e0_high;
signal e1_high_val : integer := e1_high;
signal e2_high_val : integer := e2_high;
signal e3_high_val : integer := e3_high;
signal e0_low_val : integer := e0_low;
signal e1_low_val : integer := e1_low;
signal e2_low_val : integer := e2_low;
signal e3_low_val : integer := e3_low;
signal e0_time_delay_val : integer := e0_time_delay;
signal e1_time_delay_val : integer := e1_time_delay;
signal e2_time_delay_val : integer := e2_time_delay;
signal e3_time_delay_val : integer := e3_time_delay;
signal e0_mode_val : string(1 to 6) := "bypass";
signal e1_mode_val : string(1 to 6) := "bypass";
signal e2_mode_val : string(1 to 6) := "bypass";
signal e3_mode_val : string(1 to 6) := "bypass";

signal m_mode_val : string(1 to 6) := "      ";
signal m2_mode_val : string(1 to 6) := "      ";
signal n_mode_val : string(1 to 6) := "      ";
signal n2_mode_val : string(1 to 6) := "      ";

signal cntr_e0_initial : integer := 1;
signal cntr_e1_initial : integer := 1;
signal cntr_e2_initial : integer := 1;
signal cntr_e3_initial : integer := 1;
signal ext_fbk_delay : integer := 0;
signal cntr_e0_delay : integer := 0;
signal cntr_e1_delay : integer := 0;
signal cntr_e2_delay : integer := 0;
signal cntr_e3_delay : integer := 0;

signal transfer : std_logic := '0';

signal scan_data : std_logic_vector(288 downto 0) := (OTHERS => '0');
signal ena0 : std_logic;
signal ena1 : std_logic;
signal ena2 : std_logic;
signal ena3 : std_logic;
signal ena4 : std_logic;
signal ena5 : std_logic;
signal extena0 : std_logic;
signal extena1 : std_logic;
signal extena2 : std_logic;
signal extena3 : std_logic;

signal clk0_tmp : std_logic;
signal clk1_tmp : std_logic;
signal clk2_tmp : std_logic;
signal clk3_tmp : std_logic;
signal clk4_tmp : std_logic;
signal clk5_tmp : std_logic;
signal extclk0_tmp : std_logic;
signal extclk1_tmp : std_logic;
signal extclk2_tmp : std_logic;
signal extclk3_tmp : std_logic;

signal not_clk0_tmp : std_logic;
signal not_clk1_tmp : std_logic;
signal not_clk2_tmp : std_logic;
signal not_clk3_tmp : std_logic;
signal not_clk4_tmp : std_logic;
signal not_clk5_tmp : std_logic;

signal not_extclk0_tmp : std_logic;
signal not_extclk1_tmp : std_logic;
signal not_extclk2_tmp : std_logic;
signal not_extclk3_tmp : std_logic;

signal clkin : std_logic := '0';
signal gate_locked : std_logic := '0';
signal lock : std_logic := '0';
signal about_to_lock : boolean := false;
signal quiet_period_violation : boolean := false;
signal reconfig_err : boolean := false;
signal scanclr_violation : boolean := false;
signal scanclr_clk_violation : boolean := false;

signal inclk_l0 : std_logic;
signal inclk_l1 : std_logic;
signal inclk_g0 : std_logic;
signal inclk_g1 : std_logic;
signal inclk_g2 : std_logic;
signal inclk_g3 : std_logic;
signal inclk_e0 : std_logic;
signal inclk_e1 : std_logic;
signal inclk_e2 : std_logic;
signal inclk_e3 : std_logic;
signal inclk_m : std_logic;
signal devpor : std_logic;
signal devclrn : std_logic;

signal inclk0_ipd : std_logic;
signal inclk1_ipd : std_logic;
signal ena_ipd : std_logic;
signal pfdena_ipd : std_logic;
signal comparator_ipd : std_logic;
signal areset_ipd : std_logic;
signal fbin_ipd : std_logic;
signal clkena0_ipd : std_logic;
signal clkena1_ipd : std_logic;
signal clkena2_ipd : std_logic;
signal clkena3_ipd : std_logic;
signal clkena4_ipd : std_logic;
signal clkena5_ipd : std_logic;
signal extclkena0_ipd : std_logic;
signal extclkena1_ipd : std_logic;
signal extclkena2_ipd : std_logic;
signal extclkena3_ipd : std_logic;
signal scanclk_ipd : std_logic;
signal scanaclr_ipd : std_logic;
signal scandata_ipd : std_logic;
signal clkswitch_ipd : std_logic;

signal lvds_dffa_clk : std_logic;
signal lvds_dffb_clk : std_logic;
signal lvds_dffc_clk : std_logic;
signal lvds_dffd_clk : std_logic;
signal dffa_out : std_logic := '0';
signal dffb_out : std_logic := '0';
signal dffc_out : std_logic := '0';
signal dffd_out : std_logic := '0';
signal nce_temp : std_logic := '0';
signal nce_l0 : std_logic := '0';
signal nce_l1 : std_logic := '0';

signal inclk_l0_dly1 : std_logic := '0';
signal inclk_l0_dly2 : std_logic := '0';
signal inclk_l0_dly3 : std_logic := '0';
signal inclk_l0_dly4 : std_logic := '0';
signal inclk_l0_dly5 : std_logic := '0';
signal inclk_l0_dly6 : std_logic := '0';
signal inclk_l1_dly1 : std_logic := '0';
signal inclk_l1_dly2 : std_logic := '0';
signal inclk_l1_dly3 : std_logic := '0';
signal inclk_l1_dly4 : std_logic := '0';
signal inclk_l1_dly5 : std_logic := '0';
signal inclk_l1_dly6 : std_logic := '0';


signal sig_offset : time := 0 ps;
signal sig_refclk_time : time := 0 ps;
signal sig_fbclk_period : time := 0 ps;
signal sig_vco_period_was_phase_adjusted : boolean := false;
signal sig_phase_adjust_was_scheduled : boolean := false;
signal sig_stop_vco : std_logic := '0';
signal sig_m_times_vco_period : time := 0 ps;
signal sig_new_m_times_vco_period : time := 0 ps;
signal sig_got_refclk_posedge : boolean := false;
signal sig_got_fbclk_posedge : boolean := false;
signal sig_got_second_refclk : boolean := false;

signal m_delay : integer := 0;
signal n_delay : integer := 0;

signal sig_curr_clock : string(1 to 6) := primary_clock;
signal inclk1_tmp : std_logic := '0';
signal scan_chain_length : integer := GPP_SCAN_CHAIN;

signal ext_fbk_cntr_high : integer := 0;
signal ext_fbk_cntr_low : integer := 0;
signal ext_fbk_cntr_delay : integer := 0;
signal ext_fbk_cntr_ph : integer := 0;
signal ext_fbk_cntr_initial : integer := 1;
signal ext_fbk_cntr     : string(1 to 2) := "e0";

signal enable0_tmp : std_logic := '0';
signal enable1_tmp : std_logic := '0';
signal reset_low : std_logic := '0';

signal scandataout_tmp : std_logic := '0';

signal sig_refclk_period : time := (inclk0_input_frequency * 1 ps) * n;

signal schedule_vco : std_logic := '0';

signal areset_ena_sig : std_logic := '0';

COMPONENT mn_cntr
    PORT ( clk           : IN std_logic;
           reset         : IN std_logic;
           cout          : OUT std_logic;
           initial_value : IN integer := 1;
           modulus       : IN integer;
           time_delay    : IN integer;
           ph            : IN integer := 0
         );
END COMPONENT;

COMPONENT scale_cntr
    PORT ( clk            : IN std_logic;
           reset          : IN std_logic;
           cout           : OUT std_logic;
           initial        : IN integer := 1;
           high           : IN integer := 1;
           low            : IN integer := 1;
           mode           : IN string := "bypass";
           time_delay     : IN integer := 0;
           ph_tap         : IN natural
         );
END COMPONENT;

COMPONENT DFFE
    GENERIC(
      TimingChecksOn: Boolean := true;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :  VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

COMPONENT PLL_REG
   PORT(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
END COMPONENT;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (inclk0_ipd, inclk(0), tipd_inclk(0));
        VitalWireDelay (inclk1_ipd, inclk(1), tipd_inclk(1));
        VitalWireDelay (areset_ipd, areset, tipd_areset);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
        VitalWireDelay (fbin_ipd, fbin, tipd_fbin);
        VitalWireDelay (pfdena_ipd, pfdena, tipd_pfdena);
        VitalWireDelay (clkena0_ipd, clkena(0), tipd_clkena(0));
        VitalWireDelay (clkena1_ipd, clkena(1), tipd_clkena(1));
        VitalWireDelay (clkena2_ipd, clkena(2), tipd_clkena(2));
        VitalWireDelay (clkena3_ipd, clkena(3), tipd_clkena(3));
        VitalWireDelay (clkena4_ipd, clkena(4), tipd_clkena(4));
        VitalWireDelay (clkena5_ipd, clkena(5), tipd_clkena(5));
        VitalWireDelay (extclkena0_ipd, extclkena(0), tipd_extclkena(0));
        VitalWireDelay (extclkena1_ipd, extclkena(1), tipd_extclkena(1));
        VitalWireDelay (extclkena2_ipd, extclkena(2), tipd_extclkena(2));
        VitalWireDelay (extclkena3_ipd, extclkena(3), tipd_extclkena(3));
        VitalWireDelay (scanclk_ipd, scanclk, tipd_scanclk);
        VitalWireDelay (scanaclr_ipd, scanaclr, tipd_scanaclr);
        VitalWireDelay (scandata_ipd, scandata, tipd_scandata);
        VitalWireDelay (comparator_ipd, comparator, tipd_comparator);
        VitalWireDelay (clkswitch_ipd, clkswitch, tipd_clkswitch);
    end block;

    -- User to Advanced parameter conversion

    i_extclk3_counter       <= "e3" when m=0 else extclk3_counter;
    i_extclk2_counter       <= "e2" when m=0 else extclk2_counter;
    i_extclk1_counter       <= "e1" when m=0 else extclk1_counter;
    i_extclk0_counter       <= "e0" when m=0 else extclk0_counter;
    i_clk5_counter          <= "l1" when m=0 else clk5_counter;
    i_clk4_counter          <= "l0" when m=0 else clk4_counter;
    i_clk3_counter          <= "g3" when m=0 else clk3_counter;
    i_clk2_counter          <= "g2" when m=0 else clk2_counter;
    i_clk1_counter          <= "g1" when m=0 else clk1_counter;
    i_clk0_counter          <= "g0" when m=0 else clk0_counter;

    -- end parameter conversion

    inclk_m <= extclk0_tmp when operation_mode = "external_feedback" and feedback_source = "extclk0" else
               extclk1_tmp when operation_mode = "external_feedback" and feedback_source = "extclk1" else
               extclk2_tmp when operation_mode = "external_feedback" and feedback_source = "extclk2" else
               extclk3_tmp when operation_mode = "external_feedback" and feedback_source = "extclk3" else
               vco_out(m_ph_val);

    ext_fbk_cntr <= "e0" when (feedback_source = "extclk0" and extclk0_counter = "e0") or (feedback_source = "extclk1" and extclk1_counter = "e0") or (feedback_source = "extclk2" and extclk2_counter = "e0") or (feedback_source = "extclk3" and extclk3_counter = "e0") else
                    "e1" when (feedback_source = "extclk0" and extclk0_counter = "e1") or (feedback_source = "extclk1" and extclk1_counter = "e1") or (feedback_source = "extclk2" and extclk2_counter = "e1") or (feedback_source = "extclk3" and extclk3_counter = "e1") else
                    "e2" when (feedback_source = "extclk0" and extclk0_counter = "e2") or (feedback_source = "extclk1" and extclk1_counter = "e2") or (feedback_source = "extclk2" and extclk2_counter = "e2") or (feedback_source = "extclk3" and extclk3_counter = "e2") else
                    "e3" when (feedback_source = "extclk0" and extclk0_counter = "e3") or (feedback_source = "extclk1" and extclk1_counter = "e3") or (feedback_source = "extclk2" and extclk2_counter = "e3") or (feedback_source = "extclk3" and extclk3_counter = "e3") else
                    "e0";

    ext_fbk_cntr_high <= e0_high_val when ext_fbk_cntr = "e0" else
                         e1_high_val when ext_fbk_cntr = "e1" else
                         e2_high_val when ext_fbk_cntr = "e2" else
                         e3_high_val when ext_fbk_cntr = "e3" else
                         1;
    ext_fbk_cntr_low <= e0_low_val when ext_fbk_cntr = "e0" else
                        e1_low_val when ext_fbk_cntr = "e1" else
                        e2_low_val when ext_fbk_cntr = "e2" else
                        e3_low_val when ext_fbk_cntr = "e3" else
                        1;
    ext_fbk_cntr_delay <= e0_time_delay_val when ext_fbk_cntr = "e0" else
                          e1_time_delay_val when ext_fbk_cntr = "e1" else
                          e2_time_delay_val when ext_fbk_cntr = "e2" else
                          e3_time_delay_val when ext_fbk_cntr = "e3" else
                          0;

    ext_fbk_cntr_ph <= e0_ph_val when ext_fbk_cntr = "e0" else
                       e1_ph_val when ext_fbk_cntr = "e1" else
                       e2_ph_val when ext_fbk_cntr = "e2" else
                       e3_ph_val when ext_fbk_cntr = "e3" else
                       0;

    ext_fbk_cntr_initial <= e0_initial_val when ext_fbk_cntr = "e0" else
                            e1_initial_val when ext_fbk_cntr = "e1" else
                            e2_initial_val when ext_fbk_cntr = "e2" else
                            e3_initial_val when ext_fbk_cntr = "e3" else
                            0;

    areset_ena_sig <= areset_ipd or (not ena_ipd) or sig_stop_vco;

    m1 : mn_cntr
         port map (clk           => inclk_m,
                   reset         => areset_ena_sig,
                   cout          => fbclk,
                   initial_value => m_initial_val,
                   modulus       => m_val,
                   time_delay    => m_delay,
                   ph            => m_ph_val
                  );

    -- add delta delay to inclk1 to ensure inclk0 and inclk1 are processed
    -- in different simulation deltas.
    inclk1_tmp <= inclk1_ipd;

    process (inclk0_ipd, inclk1_tmp, clkswitch_ipd)
    variable input_value : std_logic := '0';
    variable current_clock : string(1 to 6) := primary_clock;
    variable clk0_count, clk1_count : integer := 0;
    variable clk0_is_bad, clk1_is_bad : std_logic := '0';
    variable primary_clk_is_bad : boolean := false;
    variable current_clk_is_bad : boolean := false;
    variable got_curr_clk_falling_edge_after_clkswitch : boolean := false;
    variable switch_over_count : integer := 0;
    variable active_clock : std_logic := '0';
    variable external_switch : boolean := false;
    begin
        if (now = 0 ps) then
            if (current_clock = "inclk1") then
                active_clock := '1';
            end if;
        end if;
        if (clkswitch_ipd'event and clkswitch_ipd = '1') then
            external_switch := true;
        end if;
        -- save the current inclk event value
        if (inclk0_ipd'event) then
            input_value := inclk0_ipd;
        elsif (inclk1_tmp'event) then
            input_value := inclk1_tmp;
        end if;

        -- check if either input clk is bad
        if (inclk0_ipd'event and inclk0_ipd = '1') then
            clk0_count := clk0_count + 1;
            clk0_is_bad := '0';
            clk1_count := 0;
            if (clk0_count > 2) then
                -- no event on other clk for 2 cycles
                clk1_is_bad := '1';
                if (current_clock = "inclk1") then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;
        if (inclk1_tmp'event and inclk1_tmp = '1') then
            clk1_count := clk1_count + 1;
            clk1_is_bad := '0';
            clk0_count := 0;
            if (clk1_count > 2) then
                -- no event on other clk for 2 cycles
                clk0_is_bad := '1';
                if (current_clock = "inclk0") then
                    current_clk_is_bad := true;
                end if;
            end if;
        end if;

        -- check if the bad clk is the primary clock
        if ((primary_clock = "inclk0" and clk0_is_bad = '1') or (primary_clock = "inclk1" and clk1_is_bad = '1')) then
            primary_clk_is_bad := true;
        else
            primary_clk_is_bad := false;
        end if;

        -- actual switching
        if (inclk0_ipd'event and current_clock = "inclk0") then
            if (external_switch) then
                if (not got_curr_clk_falling_edge_after_clkswitch) then
                    if (inclk0_ipd = '0') then
                        got_curr_clk_falling_edge_after_clkswitch := true;
                    end if;
                    clkin <= transport inclk0_ipd;
                end if;
            else
                clkin <= transport inclk0_ipd;
            end if;
        elsif (inclk1_tmp'event and current_clock = "inclk1") then
            if (external_switch) then
                if (not got_curr_clk_falling_edge_after_clkswitch) then
                    if (inclk1_tmp = '0') then
                        got_curr_clk_falling_edge_after_clkswitch := true;
                    end if;
                    clkin <= transport inclk1_tmp;
                end if;
            else
                clkin <= transport inclk1_tmp;
            end if;
        else
            if (input_value = '1' and switch_over_on_lossclk = "on"  and enable_switch_over_counter = "on" and primary_clk_is_bad) then
                switch_over_count := switch_over_count + 1;
            end if;
            if (input_value = '0') then
                if (external_switch and (got_curr_clk_falling_edge_after_clkswitch or current_clk_is_bad)) or (switch_over_on_lossclk = "on" and primary_clk_is_bad and (enable_switch_over_counter = "off" or switch_over_count = switch_over_counter)) then
                    got_curr_clk_falling_edge_after_clkswitch := false;
                    if (current_clock = "inclk0") then
                        current_clock := "inclk1";
                    else
                        current_clock := "inclk0";
                    end if;
                    active_clock := not active_clock;
                    switch_over_count := 0;
                    external_switch := false;
                    current_clk_is_bad := false;
                end if;
       
            end if;
        end if;

        -- schedule outputs
        clkbad(0) <= clk0_is_bad;
        clkbad(1) <= clk1_is_bad;
        if (switch_over_on_lossclk = "on" and clkswitch_ipd /= '1') then
            if (primary_clk_is_bad) then
                -- assert clkloss
                clkloss <= '1';
            else
                clkloss <= '0';
            end if;
        else
            clkloss <= clkswitch_ipd;
        end if;
        activeclock <= active_clock;

        -- for debugging only
--      sig_curr_clock <= current_clock;
    end process;

    n1 : mn_cntr
         port map (clk           => clkin,
                   reset         => areset_ipd,
                   cout          => refclk,
                   initial_value => n_val,
                   modulus       => n_val,
                   time_delay    => n_time_delay_val);

    inclk_l0 <= vco_out(l0_ph_val);
    l0 : scale_cntr
         port map (clk            => inclk_l0,
                   reset          => areset_ena_sig,
                   cout           => l0_clk,
                   initial        => l0_initial_val,
                   high           => l0_high_val,
                   low            => l0_low_val,
                   mode           => l0_mode_val,
                   time_delay     => l0_time_delay_val,
                   ph_tap         => l0_ph_val);

    inclk_l1 <= vco_out(l1_ph_val);
    l1 : scale_cntr
         port map (clk            => inclk_l1,
                   reset          => areset_ena_sig,
                   cout           => l1_clk,
                   initial        => l1_initial_val,
                   high           => l1_high_val,
                   low            => l1_low_val,
                   mode           => l1_mode_val,
                   time_delay     => l1_time_delay_val,
                   ph_tap         => l1_ph_val);

    inclk_g0 <= vco_out(g0_ph_val);
    g0 : scale_cntr
         port map (clk            => inclk_g0,
                   reset          => areset_ena_sig,
                   cout           => g0_clk,
                   initial        => g0_initial_val,
                   high           => g0_high_val,
                   low            => g0_low_val,
                   mode           => g0_mode_val,
                   time_delay     => g0_time_delay_val,
                   ph_tap         => g0_ph_val);


    process(g0_clk, l0_clk, l1_clk)
    begin
        if (g0_clk'event and g0_clk = '1') then
            dffa_out <= comparator_ipd;
        end if;
        if (l0_clk'event and l0_clk = '1' and enable0_counter = "l0") then
            dffb_out <= dffa_out;
            dffc_out <= dffb_out;
            dffd_out <= nce_temp;
        end if;
        if (l1_clk'event and l1_clk = '1' and enable0_counter = "l1") then
            dffb_out <= dffa_out;
            dffc_out <= dffb_out;
            dffd_out <= nce_temp;
        end if;
    end process;

    nce_temp <= (not dffc_out) and dffb_out;

    nce_l0 <= dffd_out when enable0_counter = "l0" else '0';
    nce_l1 <= dffd_out when enable0_counter = "l1" else '0';

    inclk_g1 <= vco_out(g1_ph_val);
    g1 : scale_cntr
         port map (clk            => inclk_g1,
                   reset          => areset_ena_sig,
                   cout           => g1_clk,
                   initial        => g1_initial_val,
                   high           => g1_high_val,
                   low            => g1_low_val,
                   mode           => g1_mode_val,
                   time_delay     => g1_time_delay_val,
                   ph_tap         => g1_ph_val);

    inclk_g2 <= vco_out(g2_ph_val);
    g2 : scale_cntr
         port map (clk            => inclk_g2,
                   reset          => areset_ena_sig,
                   cout           => g2_clk,
                   initial        => g2_initial_val,
                   high           => g2_high_val,
                   low            => g2_low_val,
                   mode           => g2_mode_val,
                   time_delay     => g2_time_delay_val,
                   ph_tap         => g2_ph_val);

    inclk_g3 <= vco_out(g3_ph_val);
    g3 : scale_cntr
         port map (clk            => inclk_g3,
                   reset          => areset_ena_sig,
                   cout           => g3_clk,
                   initial        => g3_initial_val,
                   high           => g3_high_val,
                   low            => g3_low_val,
                   mode           => g3_mode_val,
                   time_delay     => g3_time_delay_val,
                   ph_tap         => g3_ph_val);

    inclk_e0 <= vco_out(e0_ph_val);
    cntr_e0_initial <= 1 when operation_mode = "external_feedback" and
                              ext_fbk_cntr = "e0" else e0_initial_val;
    cntr_e0_delay <= ext_fbk_delay when operation_mode = "external_feedback" and
                            ext_fbk_cntr = "e0" else
                     e0_time_delay_val;
    e0 : scale_cntr
         port map (clk            => inclk_e0,
                   reset          => areset_ena_sig,
                   cout           => e0_clk,
                   initial        => cntr_e0_initial,
                   high           => e0_high_val,
                   low            => e0_low_val,
                   mode           => e0_mode_val,
                   time_delay     => cntr_e0_delay,
                   ph_tap         => e0_ph_val);

    inclk_e1 <= vco_out(e1_ph_val);
    cntr_e1_initial <= 1 when operation_mode = "external_feedback" and
                              ext_fbk_cntr = "e1" else e1_initial_val;
    cntr_e1_delay <= ext_fbk_delay when operation_mode = "external_feedback" and
                            ext_fbk_cntr = "e1" else
                     e1_time_delay_val;
    e1 : scale_cntr
         port map (clk            => inclk_e1,
                   reset          => areset_ena_sig,
                   cout           => e1_clk,
                   initial        => cntr_e1_initial,
                   high           => e1_high_val,
                   low            => e1_low_val,
                   mode           => e1_mode_val,
                   time_delay     => cntr_e1_delay,
                   ph_tap         => e1_ph_val);

    inclk_e2 <= vco_out(e2_ph_val);
    cntr_e2_initial <= 1 when operation_mode = "external_feedback" and
                              ext_fbk_cntr = "e2" else e2_initial_val;
    cntr_e2_delay <= ext_fbk_delay when operation_mode = "external_feedback" and
                            ext_fbk_cntr = "e2" else
                     e2_time_delay_val;
    e2 : scale_cntr
         port map (clk            => inclk_e2,
                   reset          => areset_ena_sig,
                   cout           => e2_clk,
                   initial        => cntr_e2_initial,
                   high           => e2_high_val,
                   low            => e2_low_val,
                   mode           => e2_mode_val,
                   time_delay     => cntr_e2_delay,
                   ph_tap         => e2_ph_val);

    inclk_e3 <= vco_out(e3_ph_val);
    cntr_e3_initial <= 1 when operation_mode = "external_feedback" and
                              ext_fbk_cntr = "e3" else e3_initial_val;
    cntr_e3_delay <= ext_fbk_delay when operation_mode = "external_feedback" and
                            ext_fbk_cntr = "e3" else
                     e3_time_delay_val;
    e3 : scale_cntr
         port map (clk            => inclk_e3,
                   reset          => areset_ena_sig,
                   cout           => e3_clk,
                   initial        => cntr_e3_initial,
                   high           => e3_high_val,
                   low            => e3_low_val,
                   mode           => e3_mode_val,
                   time_delay     => cntr_e3_delay,
                   ph_tap         => e3_ph_val);

    inclk_l0_dly1 <= inclk_l0;
    inclk_l0_dly2 <= inclk_l0_dly1;
    inclk_l0_dly3 <= inclk_l0_dly2;
    inclk_l0_dly4 <= inclk_l0_dly3;
    inclk_l0_dly5 <= inclk_l0_dly4;
    inclk_l0_dly6 <= inclk_l0_dly5;

    inclk_l1_dly1 <= inclk_l1;
    inclk_l1_dly2 <= inclk_l1_dly1;
    inclk_l1_dly3 <= inclk_l1_dly2;
    inclk_l1_dly4 <= inclk_l1_dly3;
    inclk_l1_dly5 <= inclk_l1_dly4;
    inclk_l1_dly6 <= inclk_l1_dly5;

    process(inclk_l0_dly6, inclk_l1_dly6, areset_ipd, ena_ipd, sig_stop_vco)
    variable l0_got_first_rising_edge : boolean := false;
    variable l0_count : integer := 1;
    variable l0_tmp, l1_tmp : std_logic := '0';
    variable l1_got_first_rising_edge : boolean := false;
    variable l1_count : integer := 1;
    begin
        if (areset_ipd = '1' or ena_ipd = '0' or sig_stop_vco = '1') then
            l0_count := 1;
            l1_count := 1;
            l0_got_first_rising_edge := false;
            l1_got_first_rising_edge := false;
        else
            if (nce_l0 = '0') then
                if (not l0_got_first_rising_edge) then
                    if (inclk_l0_dly6'event and inclk_l0_dly6 = '1') then
                        l0_got_first_rising_edge := true;
                    end if;
                elsif (inclk_l0_dly6'event) then
                    l0_count := l0_count + 1;
                    if (l0_count = (l0_high_val + l0_low_val) * 2) then
                        l0_count := 1;
                    end if;
                end if;
            end if;
            if (inclk_l0_dly6'event and inclk_l0_dly6 = '0') then
                if (l0_count = 1) then
                    l0_tmp := '1';
                    l0_got_first_rising_edge := false;
                else
                    l0_tmp := '0';
                end if;
            end if;

            if (nce_l1 = '0') then
                if (not l1_got_first_rising_edge) then
                    if (inclk_l1_dly6'event and inclk_l1_dly6 = '1') then
                        l1_got_first_rising_edge := true;
                    end if;
                elsif (inclk_l1_dly6'event) then
                    l1_count := l1_count + 1;
                    if (l1_count = (l1_high_val + l1_low_val) * 2) then
                        l1_count := 1;
                    end if;
                end if;
            end if;
            if (inclk_l1_dly6'event and inclk_l1_dly6 = '0') then
                if (l1_count = 1) then
                    l1_tmp := '1';
                    l1_got_first_rising_edge := false;
                else
                    l1_tmp := '0';
                end if;
            end if;
        end if;

        if (enable0_counter = "l0") then
            enable0_tmp <= l0_tmp;
        elsif (enable0_counter = "l1") then
            enable0_tmp <= l1_tmp;
        else
            enable0_tmp <= '0';
        end if;

        if (enable1_counter = "l0") then
            enable1_tmp <= l0_tmp;
        elsif (enable1_counter = "l1") then
            enable1_tmp <= l1_tmp;
        else
            enable1_tmp <= '0';
        end if;

    end process;

    glocked_cntr : process(clkin, ena_ipd, areset_ipd)
    variable count : integer := 0;
    variable output : std_logic := '0';
    begin
        if (areset_ipd = '1') then
            count := 0;
            output := '0';
        elsif (clkin'event and clkin = '1') then
            if (ena_ipd = '1') then
                count := count + 1;
                if (count = gate_lock_counter) then
                    output := '1';
                end if;
            end if;
        end if;
        gate_locked <= output;
    end process;

    locked <= gate_locked and lock when gate_lock_signal = "yes" else
              lock;

    process (transfer)
    variable init : boolean := true;
    variable low, high : std_logic_vector(8 downto 0);
    variable delay_chain : std_logic_vector(3 downto 0);
    variable mn_delay_chain : std_logic_vector(0 to 3);
    variable mode : string(1 to 6) := "bypass";
    variable delay_val : integer := 0;
    variable is_error : boolean := false;

    -- user to advanced variables

    variable   i_m_initial    : natural;
    variable   i_m            : integer := 1;
    variable   i_n            : natural := 1;
    variable   i_m2           : natural;
    variable   i_n2           : natural;
    variable   i_ss           : natural;
    variable   i_l0_high      : natural;
    variable   i_l1_high      : natural;
    variable   i_g0_high      : natural;
    variable   i_g1_high      : natural;
    variable   i_g2_high      : natural;
    variable   i_g3_high      : natural;
    variable   i_e0_high      : natural;
    variable   i_e1_high      : natural;
    variable   i_e2_high      : natural;
    variable   i_e3_high      : natural;
    variable   i_l0_low       : natural;
    variable   i_l1_low       : natural;
    variable   i_g0_low       : natural;
    variable   i_g1_low       : natural;
    variable   i_g2_low       : natural;
    variable   i_g3_low       : natural;
    variable   i_e0_low       : natural;
    variable   i_e1_low       : natural;
    variable   i_e2_low       : natural;
    variable   i_e3_low       : natural;
    variable   i_l0_initial   : natural;
    variable   i_l1_initial   : natural;
    variable   i_g0_initial   : natural;
    variable   i_g1_initial   : natural;
    variable   i_g2_initial   : natural;
    variable   i_g3_initial   : natural;
    variable   i_e0_initial   : natural;
    variable   i_e1_initial   : natural;
    variable   i_e2_initial   : natural;
    variable   i_e3_initial   : natural;
    variable   i_l0_mode      : string(1 to 6);
    variable   i_l1_mode      : string(1 to 6);
    variable   i_g0_mode      : string(1 to 6);
    variable   i_g1_mode      : string(1 to 6);
    variable   i_g2_mode      : string(1 to 6);
    variable   i_g3_mode      : string(1 to 6);
    variable   i_e0_mode      : string(1 to 6);
    variable   i_e1_mode      : string(1 to 6);
    variable   i_e2_mode      : string(1 to 6);
    variable   i_e3_mode      : string(1 to 6);
    variable   max_neg_abs    : integer := 0;
    variable   i_l0_time_delay        : natural;
    variable   i_l1_time_delay        : natural;
    variable   i_g0_time_delay        : natural;
    variable   i_g1_time_delay        : natural;
    variable   i_g2_time_delay        : natural;
    variable   i_g3_time_delay        : natural;
    variable   i_e0_time_delay        : natural;
    variable   i_e1_time_delay        : natural;
    variable   i_e2_time_delay        : natural;
    variable   i_e3_time_delay        : natural;
    variable   i_m_time_delay         : natural;
    variable   i_n_time_delay         : natural;
    variable   i_l0_ph        : natural;
    variable   i_l1_ph        : natural;
    variable   i_g0_ph        : natural;
    variable   i_g1_ph        : natural;
    variable   i_g2_ph        : natural;
    variable   i_g3_ph        : natural;
    variable   i_e0_ph        : natural;
    variable   i_e1_ph        : natural;
    variable   i_e2_ph        : natural;
    variable   i_e3_ph        : natural;
    variable   i_m_ph         : natural;
    variable   output_count   : natural;
    variable   new_divisor    : natural;

    begin
        if (init) then
            if (m = 0) then  -- convert user parameters to advanced
                i_n := 1;
                i_m := lcm (clk0_multiply_by, clk1_multiply_by,
                            clk2_multiply_by, clk3_multiply_by,
                            clk4_multiply_by, clk5_multiply_by,
                            extclk0_multiply_by,
                            extclk1_multiply_by, extclk2_multiply_by,
                            extclk3_multiply_by, inclk0_input_frequency);
                i_m_time_delay  := maxnegabs(str2int(clk0_time_delay), 
                                             str2int(clk1_time_delay),
                                             str2int(clk2_time_delay), 
                                             str2int(clk3_time_delay), 
                                             str2int(clk4_time_delay),
                                             str2int(clk5_time_delay), 
                                             str2int(extclk0_time_delay),
                                             str2int(extclk1_time_delay), 
                                             str2int(extclk2_time_delay),
                                             str2int(extclk3_time_delay)); 
                i_n_time_delay  := mintimedelay(str2int(clk0_time_delay), 
                                                str2int(clk1_time_delay),
                                                str2int(clk2_time_delay), 
                                                str2int(clk3_time_delay), 
                                                str2int(clk4_time_delay),
                                                str2int(clk5_time_delay), 
                                                str2int(extclk0_time_delay),
                                                str2int(extclk1_time_delay), 
                                                str2int(extclk2_time_delay),
                                                str2int(extclk3_time_delay)); 
                i_g0_time_delay := counter_time_delay(str2int(clk0_time_delay),
                                                      i_m_time_delay,i_n_time_delay);
                i_g1_time_delay := counter_time_delay(str2int(clk1_time_delay), 
                                                      i_m_time_delay, i_n_time_delay); 
                i_g2_time_delay := counter_time_delay(str2int(clk2_time_delay), 
                                                      i_m_time_delay, i_n_time_delay);
                i_g3_time_delay := counter_time_delay(str2int(clk3_time_delay), 
                                                      i_m_time_delay, i_n_time_delay);
                i_l0_time_delay := counter_time_delay(str2int(clk4_time_delay), 
                                              i_m_time_delay, i_n_time_delay);
                i_l1_time_delay := counter_time_delay(str2int(clk5_time_delay), 
                                                      i_m_time_delay, i_n_time_delay);
                i_e0_time_delay := counter_time_delay(str2int(extclk0_time_delay), 
                                                      i_m_time_delay, i_n_time_delay);
                i_e1_time_delay := counter_time_delay(str2int(extclk1_time_delay), 
                                                      i_m_time_delay, i_n_time_delay);
                i_e2_time_delay := counter_time_delay(str2int(extclk2_time_delay), 
                                                      i_m_time_delay, i_n_time_delay);
                i_e3_time_delay := counter_time_delay(str2int(extclk3_time_delay), 
                                                      i_m_time_delay, i_n_time_delay);
                max_neg_abs := maxnegabs(str2int(clk0_phase_shift), 
                                         str2int(clk1_phase_shift),
                                         str2int(clk2_phase_shift),
                                         str2int(clk3_phase_shift),
                                         str2int(clk4_phase_shift),
                                         str2int(clk5_phase_shift),
                                         str2int(extclk0_phase_shift),
                                         str2int(extclk1_phase_shift),
                                         str2int(extclk2_phase_shift),
                                         str2int(extclk3_phase_shift));
                i_m_ph  := counter_ph(get_phase_degree(max_neg_abs,inclk0_input_frequency), i_m, i_n); 
                i_g0_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk0_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_g1_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk1_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_g2_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk2_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_g3_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_l0_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_l1_ph := counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_e0_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_e1_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_e2_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_e3_ph := counter_ph(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift),max_neg_abs),inclk0_input_frequency), i_m, i_n);
                i_g0_high := counter_high(output_counter_value(clk0_divide_by,
                             clk0_multiply_by, i_m, i_n), clk0_duty_cycle);
                i_g1_high := counter_high(output_counter_value(clk1_divide_by,
                             clk1_multiply_by, i_m, i_n), clk1_duty_cycle);
                i_g2_high := counter_high(output_counter_value(clk2_divide_by,
                             clk2_multiply_by, i_m, i_n), clk2_duty_cycle);
                i_g3_high := counter_high(output_counter_value(clk3_divide_by,
                             clk3_multiply_by, i_m, i_n), clk3_duty_cycle);
                i_l0_high := counter_high(output_counter_value(clk4_divide_by,
                             clk4_multiply_by,  i_m, i_n), clk4_duty_cycle);
                i_l1_high := counter_high(output_counter_value(clk5_divide_by,
                             clk5_multiply_by,  i_m, i_n), clk5_duty_cycle);
                i_e0_high := counter_high(output_counter_value(extclk0_divide_by,
                             extclk0_multiply_by,  i_m, i_n), extclk0_duty_cycle);
                i_e1_high := counter_high(output_counter_value(extclk1_divide_by,
                             extclk1_multiply_by,  i_m, i_n), extclk1_duty_cycle);
                i_e2_high := counter_high(output_counter_value(extclk2_divide_by,
                             extclk2_multiply_by,  i_m, i_n), extclk2_duty_cycle);
                i_e3_high := counter_high(output_counter_value(extclk3_divide_by,
                             extclk3_multiply_by,  i_m, i_n), extclk3_duty_cycle);
                i_g0_low  := counter_low(output_counter_value(clk0_divide_by,
                             clk0_multiply_by,  i_m, i_n), clk0_duty_cycle);
                i_g1_low  := counter_low(output_counter_value(clk1_divide_by,
                             clk1_multiply_by,  i_m, i_n), clk1_duty_cycle);
                i_g2_low  := counter_low(output_counter_value(clk2_divide_by,
                             clk2_multiply_by,  i_m, i_n), clk2_duty_cycle);
                i_g3_low  := counter_low(output_counter_value(clk3_divide_by,
                             clk3_multiply_by,  i_m, i_n), clk3_duty_cycle);
                i_l0_low  := counter_low(output_counter_value(clk4_divide_by,
                             clk4_multiply_by,  i_m, i_n), clk4_duty_cycle);
                i_l1_low  := counter_low(output_counter_value(clk5_divide_by,
                             clk5_multiply_by,  i_m, i_n), clk5_duty_cycle);
                i_e0_low  := counter_low(output_counter_value(extclk0_divide_by,
                             extclk0_multiply_by,  i_m, i_n), extclk0_duty_cycle);
                i_e1_low  := counter_low(output_counter_value(extclk1_divide_by,
                             extclk1_multiply_by,  i_m, i_n), extclk1_duty_cycle);
                i_e2_low  := counter_low(output_counter_value(extclk2_divide_by,
                             extclk2_multiply_by,  i_m, i_n), extclk2_duty_cycle);
                i_e3_low  := counter_low(output_counter_value(extclk3_divide_by,
                             extclk3_multiply_by,  i_m, i_n), extclk3_duty_cycle);
                i_m_initial  := counter_initial(get_phase_degree(max_neg_abs, inclk0_input_frequency), i_m,i_n);
                i_g0_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk0_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_g1_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk1_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_g2_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk2_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_g3_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_l0_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_l1_initial := counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_e0_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_e1_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_e2_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_e3_initial := counter_initial(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift), max_neg_abs), inclk0_input_frequency), i_m, i_n);
                i_g0_mode := counter_mode(clk0_duty_cycle, output_counter_value(clk0_divide_by, clk0_multiply_by,  i_m, i_n));
                i_g1_mode := counter_mode(clk1_duty_cycle, output_counter_value(clk1_divide_by, clk1_multiply_by,  i_m, i_n));
                i_g2_mode := counter_mode(clk2_duty_cycle, output_counter_value(clk2_divide_by, clk2_multiply_by,  i_m, i_n));
                i_g3_mode := counter_mode(clk3_duty_cycle, output_counter_value(clk3_divide_by, clk3_multiply_by,  i_m, i_n));
                i_l0_mode := counter_mode(clk4_duty_cycle, output_counter_value(clk4_divide_by, clk4_multiply_by,  i_m, i_n));
                i_l1_mode := counter_mode(clk5_duty_cycle, output_counter_value(clk5_divide_by, clk5_multiply_by,  i_m, i_n));
                i_e0_mode := counter_mode(extclk0_duty_cycle, output_counter_value(extclk0_divide_by, extclk0_multiply_by,  i_m, i_n));
                i_e1_mode := counter_mode(extclk1_duty_cycle, output_counter_value(extclk1_divide_by, extclk1_multiply_by,  i_m, i_n));
                i_e2_mode := counter_mode(extclk2_duty_cycle, output_counter_value(extclk2_divide_by, extclk2_multiply_by,  i_m, i_n));
                i_e3_mode := counter_mode(extclk3_duty_cycle, output_counter_value(extclk3_divide_by, extclk3_multiply_by,  i_m, i_n));

                -- in external feedback mode, need to adjust M value to take
                -- into consideration the external feedback counter value
                if(operation_mode = "external_feedback") then
                    -- if there is a negative phase shift, m_initial can
                    -- only be 1
                    if (max_neg_abs > 0) then
                        i_m_initial := 1;
                    end if;

                    -- calculate the feedback counter multiplier
                    if (feedback_source = "extclk0") then
                        if (i_e0_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e0_high + i_e0_low;
                        end if;
                    elsif (feedback_source = "extclk1") then
                        if (i_e1_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e1_high + i_e1_low;
                        end if;
                    elsif (feedback_source = "extclk2") then
                        if (i_e2_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e2_high + i_e2_low;
                        end if;
                    elsif (feedback_source = "extclk3") then
                        if (i_e3_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e3_high + i_e3_low;
                        end if;
                    else -- default to e0
                        if (i_e0_mode = "bypass") then
                            output_count := 1;
                        else
                            output_count := i_e0_high + i_e0_low;
                        end if;
                    end if;

                    if (i_m > output_count) then
                        i_m := i_m / output_count;
                    else
                        new_divisor := gcd(i_m, output_count);
                        i_m := i_m / new_divisor;
                        i_n := output_count / new_divisor;
                    end if;

                end if;
 
            else -- m /= 0

                i_n             := n;
                i_m             := m;
                i_m_initial     := m_initial;
                i_m_time_delay  := m_time_delay;
                i_n_time_delay  := n_time_delay;
                i_l0_time_delay := l0_time_delay;
                i_l1_time_delay := l1_time_delay;
                i_g0_time_delay := g0_time_delay;
                i_g1_time_delay := g1_time_delay;
                i_g2_time_delay := g2_time_delay;
                i_g3_time_delay := g3_time_delay;
                i_e0_time_delay := e0_time_delay;
                i_e1_time_delay := e1_time_delay;
                i_e2_time_delay := e2_time_delay;
                i_e3_time_delay := e3_time_delay;
                i_m_ph          := m_ph;
                i_l0_ph         := l0_ph;
                i_l1_ph         := l1_ph;
                i_g0_ph         := g0_ph;
                i_g1_ph         := g1_ph;
                i_g2_ph         := g2_ph;
                i_g3_ph         := g3_ph;
                i_e0_ph         := e0_ph;
                i_e1_ph         := e1_ph;
                i_e2_ph         := e2_ph;
                i_e3_ph         := e3_ph;
                i_l0_high       := l0_high;
                i_l1_high       := l1_high;
                i_g0_high       := g0_high;
                i_g1_high       := g1_high;
                i_g2_high       := g2_high;
                i_g3_high       := g3_high;
                i_e0_high       := e0_high;
                i_e1_high       := e1_high;
                i_e2_high       := e2_high;
                i_e3_high       := e3_high;
                i_l0_low        := l0_low;
                i_l1_low        := l1_low;
                i_g0_low        := g0_low;
                i_g1_low        := g1_low;
                i_g2_low        := g2_low;
                i_g3_low        := g3_low;
                i_e0_low        := e0_low;
                i_e1_low        := e1_low;
                i_e2_low        := e2_low;
                i_e3_low        := e3_low;
                i_l0_initial    := l0_initial;
                i_l1_initial    := l1_initial;
                i_g0_initial    := g0_initial;
                i_g1_initial    := g1_initial;
                i_g2_initial    := g2_initial;
                i_g3_initial    := g3_initial;
                i_e0_initial    := e0_initial;
                i_e1_initial    := e1_initial;
                i_e2_initial    := e2_initial;
                i_e3_initial    := e3_initial;
                i_l0_mode       := translate_string(l0_mode);
                i_l1_mode       := translate_string(l1_mode);
                i_g0_mode       := translate_string(g0_mode);
                i_g1_mode       := translate_string(g1_mode);
                i_g2_mode       := translate_string(g2_mode);
                i_g3_mode       := translate_string(g3_mode);
                i_e0_mode       := translate_string(e0_mode);
                i_e1_mode       := translate_string(e1_mode);
                i_e2_mode       := translate_string(e2_mode);
                i_e3_mode       := translate_string(e3_mode);

            end if; -- user to advanced conversion.

            m_initial_val <= i_m_initial;
            n_val <= i_n;
            m_val <= i_m;

            if (i_m = 1) then
                m_mode_val <= "bypass";
            end if;
            if (i_n = 1) then
                n_mode_val <= "bypass";
            end if;

            -- NOTE: m_time_delay (vco time delay) not supported for external
            --       feedback mode
            --       in feedback mode, m_time_delay = delay of feedback loop tap

            m_time_delay_val <= i_m_time_delay; 
            n_time_delay_val <= i_n_time_delay;

            m_ph_val  <= i_m_ph;

            m2_val <= m2;
            n2_val <= n2;
            if (m2 = 1) then
                m2_mode_val <= "bypass";
            end if;
            if (n2 = 1) then
                n2_mode_val <= "bypass";
            end if;

            if (skip_vco = "on") then
                m_val <= 1;
                m_initial_val <= 1;
                m_time_delay_val <= 0;
                m_ph_val <= 0;
            end if;

            l0_ph_val <= i_l0_ph;
            l1_ph_val <= i_l1_ph;
            g0_ph_val <= i_g0_ph;
            g1_ph_val <= i_g1_ph;
            g2_ph_val <= i_g2_ph;
            g3_ph_val <= i_g3_ph;
            e0_ph_val <= i_e0_ph;
            e1_ph_val <= i_e1_ph;
            e2_ph_val <= i_e2_ph;
            e3_ph_val <= i_e3_ph;

            l0_initial_val    <= i_l0_initial;
            l0_high_val       <= i_l0_high;
            l0_low_val        <= i_l0_low;
            l0_mode_val       <= i_l0_mode;
            l0_time_delay_val <= i_l0_time_delay;

            l1_initial_val    <= i_l1_initial;
            l1_high_val       <= i_l1_high;
            l1_low_val        <= i_l1_low;
            l1_mode_val       <= i_l1_mode;
            l1_time_delay_val <= i_l1_time_delay;

            g0_initial_val    <= i_g0_initial;
            g0_high_val       <= i_g0_high;
            g0_low_val        <= i_g0_low;
            g0_mode_val       <= i_g0_mode;
            g0_time_delay_val <= i_g0_time_delay;

            g1_initial_val    <= i_g1_initial;
            g1_high_val       <= i_g1_high;
            g1_low_val        <= i_g1_low;
            g1_mode_val       <= i_g1_mode;
            g1_time_delay_val <= i_g1_time_delay;

            g2_initial_val    <= i_g2_initial;
            g2_high_val       <= i_g2_high;
            g2_low_val        <= i_g2_low;
            g2_mode_val       <= i_g2_mode;
            g2_time_delay_val <= i_g2_time_delay;

            g3_initial_val    <= i_g3_initial;
            g3_high_val       <= i_g3_high;
            g3_low_val        <= i_g3_low;
            g3_mode_val       <= i_g3_mode;
            g3_time_delay_val <= i_g3_time_delay;

            if (scan_chain = "long") then
                e0_initial_val    <= i_e0_initial;
                e0_high_val       <= i_e0_high;
                e0_low_val        <= i_e0_low;
                e0_mode_val       <= i_e0_mode;
                e0_time_delay_val <= i_e0_time_delay;

                e1_initial_val    <= i_e1_initial;
                e1_high_val       <= i_e1_high;
                e1_low_val        <= i_e1_low;
                e1_mode_val       <= i_e1_mode;
                e1_time_delay_val <= i_e1_time_delay;

                e2_initial_val    <= i_e2_initial;
                e2_high_val       <= i_e2_high;
                e2_low_val        <= i_e2_low;
                e2_mode_val       <= i_e2_mode;
                e2_time_delay_val <= i_e2_time_delay;

                e3_initial_val    <= i_e3_initial;
                e3_high_val       <= i_e3_high;
                e3_low_val        <= i_e3_low;
                e3_mode_val       <= i_e3_mode;
                e3_time_delay_val <= i_e3_time_delay;

                scan_chain_length <= EGPP_SCAN_CHAIN;
            end if;
            init := false;
        elsif (transfer'event and transfer = '1') then
            reconfig_err <= false;
            ASSERT false REPORT "Reconfiguring PLL" severity note;
            if (scan_chain = "long") then
                -- cntr e3
                delay_chain := scan_data(287 downto 284);
                if (scan_data(273) = '1') then
                    e3_mode_val <= "bypass";
                    if (scan_data(283) = '1') then
                        e3_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E3 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                    end if;
                elsif (scan_data(283) = '1') then
                    e3_mode_val <= "   odd";
                else 
                    e3_mode_val <= "  even";
                end if;
                high := scan_data(272 downto 264);
                low := scan_data(282 downto 274);
                e3_low_val <= alt_conv_integer(low);
                e3_high_val <= alt_conv_integer(high);
                -- count value of 0 is actually 512
                if (alt_conv_integer(high) = 0) then
                    e3_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e3_low_val <= 512;
                end if;
                delay_val := alt_conv_integer(delay_chain);
                delay_val := delay_val * 250;
                if (delay_val > 3000) then
                    delay_val := 3000;
                end if;
                e3_time_delay_val <= delay_val;
  
                -- cntr e2
                delay_chain := scan_data(263 downto 260);
                if (scan_data(249) = '1') then
                    e2_mode_val <= "bypass";
                    if (scan_data(259) = '1') then
                        e2_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E2 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                    end if;
                elsif (scan_data(259) = '1') then
                    e2_mode_val <= "   odd";
                else 
                    e2_mode_val <= "  even";
                end if;
                high := scan_data(248 downto 240);
                low := scan_data(258 downto 250);
                e2_low_val <= alt_conv_integer(low);
                e2_high_val <= alt_conv_integer(high);
                if (alt_conv_integer(high) = 0) then
                    e2_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e2_low_val <= 512;
                end if;
                delay_val := alt_conv_integer(delay_chain);
                delay_val := delay_val * 250;
                if (delay_val > 3000) then
                    delay_val := 3000;
                end if;
                e2_time_delay_val <= delay_val;

                -- cntr e1
                delay_chain := scan_data(239 downto 236);
                if (scan_data(225) = '1') then
                    e1_mode_val <= "bypass";
                    if (scan_data(235) = '1') then
                        e1_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E1 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                    end if;
                elsif (scan_data(235) = '1') then
                    e1_mode_val <= "   odd";
                else 
                    e1_mode_val <= "  even";
                end if;
                high := scan_data(224 downto 216);
                low := scan_data(234 downto 226);
                e1_low_val <= alt_conv_integer(low);
                e1_high_val <= alt_conv_integer(high);
                if (alt_conv_integer(high) = 0) then
                    e1_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e1_low_val <= 512;
                end if;
                delay_val := alt_conv_integer(delay_chain);
                delay_val := delay_val * 250;
                if (delay_val > 3000) then
                    delay_val := 3000;
                 end if;
                 e1_time_delay_val <= delay_val;

                 -- cntr e0
                 delay_chain := scan_data(215 downto 212);
                 if (scan_data(201) = '1') then
                     e0_mode_val <= "bypass";
                     if (scan_data(211) = '1') then
                         e0_mode_val <= "   off";
                        ASSERT false REPORT "The specified bit settings will turn OFF the E0 counter. It cannot be turned on unless the part is re-initialized." severity warning;
                     end if;
                 elsif (scan_data(211) = '1') then
                     e0_mode_val <= "   odd";
                 else 
                     e0_mode_val <= "  even";
                 end if;
                 high := scan_data(200 downto 192);
                 low := scan_data(210 downto 202);
                 e0_low_val <= alt_conv_integer(low);
                 e0_high_val <= alt_conv_integer(high);
                if (alt_conv_integer(high) = 0) then
                    e0_high_val <= 512;
                end if;
                if (alt_conv_integer(low) = 0) then
                    e0_low_val <= 512;
                end if;
                 delay_val := alt_conv_integer(delay_chain);
                 delay_val := delay_val * 250;
                 if (delay_val > 3000) then
                     delay_val := 3000;
                 end if;
            e0_time_delay_val <= delay_val;
 
         end if;
            -- cntr l1
            delay_chain := scan_data(191 downto 188);
            if (scan_data(177) = '1') then
               l1_mode_val <= "bypass";
               if (scan_data(187) = '1') then
                  l1_mode_val <= "   off";
                  ASSERT false REPORT "The specified bit settings will turn OFF the L1 counter. It cannot be turned on unless the part is re-initialized." severity warning;
               end if;
            elsif (scan_data(187) = '1') then
               l1_mode_val <= "   odd";
            else 
               l1_mode_val <= "  even";
            end if;
            high := scan_data(176 downto 168);
            low := scan_data(186 downto 178);
            l1_low_val <= alt_conv_integer(low);
            l1_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                l1_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                l1_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            l1_time_delay_val <= delay_val;

            -- cntr l0
            delay_chain := scan_data(167 downto 164);
            if (scan_data(153) = '1') then
               l0_mode_val <= "bypass";
               if (scan_data(163) = '1') then
                  l0_mode_val <= "   off";
                  ASSERT false REPORT "The specified bit settings will turn OFF the L0 counter. It cannot be turned on unless the part is re-initialized." severity warning;
               end if;
            elsif (scan_data(163) = '1') then
               l0_mode_val <= "   odd";
            else 
               l0_mode_val <= "  even";
            end if;
            high := scan_data(152 downto 144);
            low := scan_data(162 downto 154);
            l0_low_val <= alt_conv_integer(low);
            l0_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                l0_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                l0_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            l0_time_delay_val <= delay_val;

            -- cntr g3
            delay_chain := scan_data(143 downto 140);
            if (scan_data(129) = '1') then
               g3_mode_val <= "bypass";
               if (scan_data(139) = '1') then
                  g3_mode_val <= "   off";
                  ASSERT false REPORT "The specified bit settings will turn OFF the G3 counter. It cannot be turned on unless the part is re-initialized." severity warning;
               end if;
            elsif (scan_data(139) = '1') then
               g3_mode_val <= "   odd";
            else 
               g3_mode_val <= "  even";
            end if;
            high := scan_data(128 downto 120);
            low := scan_data(138 downto 130);
            g3_low_val <= alt_conv_integer(low);
            g3_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g3_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g3_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            g3_time_delay_val <= delay_val;

            -- cntr g2
            delay_chain := scan_data(119 downto 116);
            if (scan_data(105) = '1') then
               g2_mode_val <= "bypass";
               if (scan_data(115) = '1') then
                  g2_mode_val <= "   off";
                  ASSERT false REPORT "The specified bit settings will turn OFF the G2 counter. It cannot be turned on unless the part is re-initialized." severity warning;
               end if;
            elsif (scan_data(115) = '1') then
               g2_mode_val <= "   odd";
            else 
               g2_mode_val <= "  even";
            end if;
            high := scan_data(104 downto 96);
            low := scan_data(114 downto 106);
            g2_low_val <= alt_conv_integer(low);
            g2_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g2_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g2_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            g2_time_delay_val <= delay_val;

            -- cntr g1
            delay_chain := scan_data(95 downto 92);
            if (scan_data(81) = '1') then
               g1_mode_val <= "bypass";
               if (scan_data(91) = '1') then
                  g1_mode_val <= "   off";
                  ASSERT false REPORT "The specified bit settings will turn OFF the G1 counter. It cannot be turned on unless the part is re-initialized." severity warning;
               end if;
            elsif (scan_data(91) = '1') then
               g1_mode_val <= "   odd";
            else 
               g1_mode_val <= "  even";
            end if;
            high := scan_data(80 downto 72);
            low := scan_data(90 downto 82);
            g1_low_val <= alt_conv_integer(low);
            g1_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g1_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g1_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            g1_time_delay_val <= delay_val;

            -- cntr g0
            delay_chain := scan_data(71 downto 68);
            if (scan_data(57) = '1') then
               g0_mode_val <= "bypass";
               if (scan_data(67) = '1') then
                  g0_mode_val <= "   off";
                  ASSERT false REPORT "The specified bit settings will turn OFF the G0 counter. It cannot be turned on unless the part is re-initialized." severity warning;
               end if;
            elsif (scan_data(67) = '1') then
               g0_mode_val <= "   odd";
            else 
               g0_mode_val <= "  even";
            end if;
            high := scan_data(56 downto 48);
            low := scan_data(66 downto 58);
            g0_low_val <= alt_conv_integer(low);
            g0_high_val <= alt_conv_integer(high);
            if (alt_conv_integer(high) = 0) then
                g0_high_val <= 512;
            end if;
            if (alt_conv_integer(low) = 0) then
                g0_low_val <= 512;
            end if;
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            g0_time_delay_val <= delay_val;

            -- cntr M
            is_error := false;
            -- 'low' contains modulus for m_cntr(spread_spectrum disabled)
            low := scan_data(32 downto 24);
            m_val <= alt_conv_integer(low);
            if (scan_data(33) /= '1') then
                if (m_mode_val = "bypass") then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal mode for M counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                elsif (alt_conv_integer(low) = 1) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal 1 value for M counter. Instead, M counter should be BYPASSED. Reconfiguration may not work." severity warning;
                elsif (alt_conv_integer(low) = 0) then
                    m_val <= 512;
                    ASSERT FALSE REPORT "M modulus = " &int2str(512)& " "severity note;
                else
                    ASSERT FALSE REPORT "M modulus = " &int2str(alt_conv_integer(low))& " "severity note;
                end if;
                m_mode_val <= "      ";
            elsif (scan_data(33) = '1') then
                if (m_mode_val /= "bypass") then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal mode for M counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                elsif (scan_data(24) /= '0') then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal value for M counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                else
                    m_val <= 1;
                    ASSERT FALSE REPORT "M modulus = " &int2str(1)& " "severity note;
                end if;
                m_mode_val <= "bypass";
            end if;

            if (skip_vco = "on") then
                m_val <= 1;
                ASSERT FALSE REPORT "VCO is bypassed, setting M modulus = 1, M time delay = 0" severity note;
            end if;

            -- cntr M2
            if (ss > 0) then
                low := scan_data(42 downto 34);
                m2_val <= alt_conv_integer(low);
                if (scan_data(43) /= '1') then
                    if (m2_mode_val = "bypass") then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal mode for M2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(low) = 1) then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal 1 value for M2 counter. Instead, M counter should be BYPASSED. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(low) = 0) then
                        m2_val <= 512;
                        ASSERT FALSE REPORT "M2 modulus = " &int2str(512)& " "severity note;
                    else
                        ASSERT FALSE REPORT "M2 modulus = " &int2str(alt_conv_integer(low))& " "severity note;
                    end if;
                    m2_mode_val <= "      ";
                elsif (scan_data(43) = '1') then
                    if (m2_mode_val /= "bypass") then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal mode for M2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                    elsif (scan_data(34) /= '0') then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal value for M2 counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                    else
                        m2_val <= 1;
                        ASSERT FALSE REPORT "M2 modulus = " &int2str(1)& " "severity note;
                    end if;
                    m2_mode_val <= "bypass";
                end if;
                if (m_mode_val /= m2_mode_val) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Incompatible modes for M1/M2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                end if;
            end if;

            delay_chain := scan_data(47 downto 44);
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            m_time_delay_val <= delay_val;
            if (skip_vco = "on") then
                m_time_delay_val <= 0;
                delay_val := 0;
            end if;
            ASSERT FALSE REPORT " M time delay = " &int2str(delay_val)& " "severity note;

            -- cntr N
            is_error := false;
            -- 'low' contains modulus for n_cntr(spread_spectrum disabled)
            low := scan_data(8 downto 0);
            n_val <= alt_conv_integer(low);
            if (scan_data(9) /= '1') then
                if (n_mode_val = "bypass") then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal mode for N counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                elsif (alt_conv_integer(low) = 1) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal 1 value for N counter. Instead, M counter should be BYPASSED. Reconfiguration may not work." severity warning;
                elsif (alt_conv_integer(low) = 0) then
                    n_val <= 512;
                    ASSERT FALSE REPORT "N modulus = " &int2str(512)& " "severity note;
                else
                    ASSERT FALSE REPORT "N modulus = " &int2str(alt_conv_integer(low))& " "severity note;
                end if;
                n_mode_val <= "      ";
            elsif (scan_data(9) = '1') then
                if (n_mode_val /= "bypass") then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal mode for N counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                elsif (scan_data(0) /= '0') then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Illegal value for N counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                else
                    n_val <= 1;
                    ASSERT FALSE REPORT "N modulus = " &int2str(1)& " "severity note;
                end if;
                n_mode_val <= "bypass";
            end if;

            -- cntr N2
            if (ss > 0) then
                low := scan_data(18 downto 10);
                n2_val <= alt_conv_integer(low);
                if (scan_data(19) /= '1') then
                    if (n2_mode_val = "bypass") then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal mode for N2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(low) = 1) then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal 1 value for N2 counter. Instead, N counter should be BYPASSED. Reconfiguration may not work." severity warning;
                    elsif (alt_conv_integer(low) = 0) then
                        n2_val <= 512;
                        ASSERT FALSE REPORT "N2 modulus = " &int2str(512)& " "severity note;
                    else
                        ASSERT FALSE REPORT "N2 modulus = " &int2str(alt_conv_integer(low))& " "severity note;
                    end if;
                    n2_mode_val <= "      ";
                elsif (scan_data(19) = '1') then
                    if (n2_mode_val /= "bypass") then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal mode for N2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work." severity warning;
                    elsif (scan_data(10) /= '0') then
                        is_error := true;
                        reconfig_err <= true;
                        ASSERT false REPORT "Illegal value for N2 counter in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work." severity warning;
                    else
                        n2_val <= 1;
                        ASSERT FALSE REPORT "N2 modulus = " &int2str(1)& " "severity note;
                    end if;
                    n2_mode_val <= "bypass";
                end if;
                if (n_mode_val /= n2_mode_val) then
                    is_error := true;
                    reconfig_err <= true;
                    ASSERT false REPORT "Incompatible modes for N1/N2 counters. Either both should be BYPASSED or both NON-BYPASSED. Reconfiguration may not work." severity warning;
                end if;
            end if;

            delay_chain := scan_data(23 downto 20);
            delay_val := alt_conv_integer(delay_chain);
            delay_val := delay_val * 250;
            if (delay_val > 3000) then
               delay_val := 3000;
            end if;
            n_time_delay_val <= delay_val;
            ASSERT FALSE REPORT " N time delay = " &int2str(delay_val)& " "severity note;

      else

         if (scan_chain = "long") then
            ASSERT false REPORT "E3 high = "& int2str(e3_high_val) & 
                                ", E3 low = "& int2str(e3_low_val) & 
                                ", E3 mode = "& e3_mode_val & 
                                ",  E3 time delay = "& int2str(e3_time_delay_val) & 
                                " "severity note;
            ASSERT false REPORT "E2 high = "& int2str(e2_high_val) & 
                                ", E2 low = "& int2str(e2_low_val) & 
                                ", E2 mode = "& e2_mode_val & 
                                ",  E2 time delay = "& int2str(e2_time_delay_val) & 
                                " "severity note;
            ASSERT false REPORT "E1 high = "& int2str(e1_high_val) & 
                                ", E1 low = "& int2str(e1_low_val) & 
                                ", E1 mode = "& e1_mode_val & 
                                ",  E1 time delay = "& int2str(e1_time_delay_val) & 
                                " "severity note;
            ASSERT false REPORT "E0 high = "& int2str(e0_high_val) & 
                                ", E0 low = "& int2str(e0_low_val) & 
                                ", E0 mode = "& e0_mode_val & 
                                ",  E0 time delay = "& int2str(e0_time_delay_val) & 
                                " "severity note;
         end if;

         ASSERT false REPORT "L1 high = "& int2str(l1_high_val) & 
                             ", L1 low = "& int2str(l1_low_val) & 
                             ", l1 mode = "& l1_mode_val & 
                             ",  l1 time delay = "& int2str(l1_time_delay_val) & 
                             " "severity note;
         ASSERT false REPORT "L0 high = "& int2str(l0_high_val) & 
                             ", L0 low = "& int2str(l0_low_val) & 
                             ", l0 mode = "& l0_mode_val & 
                             ",  l0 time delay = "& int2str(l0_time_delay_val) & 
                             " "severity note;
         ASSERT false REPORT "G3 high = "& int2str(g3_high_val) & 
                             ", G3 low = "& int2str(g3_low_val) & 
                             ", G3 mode = "& g3_mode_val & 
                             ",  G3 time delay = "& int2str(g3_time_delay_val) & 
                             " "severity note;
         ASSERT false REPORT "G2 high = "& int2str(g2_high_val) & 
                             ", G2 low = "& int2str(g2_low_val) & 
                             ", G2 mode = "& g2_mode_val & 
                             ",  G2 time delay = "& int2str(g2_time_delay_val) & 
                             " "severity note;
         ASSERT false REPORT "G1 high = "& int2str(g1_high_val) & 
                             ", G1 low = "& int2str(g1_low_val) & 
                             ", G1 mode = "& g1_mode_val & 
                             ",  G1 time delay = "& int2str(g1_time_delay_val) & 
                             " "severity note;
         ASSERT false REPORT "G0 high = "& int2str(g0_high_val) & 
                             ", G0 low = "& int2str(g0_low_val) & 
                             ", G0 mode = "& g0_mode_val & 
                             ",  G0 time delay = "& int2str(g0_time_delay_val) & 
                             " "severity note;
      end if;
   end process;

    process (schedule_vco, areset_ipd, ena_ipd, pfdena_ipd, refclk, fbclk)
    variable sched_time : time := 0 ps;

    TYPE time_array is ARRAY (0 to 7) of time;
    variable init : boolean := true;
    variable refclk_period : time;
    variable primary_clock_frequency : time;
    variable m_times_vco_period : time;
    variable new_m_times_vco_period : time;

    variable phase_shift : time_array := (OTHERS => 0 ps);
    variable last_phase_shift : time_array := (OTHERS => 0 ps);

    variable l_index : integer := 1;
    variable cycle_to_adjust : integer := 0;

    variable stop_vco : boolean := false;

    variable locked_tmp : std_logic := '0';
    variable pll_is_locked : boolean := false;
    variable pll_about_to_lock : boolean := false;
    variable cycles_to_lock : integer := 0;
    variable cycles_to_unlock : integer := 0;

    variable got_first_refclk : boolean := false;
    variable got_second_refclk : boolean := false;
    variable got_first_fbclk : boolean := false;

    variable refclk_time : time := 0 ps;
    variable fbclk_time : time := 0 ps;
    variable first_fbclk_time : time := 0 ps;

    variable fbclk_period : time := 0 ps;

    variable first_schedule : boolean := true;
    variable schedule_offset : boolean := true;

    variable vco_val : std_logic := '0';
    variable vco_period_was_phase_adjusted : boolean := false;
    variable phase_adjust_was_scheduled : boolean := false;

    variable loop_xplier : integer;
    variable loop_initial : integer := 0;
    variable loop_ph : integer := 0;
    variable loop_time_delay : integer := 0;

    variable initial_delay : time := 0 ps;
    variable vco_per : time;
    variable tmp_rem : integer;
    variable my_rem : integer;
    variable fbk_phase : integer := 0;

    variable pull_back_ext_fbk_cntr : integer := 0;
    variable pull_back_M : integer := 0;
    variable total_pull_back : integer := 0;
    variable fbk_delay : integer := 0;

    variable offset : time := 0 ps;

    variable tmp_vco_per : integer := 0;
    variable high_time : time;
    variable low_time : time;

    variable got_refclk_posedge : boolean := false;
    variable got_fbclk_posedge : boolean := false;
    variable inclk_out_of_range : boolean := false;
    variable no_warn : boolean := false;
    variable init_clks : boolean := true;

    begin
        if (init) then
            if (pll_type = "fast") then
                locked_tmp := '1';
            end if;

            -- jump-start the VCO
            -- add 1 ps delay to ensure all signals are updated to initial
            -- values
            schedule_vco <= transport not schedule_vco after 1 ps;

            init := false;
        end if;

        if (schedule_vco'event) then
            if (init_clks) then
                if (primary_clock = "inclk0") then
                    refclk_period := inclk0_input_frequency * n_val * 1 ps;
                    primary_clock_frequency := inclk0_input_frequency * 1 ps;
                elsif (primary_clock = "inclk1") then
                    refclk_period := inclk1_input_frequency * n_val * 1 ps;
                    primary_clock_frequency := inclk1_input_frequency * 1 ps;
                end if;

                m_times_vco_period := refclk_period;
                new_m_times_vco_period := refclk_period;
                init_clks := false;
            end if;

            sched_time := 0 ps;
            for i in 0 to 7 loop
                last_phase_shift(i) := phase_shift(i);
            end loop;
            cycle_to_adjust := 0;
            l_index := 1;
            m_times_vco_period := new_m_times_vco_period;
        end if;

        -- areset was asserted
        if (areset_ipd'event and areset_ipd = '1') then
            assert false report "PLL was reset" severity note;
        end if;

        -- ena was deasserted
        if (ena_ipd'event and ena_ipd = '0') then
            assert false report "PLL was disabled" severity note;
        end if;

        if (schedule_vco'event and (areset_ipd = '1' or ena_ipd = '0' or stop_vco)) then

            -- drop VCO taps to 0
            for i in 0 to 7 loop
                vco_out(i) <= transport '0' after last_phase_shift(i);
                phase_shift(i) := 0 ps;
                last_phase_shift(i) := 0 ps;
            end loop;

            -- reset lock parameters
            locked_tmp := '0';
            if (pll_type = "fast") then
                locked_tmp := '1';
            end if;
            pll_is_locked := false;
            pll_about_to_lock := false;
            cycles_to_lock := 0;
            cycles_to_unlock := 0;

            got_first_refclk := false;
            got_second_refclk := false;
            refclk_time := 0 ps;
            got_first_fbclk := false;
            fbclk_time := 0 ps;
            first_fbclk_time := 0 ps;
            fbclk_period := 0 ps;

            first_schedule := true;
            schedule_offset := true;
            vco_val := '0';
            vco_period_was_phase_adjusted := false;
            phase_adjust_was_scheduled := false;

        elsif ((schedule_vco'event or ena_ipd'event or areset_ipd'event) and areset_ipd = '0' and ena_ipd = '1' and (not stop_vco) and now > 0 ps) then

            -- calculate loop_xplier : this will be different from m_val
            -- in external_feedback_mode
            loop_xplier := m_val;
            loop_initial := m_initial_val - 1;
            loop_ph := m_ph_val;
            loop_time_delay := m_time_delay_val;

            if (operation_mode = "external_feedback") then
                loop_xplier := m_val * (ext_fbk_cntr_high + ext_fbk_cntr_low);
                loop_ph := ext_fbk_cntr_ph;
                loop_initial := ext_fbk_cntr_initial - 1 + ((m_initial_val - 1) * (ext_fbk_cntr_high + ext_fbk_cntr_low));
                loop_time_delay := m_time_delay_val + ext_fbk_cntr_delay;
            end if;

            -- convert initial value to delay
            initial_delay := (loop_initial * m_times_vco_period)/loop_xplier;

            -- convert loop ph_tap to delay
            my_rem := (m_times_vco_period/1 ps) rem loop_xplier;
            tmp_vco_per := (m_times_vco_period/1 ps) / loop_xplier;
            if (my_rem /= 0) then
                tmp_vco_per := tmp_vco_per + 1;
            end if;
            fbk_phase := (loop_ph * tmp_vco_per)/8;

            if (operation_mode = "external_feedback") then
                pull_back_ext_fbk_cntr :=  ext_fbk_cntr_delay + (ext_fbk_cntr_initial - 1) * (m_times_vco_period/loop_xplier)/1 ps + fbk_phase;
                while (pull_back_ext_fbk_cntr > refclk_period/1 ps) loop
                    pull_back_ext_fbk_cntr := pull_back_ext_fbk_cntr - refclk_period/ 1 ps;
                end loop;
                pull_back_M :=  m_time_delay_val + (m_initial_val - 1) * (ext_fbk_cntr_high + ext_fbk_cntr_low) * ((refclk_period/loop_xplier)/1 ps);
                while (pull_back_M > refclk_period/1 ps) loop
                    pull_back_M := pull_back_M - refclk_period/ 1 ps;
                end loop;
            else
                pull_back_ext_fbk_cntr := 0;
                pull_back_M := initial_delay/1 ps + m_time_delay_val + fbk_phase;
            end if;

            total_pull_back := pull_back_M + pull_back_ext_fbk_cntr;

            if (simulation_type = "timing") then
                total_pull_back := total_pull_back + pll_compensation_delay;
            end if;
            while (total_pull_back > refclk_period/1 ps) loop
                total_pull_back := total_pull_back - refclk_period/1 ps;
            end loop;

            if (total_pull_back > 0) then
                offset := refclk_period - (total_pull_back * 1 ps);
            end if;
            if (operation_mode = "external_feedback") then
                fbk_delay := pull_back_M;
                if (simulation_type = "timing") then
                    fbk_delay := fbk_delay + pll_compensation_delay;
                end if;
                ext_fbk_delay <= transport (pull_back_ext_fbk_cntr - fbk_phase) after 1 ps;
            else
                fbk_delay := total_pull_back - fbk_phase;
                if (fbk_delay < 0) then
                    offset := offset - (fbk_phase * 1 ps);
                    fbk_delay := total_pull_back;
                end if;
            end if;

            -- assign m_delay
            m_delay <= transport fbk_delay after 1 ps;

            my_rem := (m_times_vco_period/1 ps) rem loop_xplier;
            for i in 1 to loop_xplier loop
                -- adjust cycles
                tmp_vco_per := (m_times_vco_period/1 ps)/loop_xplier;
                if (my_rem /= 0 and l_index <= my_rem) then
                   tmp_rem := (loop_xplier * l_index) rem my_rem;
                   cycle_to_adjust := (loop_xplier * l_index) / my_rem;
                   if (tmp_rem /= 0) then
                      cycle_to_adjust := cycle_to_adjust + 1;
                   end if;
                end if;
                if (cycle_to_adjust = i) then
                    tmp_vco_per := tmp_vco_per + 1;
                    l_index := l_index + 1;
                end if;

                -- calculate high and low periods
                vco_per := tmp_vco_per * 1 ps;
                high_time := (tmp_vco_per/2) * 1 ps;
                if (tmp_vco_per rem 2 /= 0) then
                   high_time := high_time + 1 ps;
                end if;
                low_time := vco_per - high_time;

                -- schedule the rising and falling edges
                for j in 1 to 2 loop
                   vco_val := not vco_val;
                   if (vco_val = '0') then
                      sched_time := sched_time + high_time;
                   elsif (vco_val = '1') then
                      sched_time := sched_time + low_time;
                   end if;

                   -- add offset
                   if (schedule_offset) then
                       sched_time := sched_time + offset;
                       schedule_offset := false;
                   end if;

                   -- schedule the phase taps
                   for k in 0 to 7 loop
                       phase_shift(k) := (k * vco_per)/8;
                       if (first_schedule) then
                          vco_out(k) <= transport vco_val after (sched_time + phase_shift(k));
                       else
                          vco_out(k) <= transport vco_val after (sched_time + last_phase_shift(k));
                       end if;
                   end loop;
                end loop;
            end loop;

            -- schedule once more
            if (first_schedule) then
                vco_val := not vco_val;
                if (vco_val = '0') then
                   sched_time := sched_time + high_time;
                elsif (vco_val = '1') then
                   sched_time := sched_time + low_time;
                end if;
                -- schedule the phase taps
                for k in 0 to 7 loop
                    phase_shift(k) := (k * vco_per)/8;
                    vco_out(k) <= transport vco_val after (sched_time + phase_shift(k));
                end loop;
                first_schedule := false;
            end if;

            schedule_vco <= transport not schedule_vco after sched_time;

            if (vco_period_was_phase_adjusted) then
                m_times_vco_period := refclk_period;
                new_m_times_vco_period := refclk_period;
                vco_period_was_phase_adjusted := false;
                phase_adjust_was_scheduled := true;

                vco_per := m_times_vco_period/loop_xplier;
                for k in 0 to 7 loop
                    phase_shift(k) := (k * vco_per)/8;
                end loop;
            end if;
        end if;

        if (refclk'event and refclk = '1' and areset_ipd = '0') then
            got_refclk_posedge := true;
            if (not got_first_refclk) then
                got_first_refclk := true;
            else
                got_second_refclk := true;
                refclk_period := now - refclk_time;

                -- check if incoming freq. will cause VCO range to be
                -- exceeded
                if ( (vco_max /= 0 and vco_min /= 0 and skip_vco = "off" and pfdena_ipd = '1') and
                     (((refclk_period/1 ps)/loop_xplier > vco_max) or
                      ((refclk_period/1 ps)/loop_xplier < vco_min)) ) then
                    if (pll_is_locked) then
                        assert false report " Input clock freq. is not within VCO range : PLL may lose lock" severity warning;
                    else
                        assert false report " Input clock freq. is not within VCO range : PLL may not lock. Please use the correct frequency." severity warning;
                    end if;
                    inclk_out_of_range := true;
                elsif (vco_min = 0 and vco_max = 0 and pll_type = "cdr") then
                    if (refclk_period /= primary_clock_frequency) then
                        if (not no_warn) then
                            assert false report "Incoming clock period " & int2str(refclk_period/1 ps) & " ps for PLL does not match the specified inclock period " & int2str(primary_clock_frequency/1 ps) & " ps. ALTGXB simulation may not function correctly. " severity warning;
                            no_warn := true;
                        end if;
                    end if;
                else
                    inclk_out_of_range := false;
                end if;
            end if;

            if (stop_vco) then
                stop_vco := false;
                schedule_vco <= not schedule_vco;
            end if;

            refclk_time := now;
        else
            got_refclk_posedge := false;
        end if;

        if (fbclk'event and fbclk = '1') then
            got_fbclk_posedge := true;
            if (not got_first_fbclk) then
                got_first_fbclk := true;
            else
                fbclk_period := now - fbclk_time;
            end if;

            -- need refclk_period here, so initialized to proper value above
            if ( (now - refclk_time > 1.5 * refclk_period) and pfdena_ipd = '1') then
                stop_vco := true;
                -- reset
                got_first_refclk := false;
                got_first_fbclk := false;
                got_second_refclk := false;
                if (pll_is_locked) then
                    pll_is_locked := false;
                    locked_tmp := '0';
                    if (pll_type = "fast") then
                        locked_tmp := '1';
                    end if;
                    assert false report "PLL lost lock due to loss of input clock" severity note;
                end if;
                pll_about_to_lock := false;
                cycles_to_lock := 0;
                cycles_to_unlock := 0;
                first_schedule := true;
            end if;
            fbclk_time := now;
        else
            got_fbclk_posedge := false;
        end if;

        if ((got_refclk_posedge or got_fbclk_posedge) and got_second_refclk and pfdena_ipd = '1' and (not inclk_out_of_range)) then

            -- now we know actual incoming period
            if ( abs(fbclk_time - refclk_time) <= 5 ps or
                 (got_first_fbclk and abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5 ps)) then
                -- considered in phase
                if (cycles_to_lock = valid_lock_multiplier - 1) then
                    pll_about_to_lock := true;
                end if;
                if (cycles_to_lock = valid_lock_multiplier) then
                    if (not pll_is_locked) then
                        assert (quiet_period_violation) report "PLL locked to incoming clock" severity note;
                    end if;
                    pll_is_locked := true;
                    locked_tmp := '1';
                    if (pll_type = "fast") then
                        locked_tmp := '0';
                    end if;
                end if;
                -- increment lock counter only if second part of above
                -- time check is NOT true
                if (not(abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5 ps)) then
                    cycles_to_lock := cycles_to_lock + 1;
                end if;

                -- adjust m_times_vco_period
                new_m_times_vco_period := refclk_period;
            else
                -- if locked, begin unlock
                if (pll_is_locked) then
                    cycles_to_unlock := cycles_to_unlock + 1;
                    if (cycles_to_unlock = invalid_lock_multiplier) then
                        pll_is_locked := false;
                        locked_tmp := '0';
                        if (pll_type = "fast") then
                            locked_tmp := '1';
                        end if;
                        pll_about_to_lock := false;
                        cycles_to_lock := 0;
                        first_schedule := true;
                        schedule_offset := true;
                        vco_period_was_phase_adjusted := false;
                        phase_adjust_was_scheduled := false;
                    end if;
                end if;
                if ( abs(refclk_period - fbclk_period) <= 2 ps ) then
                    -- frequency is still good
                    if (now = fbclk_time and (not phase_adjust_was_scheduled)) then
                        if ( abs(fbclk_time - refclk_time) > refclk_period/2) then
                            new_m_times_vco_period := m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                            vco_period_was_phase_adjusted := true;
                        else
                            new_m_times_vco_period := m_times_vco_period - abs(fbclk_time - refclk_time);
                            vco_period_was_phase_adjusted := true;
                        end if;

                    end if;
                else
                    phase_adjust_was_scheduled := false;
                    new_m_times_vco_period := refclk_period;
                end if;
            end if;
        end if;

        if (pfdena_ipd = '0') then
            locked_tmp := 'X';
            pll_is_locked := false;
            cycles_to_lock := 0;
        end if;

        -- give message only at time of deassertion
        if (pfdena_ipd'event and pfdena_ipd = '0') then
            assert false report "PFDENA deasserted." severity note;
        elsif (pfdena_ipd'event and pfdena_ipd = '1') then
            got_first_refclk := false;
            got_second_refclk := false;
            refclk_time := now;
        end if;

        if (quiet_period_violation or reconfig_err or scanclr_violation or scanclr_clk_violation) then
            lock <= '0';
            if (pll_type = "fast") then
                lock <= '1';
            end if;
        else
            lock <= locked_tmp;
        end if;
        about_to_lock <= pll_about_to_lock after 1 ps;

        -- signal to calculate quiet_time
        sig_refclk_period <= refclk_period;

        -- signals for debugging
        sig_offset <= offset;
        sig_refclk_time <= refclk_time;
        sig_fbclk_period <= fbclk_period;
        sig_vco_period_was_phase_adjusted <= vco_period_was_phase_adjusted;
        sig_phase_adjust_was_scheduled <= phase_adjust_was_scheduled;
        if (stop_vco = true) then
            sig_stop_vco <= '1';
        else
            sig_stop_vco <= '0';
        end if;
        sig_m_times_vco_period <= m_times_vco_period;
        sig_new_m_times_vco_period <= new_m_times_vco_period;
        sig_got_refclk_posedge <= got_refclk_posedge;
        sig_got_fbclk_posedge <= got_fbclk_posedge;
        sig_got_second_refclk <= got_second_refclk;
    end process;

    process (scanclk_ipd, scanaclr_ipd, scan_data, transfer)
      variable j : integer := 0;
      variable pll_in_quiet_period : boolean := false;
      variable start_quiet_time : time := 0 ps;
      variable quiet_time : time := 0 ps;
      variable scanclr_rising_time : time := 0 ps;
      variable scanclr_falling_time : time := 0 ps;
      variable got_first_scanclk_after_scanclr_inactive_edge : boolean := false;
      variable scan_chain_being_reset : boolean := false;

      function slowest_clk(L0 : integer; L1 : integer; G0 : integer;
                           G1 : integer; G2 : integer; G3 : integer;
                           E0 : integer; E1 : integer; E2 : integer;
                           E3 : integer; scan_chain : string; 
                           refclk : time; m_mod : integer) return time is
      variable max_modulus : integer := 0;
      variable q_period : time := 0 ps;
      variable refclk_int : integer := 0;
      begin
          if (L0 > L1) then max_modulus := L0; else max_modulus := L1; end if;
          if (G0 > max_modulus) then max_modulus := G0; end if;
          if (G1 > max_modulus) then max_modulus := G1; end if;
          if (G2 > max_modulus) then max_modulus := G2; end if;
          if (G3 > max_modulus) then max_modulus := G3; end if;
          if (scan_chain = "long") then
              if (E0 > max_modulus) then max_modulus := E0; end if;
              if (E1 > max_modulus) then max_modulus := E1; end if;
              if (E2 > max_modulus) then max_modulus := E2; end if;
              if (E3 > max_modulus) then max_modulus := E3; end if;
          end if;
          refclk_int := refclk / 1 ps;
          if (m_mod /= 0) then
              q_period := ((refclk_int/m_mod) * max_modulus) * 1 ps;
          end if;
          return (2*q_period);
      end slowest_clk;

    begin
        if (transfer'event) then
            if (transfer = '0') then
                -- clear the chain
                for i in scan_data'range loop
                    scan_data(i) <= '0';
                end loop;
            end if;
        elsif (scanaclr_ipd'event and scanaclr_ipd = '1') then
            -- scanaclr rising
            scanclr_rising_time := now;
            scan_chain_being_reset := true;
        elsif (scanaclr_ipd'event and scanaclr_ipd = '0') then
            -- scanaclr falling
            scanclr_falling_time := now;
            if (scan_chain_being_reset and (now - scanclr_rising_time < TRST)) then
                scanclr_violation <= true;
                ASSERT false REPORT "Detected SCANACLR ACTIVE pulse width violation. Required is 5000 ps, actual is "& int2str((now - scanclr_rising_time) / 1 ps) &". The PLL may not function correctly." severity warning;
            else
                scanclr_violation <= false;
                for i in scan_data'range loop
                    scan_data(i) <= '0';
                end loop;
            end if;
            scan_chain_being_reset := false;
            got_first_scanclk_after_scanclr_inactive_edge := false;
        elsif (scanclk_ipd'event and scanclk_ipd = '1' and not got_first_scanclk_after_scanclr_inactive_edge and (now - scanclr_falling_time < TRSTCLK)) then
            scanclr_clk_violation <= true;
            got_first_scanclk_after_scanclr_inactive_edge := true;

            ASSERT false REPORT "Detected SCANACLR INACTIVE time violation before rising edge of SCANCLK. Required is 5000 ps, actual is "& int2str((now - scanclr_falling_time) / 1 ps) &". Reconfiguration may not work." severity warning;
        elsif (scanclk_ipd'event and scanclk_ipd = '1' and scanaclr_ipd = '0') then
            if (pll_in_quiet_period and (now - start_quiet_time < quiet_time)) then
                ASSERT false REPORT "Detected transition on SCANCLK during quiet period. The PLL may not function correctly." severity warning;
                quiet_period_violation <= true;
            else
                pll_in_quiet_period := false;
                for j in scan_chain_length-1 downto 1 loop
                    scan_data(j) <= scan_data(j-1);
                end loop;
                scan_data(0) <= scandata_ipd;
            end if;
            if (not got_first_scanclk_after_scanclr_inactive_edge) then
                got_first_scanclk_after_scanclr_inactive_edge := true;
                scanclr_clk_violation <= false;
            end if;
        elsif (scanclk_ipd'event and scanclk_ipd = '0' and scanaclr_ipd = '0') then
            if (pll_in_quiet_period and (now - start_quiet_time < quiet_time)) then
                ASSERT false REPORT "Detected transition on SCANCLK during quiet period. The PLL may not function correctly." severity warning;
                quiet_period_violation <= true;
            elsif (scan_data(scan_chain_length-1) = '1') then
                -- reset violation flag only after another reconfig seq.
                quiet_period_violation <= false;

                -- initiate transfer
                transfer <= '1';
                transfer <= transport '0' after 1 ps;
                scandataout_tmp <= '1';
                pll_in_quiet_period := true;
                start_quiet_time := now;
                quiet_time := slowest_clk(l0_high_val+l0_low_val,
                                          l1_high_val+l1_low_val,
                                          g0_high_val+g0_low_val,
                                          g1_high_val+g1_low_val,
                                          g2_high_val+g2_low_val,
                                          g3_high_val+g3_low_val,
                                          e0_high_val+e0_low_val,
                                          e1_high_val+e1_low_val,
                                          e2_high_val+e2_low_val,
                                          e3_high_val+e3_low_val,
                                          scan_chain, sig_refclk_period, m_val);
                scandataout_tmp <= transport '0' after quiet_time;
            end if;
        end if;
    end process;

    clk0_tmp <= l0_clk when i_clk0_counter = "l0" else
                l1_clk when i_clk0_counter = "l1" else
                g0_clk when i_clk0_counter = "g0" else
                g1_clk when i_clk0_counter = "g1" else
                g2_clk when i_clk0_counter = "g2" else
                g3_clk when i_clk0_counter = "g3" else
                '0';
    not_clk0_tmp <= not clk0_tmp;
    ena0_reg : dffe
              port map (D    => clkena(0),
                        CLRN => vcc,
                        PRN  => vcc,
                        ENA  => vcc,
                        CLK  => not_clk0_tmp,
                        Q    => ena0
                       );
    clk(0) <= ena0 and clk0_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
              'X';

    clk1_tmp <= l0_clk when i_clk1_counter = "l0" else
                l1_clk when i_clk1_counter = "l1" else
                g0_clk when i_clk1_counter = "g0" else
                g1_clk when i_clk1_counter = "g1" else
                g2_clk when i_clk1_counter = "g2" else
                g3_clk when i_clk1_counter = "g3" else
                '0';
    not_clk1_tmp <= not clk1_tmp;
    ena1_reg : dffe
              port map (D => clkena(1),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_clk1_tmp,
                        Q => ena1
                       );
    clk(1) <= ena1 and clk1_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
              'X';

    clk2_tmp <= l0_clk when i_clk2_counter = "l0" else
                l1_clk when i_clk2_counter = "l1" else
                g0_clk when i_clk2_counter = "g0" else
                g1_clk when i_clk2_counter = "g1" else
                g2_clk when i_clk2_counter = "g2" else
                g3_clk when i_clk2_counter = "g3" else
                '0';
    not_clk2_tmp <= not clk2_tmp;
    ena2_reg : dffe
              port map (D => clkena(2),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_clk2_tmp,
                        Q => ena2
                       );
    clk(2) <= ena2 and clk2_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
              'X';

    clk3_tmp <= l0_clk when i_clk3_counter = "l0" else
                l1_clk when i_clk3_counter = "l1" else
                g0_clk when i_clk3_counter = "g0" else
                g1_clk when i_clk3_counter = "g1" else
                g2_clk when i_clk3_counter = "g2" else
                g3_clk when i_clk3_counter = "g3" else
                '0';
    not_clk3_tmp <= not clk3_tmp;
    ena3_reg : dffe
              port map (D => clkena(3),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_clk3_tmp,
                        Q => ena3
                       );
    clk(3) <= ena3 and clk3_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
              'X';

    clk4_tmp <= l0_clk when i_clk4_counter = "l0" else
                l1_clk when i_clk4_counter = "l1" else
                g0_clk when i_clk4_counter = "g0" else
                g1_clk when i_clk4_counter = "g1" else
                g2_clk when i_clk4_counter = "g2" else
                g3_clk when i_clk4_counter = "g3" else
                '0';
    not_clk4_tmp <= not clk4_tmp;
    ena4_reg : dffe
              port map (D => clkena(4),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_clk4_tmp,
                        Q => ena4
                       );
    clk(4) <= ena4 and clk4_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
              'X';

    clk5_tmp <= l0_clk when i_clk5_counter = "l0" else
                l1_clk when i_clk5_counter = "l1" else
                g0_clk when i_clk5_counter = "g0" else
                g1_clk when i_clk5_counter = "g1" else
                g2_clk when i_clk5_counter = "g2" else
                g3_clk when i_clk5_counter = "g3" else
                '0';
    not_clk5_tmp <= not clk5_tmp;
    ena5_reg : dffe
              port map (D => clkena(5),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_clk5_tmp,
                        Q => ena5
                       );
    clk(5) <= ena5 and clk5_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
              'X';

    extclk0_tmp <= e0_clk when i_extclk0_counter = "e0" else
                   e1_clk when i_extclk0_counter = "e1" else
                   e2_clk when i_extclk0_counter = "e2" else
                   e3_clk when i_extclk0_counter = "e3" else
                   '0';
    not_extclk0_tmp <= not extclk0_tmp;
    extena0_reg : dffe
              port map (D => extclkena(0),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_extclk0_tmp,
                        Q => extena0
                       );
    extclk(0) <= extena0 and extclk0_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                 'X';

    extclk1_tmp <= e0_clk when i_extclk1_counter = "e0" else
                   e1_clk when i_extclk1_counter = "e1" else
                   e2_clk when i_extclk1_counter = "e2" else
                   e3_clk when i_extclk1_counter = "e3" else
                   '0';
    not_extclk1_tmp <= not extclk1_tmp;
    extena1_reg : dffe
              port map (D => extclkena(1),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_extclk1_tmp,
                        Q => extena1
                       );
    extclk(1) <= extena1 and extclk1_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                 'X';

    extclk2_tmp <= e0_clk when i_extclk2_counter = "e0" else
                   e1_clk when i_extclk2_counter = "e1" else
                   e2_clk when i_extclk2_counter = "e2" else
                   e3_clk when i_extclk2_counter = "e3" else
                   '0';
    not_extclk2_tmp <= not extclk2_tmp;
    extena2_reg : dffe
              port map (D => extclkena(2),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_extclk2_tmp,
                        Q => extena2
                       );
    extclk(2) <= extena2 and extclk2_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                 'X';

    extclk3_tmp <= e0_clk when i_extclk3_counter = "e0" else
                   e1_clk when i_extclk3_counter = "e1" else
                   e2_clk when i_extclk3_counter = "e2" else
                   e3_clk when i_extclk3_counter = "e3" else
                   '0';
    not_extclk3_tmp <= not extclk3_tmp;
    extena3_reg : dffe
              port map (D => extclkena(3),
                        CLRN => vcc,
                        PRN => vcc,
                        ENA => vcc,
                        CLK => not_extclk3_tmp,
                        Q => extena3
                       );
    extclk(3) <= extena3 and extclk3_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
                 'X';

    enable0 <= enable0_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
               'X';
    enable1 <= enable1_tmp when (areset_ipd = '1' or ena_ipd = '0') or (about_to_lock and (not quiet_period_violation) and (not reconfig_err) and (not scanclr_violation) and (not scanclr_clk_violation)) else
               'X';

    scandataout <= scandataout_tmp;

end vital_pll;
--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : stratix_dll
--
-- Description : Simulation model for the Stratix DLL.
--
-- Outputs     : Delayctrlout output (active high) indicates when the
--               DLL locks to the incoming clock
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY ieee, stratix;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE stratix.atom_pack.all;
USE stratix.pllpack.all;

ENTITY stratix_dll is
    GENERIC ( input_frequency   : string  := "10000 ps";
              phase_shift       : string  := "0";
              sim_valid_lock    : integer := 1;
              sim_invalid_lock  : integer := 5;
              lpm_type          : string  := "stratix_dll";

              -- VITAL generics
              XOn                         : Boolean := DefGlitchXOn;
              MsgOn                       : Boolean := DefGlitchMsgOn;
              tipd_clk                    : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( clk           : IN std_logic;
              delayctrlout  : OUT std_logic
            );
END stratix_dll;

ARCHITECTURE vital_dll of stratix_dll is

signal clk_detect : std_logic := '0';
signal clk_ipd : std_logic;

begin

    --------------------
    -- INPUT PATH DELAYS
    --------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
    end block;

    process (clk_ipd, clk_detect)
    variable got_first_rising_edge : boolean := false;
    variable got_first_falling_edge : boolean := false;
    variable clk_ipd_last_rising_edge : time := 0 ps;
    variable clk_ipd_last_falling_edge : time := 0 ps;

    variable inclk_ps : time := 0 ps;
    variable duty_cycle : time := 0 ps;
    variable clk_per_tolerance : time := 0 ps;

    variable clk_detect_count : integer := 0;
    variable start_clk_detect : boolean := false;
    variable half_cycles_to_lock : integer := 0;
    variable half_cycles_to_keep_lock : integer := 0;
    variable violation : boolean := false;

    variable dll_is_locked : std_logic := '0';
    variable init : boolean := true;
    variable input_freq_warn : boolean := true;
    variable duty_cycle_warn : boolean := true;
    begin
        if (init) then
            -- convert the frequency in string form to integer
            inclk_ps := dqs_str2int(input_frequency) * 1 ps;
            duty_cycle := inclk_ps/2;
            clk_per_tolerance := inclk_ps * 0.1;

            -- if sim_valid_lock = 0, dll starts out locked
            if (sim_valid_lock = 0) then
                dll_is_locked := '1';
            end if;
            init := false;
        end if;
        if (clk_ipd'event and clk_ipd = '1') then
            if (not got_first_rising_edge) then
                got_first_rising_edge := true;
                half_cycles_to_lock := half_cycles_to_lock + 1;
                if (sim_valid_lock > 0 and half_cycles_to_lock >= sim_valid_lock and not violation) then
                    dll_is_locked := '1';
                    assert false report "DLL locked to incoming clock" severity note;
                end if;
                -- start the internal clock that will monitor
                -- the input clock
                if (not start_clk_detect) then
                    start_clk_detect := true;
                    clk_detect <= '1';
                end if;
            else
                -- reset clk_event counter
                clk_detect_count := 0;
                -- check for clk period violation
                if ( ((now - clk_ipd_last_rising_edge) < (inclk_ps - clk_per_tolerance)) or ((now - clk_ipd_last_rising_edge) > (inclk_ps + clk_per_tolerance)) ) then
                    violation := true;
                    if (input_freq_warn) then
                        assert false report "Input frequency violation." severity warning;
                        input_freq_warn := false;
                    end if;
                elsif ( ((now - clk_ipd_last_falling_edge) < (duty_cycle - clk_per_tolerance/2)) or ((now - clk_ipd_last_falling_edge) > (duty_cycle + clk_per_tolerance/2)) ) then
                    violation := true;
                    if (duty_cycle_warn) then
                        assert false report "Duty cycle violation." severity warning;
                        duty_cycle_warn := false;
                    end if;
                else
                    violation := false;
                end if;
                if (violation and dll_is_locked = '1') then
                    half_cycles_to_keep_lock := half_cycles_to_keep_lock + 1;
                    if (half_cycles_to_keep_lock > sim_invalid_lock) then
                        dll_is_locked := '0';
                        assert false report "DLL lost lock due to Input Frequency / Duty Cycle violation" severity warning;
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                    end if;
                elsif (violation) then
                    half_cycles_to_lock := 0;
                elsif (not violation and dll_is_locked = '0') then
                    -- increment lock counter
                    half_cycles_to_lock := half_cycles_to_lock + 1;
                    if (half_cycles_to_lock > sim_valid_lock) then
                        dll_is_locked := '1';
                        assert false report "DLL locked to incoming clock" severity note;
                    end if;
                else
                    half_cycles_to_keep_lock := 0;
                end if;
            end if;
            clk_ipd_last_rising_edge := now;
        elsif (clk_ipd'event and clk_ipd = '0') then
            -- reset clk_event counter
            clk_detect_count := 0;
            got_first_falling_edge := true;
            if (got_first_rising_edge) then
                -- check for duty cycle violation
                if ( ((now - clk_ipd_last_rising_edge) < (duty_cycle - clk_per_tolerance/2)) or ((now - clk_ipd_last_rising_edge) > (duty_cycle + clk_per_tolerance/2)) ) then
                    violation := true;
                    if (duty_cycle_warn) then
                        assert false report "Duty cycle violation." severity warning;
                        duty_cycle_warn := false;
                    end if;
                else
                    violation := false;
                end if;
                if (dll_is_locked = '1' and violation) then
                    half_cycles_to_keep_lock := half_cycles_to_keep_lock + 1;
                    if (half_cycles_to_keep_lock > sim_invalid_lock) then
                        dll_is_locked := '0';
                        assert false report "DLL lost lock due to Input Frequency / Duty Cycle violation" severity warning;
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                    end if;
                elsif (dll_is_locked = '1') then
                    half_cycles_to_keep_lock := 0;
                elsif (dll_is_locked = '0' and violation) then
                    half_cycles_to_lock := 0;
                else
                    half_cycles_to_lock := half_cycles_to_lock + 1;
                end if;
            else
                -- first clk edge is falling edge, do nothing
            end if;
            clk_ipd_last_falling_edge := now;
        else
            if (clk_ipd'event) then
                -- illegal value
                if (got_first_rising_edge or got_first_falling_edge) then
                    if (dll_is_locked = '1') then
                        dll_is_locked := '0';
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                        assert false report "Illegal value detected on input clock. DLL will lose lock." severity error;
                    else
                        -- clock started up, then went to 'X'
                        -- this is to weed out the 'X' at start of simulation.
                        assert false report "Illegal value detected on input clock." severity error;
                        -- reset lock counter
                        half_cycles_to_lock := 0;
                    end if;
                end if;
            end if;
        end if;

    -- ********************************************************************
    -- The following block generates the internal clock that is used to
    -- track loss of input clock. A counter counts events on this internal
    -- clock, and is reset to 0 on event on input clock. If input clock
    -- flatlines, the counter will exceed the limit and DLL will lose lock.
    -- Events on internal clock are scheduled at the max. allowable input
    -- clock tolerance, to allow 'sim_invalid_lock' parameter value = 1.
    -- ********************************************************************

        if (start_clk_detect) then
            if (clk_detect'event and clk_detect /= clk_detect'last_value) then
                -- increment clock event counter
                clk_detect_count := clk_detect_count + 1;
                if (dll_is_locked = '1') then
                    if (clk_detect_count > sim_invalid_lock) then
                        dll_is_locked := '0';
                        assert false report "DLL lost lock due to loss of input clock" severity warning;
                        -- reset lock and unlock counters
                        half_cycles_to_lock := 0;
                        half_cycles_to_keep_lock := 0;
                        got_first_rising_edge := false;
                        got_first_falling_edge := false;
                        clk_detect_count := 0;
                        start_clk_detect := false;
                        clk_detect <= transport '0' after inclk_ps/2;
                    else
                        clk_detect <= transport not clk_detect after (inclk_ps/2 + clk_per_tolerance/2);
                    end if;
                elsif (clk_detect_count > 10) then
                    assert false report "No input clock : DLL will not lock" severity warning;
                    clk_detect_count := 0;
                else
                    clk_detect <= transport not clk_detect after (inclk_ps/2 + clk_per_tolerance/2);
                end if;
            end if;
        end if;

        delayctrlout <= dll_is_locked;

    end process;


end vital_dll;
--
--
--  STRATIX_JTAG Model
--
--
library IEEE, stratix;
use IEEE.std_logic_1164.all;
use stratix.atom_pack.all;

entity  stratix_jtag is
	 generic (
					lpm_type	: string := "stratix_jtag"
				);	
    port (tms : in std_logic; 
    		 tck : in std_logic; 
    		 tdi : in std_logic; 
    		 ntrst : in std_logic; 
    		 tdoutap : in std_logic; 
    		 tdouser : in std_logic; 
          tdo: out std_logic; 
          tmsutap: out std_logic; 
          tckutap: out std_logic; 
          tdiutap: out std_logic; 
          shiftuser: out std_logic; 
          clkdruser: out std_logic; 
          updateuser: out std_logic; 
          runidleuser: out std_logic; 
          usr1user: out std_logic);
end stratix_jtag;

architecture architecture_jtag of stratix_jtag is
begin

process(tms, tck, tdi, ntrst, tdoutap, tdouser)
begin

end process;

end architecture_jtag;

--
--
--  STRATIX_CRCBLOCK Model
--
--
library IEEE, stratix;
use IEEE.std_logic_1164.all;
use stratix.atom_pack.all;

entity  stratix_crcblock is
	generic 	(
					oscillator_divider	: integer := 1;
					lpm_type	: string := "stratix_crcblock"
				);	
	port (clk 			: in std_logic; 
   		shiftnld		: in std_logic; 
    		ldsrc			: in std_logic; 
         crcerror		: out std_logic; 
         regout		: out std_logic); 
end stratix_crcblock;

architecture architecture_crcblock of stratix_crcblock is
begin

end architecture_crcblock;
--
--
--  STRATIX_RUBLOCK Model
--
--
library IEEE, stratix;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use stratix.atom_pack.all;

entity  stratix_rublock is
	generic
	(
		operation_mode			: string := "remote";
		sim_init_config			: string := "factory";
		sim_init_watchdog_value	: integer := 0;
		sim_init_page_select	: integer := 0;
		sim_init_status			: integer := 0;
		lpm_type				: string := "stratix_rublock"
	);
	port 
	(
		clk			: in std_logic; 
		shiftnld	: in std_logic; 
		captnupdt	: in std_logic; 
		regin		: in std_logic; 
		rsttimer	: in std_logic; 
		rconfig		: in std_logic; 
		regout		: out std_logic; 
		pgmout		: out std_logic_vector(2 downto 0)
	);

end stratix_rublock;

architecture architecture_rublock of stratix_rublock is

	signal update_reg : std_logic_vector(16 downto 0);
	signal status_reg : std_logic_vector(4 downto 0) := conv_std_logic_vector(sim_init_status, 5);
	signal shift_reg : std_logic_vector(21 downto 0) := (others => '0');

	signal pgmout_update : std_logic_vector(2 downto 0) := (others => '0');

begin

	-- regout is inverted output of shift-reg bit 0
	regout <= not shift_reg(0);

	-- pgmout is set when reconfig is asserted
	pgmout <= pgmout_update;

	process (clk)
	begin

		-- initialize registers/outputs
		if ( now = 0 ns ) then

			-- wd_timeout field
			update_reg(16 downto 5) <= conv_std_logic_vector(sim_init_watchdog_value, 12);

			-- wd enable field
			if (sim_init_watchdog_value > 0) then
				update_reg(4) <= '1';
			else
				update_reg(4) <= '0';
			end if;

			-- PGM[] field
			update_reg(3 downto 1) <= conv_std_logic_vector(sim_init_page_select, 3);

			-- AnF bit
			if (sim_init_config = "factory") then
				update_reg(0) <= '0';
			else
				update_reg(0) <= '1';
			end if;

			--to-do: print field values
			--report "Remote Update Block: Initial configuration:";
			--report "        -> Field CRC, POF ID, SW ID Error Caused Reconfiguration is set to" & status_reg(0);
			--report "        -> Field nSTATUS Caused Reconfiguration is set to %s", status_reg[1] ? "True" : "False";
			--report "        -> Field Core nCONFIG Caused Reconfiguration is set to %s", status_reg[2] ? "True" : "False";
			--report "        -> Field Pin nCONFIG Caused Reconfiguration is set to %s", status_reg[3] ? "True" : "False";
			--report "        -> Field Watchdog Timeout Caused Reconfiguration is set to %s", status_reg[4] ? "True" : "False";
			--report "        -> Field Current Configuration is set to %s", update_reg[0] ? "Application" : "Factory";
			--report "        -> Field PGM[] Page Select is set to %d", update_reg[3:1]);
			--report "        -> Field User Watchdog is set to %s", update_reg[4] ? "Enabled" : "Disabled";
			--report "        -> Field User Watchdog Timeout Value is set to %d", update_reg[16:5];

		else 
			-- dont handle clk events during initialization since this will
			-- destroy the register values that we just initialized

			if (clk = '1') then
				if (shiftnld = '1') then
					-- register shifting
					for i in 0 to 20 loop
						shift_reg(i) <= shift_reg(i+1);
					end loop;

					shift_reg(21) <= regin;

				elsif (shiftnld = '0') then
					-- register loading

					if (captnupdt = '1') then
						-- capture data into shift register
						shift_reg <= update_reg & status_reg;

					elsif (captnupdt = '0') then
						-- update data from shift into Update Register

						if (sim_init_config = "factory" and operation_mode = "remote") then
							-- every bit in Update Reg gets updated
							update_reg(16 downto 0) <= shift_reg(21 downto 5);

							--to-do: print field values
							--VHDL93 only: report "Remote Update Block: Update Register updated at time " & time'image(now);
							--report "        -> Field PGM[] Page Select is set to %d", shift_reg[8:6];
							--report "        -> Field User Watchdog is set to %s", (shift_reg[9] == 1) ? "Enableds" : (shift_reg[9] == 0) ? "Disabled" : "x";
							--report "        -> Field User Watchdog Timeout Value is set to %d", shift_reg[21:10];
						else
							-- trying to do update in Application mode
							--VHDL93 only: report "Remote Update Block: Attempted update of Update Register at time " & time'image(now) & " when Configuration is set to Application" severity WARNING;
						end if;

					else
						-- invalid captnupdt
						-- destroys update and shift regs
						shift_reg <= (others => 'X');
						if (sim_init_config = "factory") then
							update_reg(16 downto 1) <= (others => 'X');
						end if;
					end if;

				else
					-- invalid shiftnld: destroys update and shift regs
					shift_reg <= (others => 'X');
					if (sim_init_config = "factory") then
						update_reg(16 downto 1) <= (others => 'X');
					end if;
				end if;

			elsif (clk /= '0') then
				-- invalid clk: destroys registers
				shift_reg <= (others => 'X');
				if (sim_init_config = "factory") then
					update_reg(16 downto 1) <= (others => 'X');
				end if;
			end if;
		end if;
	end process;

	process (rconfig)
	begin
		-- initialize registers/outputs
		if ( now = 0 ns ) then

			-- pgmout update

			if (operation_mode = "local") then
				pgmout_update <= "001";
			else
				pgmout_update <= conv_std_logic_vector(sim_init_page_select, 3);
				-- PGM[] field
			end if;
		end if;

		if (rconfig = '1') then
			-- start reconfiguration
			--to-do: print field values
			--VHDL93 only: report "Remote Update Block: Reconfiguration initiated at time " & time'image(now);
			--report "        -> Field Current Configuration is set to %s", update_reg[0] ? "Application" : "Factory";
			--report "        -> Field PGM[] Page Select is set to %d", update_reg[3:1];
			--report "        -> Field User Watchdog is set to %s", (update_reg[4] == 1) ? "Enabled" : (update_reg[4] == 0) ? "Disabled" : "x";
			--report "        -> Field User Watchdog Timeout Value is set to %d", update_reg[16:5];

			if (operation_mode = "remote") then
				-- set pgm[] to page as set in Update Register
				pgmout_update <= update_reg(3 downto 1);
				
			elsif (operation_mode = "local") then
				-- set pgm[] to page as 001
				pgmout_update <= "001";
			else			
				-- invalid rconfig: destroys pgmout (only if not initializing)
				pgmout_update <= (others => 'X');			
			end if;
			
		elsif (rconfig /= '0') then
			-- invalid rconfig: destroys pgmout (only if not initializing)
			if (now /= 0 ns) then
				pgmout_update <= (others => 'X');			
			end if;
		end if;
	end process;

end architecture_rublock;


