Library IEEE;
use IEEE.std_logic_1164.all;

Entity Transmitter is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	DIN : in std_logic_vector(7 downto 0);
	TXD : out std_logic
	);
end Transmitter;

Architecture Structural of Transmitter is
--Components declaration
Component TransmitterFSM is port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	EOC : in std_logic;
	STC : out std_logic;
	SEL : out std_logic_vector(3 downto 0));
end Component;
Component TransmitTimer is port(
	RST : in std_logic;
	CLK : in std_logic;
	STC : in std_logic;
	EOC : out std_logic);
end Component;
Component TransmitterMux is port(
	SEL : in std_logic_vector(3 downto 0);
	DIN : in std_logic_vector(7 downto 0);
	TXD : out std_logic);
end Component;
--Signals declaration
signal STC, EOC : std_logic;
signal SEL : std_logic_vector(3 downto 0);
begin
	U01 : TransmitterFSM port map(RST, CLK, STT, EOC, STC, SEL);
	U02 : TransmitTimer port map(RST, CLK, STC, EOC);
	U03 : TransmitterMux port map(SEL, DIN, TXD);
end Structural;