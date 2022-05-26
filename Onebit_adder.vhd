library ieee;
Use ieee.std_logic_1164.all;

Entity Onebit_adder IS 

PORT (A: IN std_logic;
      B: IN std_logic;
      Cin: IN std_logic;
      S: OUT std_logic;
      COUT: OUT std_logic);

END Onebit_adder;

ARCHITECTURE arch_oneadder OF Onebit_adder IS
BEGIN

s<= A XOR B XOR cin;
cout<=(A AND B) OR (Cin AND (A XOR B));

END arch_oneadder;
