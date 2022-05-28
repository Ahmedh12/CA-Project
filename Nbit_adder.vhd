library ieee;
Use ieee.std_logic_1164.all;

Entity Nbit_adder IS 
GENERIC (Z: integer:=16);
PORT (A: IN std_logic_vector(Z-1 DOWNTO 0);
      B: IN std_logic_vector(Z-1 DOWNTO 0);
      Cin: IN std_logic;
      s: OUT std_logic_vector(Z-1 DOWNTO 0);
      cout: OUT std_logic);

END Nbit_adder;

ARCHITECTURE arch_nadder OF Nbit_adder IS

COMPONENT Onebit_adder IS
 PORT (A: IN std_logic;
       B: IN std_logic;
       Cin: IN std_logic;
       s: OUT std_logic;
       cout: OUT std_logic);
END COMPONENT;

SIGNAL Temp:std_logic_vector(Z-1 downto 0);

BEGIN

f0: Onebit_adder PORT MAP(A(0),B(0),Cin,s(0),Temp(0));

loop1 : FOR i IN 1 TO Z-1 GENERATE
  fx: Onebit_adder PORT MAP(A(i),B(i),Temp(i-1),s(i),Temp(i));
END GENERATE;

COUT<=Temp(Z-1);

END arch_nadder;
