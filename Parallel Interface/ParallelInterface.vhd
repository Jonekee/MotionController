Library IEEE;
use IEEE.std_logic_1164.all;

Entity ParallelInterface is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	--Master signals
	CS   : in std_logic;
	PS   : in std_logic;
	RD   : in std_logic;
	WR   : in std_logic;
	PAR  : out std_logic_vector(4 downto 0);
	DIN  : in std_logic_vector(7 downto 0);
	DOUT : out std_logic_vector(7 downto 0);
	--Internal bus
	STS  : in std_logic_vector(7 downto 0);
	WREN : out std_logic;
	ADDR : out std_logic_vector(6 downto 0);
	MISO : in std_logic_vector(31 downto 0);
	MOSI : out std_logic_vector(31 downto 0)
	);
end ParallelInterface;

Architecture Structural of ParallelInterface is
--Components declaration
Component ParallelInterfaceFSM is port(
	RST : in std_logic;
	CLK : in std_logic;
	LDC : in std_logic;
	MDE : in std_logic;
	RDX : out std_logic;
	WRX : out std_logic);
end Component;
Component Synchronizer is port(
	RST  : in std_logic;
	CLK  : in std_logic;
	XIN  : in std_logic;
	XOUT : out std_logic);
end Component;
Component RisingEdgeDetector is port(
	RST : in std_logic;
	CLK : in std_logic;
	XIN : in std_logic;
	RES : out std_logic);
end Component;
Component LoadRegister is generic(n : integer := 8 );
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	LDR  : in std_logic;
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
Component LeftShiftRegister is port(
	RST  : in std_logic;
	CLK  : in std_logic;
	LDR  : in std_logic;
	DIN  : in std_logic_vector(7 downto 0);
	DOUT : out std_logic_vector(31 downto 0));
end Component;
Component ParInSerOutRegister is port(
	RST : in std_logic;
	CLK : in std_logic;
	LDR : in std_logic;
	SHF : in std_logic;
	DIN : in std_logic_vector(31 downto 0);
	DOUT : out std_logic_vector(7 downto 0));
end Component;
Component Mux2To1 is generic(n : integer := 8);
	port(
	DINA : in std_logic_vector(n - 1 downto 0);
	DINB : in std_logic_vector(n - 1 downto 0);
	SEL  : in std_logic;
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
Component TriStateBusAdapter is generic(n : integer := 8);
	port(
	WRE  : in std_logic;
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
--Signals declaration
signal LDC, MDE, RDX : std_logic;
signal CSS, PSS, RDS : std_logic;
signal WRS, RDE, WRE : std_logic;
signal SHI, SHO, WRB : std_logic;
signal CMD, BTS, BMUX : std_logic_vector(7 downto 0);
begin
	--Concurrent assigments
	MDE  <= CMD(7);
	WRB  <= NOT(RD);
	PAR  <= BTS(7 downto 3);
	ADDR <= CMD(6 downto 0);
	LDC  <= NOT(CSS) AND NOT(PSS) AND WRE;
	SHI  <= NOT(CSS) AND PSS AND WRE;
	SHO  <= NOT(CSS) AND PSS AND RDE;
	
	--Component instances
	U01 : ParallelInterfaceFSM port map(RST, CLK, LDC, MDE, RDX, WREN);
	U02 : Synchronizer port map(RST, CLK, CS, CSS);
	U03 : Synchronizer port map(RST, CLK, PS, PSS);
	U04 : Synchronizer port map(RST, CLK, RD, RDS);
	U05 : Synchronizer port map(RST, CLK, WR, WRS);
	U06 : RisingEdgeDetector port map(RST, CLK, RDS, RDE);
	U07 : RisingEdgeDetector port map(RST, CLK, WRS, WRE);
	U08 : LoadRegister port map(RST, CLK, LDC, DIN, CMD);
	
	U09 : LeftShiftRegister port map(RST, CLK, SHI, DIN, MOSI);
	U10 : ParInSerOutRegister port map(RST, CLK, RDX, SHO, MISO, BTS);
	U12 : Mux2To1 port map(STS, BTS, PSS, BMUX);
	U13 : TriStateBusAdapter port map(WRB, BMUX, DOUT);
end Structural;
	