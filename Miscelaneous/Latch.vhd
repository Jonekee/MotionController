Library IEEE;
use IEEE.std_logic_1164.all;

Entity Latch is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	LDR : in std_logic;
	BIN : in std_logic;
	BOUT : out std_logic
	);
end Latch;

Architecture Behavioral of Latch is
signal Qp, Qn : std_logic;
begin
	Combinational : process(LDR, BIN, Qp)
	begin
		if LDR = '1' then
			Qn <= BIN;
		else
			Qn <= Qp;
		end if;
		BOUT <= Qp;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= '0';
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;