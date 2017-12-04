Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Entity Adder is
	generic(n : integer := 16);
	port(
	OPA : in std_logic_vector(n - 1 downto 0);
	OPB : in std_logic_vector(n - 1 downto 0);
	RES : out std_logic_vector(n - 1 downto 0)
	);
end Adder;

Architecture DataFlow of Adder is
begin
	RES <= OPA + OPB;
end DataFlow;