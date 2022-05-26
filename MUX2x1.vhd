Library ieee;
Use ieee.std_logic_1164.all;

ENTITY MUX2x1 IS 
generic (
n:integer:=18
);
	PORT (inputA, inputB: IN std_logic_vector(n-1 DOWNTO 0);
		sel: IN std_logic;
		result: OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY MUX2x1;

ARCHITECTURE archMUX2x1 of MUX2x1 IS 
BEGIN
	result <= inputA WHEN sel ='0'
		ELSE inputB;
END archMUX2x1;
