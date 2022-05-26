LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY control_unit IS
	PORT (
		opcode: in std_logic_vector(4 downto 0);
		fired_signals : out std_logic_vector(17 DOWNTO 0)
		--alu_src: out std_logic;
		--alu_op: out std_logic_vector(2 downto 0);
		--mem_write: out std_logic;
		--mem_read: out std_logic;
		--mem_to_reg: out std_logic;
		--reg_write: out std_logic;
		--stack: out std_logic;
		--port_read: out std_logic;
		--port_write: out std_logic;
		--ldm: out std_logic;
		--pc_to_stack: out std_logic;
		--mem_to_pc: out std_logic;
		--int: out std_logic; ----------------------int to be removed from cu
		--rti: out std_logic;
		--ret: out std_logic;
		--call: out std_logic
	);
END control_unit;

ARCHITECTURE control_unit_arch OF control_unit IS

	CONSTANT nop_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10001";
	CONSTANT hlt_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "10000";
	CONSTANT setc_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
	CONSTANT not_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00001";
	CONSTANT inc_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00010";
	CONSTANT out_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01001";
	CONSTANT in_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01000";
	CONSTANT mov_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00011";
	------------CONSTANT swap_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01001";
	CONSTANT add_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00100";
	CONSTANT sub_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00110";
	CONSTANT and_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00101";
	CONSTANT iadd_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00111";
	CONSTANT push_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01100";
	CONSTANT pop_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01101";
	CONSTANT ldm_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01110";
	CONSTANT ldd_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01010";
	CONSTANT std_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "01011";
	CONSTANT jz_imm_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11000";
	CONSTANT jn_imm_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11010";
	CONSTANT jc_imm_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11001";
	CONSTANT jmp_imm_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11011";
	CONSTANT call_imm_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11100";
	CONSTANT ret_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11101";
	CONSTANT int_index_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11110";
	CONSTANT rti_operation : STD_LOGIC_VECTOR(4 DOWNTO 0) := "11111";
        --SIGNAL fired_signals :  STD_LOGIC_VECTOR(17 DOWNTO 0);
	--SIGNAL opcode: STD_LOGIC_VECTOR(4 downto 0);
BEGIN
	   
	WITH opcode SELECT
		fired_signals <=
		"001100000000000000" WHEN nop_operation,
		"001100000000000000" WHEN hlt_operation,
		"000000000000000000" WHEN setc_operation,
		"000100010000000000" WHEN not_operation,
		"001000010000000000" WHEN inc_operation,
		"001100000001000000" WHEN out_operation,
		"001100010010000000" WHEN in_operation,
		"001100010000000000" WHEN mov_operation,
		--"000110010000000000" WHEN swap_operation,
		"110000010000000000" WHEN add_operation,
		"111000010000000000" WHEN sub_operation,
		"110100010000000000" WHEN and_operation,
		"010000010000000000" WHEN iadd_operation,
		"101110000100000000" WHEN push_operation,
		"001101111000000000" WHEN pop_operation,
		"010000010000100000" WHEN ldm_operation,
		"010001110000000000" WHEN ldd_operation,
		"010010000000000000" WHEN std_operation,
		"001100000000000000" WHEN jz_imm_operation,
		"001100000000000000" WHEN jn_imm_operation,
		"001100000000000000" WHEN jc_imm_operation,
		"001100000000000000" WHEN jmp_imm_operation,
		"001110000100010001" WHEN call_imm_operation,
		"001101001000001010" WHEN ret_operation,
		"001110000100010000" WHEN int_index_operation,
		"001101001000001100" WHEN rti_operation,
		"001100000000000000" WHEN OTHERS;
END control_unit_arch;
