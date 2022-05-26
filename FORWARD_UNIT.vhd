Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY FORWARD_UNIT IS
PORT(

--Inputs:
--Control unit Signals
E_M_BUFFER_WB		:IN std_logic;
M_WB_BUFFER_WB  	:IN std_logic;
E_MEM_BUFFER_PortRead	:IN std_logic;
M_WB_BUFFER_PortRead	:IN std_logic;
M_WB_BUFFER_MemRead	:IN std_logic;
E_M_BUFFER_LDM  	:IN std_logic;
M_WB_BUFFER_LDM		:IN std_logic;


--Addresses for comparing if the source of the new instruction 
--is the destination of the curren instruction
D_E_BUFFER_SRC1		:IN std_logic_vector(2 DOWNTO 0);
D_E_BUFFER_SRC2		:IN std_logic_vector(2 DOWNTO 0);
E_MEM_BUFFER_DEST	:IN std_logic_vector(2 DOWNTO 0);
M_WB_BUFFER_DEST	:IN std_logic_vector(2 DOWNTO 0);

--Outputs:
FUNC_SIG_OUT_1 : OUT std_logic_vector(2 DOWNTO 0);
FUNC_SIG_OUT_2 : OUT std_logic_vector(2 DOWNTO 0)

);
END ENTITY FORWARD_UNIT;

ARCHITECTURE arch_FORWARD_UNIT OF FORWARD_UNIT IS 
BEGIN


-- 111 : M_WB_BUFFER_PortRead
-- 110 : E_MEM_BUFFER_PortRead
-- 101 : M_WB_BUFFER_LDM
-- 100 : E_M_BUFFER_LDM
-- 011 : M_WB_BUFFER_WB
-- 010 : E_M_BUFFER_WB
-- 001 : M_WB_BUFFER_MemRead 
-- 000 : normal_src_value

-- WE CHOOSE WHICH OUTPUT WE WILL BE FORWARDING FROM
FUNC_SIG_OUT_1 <= "111" WHEN ((D_E_BUFFER_SRC1 = M_WB_BUFFER_DEST ) and M_WB_BUFFER_PortRead='1') -- Forward the In port value incase needed before WB written in register
		ELSE "110" WHEN ((D_E_BUFFER_SRC1 = E_MEM_BUFFER_DEST) and E_MEM_BUFFER_PortRead = '1' ) -- Forward the In port value incase needed before WB written in register same idea as ALU inst.
		ELSE "101" WHEN ((D_E_BUFFER_SRC1 = M_WB_BUFFER_DEST) and M_WB_BUFFER_LDM = '1' ) -- Forward Load immediate value before being written in register same idea as ALU inst.
		ELSE "100" WHEN ((D_E_BUFFER_SRC1 = E_MEM_BUFFER_DEST) and E_M_BUFFER_LDM = '1' )  -- Forward Load immediate value before being written in register same idea as ALU inst.		
		ELSE "011" WHEN ((D_E_BUFFER_SRC1 = M_WB_BUFFER_DEST) and M_WB_BUFFER_WB = '1' ) -- ALU WB from Buffer Memory and write back needed before WB written in register
		ELSE "010" WHEN ((D_E_BUFFER_SRC1 = E_MEM_BUFFER_DEST) and E_M_BUFFER_WB = '1' ) -- ALU WB from Buffer Execute and Memory needed before WB written in register		
		ELSE "001" WHEN ((D_E_BUFFER_SRC1 = M_WB_BUFFER_DEST) and M_WB_BUFFER_MemRead = '1' ) -- Incase I have ex.Load/Pop instruction i need to forward the value without the need for write back
		ELSE "000";  --Normal reading from the Register file

FUNC_SIG_OUT_2 <= "111" WHEN ((D_E_BUFFER_SRC2 = M_WB_BUFFER_DEST ) and M_WB_BUFFER_PortRead='1') -- Forward the In port value incase needed before WB written in register
		ELSE "110" WHEN ((D_E_BUFFER_SRC2 = E_MEM_BUFFER_DEST) and E_MEM_BUFFER_PortRead = '1' ) -- Forward the In port value incase needed before WB written in register same idea as ALU inst.
		ELSE "101" WHEN ((D_E_BUFFER_SRC2 = M_WB_BUFFER_DEST) and M_WB_BUFFER_LDM = '1' ) -- Forward Load immediate value before being written in register same idea as ALU inst.
		ELSE "100" WHEN ((D_E_BUFFER_SRC2 = E_MEM_BUFFER_DEST) and E_M_BUFFER_LDM = '1' )  -- Forward Load immediate value before being written in register same idea as ALU inst.		
		ELSE "011" WHEN ((D_E_BUFFER_SRC2 = M_WB_BUFFER_DEST) and M_WB_BUFFER_WB = '1' ) -- ALU WB from Buffer Memory and write back needed before WB written in register
		ELSE "010" WHEN ((D_E_BUFFER_SRC2 = E_MEM_BUFFER_DEST) and E_M_BUFFER_WB = '1' ) -- ALU WB from Buffer Execute and Memory needed before WB written in register		
		ELSE "001" WHEN ((D_E_BUFFER_SRC2 = M_WB_BUFFER_DEST) and M_WB_BUFFER_MemRead = '1' ) -- Incase I have ex.Load/Pop instruction i need to forward the value without the need for write back
		ELSE "000";  --Normal reading from the Register file

END arch_FORWARD_UNIT;
