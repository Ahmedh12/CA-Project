
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY stack_pointer IS
	PORT(clk, rst, call, ret, rti  : IN std_logic;
		push_pop : IN  std_logic_vector(1 DOWNTO 0);
		stack_pointer_in : IN  std_logic_vector(31 DOWNTO 0);
		sp_unexpected :  OUT std_logic;
		stack_pointer_out : OUT  std_logic_vector(31 DOWNTO 0));
END ENTITY stack_pointer;

ARCHITECTURE arch_stack_pointer OF stack_pointer IS

SIGNAL sp_new: std_logic_vector(31 DOWNTO 0);

BEGIN
	
	PROCESS(clk)
		BEGIN
		

		IF rst = '1' THEN
			sp_new <= "00000000000011111111111111111111";  -- initial sp

		ELSIF falling_edge (clk) and (call = '1' or push_pop = "01") THEN -- push
			sp_new <= std_logic_vector(to_unsigned(to_integer(unsigned(stack_pointer_in)) - 1 ,32));
		
		ELSIF falling_edge (clk) and (ret = '1' or rti = '1' or push_pop = "10") THEN -- pop
			sp_new <= std_logic_vector(to_unsigned(to_integer(unsigned(stack_pointer_in)) + 1 ,32));

		ELSIF falling_edge (clk) THEN
			sp_new <= stack_pointer_in;
		END IF;

		--IF rising_edge (clk) THEN
		IF (sp_new > "00000000000011111111111111111111") then
			sp_new <= stack_pointer_in;
			--sp_new <="00000000000011111111111111111111";
			sp_unexpected <='1';
		ELSE
			sp_unexpected <='0';
		END IF;

		stack_pointer_out <= sp_new;
		--END IF;
	END PROCESS;
END arch_stack_pointer;