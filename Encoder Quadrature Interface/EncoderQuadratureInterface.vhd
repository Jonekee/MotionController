Library IEEE;
use IEEE.std_logic_1164.all;

Entity EncoderQuadratureInterface is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	CHA : in std_logic;
	CHB : in std_logic;
	POS : out std_logic_vector(31 downto 0)
	);
end EncoderQuadratureInterface;

Architecture Structural of EncoderQuadratureInterface is
--Components declaration
Component QuadratureDecoder is port(
	RST : in std_logic;
	CLK : in std_logic;
	CHA : in std_logic;
	CHB : in std_logic;
	ENC : out std_logic;
	DIR : out std_logic);
end Component;
cOMponent UpDownCounter is generic(n : integer := 16 );
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	ENA  : in std_logic;
	DIR  : in std_logic;
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
--signals
signal ENA, DIR : std_logic;
begin
	--Component instances
	U03 : QuadratureDecoder port map(RST, CLK, CHA, CHB, ENA, DIR);
	U04 : UpDownCounter generic map(32) port map(RST, CLK, ENA, DIR, POS);
end Structural;