LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PC IS
	PORT (
		address_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		clk : IN STD_LOGIC;
		address_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY PC;

ARCHITECTURE a_PC OF PC IS
BEGIN
	PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			address_out <= address_in;
		END IF;

	END PROCESS;
END a_PC;