Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Entity Synchronizer is
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	XIN  : in std_logic;
	XOUT : out std_logic
	);
end Synchronizer;

Architecture Behavioral of Synchronizer is
signal Sp, Sn : std_logic;
signal Qp, Qn : std_logic_vector(1 downto 0);
begin
	Combinational : process(Qp, XIN, Sp)
	begin
		if Qp = "11" then
			Qn <= "00";
			Sn <= XIN;
		else
			Qn <= Qp + 1;
			Sn <= Sp;
		end if;
		XOUT <= Sp;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Sp <= '1';
			Qp <= "00";
		elsif CLK'event and CLK = '1' then
			Sp <= Sn;
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;