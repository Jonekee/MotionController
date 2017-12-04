Library IEEE;
use IEEE.std_logic_1164.all;

Entity TransmitterMux is
	port(
	SEL : in std_logic_vector(3 downto 0);
	DIN : in std_logic_vector(7 downto 0);
	TXD : out std_logic
	);
end TransmitterMux;

Architecture DataFlow of TransmitterMux is
begin
	With SEL Select TXD <=
	'0' when "0000",
	DIN(0) when "0001",
	DIN(1) when "0010",
	DIN(2) when "0011",
	DIN(3) when "0100",
	DIN(4) when "0101",
	DIN(5) when "0110",
	DIN(6) when "0111",
	DIN(7) when "1000",
	'1' when others;
end DataFlow;