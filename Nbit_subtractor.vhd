library ieee;
Use ieee.std_logic_1164.all;

Entity Nbit_subtractor IS 
GENERIC (Z: integer:=32);
PORT (X: IN std_logic_vector(Z-1 DOWNTO 0);
      Y: IN std_logic_vector(Z-1 DOWNTO 0);
      Bin: IN std_logic;
      s: OUT std_logic_vector(Z-1 DOWNTO 0);
      Bout: OUT std_logic);

END Nbit_subtractor;

ARCHITECTURE arch_Nbit_subtractor OF Nbit_subtractor IS

COMPONENT Onebit_subtractor IS
 PORT (X: IN std_logic;
       Y: IN std_logic;
       Bin: IN std_logic;
       s: OUT std_logic;
       Bout: OUT std_logic);
END COMPONENT;

SIGNAL Temp:std_logic_vector(Z-1 downto 0);

BEGIN

f0: Onebit_subtractor PORT MAP(X(0),Y(0),Bin,s(0),Temp(0));

loop1 : FOR i IN 1 TO Z-1 GENERATE
  fx: Onebit_subtractor PORT MAP(X(i),Y(i),Temp(i-1),s(i),Temp(i));
END GENERATE;

BOUT<=Temp(Z-1);

END arch_Nbit_subtractor;
