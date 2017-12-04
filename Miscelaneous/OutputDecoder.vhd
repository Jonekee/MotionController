Library IEEE;
use IEEE.std_logic_1164.all;

Entity OutputDecoder is
	generic(n : integer := 8);
	port(
	BAD  : in std_logic_vector(6 downto 0);
	ADD  : in std_logic_vector(6 downto 0);
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0)
	);
end OutputDecoder;

Architecture Mixed of OutputDecoder is
Component TriStateBusAdapter is generic(n : integer := 8);
	port(
	WRE  : in std_logic;
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0)
	);
end Component;
signal WRE : std_logic;
begin
	Combinational : process(BAD, ADD)
	begin
		if BAD = ADD then
			WRE <= '1';
		else
			WRE <= '0';
		end if;
	end process Combinational;
	U01 : TriStateBusAdapter generic map(n) port map(WRE, DIN, DOUT);
end Mixed;