Library IEEE;
use IEEE.std_logic_1164.all;

Entity QuadratureDecoder is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	CHA : in std_logic;
	CHB : in std_logic;
	ENC : out std_logic;
	DIR : out std_logic
	);
end QuadratureDecoder;

Architecture Behavioral of QuadratureDecoder is
signal Ap, An : std_logic_vector(2 downto 0);
signal Bp, Bn : std_logic_vector(2 downto 0);
begin
	Sampling : process(Ap, Bp, CHA, CHB)
	begin
		An <= Ap(1 downto 0) & CHA;
		Bn <= Bp(1 downto 0) & CHB;
	end process Sampling;
	Combinational : process(Ap, Bp)
	begin
		DIR <= Bp(2) xnor Ap(1);
		ENC <= Ap(1) xor Ap(2) xor Bp(1) xor Bp(2);
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Ap <= "000";
			Bp <= "000";
		elsif CLK'event and CLK = '1' then
			Ap <= An;
			Bp <= Bn;
		end if;
	end process Sequential;
end Behavioral;