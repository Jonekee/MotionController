Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Entity ReceiverTimer is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STC : in std_logic;
	EOC : out std_logic
	);
end ReceiverTimer;

Architecture Behavioral of ReceiverTimer is
signal Qp, Qn : std_logic_vector(7 downto 0);
begin
	Combinational : process(STC, Qp)
	begin
		if STC = '1' then
			EOC <= '0';
			Qn <= "11011001";
		else
			if Qp = "000000000" then
				EOC <= '1';
				Qn <= Qp;
			else
				EOC <= '0';
				Qn <= Qp - 1;
			end if;
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
end Behavioral;