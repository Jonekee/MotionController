Library IEEE;
use IEEE.std_logic_1164.all;

Entity Multiplexor4To1 is
	generic(n : integer := 8);
	port(
	DIN0 : in std_logic_vector(n - 1 downto 0);
	DIN1 : in std_logic_vector(n - 1 downto 0);
	DIN2 : in std_logic_vector(n - 1 downto 0);
	DIN3 : in std_logic_vector(n - 1 downto 0);
	SEL  : in std_logic_vector(1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0)
	);
end Multiplexor4To1;

Architecture DataFlow of Multiplexor4To1 is
begin
DOUT <= DIN1 when SEL = "01" else
		DIN2 when SEL = "10" else
		DIN3 when SEL = "11" else
		DIN0;
end DataFlow;