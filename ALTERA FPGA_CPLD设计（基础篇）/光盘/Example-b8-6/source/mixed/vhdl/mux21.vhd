library ieee;
use ieee.std_logic_1164.all;

entity mux21 is
	port ( Y : out std_logic;
		   A, B, SEL : in std_logic
		 );
end mux21;

architecture rtl of mux21 is
begin
with sel select
	Y <= A when '1',
	     B when '0',
	     'X' when others;
end rtl;
