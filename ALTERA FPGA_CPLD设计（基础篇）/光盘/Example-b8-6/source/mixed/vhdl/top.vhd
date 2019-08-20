library ieee;
use ieee.std_logic_1164.all;
entity top is
	port (q:	 buffer std_logic_vector (7 downto 0);
	a, b: in std_logic_vector (7 downto 0);
	sel, r_l, clk, rst: in std_logic);
end top;

architecture structural of top is

component mux  -- component declaration for mux
	port (outvec: out std_logic_vector (7 downto 0);
	a_vec, b_vec: in std_logic_vector (7 downto 0);
	sel: in std_logic);
end component;

component reg8  -- component declaration for reg8
	port (q: out std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst: in std_logic);
end component;

component rotate  -- component declaration for rotate
	port (q: buffer std_logic_vector (7 downto 0);
	data: in std_logic_vector (7 downto 0);
	clk, rst, r_l: in std_logic);
end component;

-- declare the internal signals here
signal mux_out, reg_out: std_logic_vector (7 downto 0);

begin  --  structural description begins

-- instantiate a mux, name it inst1, and wire it up
-- here we connect the mux  with positional port mapping (by position)
inst1:  mux port map (mux_out, a, b, sel);

-- instantiate a rotate, name it inst2, and wire it up
inst2: rotate port map (q, reg_out, clk, r_l, rst);

-- instantiate a reg8, name it inst3, and wire it up
-- reg8 is connected with named port mapping (by name)
-- the port connections can be given in any order
-- Note that the local signal names are on the right of the
-- '=>' mapping operators, and the signal names from the
-- component declaration are on the left.

inst3: reg8 
	port map (clk => clk, data => mux_out, 
	q => reg_out, rst => rst);

end structural;
