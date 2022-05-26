LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY WB_STAGE IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;

		PORT_READ : IN STD_LOGIC;
		LOAD_IMM : IN STD_LOGIC;
		MEM_TO_REG : IN STD_LOGIC;

		ADDRESS_IS_INVALID : IN STD_LOGIC;
		SP_ERROR : IN STD_LOGIC;

		MEMORY_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_RESULT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		IMM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		IN_VECTOR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ERROR_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

		WRITE_BACK_VAL_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

		R_DST_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);

END ENTITY WB_STAGE;

ARCHITECTURE ARCH_WB_STAGE OF WB_STAGE IS

BEGIN

	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			IF (ADDRESS_IS_INVALID = '1' OR SP_ERROR = '1') THEN
				ERROR_PC <= PC;
			END IF;
		END IF;
	END PROCESS;

	WRITE_BACK_VAL_OUT <= ALU_RESULT WHEN PORT_READ = '0' AND LOAD_IMM = '0' AND MEM_TO_REG = '0' ELSE
		IMM WHEN PORT_READ = '0' AND LOAD_IMM = '1' AND MEM_TO_REG = '0' ELSE
		MEMORY_DATA WHEN PORT_READ = '0' AND LOAD_IMM = '0' AND MEM_TO_REG = '1' ELSE
		IN_VECTOR WHEN PORT_READ = '1' AND LOAD_IMM = '0' AND MEM_TO_REG = '0';
END ARCH_WB_STAGE;