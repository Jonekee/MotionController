Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

Entity Multiplier is
	generic(m : integer := 18; n : integer := 18);
	port(
	OPA : in std_logic_vector(m - 1 downto 0);
	OPB : in std_logic_vector(n - 1 downto 0);
	RES : out std_logic_vector(m + n -1 downto 0)
	);
end Multiplier;

Architecture DataFlow of Multiplier is
begin
	Combinational : process(OPA, OPB)
	begin
		RES <= signed(OPA) * signed(OPB);
	end process Combinational;
end DataFlow;