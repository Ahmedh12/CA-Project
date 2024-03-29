LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

--REGESTER FROM LABS
ENTITY Output_port IS
	PORT(PORt_WRITE,CLK,RESET:IN std_logic;
	DATA_IN:IN std_logic_vector (31 DOWNTO 0);
	DATA_OUT:OUT std_logic_vector (31 DOWNTO 0));
END ENTITY Output_port ;


ARCHITECTURE ARCH_Output_port OF Output_port IS 
BEGIN
PROCESS(CLK,RESET)
BEGIN
IF RESET='1' THEN 
DATA_OUT<=(OTHERS=>'0');
ELSIF RISING_EDGE(CLK) and PORt_WRITE='1' THEN
DATA_OUT<=DATA_IN;
END IF;		
END PROCESS;
END ARCH_Output_port;