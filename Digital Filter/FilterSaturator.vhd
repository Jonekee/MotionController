Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

Entity FilterSaturator is
	port(
	UIN : in std_logic_vector(59 downto 0);
	UOUT : out std_logic_vector(15 downto 0)
	);
end FilterSaturator;

Architecture Behavioral of FilterSaturator is
constant UMAX : std_logic_vector(59 downto 0) := x"00000007FFF0000";
constant UMIN : std_logic_vector(59 downto 0) := x"FFFFFFF80010000";
begin
	Combinational : process(UIN)
	begin
		if UIN > UMAX then
			UOUT <= UMAX(31 downto 16);
		elsif UIN < UMIN then
			UOUT <= UMIN(31 downto 16);
		else
			UOUT <= UIN(31 downto 16);
		end if;
	end process Combinational;
end Behavioral;