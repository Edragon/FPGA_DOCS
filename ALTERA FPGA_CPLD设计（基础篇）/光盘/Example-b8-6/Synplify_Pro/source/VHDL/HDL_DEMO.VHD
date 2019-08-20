library IEEE;
use IEEE.std_logic_1164.all;
--lab2
--lab2

entity hdl_demo is 
	port (rst, clk,in_a,in_b,in_c : in std_logic;
          accum_a, accum_b : in std_logic_vector(7 downto 0);
           start_value : in std_logic_vector(31 downto 0);
          result : out std_logic_vector(7 downto 0)
   );
end hdl_demo;

architecture arch1 of hdl_demo is
 constant S1  : std_logic_vector(3 downto 0) := "0000";
 constant S2  : std_logic_vector(3 downto 0) := "0001";
 constant S3  : std_logic_vector(3 downto 0) := "0010";
 constant S4  : std_logic_vector(3 downto 0) := "0011";
 constant S5  : std_logic_vector(3 downto 0) := "0100";
 constant S10 : std_logic_vector(3 downto 0) := "1000";
 constant S20 : std_logic_vector(3 downto 0) := "1001";
 constant S30 : std_logic_vector(3 downto 0) := "1010";
 constant S40 : std_logic_vector(3 downto 0) := "1011";
 constant S50 : std_logic_vector(3 downto 0) := "1100";
 constant SX  : std_logic_vector(3 downto 0) := "0111";
 
 subtype state_values is std_logic_vector (3 downto 0);

 signal state: state_values;
 

 signal op_code : std_logic_vector(2 downto 0);
 signal start : std_logic;
 constant op_add : std_logic_vector(2 downto 0) := "000";
 constant op_sub : std_logic_vector(2 downto 0) := "001";
 constant op_and : std_logic_vector(2 downto 0) := "010";
 constant op_or : std_logic_vector(2 downto 0) := "011";
 constant op_unary : std_logic_vector(2 downto 0) := "100";
 constant start_code : std_logic_vector(31 downto 0) := X"AF95FE47";
 
 component alu
  	port (clk : in std_logic;
          opcode : in std_logic_vector(2 downto 0);
          a,b : in std_logic_vector(7 downto 0);
          outp : out std_logic_vector(7 downto 0)
    );
 end component;

begin

   alu_inst: alu port map (clk=>clk,
						   outp=>result,
						   opcode=>op_code,
						   a=>accum_a,
						   b=>accum_b);
   process (clk, rst)
       
   begin  

       if rst = '1' then
	   start <= '0';
       -- activities triggered by rising edge of clock
       elsif clk'event and clk = '1' then 
	  if (start_value = start_code) then
	      start <='1';
	  end if;
         end if;
   end process;

	process(clk,rst)
	begin
	  if rst = '1' then

			op_code <= "000";
            state <= S1;

          elsif clk'event and clk='1' then
	      if start = '1' then
		case state is
			when S1 => op_code <= op_add;
                     state <= S10;
			when S10 => op_code <= op_add;
                   if in_a = '1' then
               		 state <= S2;
	 			   else 
					 state <= S1;
				   end if;
  			when S2 => op_code <= op_sub;
                     state <= S20;
  			when S20 => op_code <= op_sub;
                   if in_b = '1' and in_a = '0' then
					 state <= S3;
				   else
					 state <= S2;
				   end if;
			when S3 => op_code <= op_and;
				   state <= S30;
			when S30 => op_code <= op_and;
				   if in_c = '1' then
					 state <= S4;
				   else
					 state <= S3;
				   end if;
			when S4 => op_code <= op_or;
					 state <= S40;
			when S40 => op_code <= op_or;
			       if in_a = '1' and in_c = '1' and in_b = '0' then
					 state <= S5;
				   else
					 state <= S4;
				   end if;
			when S5 => op_code <= op_unary;
					state <= S50;
			when S50 => op_code <= op_unary;
					state <= S5;

		     end case;

		       end if;
			       end if;
					 
      end process;


end arch1;

