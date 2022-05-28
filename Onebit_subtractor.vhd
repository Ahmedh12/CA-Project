library ieee;
Use ieee.std_logic_1164.all;

Entity Onebit_subtractor IS 

PORT (X: IN std_logic;
      Y: IN std_logic;
      Bin: IN std_logic; --BORROW INPUT 
      S: OUT std_logic;
      BOUT: OUT std_logic); --BORROW OUTPUT

END Onebit_subtractor;

ARCHITECTURE arch_Onebit_subtractor OF Onebit_subtractor IS
BEGIN

S<= X XOR Y XOR Bin;
BOUT<=(NOT X AND Y) OR (NOT(X XOR Y) AND Bin);

END arch_Onebit_subtractor;
