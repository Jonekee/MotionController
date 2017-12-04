Library IEEE;
use IEEE.std_logic_1164.all;

Entity AxisController is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	--Servo system signals
	AMP  : out std_logic;
	CHA  : in std_logic;
	CHB  : in std_logic;
	UOUT : out std_logic_vector(15 downto 0);
	--Internal bus signals
	BADD : in std_logic_vector(2 downto 0);
	WREN : in std_logic;
	ADDR : in std_logic_vector(6 downto 0);
	DIN  : in std_logic_vector(31 downto 0);
	DOUT : out std_logic_vector(31 downto 0)
	);
end AxisController;

Architecture Structural of AxisController is
--Components declaration
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
Component Latch is port(
	RST : in std_logic;
	CLK : in std_logic;
	LDR : in std_logic;
	BIN : in std_logic;
	BOUT : out std_logic);
end Component;
Component OutputDecoder is generic(n : integer := 8);
	port(
	BAD  : in std_logic_vector(6 downto 0);
	ADD  : in std_logic_vector(6 downto 0);
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
--------------------------------------------------------
Component EncoderQuadratureInterface is port(
	RST : in std_logic;
	CLK : in std_logic;
	CHA : in std_logic;
	CHB : in std_logic;
	POS : out std_logic_vector(31 downto 0));
end Component;
Component ErrorSubtractor is port(
	REF : in  std_logic_vector(31 downto 0);
	POS : in  std_logic_vector(31 downto 0);
	ERR : out std_logic_vector(15 downto 0));
end Component;
Component DigitalFilter is port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	ERR : in std_logic_vector(15 downto 0);
	Q0 : in std_logic_vector(31 downto 0);
	Q1 : in std_logic_vector(31 downto 0);
	Q2 : in std_logic_vector(31 downto 0);
	Q3 : in std_logic_vector(31 downto 0);
	Q4 : in std_logic_vector(31 downto 0);
	UOUT : out std_logic_vector(15 downto 0));
end Component;
Component Adder is generic(n : integer := 16);
	port(
	OPA : in std_logic_vector(n - 1 downto 0);
	OPB : in std_logic_vector(n - 1 downto 0);
	RES : out std_logic_vector(n - 1 downto 0));
end Component;
--Signals declaration----------------------------------------------------------
signal Q0ADD  : std_logic_vector(6 downto 0);
signal Q1ADD  : std_logic_vector(6 downto 0);
signal Q2ADD  : std_logic_vector(6 downto 0);
signal Q3ADD  : std_logic_vector(6 downto 0);
signal Q4ADD  : std_logic_vector(6 downto 0);
signal REFADD : std_logic_vector(6 downto 0);
signal ENADD  : std_logic_vector(6 downto 0);
signal RSADD  : std_logic_vector(6 downto 0);
signal POSADD : std_logic_vector(6 downto 0);
signal ERRADD : std_logic_vector(6 downto 0);
signal UADD   : std_logic_vector(6 downto 0);
signal OFFADD : std_logic_vector(6 downto 0);

signal LDR  : std_logic_vector(8 downto 0);
signal REF  : std_logic_vector(31 downto 0);
signal Q0   : std_logic_vector(31 downto 0);
signal Q1   : std_logic_vector(31 downto 0);
signal Q2   : std_logic_vector(31 downto 0);
signal Q3   : std_logic_vector(31 downto 0);
signal Q4   : std_logic_vector(31 downto 0);
signal SRST : std_logic;
signal ENAC : std_logic;

