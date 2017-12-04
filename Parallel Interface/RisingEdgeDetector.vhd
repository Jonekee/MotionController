Library IEEE;
use IEEE.std_logic_1164.all;

Entity RisingEdgeDetector is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	XIN : in std_logic;
	RES : out std_logic
	);
end RisingEdgeDetector;

Architecture Behavioral of RisingEdgeDetector is
signal Qp, Qn : std_logic_vector(7 downto 0);
signal Sp, Sn : std_logic_vector(1 downto 0);
begin
	Combinational : process(XIN, Qp, Sp)
	begin
		Qn <= Qp(6 downto 0) & XIN;
		Sn <= Sp(0) & (Qp(7) AND Qp(6) AND Qp(5) AND Qp(4) AND Qp(3) AND Qp(2) AND Qp(1) AND Qp(0));
		RES <= Sp(0) AND NOT(Sp(1));
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Sp <= "11";
			Qp <= (others => '1');
		elsif CLK'event and CLK = '1' then
			Sp <= Sn;
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;