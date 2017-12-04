Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

Entity ErrorSubtractor is
	port(
	REF : in  std_logic_vector(31 downto 0);
	POS : in  std_logic_vector(31 downto 0);
	ERR : out std_logic_vector(15 downto 0)
	);
end ErrorSubtractor;

Architecture Mixed of ErrorSubtractor is
signal RES : std_logic_vector(31 downto 0);
constant EMAX : std_logic_vector(31 downto 0) := x"00007FFF";
constant EMIN : std_logic_vector(31 downto 0) := x"FFFF0001";
begin
	RES <= REF - POS;
	Saturation : process(RES)
	begin
		if RES > EMAX then
			ERR <= EMAX(15 downto 0);
		elsif RES < EMIN then
			ERR <= EMIN(15 downto 0);
		else
			ERR <= RES(15 downto 0);
		end if;
	end process Saturation;
end Mixed;