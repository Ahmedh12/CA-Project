LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Swap_Controller IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;

		Data1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		Data1Addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Data2Addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

		DataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DataOutAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

		swapBob : IN STD_LOGIC
	);

END ENTITY Swap_Controller;

ARCHITECTURE ARCH_Swap_Controller OF Swap_Controller IS

	SIGNAL state : STD_LOGIC := '0';

BEGIN

	PROCESS (state)
	BEGIN
		IF swapBob = '1' THEN
			IF state = '0' THEN
				DataOutAddr <= Data1Addr;
				DataOut <= Data2;
			END IF;
			IF state = '1' THEN
				DataOutAddr <= Data2Addr;
				DataOut <= Data1;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk, rst)
	BEGIN
		IF rising_edge(clk) AND swapBob = '1' THEN
			state <= NOT state;
		END IF;
	END PROCESS;

END ARCH_Swap_Controller;