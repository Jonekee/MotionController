Library IEEE;
use IEEE.std_logic_1164.all;

Entity FanucControl is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	RXD : in std_logic;
	TXD : out std_logic;
	INH : out std_logic_vector(5 downto 0);
	--Commutation signals
	CA : in std_logic_vector(5 downto 0);
	CB : in std_logic_vector(5 downto 0);
	C8 : in std_logic_vector(5 downto 0);
	C4 : in std_logic_vector(5 downto 0);
	C2 : in std_logic_vector(5 downto 0);
	C1 : in std_logic_vector(5 downto 0);
	--Master interface signals
	CS  : in std_logic;
	PS  : in std_logic;
	RD  : in std_logic;
	WR  : in std_logic;
	PAR : out std_logic_vector(4 downto 0);
	DIO : inout std_logic_vector(7 downto 0);
	-- Leds and Displays
	LED : out std_logic_vector(7 downto 0);
	SEG : out std_logic_vector(7 downto 0);
	ANX : out std_logic_vector(3 downto 0);
	--DAC signals
	LDAC : out std_logic_vector(1 downto 0);
	SYNC : out std_logic_vector(1 downto 0);
	SCLK : out std_logic_vector(1 downto 0);
	DOUT : out std_logic_vector(1 downto 0);
	SCLR : out std_logic_vector(1 downto 0)
	);
end FanucControl;

Architecture Structural of FanucControl is
--Components declaration
Component ParallelInterface is port(
	RST : in std_logic;
	CLK : in std_logic;
	CS   : in std_logic;
	PS   : in std_logic;
	RD   : in std_logic;
	WR   : in std_logic;
	PAR  : out std_logic_vector(4 downto 0);
	DIN  : in std_logic_vector(7 downto 0);
	DOUT : out std_logic_vector(7 downto 0);
	STS  : in std_logic_vector(7 downto 0);
	WREN : out std_logic;
	ADDR : out std_logic_vector(6 downto 0);
	MISO : in std_logic_vector(31 downto 0);
	MOSI : out std_logic_vector(31 downto 0));
end Component;
Component Timer1ms is port(
	RST : in std_logic;
	CLK : in std_logic;
	ENO : out std_logic);
end Component;
Component FourDigitDisplay is port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	DIN : in std_logic_vector(15 downto 0);
	SEG : out std_logic_vector(7 downto 0);
	ANX : out std_logic_vector(3 downto 0));
end Component;
Component AD5668 is port(
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
	SCLR : out std_logic);
end Component;
Component AxisController is port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	AMP  : out std_logic;
	CHA  : in std_logic;
	CHB  : in std_logic;
	UOUT : out std_logic_vector(15 downto 0);
	BADD : in std_logic_vector(2 downto 0);
	WREN : in std_logic;
	ADDR : in std_logic_vector(6 downto 0);
	DIN  : in std_logic_vector(31 downto 0);
	DOUT : out std_logic_vector(31 downto 0));
end Component;
Component SinusoidalCommutatorA is port(
	EANG : in std_logic_vector(3 downto 0);
	UOUT : in std_logic_vector(15 downto 0);
	PHA : out std_logic_vector(15 downto 0);
	PHB : out std_logic_vector(15 downto 0));
end Component;
Component SinusoidalCommutatorB is port(
	EANG : in std_logic_vector(3 downto 0);
	UOUT : in std_logic_vector(15 downto 0);
	PHA : out std_logic_vector(15 downto 0);
	PHB : out std_logic_vector(15 downto 0));
end Component;
Component InputDecoder is port(
	BAD : in std_logic_vector(6 downto 0);
	ALE : in std_logic;
	ADD : in std_logic_vector(6 downto 0);
	LDR : out std_logic);
end Component;
Component LoadRegister is generic(n : integer := 8 );
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	LDR  : in std_logic;
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
Component UniversalTransceiver is port(
	RST : in std_logic;
	CLK : in std_logic;
	STT : in std_logic;
	RXD : in std_logic;
	DIN : in std_logic_vector(7 downto 0);
	TXD : out std_logic;
	DOUT : out std_logic_vector(7 downto 0));
end Component;
--Constants declaration--------------------------------------------------------
constant ZR : std_logic_vector(15 downto 0) := x"8000";
--Signals declaration----------------------------------------------------------
signal SYN : std_logic;
signal NCS : std_logic;
signal NPS : std_logic;
signal NRD : std_logic;
signal NWR : std_logic;
signal WREN : std_logic;
signal ADDR : std_logic_vector(6 downto 0);
signal MISO : std_logic_vector(31 downto 0);
signal MOSI : std_logic_vector(31 downto 0);

