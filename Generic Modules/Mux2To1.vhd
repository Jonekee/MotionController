Library IEEE;
use IEEE.std_logic_1164.all;

Entity Mux2To1 is
	generic(n : integer := 8);
	port(
	DINA : in std_logic_vector(n - 1 downto 0);
	DINB : in std_logic_vector(n - 1 downto 0);
	SEL  : in std_logic;
	DOUT : out std_logic_vector(n - 1 downto 0)
	);
end Mux2To1;

Architecture DataFlow of Mux2To1 is
begin
	With SEL select DOUT <= DINA when '0', DINB when others;
end DataFlow;