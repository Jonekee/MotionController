Library IEEE;
use IEEE.std_logic_1164.all;

Entity TriStateBusAdapter is
	generic(n : integer := 8);
	port(
	WRE  : in std_logic;
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0)
	);
end TriStateBusAdapter;

Architecture DataFlow of TriStateBusAdapter is
begin
	DOUT <= DIN when WRE = '1' else (others => 'Z');
end DataFlow;
