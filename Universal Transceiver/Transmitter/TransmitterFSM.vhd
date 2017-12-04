Library IEEE;
use IEEE.std_logic_1164.all;

Entity TransmitterFSM is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	EOC : in std_logic;
	STC : out std_logic;
	SEL : out std_logic_vector(3 downto 0)
	);
end TransmitterFSM;

Architecture Behavioral of TransmitterFSM is
signal Qp, Qn : std_logic_vector(4 downto 0);
begin
	Combinational : process(Qp, STT, EOC)
	begin
		case Qp is
			when "00000" => --Idle state
				STC <= '0';
				SEL <= "1111";
				if STT = '1' then
					Qn <= "00001";
				else
					Qn <= Qp;
				end if;
			when "00001" => --Transmit start bit
				STC <= '1';
				SEL <= "0000";
				Qn <= "00010";
			when "00010" =>
				STC <= '0';
				SEL <= "0000";
				if EOC = '1' then
					Qn <= "00011";
				else
					Qn <= Qp;
				end if;
			when "00011" => --Transmit bit 0
				STC <= '1';
				SEL <= "0001";
				Qn <= "00100";
			when "00100" =>
				STC <= '0';
				SEL <= "0001";
				if EOC = '1' then
					Qn <= "00101";
				else
					Qn <= Qp;
				end if;
			when "00101" => --Transmit bit 1
				STC <= '1';
				SEL <= "0010";
				Qn <= "00110";
			when "00110" =>
				STC <= '0';
				SEL <= "0010";
				if EOC = '1' then
					Qn <= "00111";
				else
					Qn <= Qp;
				end if;
			when "00111" => --Transmit bit 2
				STC <= '1';
				SEL <= "0011";
				Qn <= "01000";
			when "01000" =>
				STC <= '0';
				SEL <= "0011";
				if EOC = '1' then
					Qn <= "01001";
				else
					Qn <= Qp;
				end if;
			when "01001" => --Transmit bit 3
				STC <= '1';
				SEL <= "0100";
				Qn <= "01010";
			when "01010" =>
				STC <= '0';
				SEL <= "0100";
				if EOC = '1' then
					Qn <= "01011";
				else
					Qn <= Qp;
				end if;
			when "01011" => --Transmit bit 4
				STC <= '1';
				SEL <= "0101";
				Qn <= "01100";
			when "01100" =>
				STC <= '0';
				SEL <= "0101";
				if EOC = '1' then
					Qn <= "01101";
				else
					Qn <= Qp;
				end if;
			when "01101" => --Transmit bit 5
				STC <= '1';
				SEL <= "0110";
				Qn <= "01110";
			when "01110" =>
				STC <= '0';
				SEL <= "0110";
				if EOC = '1' then
					Qn <= "01111";
				else
					Qn <= Qp;
				end if;
			when "01111" => --Transmit bit 6
				STC <= '1';
				SEL <= "0111";
				Qn <= "10000";
			when "10000" =>
				STC <= '0';
				SEL <= "0111";
				if EOC = '1' then
					Qn <= "10001";
				else
					Qn <= Qp;
				end if;
			when "10001" => --Transmit bit 7
				STC <= '1';
				SEL <= "1000";
				Qn <= "10010";
			when "10010" =>
				STC <= '0';
				SEL <= "1000";
				if EOC = '1' then
					Qn <= "10011";
				else
					Qn <= Qp;
				end if;
			when "10011" =>	--Transmit stop bit
				STC <= '1';
				SEL <= "1001";
				Qn <= "10100";
			when others =>
				STC <= '0';
				SEL <= "1001";
				if EOC = '1' then
					Qn <= "00000";
				else
					Qn <= Qp;
				end if;
		end case;
	end process Combinational;
	Sequential : process(RST, CLK)
	begin
		if RST = '0' then
			Qp <= "00000";
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end process Sequential;
end Behavioral;