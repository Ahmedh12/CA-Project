LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

--REGESTER FROM LABS
ENTITY CCR IS
	PORT(EN,CLK,RESET:IN std_logic;
	DATA_IN:IN std_logic_vector (3 DOWNTO 0);
	DATA_OUT:OUT std_logic_vector (3 DOWNTO 0));
END ENTITY CCR ;


ARCHITECTURE ARCH_CCR OF CCR IS 
BEGIN
PROCESS(CLK,RESET)
BEGIN
IF RESET='1' THEN 
DATA_OUT<=(OTHERS=>'0');
ELSIF RISING_EDGE(CLK) and EN='1' THEN
DATA_OUT<=DATA_IN;
END IF;		
END PROCESS;
END ARCH_CCR;