Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY JMP_DETECT_UNIT IS 
PORT(--disable:IN std_logic;
FLAGS_IN:IN std_logic_vector(3 downto 0);
OT_CODE:IN std_logic_vector(1 downto 0); --(OPERATIONAL TYPE)
ID_CODE:IN std_logic_vector(2 downto 0); --(Instruction identification)

CHECK_JMP:OUT std_logic;
FLAGS_OUT:OUT std_logic_vector(3 downto 0));
END ENTITY JMP_DETECT_UNIT;


ARCHITECTURE ARCH_JMP_DETECT_UNIT OF JMP_DETECT_UNIT IS 

signal N_flag : std_logic; --(NEGATIVE FLAG)
signal C_FLAG : std_logic; --(CARRAY FLAG)
signal Z_flag : std_logic; --(ZERO FLAG)


BEGIN	

-- HERE WE CHECK IF THIS IS A JUMP INSTRUCTION
CHECK_JMP <= '1' WHEN ((OT_CODE = "11") and (ID_CODE = "100"))
	 ELSE '1' WHEN ((OT_CODE = "11") and (ID_CODE = "000") and (FLAGS_IN(0) = '1'))
	 ELSE '1' WHEN ((OT_CODE = "11") and (ID_CODE = "001") and (FLAGS_IN(2) = '1'))
	 ELSE '1' WHEN ((OT_CODE = "11") and (ID_CODE = "010") and (FLAGS_IN(1) = '1'))
	 ELSE '1' WHEN ((OT_CODE = "11") and (ID_CODE = "011"))
	 --ELSE '0' WHEN disable='1'
	 ELSE '0' ;

--ZERO JUMP INSTRUCTION
Z_flag <= '0' WHEN ((OT_CODE = "11") and (ID_CODE = "000") and (FLAGS_IN(0) = '1'))
	ELSE FLAGS_IN(0);

--NEGATIVE JUMP INSTRUCTION
N_flag <= '0' WHEN ((OT_CODE = "11") and (ID_CODE = "001") and (FLAGS_IN(1) = '1'))
	ELSE FLAGS_IN(1);

--CARRY JUMP INSTRUCTION
C_FLAG <= '0'  WHEN ((OT_CODE = "11") and (ID_CODE = "010") and (FLAGS_IN(2) = '1'))
	ELSE FLAGS_IN(2);


FLAGS_OUT <= '0'& C_FLAG & N_flag & Z_flag;

END ARCH_JMP_DETECT_UNIT; 
