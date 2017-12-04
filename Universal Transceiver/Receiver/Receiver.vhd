Library IEEE;
use IEEE.std_logic_1164.all;

Entity Receiver is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	RXD : in std_logic;
	DIN : out std_logic_vector(7 downto 0)
	);
end Receiver;

Architecture Structural of Receiver is
--Components declaration
Component ReceiverFSM is port(
	RST : in std_logic;
	CLK : in std_logic;
	RXD : in std_logic;
	EOC : in std_logic;
	STC : out std_logic;
	LDR : out std_logic;
	LDO : out std_logic);
end Component;
Component ReceiverTimer is port(
	RST : in std_logic;
	CLK : in std_logic;
	STC : in std_logic;
	EOC : out std_logic);
end Component;
Component ShifterRegister is port(
	RST  : in std_logic;
	CLK  : in std_logic;
	SHI  : in std_logic;
	BIN  : in std_logic;
	DOUT : out std_logic_vector(7 downto 0));
end Component;
Component LoadRegister is generic(n : integer := 8 );
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	LDR  : in std_logic;
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
--Signals declaration
signal EOC, STC, LDR, LDO : std_logic;
signal DREC : std_logic_vector(7 downto 0);
begin
	U01 : ReceiverFSM port map(RST, CLK, RXD, EOC, STC, LDR, LDO);
	U02 : ReceiverTimer port map(RST, CLK, STC, EOC);
	U03 : ShifterRegister port map(RST, CLK, LDR, RXD, DREC);
	U04 : LoadRegister port map(RST, CLK, LDO, DREC, DIN);
end Structural;