signal POS  : std_logic_vector(31 downto 0);
signal ERR  : std_logic_vector(15 downto 0);
signal EEXT : std_logic_vector(31 downto 0);
signal UINT : std_logic_vector(15 downto 0);
signal UEXT : std_logic_vector(31 downto 0);
signal URES : std_logic_vector(15 downto 0);
signal BIAS : std_logic_vector(15 downto 0);
begin
	--Concurrent assignations--------------------------------------------------
	Q0ADD  <= BADD & "0000";
	Q1ADD  <= BADD & "0001";
	Q2ADD  <= BADD & "0010";
	Q3ADD  <= BADD & "0011";
	Q4ADD  <= BADD & "0100";
	REFADD <= BADD & "0101";	
	POSADD <= BADD & "0110";
	ERRADD <= BADD & "0111";
	UADD   <= BADD & "1000";
	OFFADD <= BADD & "1001";
	RSADD  <= BADD & "1110";
	ENADD  <= BADD & "1111";
	
	SRST <= RST AND ENAC;
	EEXT(15 downto  0) <= ERR;
	EEXT(31 downto 16) <= (others => ERR(15));
	UEXT(15 downto  0) <= UINT;
	UEXT(31 downto 16) <= (others => UINT(15));
	--Component instances------------------------------------------------------
	U01 : InputDecoder port map(Q0ADD,  WREN, ADDR, LDR(0));
	U02 : InputDecoder port map(Q1ADD,  WREN, ADDR, LDR(1));
	U03 : InputDecoder port map(Q2ADD,  WREN, ADDR, LDR(2));
	U04 : InputDecoder port map(Q3ADD,  WREN, ADDR, LDR(3));
	U05 : InputDecoder port map(Q4ADD,  WREN, ADDR, LDR(4));
	U06 : InputDecoder port map(REFADD, WREN, ADDR, LDR(5));
	U07 : InputDecoder port map(OFFADD, WREN, ADDR, LDR(6)); --Offset
	U08 : InputDecoder port map(ENADD,  WREN, ADDR, LDR(7));
	U09 : InputDecoder port map(RSADD,  WREN, ADDR, LDR(8));
	
	U10 : LoadRegister generic map(32) port map(RST,  CLK, LDR(0), DIN, Q0);
	U11 : LoadRegister generic map(32) port map(RST,  CLK, LDR(1), DIN, Q1);
	U12 : LoadRegister generic map(32) port map(RST,  CLK, LDR(2), DIN, Q2);
	U13 : LoadRegister generic map(32) port map(RST,  CLK, LDR(3), DIN, Q3);
	U14 : LoadRegister generic map(32) port map(RST,  CLK, LDR(4), DIN, Q4);
	U15 : LoadRegister generic map(32) port map(SRST, CLK, LDR(5), DIN, REF);
	U16 : LoadRegister generic map(16) port map(SRST, CLK, LDR(6), DIN(15 downto 0), BIAS);
	U17 : Latch port map(RST, CLK, LDR(7), DIN(0), AMP);
	U18 : Latch port map(RST, CLK, LDR(8), DIN(0), ENAC);
	
	U19 : OutputDecoder generic map(32) port map(Q0ADD,  ADDR, Q0,   DOUT);
	U20 : OutputDecoder generic map(32) port map(Q1ADD,  ADDR, Q1,   DOUT);
	U21 : OutputDecoder generic map(32) port map(Q2ADD,  ADDR, Q2,   DOUT);
	U22 : OutputDecoder generic map(32) port map(Q3ADD,  ADDR, Q3,   DOUT);
	U23 : OutputDecoder generic map(32) port map(Q4ADD,  ADDR, Q4,   DOUT);
	U24 : OutputDecoder generic map(32) port map(REFADD, ADDR, REF,  DOUT);
	U25 : OutputDecoder generic map(32) port map(POSADD, ADDR, POS,  DOUT);
	U26 : OutputDecoder generic map(32) port map(ERRADD, ADDR, EEXT, DOUT);
	U27 : OutputDecoder generic map(32) port map(UADD  , ADDR, UEXT, DOUT);
	---------------------------------------------------------------------------
	
	U28 : EncoderQuadratureInterface port map(SRST, CLK, CHA, CHB, POS);
	U29 : ErrorSubtractor port map(REF, POS, ERR);
	U30 : DigitalFilter port map(SRST, CLK, SYN, ERR, Q0, Q1, Q2, Q3, Q4, UINT);
	U31 : Adder generic map(16) port map(UINT, BIAS, UOUT);
	---------------------------------------------------------------------------
end Structural;