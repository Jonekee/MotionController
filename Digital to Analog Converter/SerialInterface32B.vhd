Library IEEE;
use IEEE.std_logic_1164.all;

Entity SerialInterface32B is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	DIN : in std_logic_vector(31 downto 0);
	CSE : out std_logic;
	SCK : out std_logic;
	SDO : out std_logic;
	EOT : out std_logic
	);
end SerialInterface32B;

Architecture Structural of SerialInterface32B is
--Components declaration
Component SerialInterface32BFSM is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	SHF : out std_logic;
	EOT : out std_logic
	);
end Component;
Component BarrelShiftRegister is generic(n : integer := 8);
	port(
	RST : in std_logic;
	CLK : in std_logic;
	LDR : in std_logic;
	SHF : in std_logic;
	DIN : in std_logic_vector(n - 1 downto 0);
	MSB : out std_logic);
end Component;
--Signals
signal AUX, SHF : std_logic;
begin
	--Assigments
	CSE <= AUX;
	EOT <= AUX;
	SCK <= NOT(SHF);
	--Component instances
	U01 : SerialInterface32BFSM port map(RST, CLK, STT, SHF, AUX);
	U02 : BarrelShiftRegister generic map(32) port map(RST, CLK, STT, SHF, DIN, SDO);
end Structural;