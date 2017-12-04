Library IEEE;
use IEEE.std_logic_1164.all;

Entity AD5668FSM is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	EOT : in std_logic;
	LDAC : out std_logic;
	STT : out std_logic;
	SEL : out std_logic_vector(2 downto 0)
	);
end AD5668FSM;

Architecture Behavioral of AD5668FSM is
signal Qp, Qn : std_logic_vector(4 downto 0);
begin
	Combinational : process(Qp, SYN, EOT)
	begin
		case Qp is
			when "00000" => --Idle state
				STT <= '0';
				LDAC <= '1';
				SEL <= "000";
				if SYN = '1' then
					Qn <= "00001";
				else
					Qn <= Qp;
				end if;
			when "00001" => --Start Channel A transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "000";
				Qn <= "00010";
			when "00010" => --Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "000";
				if EOT = '1' then
					Qn <= "00011";
				else
					Qn <= Qp;
				end if;
			when "00011" =>	--Start Channel B transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "001";
				Qn <= "00100";
			when "00100" =>	--Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "001";
				if EOT = '1' then
					Qn <= "00101";
				else
					Qn <= Qp;
				end if;
			when "00101" =>	--Start Channel C transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "010";
				Qn <= "00110";
			when "00110" => --Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "010";
				if EOT = '1' then
				 	Qn <= "00111";
				else
					Qn <= Qp;
				end if;
			when "00111" => --Start Channel D transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "011";
				Qn <= "01000";
			when "01000" => --Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "011";
				if EOT = '1' then
					Qn <= "01001";
				else
					Qn <= Qp;
				end if;
			when "01001" => --Start Channel E transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "100";
				Qn <= "01010";
			when "01010" => --Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "100";
				if EOT = '1' then
					Qn <= "01011";
				else
					Qn <= Qp;
				end if;
			when "01011" => --Start Channel F transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "101";
				Qn <= "01100";
			when "01100" => --Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "101";
				if EOT = '1' then
					Qn <= "01101";
				else
					Qn <= Qp;
				end if;
			when "01101" => --Start Channel G transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "110";
				Qn <= "01110";
			when "01110" => --Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "110";
				if EOT = '1' then
					Qn <= "01111";
				else
					Qn <= Qp;
				end if;
			when "01111" => --Start Channel H transmission
				STT <= '1';
				LDAC <= '1';
				SEL <= "111";
				Qn <= "10000";
			when "10000" => --Waiting
				STT <= '0';
				LDAC <= '1';
				SEL <= "111";
				if EOT = '1' then
					Qn <= "10001";
				else
					Qn <= Qp;
				end if;
			when others => --Start update channels
				STT <= '0';
				LDAC <= '0';
				SEL <= "000";
				Qn <= "00000";
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
