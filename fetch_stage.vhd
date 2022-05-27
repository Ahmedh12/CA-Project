LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FetchStage IS PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;

    buff4_sp_exception : IN STD_LOGIC;
    buff4_addr_exception : IN STD_LOGIC;

    is_jump : IN STD_LOGIC;
    jump_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    mem_to_pc : IN STD_LOGIC; --in case of POP
    mem_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --instruction fetched from memory
    structural_hazard : IN STD_LOGIC;
    disable : IN STD_LOGIC;

    sp_exception : IN STD_LOGIC;
    addr_exception : IN STD_LOGIC;

    HW_interrupt : IN STD_LOGIC;

    inport_val_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

    --outputs
    fetch_adderss : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    PC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    inport_val_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    SW_interrupt_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));

END FetchStage;

ARCHITECTURE rtl OF FetchStage IS

    ------------------------------------------------------------------------COMPONENT DECLERATION------------------------------------------------------------------------------
    COMPONENT FetchControl IS PORT (
        family : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        func : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        reset : IN STD_LOGIC; --HW reset Signal
        buff1_reset : IN STD_LOGIC; --Reset Signal for Buffer 1
        disable : IN STD_LOGIC; --disable Signal
        structural_hazard : IN STD_LOGIC; --Structural Hazard Signal from memory
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
    END COMPONENT;
    COMPONENT FD_Buffer IS PORT (
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
    END COMPONENT;
    COMPONENT PC IS
        PORT (
            address_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            clk : IN STD_LOGIC;
            address_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    --------------------------------------------------------------------------END COMPONENTS DECLERATION------------------------------------------------------------------

    ----------------------------------------------------------------------------SIGNALS DECLERATION----------------------------------------------------------------------

    SIGNAL buff1_reset : STD_LOGIC;
    SIGNAL buff1_structural_hazard : STD_LOGIC;
    SIGNAL buff1_HW_interrupt : STD_LOGIC;
    SIGNAL buff1_SW_interrupt : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SW_interrupt : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL FC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_reg_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Instruction_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MuxWithNOPInstruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL state : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    --------------------------------------------------------------------------END SIGNALS DECLERATION----------------------------------------------------------------------------
BEGIN


    SW_interrupt  <= "01" WHEN (mem_out(13 DOWNTO 9) = "11011" AND mem_out(2 DOWNTO 0) = "000") -- int 0 instruction
    ELSE "10" WHEN (mem_out(13 DOWNTO 9) = "11011" AND mem_out(2 DOWNTO 0) = "010")             --int 1 instruction
    ELSE "00"; --NO interrupt

    SW_interrupt_out <= SW_interrupt;

    program_counter : PC PORT MAP(
        address_in => FC_out,
        clk => clk,
        address_out => PC_reg_out);

    fetch_Decode_Buffer : FD_Buffer PORT MAP(
        clk => clk,
        enable => '1',
        flush => '0',
        Instruction_in => MuxWithNOPInstruction,
        PC_in => PC_reg_out,
        inPortVal_in => inport_val_in,
        reset_in => reset,
        SW_int_in => SW_interrupt,
        HW_int_in => HW_interrupt,
        structural_hazard_in => structural_hazard,
        Instruction_out => instruction,
        PC_out => PC_OUT,
        inPortVal_out => inport_val_out,
        reset_out => buff1_reset,
        SW_int_out => buff1_SW_interrupt,
        HW_int_out => buff1_HW_interrupt,
        structural_hazard_out => buff1_structural_hazard);

    fetch_Control : FetchControl PORT MAP(
        family => mem_out(10 DOWNTO 9),
        func => mem_out(13 DOWNTO 11),
        reset => reset,
        buff1_reset => buff1_reset,
        disable => disable,
        structural_hazard => structural_hazard,
        sp_Exception => sp_exception,
        addr_Exception => addr_exception,
        buff4_sp_Exception => buff4_sp_exception,
        buff4_addr_Exception => buff4_addr_exception,
        HW_interrupt => HW_interrupt,
        SW_interrupt => SW_interrupt,
        buff1_HW_interrupt => buff1_HW_interrupt,
        buff1_SW_interrupt => buff1_SW_interrupt,
        mem_out => mem_out,
        is_jump => is_jump,
        jump_address => jump_address,
        mem_to_pc => mem_to_pc,
        PC => PC_reg_out,
        FC_out => FC_out);

        fetch_adderss <= PC_reg_out;

    MuxWithNOPInstruction <= "00000000000000000000110000000000" WHEN (
        reset = '1' OR
        SW_interrupt = "01" OR
        SW_interrupt = "10" OR
        HW_interrupt = '1' OR
        structural_hazard = '1' OR
        sp_exception = '1' OR
        addr_exception = '1' OR
        state /= "000") ELSE
        mem_out;
    
        
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF mem_out(13 DOWNTO 9) = "10111" OR mem_out(13 DOWNTO 9) = "11111" THEN
                state <= "100";

            ELSIF state /= "000" THEN
                state <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(state)) - 1, 3));
            END IF;
        END IF;

        IF falling_edge(clk) THEN
            IF is_jump = '1' THEN
                state <= "001";
            END IF;

            IF disable = '1' THEN
                state <= "001";
            END IF;
        END IF;
    END PROCESS;

END rtl;