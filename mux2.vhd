library ieee;
Use ieee.std_logic_1164.all;

Entity mux2 IS
Generic (n: integer :=32);  -- n: is the size of the actual data
PORT( in0,in1: IN std_logic_vector(n-1 downto 0);
S: IN std_logic;
F: OUT std_logic_vector(n-1 downto 0));

END mux2;

ARCHITECTURE arch_mux2 OF mux2 IS
BEGIN

F<= in0 When S = '0'
ELSE in1;

END arch_mux2;
