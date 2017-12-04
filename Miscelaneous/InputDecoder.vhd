Library IEEE;
use IEEE.std_logic_1164.all;

Entity InputDecoder is
	port(
	BAD : in std_logic_vector(6 downto 0);
	ALE : in std_logic;
	ADD : in std_logic_vector(6 downto 0);
	LDR : out std_logic
	);
end InputDecoder;

Architecture Mixed of InputDecoder is
begin
	Combinational : process(BAD, ADD, ALE)
	begin
		if ALE = '1' AND BAD = ADD then
			LDR <= '1';
		else
			LDR <= '0';
		end if;
	end process Combinational;
end Mixed;