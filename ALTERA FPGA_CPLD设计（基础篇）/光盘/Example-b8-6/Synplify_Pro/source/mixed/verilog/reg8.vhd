library ieee;
use ieee.std_logic_1164.all;
entity reg8 is
	port (q: buffer std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst: in std_logic);
end reg8;
architecture reg8_design of reg8 is -- eight bit register
begin 
process (clk, rst)
begin
    if rst = '1' then
        q <= X"00";
    elsif rising_edge(clk) then
        q <= data;
    end if;
end process;
end reg8_design;