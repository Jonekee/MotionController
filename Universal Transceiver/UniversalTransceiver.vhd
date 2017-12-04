Library IEEE;
use IEEE.std_logic_1164.all;

Entity UniversalTransceiver is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	RXD : in std_logic;
	DIN : in std_logic_vector(7 downto 0);
	TXD : out std_logic;
	DOUT : out std_logic_vector(7 downto 0)
	);
end UniversalTransceiver;

Architecture Structural of UniversalTransceiver is
Component Transmitter is port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	DIN : in std_logic_vector(7 downto 0);
	TXD : out std_logic);
end Component;
Component Receiver is port(
	RST : in std_logic;
	CLK : in std_logic;
	RXD : in std_logic;
	DIN : out std_logic_vector(7 downto 0));
end Component;
begin
	U01 : Transmitter port map(RST, CLK, STT, DIN, TXD);
	U02 : Receiver port map(RST, CLK, RXD, DOUT);
end Structural;