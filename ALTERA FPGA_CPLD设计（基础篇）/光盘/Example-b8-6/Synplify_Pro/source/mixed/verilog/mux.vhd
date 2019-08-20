library ieee;
use ieee.std_logic_1164.all;

entity mux is
	port ( outvec 		: out std_logic_vector(7 downto 0);
		   a_vec, b_vec	: in std_logic_vector(7 downto 0);
		   sel			: in std_logic
		 );
end entity mux;

architecture structure of mux is
component mux21 port ( Y : out std_logic;
					   A : in std_logic;
					   B : in std_logic;
					   SEL : in std_logic
					 );
end component;
begin
x: for i in 7 downto 0 generate
begin
inst: mux21 port map (Y => outvec(i),
				A => a_vec(i),
				B => b_vec(i),
				SEL => sel
			   );
end generate x;
end architecture structure;
