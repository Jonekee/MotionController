Library IEEE;
use IEEE.std_logic_1164.all;

Entity LeftShiftRegister is
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	LDR  : in std_logic;
	DIN  : in std_logic_vector(7 downto 0);
	DOUT : out std_logic_vector(31 downto 0)
	);
end LeftShiftRegister;

Architecture Behavioral of LeftShiftRegister is
signal Qp, Qn : std_logic_vector(31 downto 0);
begin
	Combinational : process(LDR, DIN, Qp)
	begin
		if LDR = '1' then
			Qn <= Qp(23 downto 0) & DIN;
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