signal COMX : std_logic_vector(3 downto 0);
signal USSX : std_logic_vector(15 downto 0);
signal PHAX : std_logic_vector(15 downto 0);
signal PHBX : std_logic_vector(15 downto 0);
signal COMY : std_logic_vector(3 downto 0);
signal USSY : std_logic_vector(15 downto 0);
signal PHAY : std_logic_vector(15 downto 0);
signal PHBY : std_logic_vector(15 downto 0);
signal COMZ : std_logic_vector(3 downto 0);
signal USSZ : std_logic_vector(15 downto 0);
signal PHAZ : std_logic_vector(15 downto 0);
signal PHBZ : std_logic_vector(15 downto 0);
signal COMW : std_logic_vector(3 downto 0);
signal USSW : std_logic_vector(15 downto 0);
signal PHAW : std_logic_vector(15 downto 0);
signal PHBW : std_logic_vector(15 downto 0);
signal COME : std_logic_vector(3 downto 0);
signal USSE : std_logic_vector(15 downto 0);
signal PHAE : std_logic_vector(15 downto 0);
signal PHBE : std_logic_vector(15 downto 0);
signal COMF : std_logic_vector(3 downto 0);
signal USSF : std_logic_vector(15 downto 0);
signal PHAF : std_logic_vector(15 downto 0);
signal PHBF : std_logic_vector(15 downto 0);

signal STTR : std_logic;
signal BRKS : std_logic_vector(7 downto 0);
signal LMTS : std_logic_vector(7 downto 0);
begin
	--Concurrent assigments
	LED <= DIO;
	NCS <= NOT(CS);
	NPS <= NOT(PS);
	NRD <= NOT(RD);
	NWR <= NOT(WR);
	COMX <= C8(0) & C4(0) & C2(0) & C1(0);
	COMY <= C8(1) & C4(1) & C2(1) & C1(1);
	COMZ <= C8(2) & C4(2) & C2(2) & C1(2);
	COMW <= C8(3) & C4(3) & C2(3) & C1(3);
	COME <= C8(4) & C4(4) & C2(4) & C1(4);
	COMF <= C8(5) & C4(5) & C2(5) & C1(5);
	
	--Component instances------------------------------------------------------
	U01 : Timer1ms port map(RST, CLK, SYN);
	U02 : FourDigitDisplay port map(RST, CLK, SYN, MOSI(15 downto 0), SEG, ANX);
	U03 : ParallelInterface port map(RST, CLK, NCS, NPS, NRD, NWR, PAR, DIO, DIO, LMTS, WREN, ADDR, MISO, MOSI);
	U04 : AD5668 port map(RST, CLK, SYN, PHAX, PHAZ, PHBX, PHBZ, PHAY, PHAW, PHBY, PHBW, LDAC(0), SYNC(0), SCLK(0), DOUT(0), SCLR(0));
	U05 : AD5668 port map(RST, CLK, SYN, PHAE, ZR, PHBE, ZR, PHAF, ZR, PHBF, ZR, LDAC(1), SYNC(1), SCLK(1), DOUT(1), SCLR(1));
	
	---------------------------------------------------------------------------
	U06 : AxisController port map(RST, CLK, SYN, INH(0), CA(0), CB(0), USSX, "001", WREN, ADDR, MOSI, MISO);
	U07 : AxisController port map(RST, CLK, SYN, INH(1), CA(1), CB(1), USSY, "010", WREN, ADDR, MOSI, MISO);
	U08 : AxisController port map(RST, CLK, SYN, INH(2), CA(2), CB(2), USSZ, "011", WREN, ADDR, MOSI, MISO);
	U09 : AxisController port map(RST, CLK, SYN, INH(3), CA(3), CB(3), USSW, "100", WREN, ADDR, MOSI, MISO);
	U10 : AxisController port map(RST, CLK, SYN, INH(4), CA(4), CB(4), USSE, "101", WREN, ADDR, MOSI, MISO);
	U11 : AxisController port map(RST, CLK, SYN, INH(5), CA(5), CB(5), USSF, "110", WREN, ADDR, MOSI, MISO);
	
	---------------------------------------------------------------------------
	U12 : SinusoidalCommutatorA port map(COMX, USSX, PHAX, PHBX);
	U13 : SinusoidalCommutatorB port map(COMY, USSY, PHAY, PHBY);
	U14 : SinusoidalCommutatorB port map(COMZ, USSZ, PHAZ, PHBZ);
	U15 : SinusoidalCommutatorA port map(COMW, USSW, PHAW, PHBW);
	U16 : SinusoidalCommutatorA port map(COME, USSE, PHAE, PHBE);
	U17 : SinusoidalCommutatorA port map(COMF, USSF, PHAF, PHBF);
	
	U18 : InputDecoder port map("0000000", WREN, ADDR, STTR);
	U19 : LoadRegister port map(RST, CLK, STTR, MOSI(7 downto 0), BRKS);
	U20 : UniversalTransceiver port map(RST, CLK, STTR, RXD, BRKS, TXD, LMTS);
end Structural;
