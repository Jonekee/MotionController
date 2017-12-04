Library IEEE;
use IEEE.std_logic_1164.all;

Entity ReceiverFSM is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	RXD : in std_logic;
	EOC : in std_logic;
	STC : out std_logic;
	LDR : out std_logic;
	LDO : out std_logic
	);
end ReceiverFSM;

Architecture Simple of ReceiverFSM is
signal Qp, Qn : std_logic_vector(5 downto 0);
begin
	Combinational : process(Qp, RXD, EOC)
	begin
		case Qp is
			when "000000" => --Idle state
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if RXD = '0' then
					Qn <= "000001";
				else
					Qn <= Qp;
				end if;
			when "000001" => --Start/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "000010";
			when "000010" => --Start/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "000011";
				else
					Qn <= Qp;
				end if;
			when "000011" => --Start/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "000100";
			when "000100" => --Start/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "000101";	
				else
					Qn <= Qp;
				end if;
			when "000101" => --Bit0/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "000110";
			when "000110" => --Bit0/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "000111";
				else
					Qn <= Qp;
				end if;
			when "000111" => --Bit0/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "001000";
			when "001000" => --Bit0/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "001001";
			when "001001" => --Bit0/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "001010";
				else
					Qn <= Qp;
				end if;
			when "001010" => --Bit1/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "001011";
			when "001011" => --Bit1/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "001100";
				else
					Qn <= Qp;
				end if;
			when "001100" => --Bit1/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "001101";
			when "001101" => --Bit1/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "001110";
			when "001110" => --Bit1/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "001111";
				else
					Qn <= Qp;
				end if;
			when "001111" => --Bit2/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "010000";
			when "010000" => --Bit2/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "010001";
				else
					Qn <= Qp;
				end if;
			when "010001" => --Bit2/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "010010";
			when "010010" => --Bit2/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "010011";
			when "010011" => --Bit2/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "010100";
				else
					Qn <= Qp;
				end if;
			when "010100" => --Bit3/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "010101";
			when "010101" => --Bit3/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "010110";
				else
					Qn <= Qp;
				end if;
			when "010110" => --Bit3/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "010111";
			when "010111" => --Bit3/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "011000";
			when "011000" => --Bit3/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "011001";
				else
					Qn <= Qp;
				end if;
			when "011001" => --Bit4/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "011010";
			when "011010" => --Bit4/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "011011";
				else
					Qn <= Qp;
				end if;
			when "011011" => --Bit4/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "011100";
			when "011100" => --Bit4/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "011101";
			when "011101" => --Bit4/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "011110";
				else
					Qn <= Qp;
				end if;
			when "011110" => --Bit5/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "011111";
			when "011111" => --Bit5/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "100000";
				else
					Qn <= Qp;
				end if;
			when "100000" => --Bit5/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "100001";
			when "100001" => --Bit5/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "100010";
			when "100010" => --Bit5/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "100011";
				else
					Qn <= Qp;
				end if;
			when "100011" => --Bit6/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "100100";
			when "100100" => --Bit6/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "100101";
				else
					Qn <= Qp;
				end if;
			when "100101" => --Bit6/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "100110";
			when "100110" => --Bit6/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "100111";
			when "100111" => --Bit6/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "101000";
				else
					Qn <= Qp;
				end if;
			when "101000" => --Bit7/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "101001";
			when "101001" => --Bit7/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "101010";
				else
					Qn <= Qp;
				end if;
			when "101010" => --Bit7/Latching
				STC <= '0';
				LDR <= '1';
				LDO <= '0';
				Qn <= "101011";
			when "101011" => --Bit7/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "101100";
			when "101100" => --Bit7/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "101101";
				else
					Qn <= Qp;
				end if;
			when "101101" => --Stop/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "101110";
			when "101110" => --Stop/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "101111";
				else
					Qn <= Qp;
				end if;
			when "101111" => --Stop/Start timer
				STC <= '1';
				LDR <= '0';
				LDO <= '0';
				Qn <= "110000";
			when "110000" => --Stop/Waiting
				STC <= '0';
				LDR <= '0';
				LDO <= '0';
				if EOC = '1' then
					Qn <= "110001";
				else
					Qn <= Qp;
				end if;
			when others =>
				STC <= '0';
				LDR <= '0';
				LDO <= '1';
				Qn <= "000000";
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
end Simple;
