Library IEEE;
use IEEE.std_logic_1164.all;

Entity AnodeSelector is
	port(
	SEL : in std_logic_vector(1 downto 0);
	ANX : out std_logic_vector(3 downto 0)
	);
end AnodeSelector;

Architecture Decoder of AnodeSelector is
begin
ANX <=  "1101" when SEL = "01" else
		"1011" when SEL = "10" else
		"0111" when SEL = "11" else
		"1110";
end Decoder;