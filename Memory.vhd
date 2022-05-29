LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory IS
	PORT (
		clk : IN STD_LOGIC; -- clock
		--Memory Stage Needed Variables
		memWrite : IN STD_LOGIC; --Write Signal from memory stage
		memRead : IN STD_LOGIC; --Read Signal from memory stage
		data_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Address of the data to be read or written from memory stage
		datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Data to be written to memory from memory stage

		--Fetch Stage Needed Variables
		Fetch_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Address of the instruction to be fetched from fetch stage
		--Stack Operations required variables
		Stack_pointer : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Stack pointer
		PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Program counter
		flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --Flags to be passed to the memory stage to be preserved in case of calling an interrupt
		PC_to_Stack : IN STD_LOGIC; --Signal to indicate that the PC is to be pushed to the stack
		ret, rti : IN STD_LOGIC; --Signals to indicate that the program is to be returned from a subroutine or an interrupt
		call : IN STD_LOGIC; --Signal to indicate that the program is to be called from a subroutine
		stack : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --Signal indicating that the stack is to be pushed or popped

		--Outputs
		structural_hazard : OUT STD_LOGIC; --Signal to freeze the PC in case the memory stage is using the Memory
		dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); --Data to be read from memory
END ENTITY Memory;

ARCHITECTURE a_Memory OF Memory IS
	TYPE ram_type IS ARRAY(0 TO 1048575) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram : ram_type;

BEGIN
	PROCESS (clk, memRead) IS
		VARIABLE pc_with_flags : STD_LOGIC_VECTOR(31 DOWNTO 0);
	BEGIN
		IF memWrite = '1' THEN --Write to memory (push or store or call or int)
			IF rising_edge(clk) THEN
				dataout <= (OTHERS => 'Z');
				structural_hazard <= '1'; --Freeze the PC to stall the fetch stage
				IF PC_to_Stack = '1' THEN --Push the PC to the stack (call or int)
					IF call = '1' THEN --Call a subroutine
						ram(to_integer(unsigned(Stack_pointer))) <= datain;
					ELSE --Interrupt 
						pc_with_flags := STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(PC)) + 1, 32)); --we add one to the Propagated PC to push the address of the next instruction
						pc_with_flags(31 DOWNTO 29) := flags; -- Preserve the flags with the PC --- 19 downto 0 are the PC bits and 31 downto 29 are the flags
						ram(to_integer(unsigned(Stack_pointer))) <= pc_with_flags;
					END IF;
				ELSIF stack = "01" THEN --push a value into the stack
					ram(to_integer(unsigned(Stack_pointer))) <= datain;
				ELSE
					ram(to_integer(unsigned(data_address))) <= datain;
				END IF;
			END IF;
		ELSIF memRead = '1' THEN --Read from memory (pop or load or ret or rti)
			structural_hazard <= '1'; --Freeze the PC to stall the fetch stage
			IF ret = '1' OR rti = '1' OR stack = "10" THEN --Pop the PC from the stack (ret or rti)
				dataout <= ram(to_integer(unsigned(Stack_pointer)) - 1);
			ELSE --Load a value from the Memory (load)
				dataout <= ram(to_integer(unsigned(data_address)));
			END IF;
		ELSE --No memory operation so we can fetch the next instruction
			structural_hazard <= '0';
			dataout <= ram(to_integer(unsigned(Fetch_address)));
		END IF;

	END PROCESS;
END a_Memory;