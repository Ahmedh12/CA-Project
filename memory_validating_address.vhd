LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memory_validating_address IS
	PORT(mem_write, mem_read: IN std_logic;
		push_pop : IN  std_logic_vector(1 DOWNTO 0);
		address : IN  std_logic_vector(31 DOWNTO 0);
		address_invalid : OUT  std_logic);
END ENTITY memory_validating_address;

ARCHITECTURE arch_memory_validating_address OF memory_validating_address IS



BEGIN
	address_invalid <= '1' WHEN address > "00000000000011111111111111111111" and push_pop = "00" and (mem_read = '1' or mem_write = '1' )
	ELSE '0';

END arch_memory_validating_address;
