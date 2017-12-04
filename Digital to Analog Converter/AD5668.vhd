Library IEEE;
use IEEE.std_logic_1164.all;

Entity AD5668 is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	D0  : in std_logic_vector(15 downto 0);
	D1  : in std_logic_vector(15 downto 0);
	D2  : in std_logic_vector(15 downto 0);
	D3  : in std_logic_vector(15 downto 0);
	D4  : in std_logic_vector(15 downto 0);
	D5  : in std_logic_vector(15 downto 0);
	D6  : in std_logic_vector(15 downto 0);
	D7  : in std_logic_vector(15 downto 0);
	LDAC : out std_logic;
	SYNC : out std_logic;
	SCLK : out std_logic;
	DOUT : out std_logic;
	SCLR : out std_logic
	);
end AD5668;

Architecture Structural of AD5668 is
--Components declaration
Component AD5668FSM is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	EOT : in std_logic;
	LDAC : out std_logic;
	STT : out std_logic;
	SEL : out std_logic_vector(2 downto 0)
	);
end Component;
Component AD5668_Decoder is
	port(
	DIN0 : in std_logic_vector(15 downto 0);
	DIN1 : in std_logic_vector(15 downto 0);
	DIN2 : in std_logic_vector(15 downto 0);
	DIN3 : in std_logic_vector(15 downto 0);
	DIN4 : in std_logic_vector(15 downto 0);
	DIN5 : in std_logic_vector(15 downto 0);
	DIN6 : in std_logic_vector(15 downto 0);
	DIN7 : in std_logic_vector(15 downto 0);
	SEL  : in std_logic_vector(2 downto 0);
	DOUT : out std_logic_vector(31 downto 0)
	);
end Component;
Component SerialInterface32B is
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
end Component;
--Signals
signal STT, EOT : std_logic;
signal SEL : std_logic_vector(2 downto 0);
signal DTS : std_logic_vector(31 downto 0);
begin
	--Signal assigments
	SCLR <= RST;
	--Component instances
	U01 : AD5668FSM port map(RST, CLK, SYN, EOT, LDAC, STT, SEL);
	U02 : AD5668_Decoder port map(D0, D1, D2, D3, D4, D5, D6, D7, SEL, DTS);
	U03 : SerialInterface32B port map(RST, CLK, STT, DTS, SYNC, SCLK, DOUT, EOT);
end Structural;