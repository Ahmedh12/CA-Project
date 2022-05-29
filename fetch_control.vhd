LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FetchControl IS PORT (
	family : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	func : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	reset : IN STD_LOGIC; --HW reset Signal
	buff1_reset : IN STD_LOGIC; --Reset Signal for Buffer 1
	disable : IN STD_LOGIC; --disable Signal
	structural_hazard : IN STD_LOGIC; --Structural Hazard Signal from memory after 1 cycle
	buff1_structural_hazard: IN STD_LOGIC;
	buff2_structural_hazard: IN STD_LOGIC;
        sp_Exception : IN STD_LOGIC; --Exception EmptyStack
	addr_Exception : IN STD_LOGIC; --Exception invalid address
	buff4_sp_Exception : IN STD_LOGIC; --Exception EmptyStack in Buffer 4
	buff4_addr_Exception : IN STD_LOGIC; --Exception invalid address in Buffer 4  
	HW_interrupt : IN STD_LOGIC; --HW interrupt Signal
	SW_interrupt : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --SW interrupt Instruction Int 0 or Int 1
	buff1_HW_interrupt : IN STD_LOGIC; --HW interrupt Signal
	buff1_SW_interrupt : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --SW interrupt Instruction Int 0 or Int 1
	mem_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Instruction contains PC value in case or reset and interrupt and in case of pop
	is_jump : IN STD_LOGIC; --flag if a branching action is to happen
	jump_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --address of the branching action
	mem_to_pc : IN STD_LOGIC; --signal indicating a pop instruction
	PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Previous Value of PC
	FC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); --The output instruction address that will be feed into the memory 
END FetchControl;

ARCHITECTURE a_FetchControl OF FetchControl IS
SIGNAL CHECK : STD_LOGIC := '0';
SIGNAL FC_out_DUMMYY : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	FC_out <= (OTHERS => '0') WHEN reset = '1'
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(1, 32)) WHEN HW_interrupt = '1' 
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(2, 32)) WHEN SW_interrupt = "01"
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(3, 32)) WHEN SW_interrupt = "10"
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(4, 32)) WHEN (sp_Exception = '1' OR addr_exception = '1')
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(PC)) - 1, 32)) WHEN disable = '1'
		ELSE
		mem_out WHEN 
		buff1_reset = '1' OR 
		buff1_SW_interrupt = "01" OR 
		buff1_SW_interrupt = "10" OR 
		buff4_sp_Exception = '1' OR 
		buff4_addr_Exception = '1' OR 
		buff1_HW_interrupt = '1' OR 
		mem_to_pc = '1' OR
		reset = '1'
		-- HW_interrupt = '1' OR
		-- SW_interrupt = "01" OR
		-- SW_interrupt = "10" OR
		-- sp_Exception = '1' OR
		-- addr_Exception = '1'
		ELSE
		jump_address WHEN is_jump = '1'
		ELSE
		PC WHEN (family = "10" AND func = "000") --hlt instruction
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(PC)), 32)) WHEN structural_hazard = '1' AND buff1_structural_hazard = '0' AND buff2_structural_hazard = '0'
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(PC)), 32)) WHEN structural_hazard = '1' AND buff1_structural_hazard = '1' AND buff2_structural_hazard = '1'
		ELSE 
		STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(PC))-2, 32)) WHEN structural_hazard = '1' AND buff1_structural_hazard = '1' AND buff2_structural_hazard = '0'
		ELSE
		STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(PC)) + 1, 32));

END a_FetchControl;