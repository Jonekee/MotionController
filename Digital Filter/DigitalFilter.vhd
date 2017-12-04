Library IEEE;
use IEEE.std_logic_1164.all;

Entity DigitalFilter is
	port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	ERR : in std_logic_vector(15 downto 0);
	Q0 : in std_logic_vector(31 downto 0);
	Q1 : in std_logic_vector(31 downto 0);
	Q2 : in std_logic_vector(31 downto 0);
	Q3 : in std_logic_vector(31 downto 0);
	Q4 : in std_logic_vector(31 downto 0);
	UOUT : out std_logic_vector(15 downto 0)
	);
end DigitalFilter;

Architecture Structural of DigitalFilter is
--Components declaration
Component DigitalFilterFSM is port(
	RST : in std_logic;
	CLK : in std_logic;
	SYN : in std_logic;
	LDS : out std_logic;
	LDR : out std_logic;
	SEL : out std_logic_vector(2 downto 0));
end Component;
Component LoadRegister is generic(n : integer := 8 );
	port(
	RST  : in std_logic;
	CLK  : in std_logic;
	LDR  : in std_logic;
	DIN  : in std_logic_vector(n - 1 downto 0);
	DOUT : out std_logic_vector(n - 1 downto 0));
end Component;
Component FilterMultiplexor is port(
	EK0 : in std_logic_vector(15 downto 0);
	EK1 : in std_logic_vector(15 downto 0);
	EK2 : in std_logic_vector(15 downto 0);
	EK3 : in std_logic_vector(15 downto 0);
	EK4 : in std_logic_vector(15 downto 0);
	Q0 : in std_logic_vector(31 downto 0);
	Q1 : in std_logic_vector(31 downto 0);
	Q2 : in std_logic_vector(31 downto 0);
	Q3 : in std_logic_vector(31 downto 0);
	Q4 : in std_logic_vector(31 downto 0);
	SEL : in std_logic_vector(2 downto 0);
	EOUT : out std_logic_vector(17 downto 0);
	QOUT : out std_logic_vector(35 downto 0));
end Component;
Component Multiplier is generic(m : integer := 18; n : integer := 18);
	port(
	OPA : in std_logic_vector(m - 1 downto 0);
	OPB : in std_logic_vector(n - 1 downto 0);
	RES : out std_logic_vector(m + n -1 downto 0));
end Component;
Component Adder is generic(n : integer := 16);
	port(
	OPA : in std_logic_vector(n - 1 downto 0);
	OPB : in std_logic_vector(n - 1 downto 0);
	RES : out std_logic_vector(n - 1 downto 0));
end Component;
Component FilterSaturator is port(
	UIN : in std_logic_vector(59 downto 0);
	UOUT : out std_logic_vector(15 downto 0));
end Component;
--Signals declaration
signal LDS, LDR : std_logic;
signal SEL  : std_logic_vector(2 downto 0);
signal EK0  : std_logic_vector(15 downto 0);
signal EK1  : std_logic_vector(15 downto 0);
signal EK2  : std_logic_vector(15 downto 0);
signal EK3  : std_logic_vector(15 downto 0);
signal EK4  : std_logic_vector(15 downto 0);
signal EMUX : std_logic_vector(17 downto 0);
signal QMUX : std_logic_vector(35 downto 0);
signal MULT : std_logic_vector(53 downto 0);
signal EMUL : std_logic_vector(59 downto 0);
signal ACCU : std_logic_vector(59 downto 0);
signal RSUM : std_logic_vector(59 downto 0);
signal URES : std_logic_vector(59 downto 0);
begin
	--Concurrent assignations
	EMUL <= MULT(53)&MULT(53)&MULT(53)&MULT(53)&MULT(53)&MULT(53)&MULT;
	--Component instances
	U01 : DigitalFilterFSM port map(RST, CLK, SYN, LDS, LDR, SEL);
	U02 : LoadRegister generic map(16) port map(RST, CLK, SYN, ERR, EK0);
	U03 : LoadRegister generic map(16) port map(RST, CLK, SYN, EK0, EK1);
	U04 : LoadRegister generic map(16) port map(RST, CLK, SYN, EK1, EK2);
	U05 : LoadRegister generic map(16) port map(RST, CLK, SYN, EK2, EK3);
	U06 : LoadRegister generic map(16) port map(RST, CLK, SYN, EK3, EK4);
	U07 : FilterMultiplexor port map(EK0, EK1, EK2, EK3, EK4, Q0, Q1, Q2, Q3, Q4, SEL, EMUX, QMUX);
	U08 : Multiplier generic map(18, 36) port map(EMUX, QMUX, MULT);
	U09 : Adder generic map(60) port map(EMUL, ACCU, RSUM);
	U10 : LoadRegister generic map(60) port map(RST, CLK, LDS, RSUM, ACCU);
	U11 : LoadRegister generic map(60) port map(RST, CLK, LDR, ACCU, URES);
	U12 : FilterSaturator port map(URES, UOUT);
end Structural;