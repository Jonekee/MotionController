Library IEEE;
use IEEE.std_logic_1164.all;

Entity DigitalFilterFSM is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	LDS : out std_logic;
	LDR : out std_logic;
	SEL : out std_logic_vector(2 downto 0)
	);
end DigitalFilterFSM;

Architecture Behavioral of DigitalFilterFSM is
signal Qp, Qn : std_logic_vector(2 downto 0);
begin
	Combinational : process(Qp, SYN)
	begin
		case Qp is
			when "000" => --Idle state
			LDS <= '0';
			LDR <= '0';
			SEL <= "000";
			if SYN = '1' then
				Qn <= "001";
			else
				Qn <= Qp;
			end if;
			when "001" => --q0 * e(k)
			LDS <= '1';
			LDR <= '0';
			SEL <= "001";
			Qn <= "010"; 
			when "010" => --q1 * e(k - 1)
			LDS <= '1';
			LDR <= '0';
			SEL <= "010";
			Qn <= "011";
			when "011" => --q2 * e(k - 2)
			LDS <= '1';
			LDR <= '0';
			SEL <= "011";
			Qn <= "100";
			when "100" => --q3 * e(k - 3)
			LDS <= '1';
			LDR <= '0';
			SEL <= "100";
			Qn <= "101";
			when "101" => --q4 * e(k - 4)
			LDS <= '1';
			LDR <= '0';
			SEL <= "101";
			Qn <= "110";
			when others => --Load result
			LDS <= '0';
			LDR <= '1';
			SEL <= "000";
			Qn <= "000";
		end case;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= "000";
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;