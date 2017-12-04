Library IEEE;
use IEEE.std_logic_1164.all;

Entity FilterMultiplexor is
	port(
	EK0 : in std_logic_vector(15 downto 0);
	EK1 : in std_logic_vector(15 downto 0);
	EK2 : in std_logic_vector(15 downto 0);
	EK3 : in std_logic_vector(15 downto 0);
	EK4 : in std_logic_vector(15 downto 0);
	Q0 : in std_logic_vector(31 downto 0);
	Q1 : in std_logic_vector(31 downto 0);
	Q2 : in std_logic_vector(31 downto 0);
	Q3 : in std_logic_vector(31 downto 0);
	Q4 : in std_logic_vector(31 downto 0);
	SEL : in std_logic_vector(2 downto 0);
	EOUT : out std_logic_vector(17 downto 0);
	QOUT : out std_logic_vector(35 downto 0)
	);
end FilterMultiplexor;

Architecture DataFlow of FilterMultiplexor is
begin
	With SEL select EOUT <=
	EK0(15) & EK0(15) & EK0 when "001",
	EK1(15) & EK1(15) & EK1 when "010",
	EK2(15) & EK2(15) & EK2 when "011",
	EK3(15) & EK3(15) & EK3 when "100",
	EK4(15) & EK4(15) & EK4 when "101",
	(others => '0') when others;
	With SEL select QOUT <=
	Q0(31) & Q0(31) & Q0(31) & Q0(31) & Q0 when "001",
	Q1(31) & Q1(31) & Q1(31) & Q1(31) & Q1 when "010",
	Q2(31) & Q2(31) & Q2(31) & Q2(31) & Q2 when "011",
	Q3(31) & Q3(31) & Q3(31) & Q3(31) & Q3 when "100",
	Q4(31) & Q4(31) & Q4(31) & Q4(31) & Q4 when "101",
	(others => '0') when others;
end DataFlow;