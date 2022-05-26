LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FD_Buffer IS PORT (
	clk : IN STD_LOGIC;
	enable : IN STD_LOGIC;
	flush : IN STD_LOGIC;
	Instruction_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	PC_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	inPortVal_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	reset_in : IN STD_LOGIC;
	SW_int_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	HW_int_in : IN STD_LOGIC;
	structural_hazard_in : IN STD_LOGIC;
	Instruction_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	PC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	inPortVal_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	reset_out : OUT STD_LOGIC;
	SW_int_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	HW_int_out : OUT STD_LOGIC;
	structural_hazard_out : OUT STD_LOGIC);
END FD_Buffer;

ARCHITECTURE a_FD_Buffer OF FD_Buffer IS
BEGIN
	PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			reset_out <= reset_in;
			IF flush = '1' THEN
				Instruction_out <= (others => '0');
				inPortVal_out <= (OTHERS => '0');
				PC_out <= (OTHERS => '0');
				SW_int_out <= (OTHERS => '0');
				HW_int_out <= '0';
				structural_hazard_out <= '0';
			ELSIF enable = '1' THEN
				Instruction_out <= Instruction_in;
				inPortVal_out <= inPortVal_in;
				PC_out <= PC_in;
				SW_int_out <= SW_int_in;
				HW_int_out <= HW_int_in;
				structural_hazard_out <= structural_hazard_in;
			END IF;
		END IF;
	END PROCESS;
END a_FD_Buffer;