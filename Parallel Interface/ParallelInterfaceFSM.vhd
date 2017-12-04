Library IEEE;
use IEEE.std_logic_1164.all;

Entity ParallelInterfaceFSM is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	LDC : in std_logic;
	MDE : in std_logic;
	RDX : out std_logic;
	WRX : out std_logic
	);
end ParallelInterfaceFSM;

Architecture Behavioral of ParallelInterfaceFSM is
signal Qp, Qn : std_logic_vector(1 downto 0);
begin
	Combinational : process(Qp, LDC, MDE)
	begin
		case Qp is
			when "00" => --Idle state
				RDX <= '0';
				WRX <= '0';
				if LDC = '1' then
					Qn <= "01";
				else
					Qn <= Qp;
				end if;
			when "01" => --Parsing command
				RDX <= '0';
				WRX <= '0';
				if MDE = '0' then
					Qn <= "10";
				else
					Qn <= "11";
				end if;
			when "10" => --Reading command
				RDX <= '1';
				WRX <= '0';
				Qn <= "00";
			when others => --Writing command
				RDX <= '0';
				WRX <= '1';
				Qn <= "00";
		end case;
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