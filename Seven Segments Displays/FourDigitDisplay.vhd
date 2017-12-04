Library IEEE;
use IEEE.std_logic_1164.all;

Entity FourDigitDisplay is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	DIN : in std_logic_vector(15 downto 0);
	SEG : out std_logic_vector(7 downto 0);
	ANX : out std_logic_vector(3 downto 0)
	);
end FourDigitDisplay;

Architecture Structural of FourDigitDisplay is
--Components declaration
Component Timer1ms is port(
	RST : in std_logic;
	CLK : in std_logic;
	ENO : out std_logic);
end Component;
Component FreeCounter is generic(n : integer := 16 );
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	ENA  : in std_logic;
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
Component Multiplexor4To1 is generic(n : integer := 8);
	port(
	DIN0 : in std_logic_vector(n - 1 downto 0);
	DIN1 : in std_logic_vector(n - 1 downto 0);
	DIN2 : in std_logic_vector(n - 1 downto 0);
	DIN3 : in std_logic_vector(n - 1 downto 0);
	SEL  : in std_logic_vector(1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
Component BCDToSevenSegs is port(
	DIN : in std_logic_vector(3 downto 0);
	DOUT : out std_logic_vector(7 downto 0));
end Component;
Component AnodeSelector is port(
	SEL : in std_logic_vector(1 downto 0);
	ANX : out std_logic_vector(3 downto 0));
end Component;
--Internal signals
signal NSEL : std_logic_vector(1 downto 0);
signal NIB0 : std_logic_vector(3 downto 0);
signal NIB1 : std_logic_vector(3 downto 0);
signal NIB2 : std_logic_vector(3 downto 0);
signal NIB3 : std_logic_vector(3 downto 0);
signal NIBX : std_logic_vector(3 downto 0);
begin
	NIB0 <= DIN(3 downto 0);
	NIB1 <= DIN(7 downto 4);
	NIB2 <= DIN(11 downto 8);
	NIB3 <= DIN(15 downto 12);
	--Component instances
	U01 : FreeCounter generic map(2) port map(RST, CLK, SYN, NSEL);
	U03 : Multiplexor4To1 generic map(4) port map(NIB0, NIB1, NIB2, NIB3, NSEL, NIBX);
	U04 : BCDToSevenSegs port map(NIBX, SEG);
	U05 : AnodeSelector port map(NSEL, ANX);
end Structural;