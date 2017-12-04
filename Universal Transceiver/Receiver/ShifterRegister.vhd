Library IEEE;
use IEEE.std_logic_1164.all;

Entity ShifterRegister is
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	SHI  : in std_logic;
	BIN  : in std_logic;
	DOUT : out std_logic_vector(7 downto 0)
	);
end ShifterRegister;

Architecture Behavioral of ShifterRegister is
signal Qp, Qn : std_logic_vector(7 downto 0);
begin
	Combinational : process(Qp, SHI, BIN)
	begin
		if SHI = '1' then
			Qn <= BIN & Qp(7 downto 1);
		else
			Qn <= Qp;
		end if;
		DOUT <= Qp;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;