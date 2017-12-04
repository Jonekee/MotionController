Library IEEE;
use IEEE.std_logic_1164.all;

Entity AD5668_Decoder is
	port(
	DIN0 : in std_logic_vector(15 downto 0);
	DIN1 : in std_logic_vector(15 downto 0);
	DIN2 : in std_logic_vector(15 downto 0);
	DIN3 : in std_logic_vector(15 downto 0);
	DIN4 : in std_logic_vector(15 downto 0);
	DIN5 : in std_logic_vector(15 downto 0);
	DIN6 : in std_logic_vector(15 downto 0);
	DIN7 : in std_logic_vector(15 downto 0);
	SEL  : in std_logic_vector(2 downto 0);
	DOUT : out std_logic_vector(31 downto 0)
	);
end AD5668_Decoder;

Architecture DataFlow of AD5668_Decoder is
begin
	With SEL select DOUT <=
	"XXXX" & "00000000" & DIN0 & "XXXX" when "000",
	"XXXX" & "00000001" & DIN1 & "XXXX" when "001",
	"XXXX" & "00000010" & DIN2 & "XXXX" when "010",
	"XXXX" & "00000011" & DIN3 & "XXXX" when "011",
	"XXXX" & "00000100" & DIN4 & "XXXX" when "100",
	"XXXX" & "00000101" & DIN5 & "XXXX" when "101",
	"XXXX" & "00000110" & DIN6 & "XXXX" when "110",
	"XXXX" & "00000111" & DIN7 & "XXXX" when others;
end DataFlow;