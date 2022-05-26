LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY EXECUTE_MEMORY_BUFFER IS
    PORT (

        ----------------------------------------- INPUTS -------------------------------
        --------------------STACK/INTERRUPT
        INPUT_STACK : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --STACK IN
        INPUT_INTERRUPT : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --IN INT
        STACK_DATA_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        --------------------

        ---------------------MEM READ/WRITE
        INPUT_MEM_READ : IN STD_LOGIC;
        INPUT_MEM_WRITE : IN STD_LOGIC;
        --------------------

        ------------------PROGRAM COUNTER
        PC_DATA_32BIT_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        ------------------

        --------------------ALU RESULT
        ALU_RESULT_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        -------------------

        --------------------OFFSET/IMMEDIATE
        OFFSET_IMM_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        ---------------------
        ---------------------ADDRESSES
        --INPUT ADRRESSS
        ADDRESS_RSRC1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ADDRESS_RSRC2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ADDRESS_RDST_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ------------------

        ----------------------RSRC2
        INPUT_RSRC2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        ----------------------

        -------------- INPUT SIGNALS
        INPUT_MEM_PC : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        EXEP_STACK_POINTER : IN STD_LOGIC;
        INVALID_ADD_BIT : IN STD_LOGIC;
        INPUT_PC_TO_STACK : IN STD_LOGIC;
        INPUT_RTI : IN STD_LOGIC;
        INPUT_WB : IN STD_LOGIC;
        INPUT_LOAD_IMM : IN STD_LOGIC;
        INPUT_PORT_READ : IN STD_LOGIC; --PORT READ
        INPUT_MEM_TO_REG : IN STD_LOGIC;
        INPUT_RETURN : IN STD_LOGIC;
        INPUT_CALL : IN STD_LOGIC;
        -----------------

        ---------------PORT INPUT:
        INPUT_PORT_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        ---------------

        --------------------------------------------- OUTPUTS -----------------------------
        --------------------STACK/INTERRUPT
        OUTPUT_STACK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --STACK OUT
        OUTPUT_INTERRUPT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); --OUT INT
        STACK_DATA_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        -------------------

        ---------------------MEM READ/WRITE
        OUTPUT_MEM_READ : OUT STD_LOGIC;
        OUTPUT_MEM_WRITE : OUT STD_LOGIC;
        --------------------

        ------------------PROGRAM COUNTER
        PC_DATA_32BIT_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        ------------------

        --------------------ALU RESULT
        ALU_RESULT_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        -------------------

        --------------------OFFSET/IMMEDIATE
        OFFSET_IMM_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        ---------------------

        ---------------------ADDRESSES
        --INPUT ADRRESSS
        ADDRESS_RSRC1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ADDRESS_RSRC2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ADDRESS_RDST_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        --------------------------------

        ----------------------RSRC2
        OUTPUT_RSRC2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        ----------------------

        ---------------PORT INPUT:
        OUTOUT_PORT_IN : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        -----------------

        -------------- INPUT SIGNALS
        OUTPUT_MEM_PC : OUT STD_LOGIC;
        --CLK:  OUT STD_LOGIC;
        --RESET: OUT STD_LOGIC; 
        EXEP_STACK_POINTER_OUT : OUT STD_LOGIC;
        OUTPUT_PC_TO_STACK : OUT STD_LOGIC;
        OUTPUT_RTI : OUT STD_LOGIC;
        OUTPUT_WB : OUT STD_LOGIC;
        OUTPUT_LOAD_IMM : OUT STD_LOGIC;
        OUTPUT_PORT_READ : OUT STD_LOGIC; --PORT READ
        OUTPUT_MEM_TO_REG : OUT STD_LOGIC;
        OUTPUT_RETURN : OUT STD_LOGIC;
        OUTPUT_CALL : OUT STD_LOGIC;
        -----------------
        flags_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        flags_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY EXECUTE_MEMORY_BUFFER;

ARCHITECTURE ARCH_EXECUTE_MEMORY_BUFFER OF EXECUTE_MEMORY_BUFFER IS
    --read anytime and write only at rising edge
BEGIN

    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (RESET = '1' OR EXEP_STACK_POINTER = '1' OR INVALID_ADD_BIT = '1') THEN

                OUTPUT_LOAD_IMM <= '0';
                OUTPUT_PORT_READ <= '0';
                OUTPUT_MEM_TO_REG <= '0';
                OUTPUT_PC_TO_STACK <= '0';

                OUTPUT_MEM_PC <= '0';
                OUTPUT_STACK <= "00";
                OUTPUT_WB <= '0';

                ADDRESS_RSRC1_OUT <= (OTHERS => '0');
                ADDRESS_RSRC2_OUT <= (OTHERS => '0');
                ADDRESS_RDST_OUT <= (OTHERS => '0');
                ALU_RESULT_OUT <= (OTHERS => '0');
                OUTPUT_RSRC2 <= (OTHERS => '0');
                OFFSET_IMM_OUT <= (OTHERS => '0');
                PC_DATA_32BIT_OUT <= (OTHERS => '0');
                OUTOUT_PORT_IN <= (OTHERS => '0'); ---check
                STACK_DATA_OUT <= (OTHERS => '0'); ---check

                OUTPUT_INTERRUPT <= "00";
                OUTPUT_RETURN <= '0';
                OUTPUT_CALL <= '0';

                OUTPUT_MEM_READ <= '0';
                OUTPUT_MEM_WRITE <= '0';
                OUTPUT_RTI <= '0';

                flags_out <= (OTHERS => '0');

            ELSE

                OUTPUT_MEM_TO_REG <= INPUT_MEM_TO_REG;
                OUTPUT_PC_TO_STACK <= INPUT_PC_TO_STACK;
                OUTPUT_MEM_WRITE <= INPUT_MEM_WRITE;
                OUTPUT_MEM_READ <= INPUT_MEM_READ;
                OUTPUT_RTI <= INPUT_RTI;

                OUTPUT_MEM_PC <= INPUT_MEM_PC;
                OUTPUT_STACK <= INPUT_STACK;
                OUTPUT_WB <= INPUT_WB;
                OUTPUT_LOAD_IMM <= INPUT_LOAD_IMM;
                OUTPUT_PORT_READ <= INPUT_PORT_READ;
                ADDRESS_RDST_OUT <= ADDRESS_RDST_IN;
                ALU_RESULT_OUT <= ALU_RESULT_IN;
                ADDRESS_RSRC1_OUT <= ADDRESS_RSRC1_IN;
                ADDRESS_RSRC2_OUT <= ADDRESS_RSRC2_IN;

                OUTPUT_RSRC2 <= INPUT_RSRC2;
                OFFSET_IMM_OUT <= OFFSET_IMM_IN;
                PC_DATA_32BIT_OUT <= PC_DATA_32BIT_IN;
                OUTOUT_PORT_IN <= INPUT_PORT_IN;

                OUTPUT_INTERRUPT <= INPUT_INTERRUPT;
                OUTPUT_RETURN <= INPUT_RETURN;
                OUTPUT_CALL <= INPUT_CALL;
                STACK_DATA_OUT <= STACK_DATA_IN;
                EXEP_STACK_POINTER_OUT <= EXEP_STACK_POINTER;

                flags_out <= flags_in;
            END IF;
        END IF;
    END PROCESS;

END ARCH_EXECUTE_MEMORY_BUFFER;