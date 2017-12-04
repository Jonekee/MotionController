Library IEEE;
use IEEE.std_logic_1164.all;

Entity BarrelShiftRegister is
	generic(n : integer := 8);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	LDR : in std_logic;
	SHF : in std_logic;
	DIN : in std_logic_vector(n - 1 downto 0);
	MSB : out std_logic
	);
end BarrelShiftRegister;

Architecture Behavioral of BarrelShiftRegister is
signal Qp, Qn : std_logic_vector(n - 1 downto 0);
begin
	Combinational : process(LDR, SHF, DIN, Qp)
	begin
		if LDR = '1' then
			Qn <= DIN;
		elsif SHF = '1' then
			Qn <= Qp(n - 2 downto 0) & '0';
		else
			Qn <= Qp;
		end if;
		MSB <= Qp(n - 1);
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