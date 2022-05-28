library ieee;
Use ieee.std_logic_1164.all;

Entity MUX8X1 IS
Generic (n: integer :=32);  -- n: is the size of the actual data
PORT( in0,in1,in2,in3,in4,in5,in6,in7: IN std_logic_vector(n-1 downto 0);
S: IN std_logic_vector(2 downto 0);
F: OUT std_logic_vector(n-1 downto 0));

END MUX8X1;

ARCHITECTURE arch_MUX8X1 OF MUX8X1 IS
BEGIN

F<= in0  When S(0) = '0' AND S(1) = '0' AND S(2) = '0'
ELSE in1 When S(0) = '1' AND S(1) = '0' AND S(2) = '0'
ELSE in2 When S(0) = '0' AND S(1) = '1' AND S(2) = '0'
ELSE in3 when S(0) = '1' AND S(1) = '1' AND S(2) = '0'
ELSE in4 when S(0) = '0' AND S(1) = '0' AND S(2) = '1'
ELSE in5 when S(0) = '1' AND S(1) = '0' AND S(2) = '1'
ELSE in6 when S(0) = '0' AND S(1) = '1' AND S(2) = '1'
ELSE in7;

 
END arch_MUX8X1;