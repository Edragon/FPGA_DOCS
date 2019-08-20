library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity alu is
 port (clk : in std_logic;
       a,b : in std_logic_vector(7 downto 0);
       opcode : in std_logic_vector(2 downto 0);
       outp : out std_logic_vector(7 downto 0)
 );

end alu;

architecture arch1 of alu is

begin

   process(clk)
    begin
	 if clk'event and clk='1' then
      case opcode is
			when "000" => outp <= a + b;
			when "001" => outp <= a - b;
			when "010" => outp <= a AND b;
			when "011" => outp <= a OR b;
			when "100" => outp <= NOT a;
		end case;
	  end if;
	end process;

end arch1;

