Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Entity Timer1ms is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	ENO : out std_logic
	);
end Timer1ms;

Architecture Counter of Timer1ms is
signal Qp, Qn : std_logic_vector(15 downto 0);
begin
	Combinational : process(Qp)
	begin
		if Qp = "1100001101001111" then
			ENO <= '1';
			Qn <= (others => '0');
		else
			ENO <= '0';
			Qn <= Qp + 1;
		end if;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
end Counter;