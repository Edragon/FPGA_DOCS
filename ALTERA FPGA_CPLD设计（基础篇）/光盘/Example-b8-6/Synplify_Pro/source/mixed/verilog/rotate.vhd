library ieee;
use ieee.std_logic_1164.all;
entity rotate is
	port (q: buffer std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst, r_l: in std_logic);
end rotate;
architecture rotate_design of rotate is 
-- rotates bits or loads
-- when r_l is high, it rotates; if low, it loads data
begin 
process (clk, rst)
begin
    if rst = '1' then
         q <= X"00";
    elsif rising_edge(clk) then
         if r_l = '1' then
              q <= q ( 6 downto 0 ) & q (7) ;
         else
              q <= data;
         end if;
    end if;
end process;

end rotate_design;
