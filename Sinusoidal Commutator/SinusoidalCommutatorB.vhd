Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Entity SinusoidalCommutatorB is
	port(
	EANG : in std_logic_vector(3 downto 0);
	UOUT : in std_logic_vector(15 downto 0);
	PHA : out std_logic_vector(15 downto 0);
	PHB : out std_logic_vector(15 downto 0)
	);
end SinusoidalCommutatorB;

Architecture Structural of SinusoidalCommutatorB is
Component SineLUTB is port(
	EANG : in std_logic_vector(3 downto 0);
	SINA : out std_logic_vector(17 downto 0);
	SINB : out std_logic_vector(17 downto 0));
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
signal UEXT : std_logic_vector(17 downto 0);
signal SINA : std_logic_vector(17 downto 0);
signal SINB : std_logic_vector(17 downto 0);
signal RESA : std_logic_vector(35 downto 0);
signal RESB : std_logic_vector(35 downto 0);
signal AUXA : std_logic_vector(15 downto 0);
signal AUXB : std_logic_vector(15 downto 0);
constant OFFSET : std_logic_vector(15 downto 0) := x"8000";
begin
	AUXA <= RESA(31 downto 16);
	AUXB <= RESB(31 downto 16);
	UEXT <= UOUT(15) & UOUT(15) & UOUT;
	-------------------------------------------------
	U01 : SineLUTB port map(EANG, SINA, SINB);
	U02 : Multiplier port map(UEXT, SINA, RESA);
	U03 : Multiplier port map(UEXT, SINB, RESB);
	U04 : Adder port map(AUXA, OFFSET, PHA);
	U05 : Adder port map(AUXB, OFFSET, PHB);
end Structural;