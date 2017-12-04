Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Entity UpDownCounter is
	generic(n : integer := 16 );
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	ENA  : in std_logic;
	DIR  : in std_logic;
	DOUT : out std_logic_vector(n - 1 downto 0)
	);
end UpDownCounter;

Architecture Behavioral of UpDownCounter is
signal Qp, Qn : std_logic_vector(n - 1 downto 0);
begin
	Combinational : process(Qp, ENA, DIR)
	begin
		if ENA = '1' then
			if DIR = '0' then
				Qn <= Qp + 1;
			elsif DIR = '1' then
				Qn <= Qp - 1;
			else
				Qn <= Qp;
			end if;
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