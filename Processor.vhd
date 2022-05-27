LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Processor IS
        PORT (
                in_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                out_port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                reset : IN STD_LOGIC;
                clk : IN STD_LOGIC;
                int : IN STD_LOGIC
        );

END Processor;

ARCHITECTURE arch_Processor OF Processor IS

        ------------------------------------MEMORY---------------------
        COMPONENT Memory IS
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
        END COMPONENT;
        ------------------------- FETCH STAGE -------------------------
        COMPONENT FetchStage IS PORT (
                clk : IN STD_LOGIC;
                reset : IN STD_LOGIC;

                buff4_sp_exception : IN STD_LOGIC;
                buff4_addr_exception : IN STD_LOGIC;

                is_jump : IN STD_LOGIC;
                jump_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

                mem_to_pc : IN STD_LOGIC; --in case of POP
                mem_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --instruction fetched from memory
                structural_hazard : IN STD_LOGIC; --Signal to freeze the PC in case the memory stage is using the Memory
                disable : IN STD_LOGIC; --Signal to disable the fetch stage

                sp_exception : IN STD_LOGIC;
                addr_exception : IN STD_LOGIC;

                HW_interrupt : IN STD_LOGIC;
                inport_val_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

                --outputs
                fetch_adderss : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                PC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                inport_val_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                SW_interrupt_out : OUT STD_LOGIC_Vector(1 downto 0));

        END COMPONENT;
        ------------------------- DECODE STAGE -------------------------
        COMPONENT decode_stage IS
                PORT (
                        int_decode : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
                        in_port_decode : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        clock : IN STD_LOGIC;
                        reset : IN STD_LOGIC;
                        family_code_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
                        function_code_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        ------Hazard----
                        --    id_ex_mem_read_in: in std_logic;
                        --	id_ex_rdst_in: in std_logic_vector(2 downto 0);
                        pc_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        rsrc1_address_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        rsrc2_address_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        ------reg file-----
                        write_addr_reg_file : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        data_in_reg_file : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --write back value
                        mem_wb_reg_write : IN STD_LOGIC;--enable
                        -------------------
                        offset_immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        rdst_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        jump_in : IN STD_LOGIC;
                        address_out_of_bound_in : IN STD_LOGIC;
                        empty_stack_in : IN STD_LOGIC;
                        ------------------------------
                        buf_family_code_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        buf_function_code_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        buf_int_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        buf_in_port_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        --buf_cu_mux_buffer: out STD_LOGIC_VECTOR(17 DOWNTO 0);
                        --buf_stall_hazard: out std_logic;
                        buf_pc_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        buf_rsrc1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        buf_rsrc2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        buf_rsrc1_address_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        buf_rsrc2_address_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        buf_rdst_address_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        buf_offset_immediate_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        data_out_alu_src_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_alu_op_decode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        data_out_mem_write_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_mem_read_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_mem_to_reg_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_reg_write_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_stack_decode : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        data_out_port_read_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_port_write_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_ldm_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_pc_to_stack_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_mem_to_pc_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_rti_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_ret_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_call_decode : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                        data_out_in_port_decode : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        data_out_int_decode : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        --data_out_Rsrc1: out std_logic_vector(31 downto 0);
                        --  data_out_Rsrc2: out std_logic_vector(31 downto 0);
                        --data_out_pc: out std_logic_vector(31 downto 0)
                        freeze_pc_out_decode : OUT STD_LOGIC;
                        flush_out_decode : OUT STD_LOGIC;
                        buffer_disable_out_decode : OUT STD_LOGIC
                );
        END COMPONENT;
        ------------------------- EXECUTE STAGE -------------------------
        COMPONENT EX_STAGE IS
                PORT (

                        --Inputs:
                        --Control unit Signals
                        --E_M_BUFFER_WB		:IN std_logic;
                        --M_WB_BUFFER_WB  	:IN std_logic;

                        --------------------------------------MUX COMPONENTS
                        --BUFF4 MEM_WB_BUFF
                        --BUFF3 EX_MEM_BUFF
                        ----MUX1
                        RSCR1_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --000

                        MEM_WB_BUFF_MEMORY_VAL : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --001

                        EX_MEM_BUFF_ALU : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --010
                        MEM_WB_BUFF_ALU : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --011

                        EX_MEM_BUFF_IMM : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --100
                        MEM_WB_BUFF_IMM : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --101

                        EX_MEM_PORT_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --110
                        MEM_WB_PORT_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --111

                        ----MUX2
                        --BUFF4 MEM_WB_BUFF
                        --BUFF3 EX_MEM_BUFF
                        RSCR2_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --000

                        ---MUX_INTERM
                        OFFEST_IMM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        ALU_SRC : IN STD_LOGIC;
                        --Forwarding unit
                        --BUFF4 MEM_WB_BUFF
                        --BUFF3 EX_MEM_BUFF
                        --Inputs:
                        --Control unit Signals
                        E_M_BUFFER_WB : IN STD_LOGIC;
                        M_WB_BUFFER_WB : IN STD_LOGIC;
                        E_MEM_BUFFER_PortRead : IN STD_LOGIC;
                        M_WB_BUFFER_PortRead : IN STD_LOGIC;
                        M_WB_BUFFER_MemRead : IN STD_LOGIC;
                        E_M_BUFFER_LDM : IN STD_LOGIC;
                        M_WB_BUFFER_LDM : IN STD_LOGIC;
                        --Addresses for comparing if the source of the new instruction 
                        --is the destination of the curren instruction
                        D_E_BUFFER_SRC1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        D_E_BUFFER_SRC2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        E_MEM_BUFFER_DEST : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        M_WB_BUFFER_DEST : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

                        --- JDU
                        OP_CODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0); --(OPERATIONAL TYPE)
                        --- OUTPUT PORT
                        PORT_WRITE_SIG : IN STD_LOGIC;
                        CLK : IN STD_LOGIC;
                        RESET : IN STD_LOGIC;
                        --- E/M BUFFER
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

                        ---------------------ADDRESSES
                        --INPUT ADRRESSS
                        ADDRESS_RSRC1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        ADDRESS_RSRC2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        ADDRESS_RDST_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        ------------------

                        -------------- INPUT SIGNALS
                        INPUT_MEM_PC : IN STD_LOGIC;
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
                        is_Jump : OUT STD_LOGIC;
                        flags_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
                        OUT_PORT_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                );
        END COMPONENT;

        ------------------------- MEMORY STAGE -------------------------
        COMPONENT memory_stage_project IS
                PORT (
                        clk : IN STD_LOGIC;
                        rst : IN STD_LOGIC;
                        mem_write : IN STD_LOGIC;
                        mem_read : IN STD_LOGIC;
                        pc_signal : IN STD_LOGIC;
                        call : IN STD_LOGIC;
                        ret : IN STD_LOGIC;
                        rti : IN STD_LOGIC;
                        wb_signal_in : IN STD_LOGIC;
                        load_imm_in : IN STD_LOGIC;
                        port_read_in : IN STD_LOGIC;
                        mem_to_reg_in : IN STD_LOGIC;
                        mem_to_pc_in : IN STD_LOGIC;

                        push_pop : IN STD_LOGIC_VECTOR(1 DOWNTO 0);

                        data_from_memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        alu_result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        r_src_2_32_bits : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        imm_or_offset_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

                        flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        r_src_1_3_bits_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        r_src_2_3_bits_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        r_dst_3_bits_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

                        push_pop_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
                        flags_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        sp_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        pc_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

                        r_src_1_3_bits_OUT_buff4 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        r_src_2_3_bits_OUT_buff4 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        r_dst_3_bits_OUT_buff4 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
                        data_from_memory_out_buff4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        alu_result_out_buff4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        pc_out_buff4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        r_src_2_32_bits_out_buff4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        imm_or_offset_out_buff4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

                        address_is_invalid_out : OUT STD_LOGIC;
                        sp_error_out : OUT STD_LOGIC;
                        sp_error_out_buff4 : OUT STD_LOGIC;
                        address_is_invalid_out_buff4 : OUT STD_LOGIC;
                        mem_write_out : OUT STD_LOGIC;
                        mem_read_out : OUT STD_LOGIC;
                        pc_signal_out : OUT STD_LOGIC;
                        call_out : OUT STD_LOGIC;
                        ret_out : OUT STD_LOGIC;
                        rti_out : OUT STD_LOGIC;
                        wb_signal_out_buff4 : OUT STD_LOGIC;
                        load_imm_out_buff4 : OUT STD_LOGIC;
                        port_read_out_buff4 : OUT STD_LOGIC;
                        mem_to_reg_out_buff4 : OUT STD_LOGIC;
                        mem_to_pc_out_buff4 : OUT STD_LOGIC;
                        inPort_read_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                        inPort_read_out_buff4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        mem_read_out_buff4: OUT STD_LOGIC
                );

        END COMPONENT memory_stage_project;
        ------------------------- WRITE BACK STAGE -------------------------
        COMPONENT WB_STAGE IS
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

        END COMPONENT;
        ------------------------------ SIGNALS -----------------------------
        -------------------------Memory Output Signal ----------------------
        SIGNAL MEMORY_DATA_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL Structural_hazard : STD_LOGIC;
        ------SIGNALS Between FETCH AND DECODE--------------------------------------------------
        SIGNAL FD_family_Code : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL FD_func_Code : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL FD_RS1_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL FD_RS2_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL FD_Rdst_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL FD_OFFSET : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL FD_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL FD_INSTRUCTION : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL FD_INPORT : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL FD_SW_intrrupt : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL FS_FETCH_ADDRESS : STD_LOGIC_VECTOR(31 DOWNTO 0);
        Signal FD_SW_INT_OUT : STD_LOGIC_VECTOR(1 DOWNTO 0);
        -------------------------------------SIGNALS OUT OF DECODE STAGE-----------------------------
        SIGNAL buf_family_code_out_signal : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL buf_func_code_out_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL buf_pc_out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL buf_rsrc1_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL buf_rsrc2_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL buf_rsrc1_address_out_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL buf_rsrc2_address_out_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL buf_rdst_address_out_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL buf_offset_immediate_out_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL data_out_alu_src_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_alu_op_decode_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL data_out_mem_write_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_mem_read_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_mem_to_reg_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_reg_write_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_stack_decode_signal : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL data_out_port_read_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_port_write_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_ldm_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_pc_to_stack_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_mem_to_pc_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_rti_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_ret_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL data_out_call_decode_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL freeze_pc_out_decode_signal : STD_LOGIC;
        SIGNAL flush_out_decode_signal : STD_LOGIC;
        SIGNAL buffer_disable_out_decode_signal : STD_LOGIC;
        SIGNAL buffer_int_out_decode_signal : STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL buffer_in_port_decode_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

        ----------------SIGNALS BETWEEN DECODE AND EXECUTE------------------------------
        --data_out_Rsrc1: out std_logic_vector(31 downto 0);
        --data_out_Rsrc2: out std_logic_vector(31 downto 0);
        --data_out_pc: out std_logic_vector(31 downto 0)

        ---SIGNAL freeze_pc_out_decode: std_logic; 
        ---SIGNAL flush_out_decode: std_logic;
        ---SIGNAL buffer_disable_out_decode: std_logic
        SIGNAL data_out_in_port_decode_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL MEM_WB_BUFF_MEMORY_VAL : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL EX_MEM_BUFF_ALU : STD_LOGIC_VECTOR(31 DOWNTO 0); --010
        SIGNAL MEM_WB_BUFF_ALU : STD_LOGIC_VECTOR(31 DOWNTO 0); --011

        SIGNAL EX_MEM_BUFF_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0); --100
        SIGNAL MEM_WB_BUFF_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0); --101

        SIGNAL EX_MEM_PORT_IN : STD_LOGIC_VECTOR(31 DOWNTO 0); --110
        SIGNAL MEM_WB_PORT_IN : STD_LOGIC_VECTOR(31 DOWNTO 0); --111

        SIGNAL E_MEM_BUFFER_DEST : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL M_WB_BUFFER_DEST : STD_LOGIC_VECTOR(2 DOWNTO 0);

        SIGNAL E_M_BUFFER_WB : STD_LOGIC;
        SIGNAL M_WB_BUFFER_WB : STD_LOGIC;
        SIGNAL E_MEM_BUFFER_PortRead : STD_LOGIC;
        SIGNAL M_WB_BUFFER_PortRead : STD_LOGIC;
        SIGNAL M_WB_BUFFER_MemRead : STD_LOGIC;
        SIGNAL E_M_BUFFER_LDM : STD_LOGIC;
        SIGNAL M_WB_BUFFER_LDM : STD_LOGIC;

        SIGNAL OP_CODE_DATA : STD_LOGIC_VECTOR(4 DOWNTO 0);

        SIGNAL STACK_DATA_IN_SIGNAL : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0'); --CHECK
        SIGNAL INVALID_ADD_BIT_SIGNAL : STD_LOGIC := '0'; --CHECK
        SIGNAL INPUT_MEM_PC_SIGNAL : STD_LOGIC := '0'; ---check
        SIGNAL EXEP_STACK_POINTER_SIGNAL : STD_LOGIC := '0'; ---check
        SIGNAL INPUT_WB : STD_LOGIC := '0'; ---check
        --------------------STACK/INTERRUPT
        SIGNAL OUTPUT_STACK : STD_LOGIC_VECTOR(1 DOWNTO 0); --STACK OUT
        SIGNAL OUTPUT_INTERRUPT : STD_LOGIC_VECTOR(1 DOWNTO 0); --OUT INT
        SIGNAL STACK_DATA_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        -------------------

        ---------------------MEM READ/WRITE
        SIGNAL OUTPUT_MEM_READ : STD_LOGIC;
        SIGNAL OUTPUT_MEM_WRITE : STD_LOGIC;
        --------------------

        ------------------PROGRAM COUNTER
        SIGNAL PC_DATA_32BIT_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        ------------------

        --------------------ALU RESULT
        SIGNAL ALU_RESULT_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        -------------------

        --------------------OFFSET/IMMEDIATE
        SIGNAL OFFSET_IMM_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        ---------------------

        ---------------------ADDRESSES---------------------------
        --INPUT ADRRESSS
        SIGNAL ADDRESS_RSRC1_OUT : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL ADDRESS_RSRC2_OUT : STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL ADDRESS_RDST_OUT : STD_LOGIC_VECTOR(2 DOWNTO 0);
        --------------------------------

        ----------------------RSRC2
        SIGNAL OUTPUT_RSRC2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
        ----------------------

        ---------------PORT INPUT:
        SIGNAL OUTOUT_PORT_IN : STD_LOGIC_VECTOR (31 DOWNTO 0);
        -----------------

        -------------- OUTPUT SIGNALS:
        SIGNAL OUTPUT_MEM_PC : STD_LOGIC;
        --CLK:  OUT STD_LOGIC;
        --RESET: OUT STD_LOGIC; 
        SIGNAL EXEP_STACK_POINTER_OUT : STD_LOGIC;
        SIGNAL OUTPUT_PC_TO_STACK : STD_LOGIC;
        SIGNAL OUTPUT_RTI : STD_LOGIC;
        SIGNAL OUTPUT_WB : STD_LOGIC;
        SIGNAL OUTPUT_LOAD_IMM : STD_LOGIC;
        SIGNAL OUTPUT_PORT_READ : STD_LOGIC; --PORT READ
        SIGNAL OUTPUT_MEM_TO_REG : STD_LOGIC;
        SIGNAL OUTPUT_RETURN : STD_LOGIC;
        SIGNAL OUTPUT_CALL : STD_LOGIC;

        ----------------------------is_Jump----------------------------
        SIGNAL is_Jump_out : STD_LOGIC;

        ----------------------------Flags-------------------------------
        SIGNAL EXE_FLAG_OUT : STD_LOGIC_VECTOR(3 DOWNTO 0);
        -----------------Signals From Memory Stage----------------------
        SIGNAL PUSH_POP_MEM_OUT : STD_LOGIC_VECTOR (1 DOWNTO 0);
        SIGNAL FLAGS_MEM_OUT : STD_LOGIC_VECTOR (2 DOWNTO 0);
        SIGNAL SP_MEM_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL ADDRESS_MEM_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL DATA_MEM_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL PC_MEM_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);

        SIGNAL R_SRC_1_3_BITS_BUFF4_OUT : STD_LOGIC_VECTOR (2 DOWNTO 0);
        SIGNAL R_SRC_2_3_BITS_BUFF4_OUT : STD_LOGIC_VECTOR (2 DOWNTO 0);
        SIGNAL R_DST_3_BITS_BUFF4_OUT : STD_LOGIC_VECTOR (2 DOWNTO 0);

        SIGNAL DATA_FROM_MEMORY_BUFF4_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL ALU_RESULT_BUFF4_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL PC_BUFF4_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL R_SRC_2_32_BITS_BUFF4_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL IMM_OR_OFFSET_BUFF4_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);

        SIGNAL ADDRESS_IS_INVALID_MEM_OUT : STD_LOGIC;
        SIGNAL SP_ERROR_MEM_OUT : STD_LOGIC;

        SIGNAL SP_ERROR_BUFF4_OUT : STD_LOGIC;
        SIGNAL ADDRESS_IS_INVALID_BUFF4_OUT : STD_LOGIC;

        SIGNAL MEM_WRITE_MEM_OUT : STD_LOGIC;
        SIGNAL MEM_READ_MEM_OUT : STD_LOGIC;
        SIGNAL PC_SIGNAL_MEM_OUT : STD_LOGIC;
        SIGNAL CALL_MEM_OUT : STD_LOGIC;
        SIGNAL RET_MEM_OUT : STD_LOGIC;
        SIGNAL RTI_MEM_OUT : STD_LOGIC;

        SIGNAL WB_SIGNAL_BUFF4_OUT : STD_LOGIC;
        SIGNAL LOAD_IMM_BUFF4_OUT : STD_LOGIC;
        SIGNAL PORT_READ_BUFF4_OUT : STD_LOGIC;
        SIGNAL MEM_TO_REG_BUFF4_OUT : STD_LOGIC;
        SIGNAL MEM_TO_PC_BUFF4_OUT : STD_LOGIC;
        SIGNAL MEM_READ_SIGNAL_BUFF4_OUT : STD_LOGIC;
        SIGNAL INPORT_READ_BUFF4_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        -----------------------WB Signals-----------------------
        SIGNAL WB_ERROR_PC_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL WB_VALUE_OUT : STD_LOGIC_VECTOR (31 DOWNTO 0);
        SIGNAL WB_RDEST_OUT : STD_LOGIC_VECTOR (2 DOWNTO 0);

        SIGNAL DUMMY_SIGNAL2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
        Memory_component : Memory PORT MAP(
                clk => clk,
                memWrite => MEM_WRITE_MEM_OUT,
                memRead => MEM_READ_MEM_OUT,
                data_address => ADDRESS_MEM_OUT,
                datain => DATA_MEM_OUT,
                Fetch_address => FS_FETCH_ADDRESS,
                Stack_pointer => STACK_DATA_OUT,
                PC => PC_MEM_OUT,
                flags => FLAGS_MEM_OUT,
                PC_to_Stack => PC_SIGNAL_MEM_OUT,
                ret => RET_MEM_OUT,
                rti => RTI_MEM_OUT,
                call => CALL_MEM_OUT,
                stack => PUSH_POP_MEM_OUT,
                structural_hazard => Structural_hazard,
                dataout => MEMORY_DATA_OUT
        );
        fetching_Satge_Component : FetchStage PORT MAP(
                clk => clk,
                reset => reset,

                buff4_sp_exception => SP_ERROR_BUFF4_OUT,
                buff4_addr_exception => ADDRESS_IS_INVALID_BUFF4_OUT,

                is_jump => is_Jump_out, -- is_jump signal from execute stage
                jump_address => OFFSET_IMM_OUT, --jump address from execute stage

                mem_to_pc => MEM_TO_PC_BUFF4_OUT,
                mem_out => MEMORY_DATA_OUT,
                structural_hazard => Structural_hazard,
                disable => freeze_pc_out_decode_signal,

                sp_exception => SP_ERROR_MEM_OUT,
                addr_exception => ADDRESS_IS_INVALID_MEM_OUT,

                HW_interrupt => int,

                inport_val_in => in_port,

                --Outputs
                fetch_adderss => FS_FETCH_ADDRESS,
                PC_OUT => FD_PC,
                instruction => FD_INSTRUCTION,
                inport_val_out => FD_INPORT,
                SW_interrupt_out=>FD_SW_INT_OUT
        );
        --Mapping the inputs to the decode stage
        FD_family_Code <= FD_INSTRUCTION(10 DOWNTO 9);
        FD_func_Code <= FD_INSTRUCTION(13 DOWNTO 11);
        FD_RS1_address <= FD_INSTRUCTION(2 DOWNTO 0);
        FD_RS2_address <= FD_INSTRUCTION(5 DOWNTO 3);
        FD_Rdst_address <= FD_INSTRUCTION(8 DOWNTO 6);
        FD_OFFSET <= "0000000000000000" & FD_INSTRUCTION(31 DOWNTO 16);

        DecodingStage_Component : decode_stage PORT MAP(
                int_decode => FD_SW_INT_OUT, ---to be added from fetch stage
                in_port_decode => FD_INPORT,
                clock => clk,
                reset => reset,
                family_code_in => FD_family_Code,
                function_code_in => FD_func_Code,
                ------Hazard----
                --    id_ex_mem_read_in: in std_logic;
                --	id_ex_rdst_in: in std_logic_vector(2 downto 0);
                pc_in => FD_PC,
                rsrc1_address_in => FD_RS1_address,
                rsrc2_address_in => FD_RS2_address,
                ------reg file-----
                write_addr_reg_file => R_DST_3_BITS_BUFF4_OUT, --write back address --to be added from memory stage 
                data_in_reg_file =>WB_VALUE_OUT, --write back value --to be added from memory stage 
                mem_wb_reg_write => WB_SIGNAL_BUFF4_OUT, --enable --to be added from memory stage  ------------------------------------------HUSSEIN
                -------------------
                offset_immediate => FD_OFFSET,
                rdst_address => FD_Rdst_address,
                jump_in => is_Jump_out, --to be added from execute stage
                address_out_of_bound_in =>ADDRESS_IS_INVALID_BUFF4_OUT, --to be added from memory stage;
                empty_stack_in =>SP_ERROR_BUFF4_OUT, --to be added from memory stage;

                --outputs

                buf_family_code_out => buf_family_code_out_signal,
                buf_function_code_out => buf_func_code_out_signal,
                buf_int_out => buffer_int_out_decode_signal,
                buf_in_port_out => buffer_in_port_decode_signal,
                buf_pc_out => buf_pc_out_signal,
                buf_rsrc1 => buf_rsrc1_signal,
                buf_rsrc2 => buf_rsrc2_signal,
                buf_rsrc1_address_out => buf_rsrc1_address_out_signal,
                buf_rsrc2_address_out => buf_rsrc2_address_out_signal,
                buf_rdst_address_out => buf_rdst_address_out_signal,
                buf_offset_immediate_out => buf_offset_immediate_out_signal,
                data_out_alu_src_decode => data_out_alu_src_decode_signal,
                data_out_alu_op_decode => data_out_alu_op_decode_signal,  --check not taken
                data_out_mem_write_decode => data_out_mem_write_decode_signal,
                data_out_mem_read_decode => data_out_mem_read_decode_signal,
                data_out_mem_to_reg_decode => data_out_mem_to_reg_decode_signal,
                data_out_reg_write_decode => data_out_reg_write_decode_signal,
                data_out_stack_decode => data_out_stack_decode_signal,
                data_out_port_read_decode => data_out_port_read_decode_signal,
                data_out_port_write_decode => data_out_port_write_decode_signal,
                data_out_ldm_decode => data_out_ldm_decode_signal,
                data_out_pc_to_stack_decode => data_out_pc_to_stack_decode_signal,
                data_out_mem_to_pc_decode => data_out_mem_to_pc_decode_signal,
                data_out_in_port_decode => DUMMY_SIGNAL2,
                data_out_rti_decode => data_out_rti_decode_signal,
                data_out_ret_decode => data_out_ret_decode_signal,
                data_out_call_decode => data_out_call_decode_signal,
                freeze_pc_out_decode => freeze_pc_out_decode_signal,  --not taken
                flush_out_decode => flush_out_decode_signal,  --not taken
                buffer_disable_out_decode => buffer_disable_out_decode_signal  --not taken
        );

        ----------------------------------EXECUTION-----------------------------------------------
        OP_CODE_DATA <= buf_family_code_out_signal & buf_func_code_out_signal;

        EXECUTE_STAGE : EX_STAGE PORT MAP(
                RSCR1_DATA => buf_rsrc1_signal,  --USED FORM DECODE
                MEM_WB_BUFF_MEMORY_VAL => DATA_FROM_MEMORY_BUFF4_OUT,  -- --USED FROM MEM BUFF --------------------------
                EX_MEM_BUFF_ALU => ALU_RESULT_OUT, --USED  --------------------------------------
                MEM_WB_BUFF_ALU => ALU_RESULT_BUFF4_OUT, --USED FROM MEM BUFF
                EX_MEM_BUFF_IMM => OFFSET_IMM_OUT, --USED -------------------------------------------------
                MEM_WB_BUFF_IMM => IMM_OR_OFFSET_BUFF4_OUT , --USED FROM MEM BUFF
                EX_MEM_PORT_IN => OUTOUT_PORT_IN,  --USED
                MEM_WB_PORT_IN => INPORT_READ_BUFF4_OUT ,  --USED
                RSCR2_DATA => buf_rsrc2_signal, --USED FROM DECODE 
                OFFEST_IMM => buf_offset_immediate_out_signal,  --USED FROM DECODE
                ALU_SRC => data_out_alu_src_decode_signal(0), --USED FROM DECODE
                E_M_BUFFER_WB => OUTPUT_WB,  --USED
                M_WB_BUFFER_WB => WB_SIGNAL_BUFF4_OUT,  --USED
                E_MEM_BUFFER_PortRead => OUTPUT_PORT_READ,  --USED
                M_WB_BUFFER_PortRead => PORT_READ_BUFF4_OUT,  --USED
                M_WB_BUFFER_MemRead => MEM_READ_SIGNAL_BUFF4_OUT, --NOT USED -------------------------------------NOT DONE------------MISSING
                E_M_BUFFER_LDM => OUTPUT_LOAD_IMM, --USED
                M_WB_BUFFER_LDM => LOAD_IMM_BUFF4_OUT , --USED 
                D_E_BUFFER_SRC1 => buf_rsrc1_address_out_signal, --USED FROM DECODE
                D_E_BUFFER_SRC2 => buf_rsrc2_address_out_signal, --USED FROM DECODE
                E_MEM_BUFFER_DEST => ADDRESS_RDST_OUT, --USED
                M_WB_BUFFER_DEST => R_DST_3_BITS_BUFF4_OUT , --USED
                OP_CODE => OP_CODE_DATA,  --USED FROM DECODE CONCATINATED
                PORT_WRITE_SIG => data_out_port_write_decode_signal(0),  --USED FROM DECODE
                CLK => CLK, --GENERAL
                RESET => RESET, --GENERAL
                INPUT_STACK => data_out_stack_decode_signal, --USED FROM DECODE
                INPUT_INTERRUPT => buffer_int_out_decode_signal, --USED FROM DECODE ---8ALTA
                STACK_DATA_IN => STACK_DATA_IN_SIGNAL,  ------------------------------------------NOT USED
                INPUT_MEM_READ => data_out_mem_read_decode_signal(0),  --USED FROM DECODE
                INPUT_MEM_WRITE => data_out_mem_write_decode_signal(0),  --USED FROM DECODE
                PC_DATA_32BIT_IN => buf_pc_out_signal, --USED FROM DECODE
                ADDRESS_RSRC1_IN => buf_rsrc1_address_out_signal,  --check, --USED FROM DECODE
                ADDRESS_RSRC2_IN => buf_rsrc2_address_out_signal,  --check, --USED FROM DECODE
                ADDRESS_RDST_IN => buf_rdst_address_out_signal, --USED FROM DECODE 
                INPUT_MEM_PC => data_out_mem_to_pc_decode_signal(0), ---check,USED
                EXEP_STACK_POINTER => EXEP_STACK_POINTER_SIGNAL, ---check, --NOT USED
                INVALID_ADD_BIT => INVALID_ADD_BIT_SIGNAL, ---check, ----------------------------------------NOT USED
                INPUT_PC_TO_STACK => data_out_pc_to_stack_decode_signal(0), --USED FROM DECODE
                INPUT_RTI => data_out_rti_decode_signal(0), --USED FROM DECODE
                INPUT_WB => data_out_reg_write_decode_signal(0), --USED(Updated)
                INPUT_LOAD_IMM => data_out_ldm_decode_signal(0), --USED FROM DECODE
                INPUT_PORT_READ => data_out_port_read_decode_signal(0), --USED FROM DECODE
                INPUT_MEM_TO_REG => data_out_mem_to_reg_decode_signal(0), --USED FROM DECODE
                INPUT_RETURN => data_out_ret_decode_signal(0), --USED FROM DECODE
                INPUT_CALL => data_out_call_decode_signal(0), --USED FROM DECODE
                INPUT_PORT_IN => buffer_in_port_decode_signal, --USED FROM DECODE 
                ----------------------------------------------------------------- outputs --------------------------------------------------
                OUTPUT_STACK => OUTPUT_STACK, --STACK OUT  --USED BY MEMORY
                OUTPUT_INTERRUPT => OUTPUT_INTERRUPT, --OUT INT -----------------------------------------------NOT USED 
                STACK_DATA_OUT => STACK_DATA_OUT, --USED BY MEMORY
                OUTPUT_MEM_READ => OUTPUT_MEM_READ, --USED BY MEMORY
                OUTPUT_MEM_WRITE => OUTPUT_MEM_WRITE, --USED BY MEMORY
                PC_DATA_32BIT_OUT => PC_DATA_32BIT_OUT, --USED BY MEMORY
                ALU_RESULT_OUT => ALU_RESULT_OUT,  --USED BY MEMORY
                OFFSET_IMM_OUT => OFFSET_IMM_OUT,  --USED BY MEMORY  AND FETCH
                ADDRESS_RSRC1_OUT => ADDRESS_RSRC1_OUT, --USED BY MEMORY
                ADDRESS_RSRC2_OUT => ADDRESS_RSRC2_OUT, --USED BY MEMORY
                ADDRESS_RDST_OUT => ADDRESS_RDST_OUT, --USED BY MEMORY
                OUTPUT_RSRC2 => OUTPUT_RSRC2,  --USED BY MEMORY
                OUTOUT_PORT_IN => OUTOUT_PORT_IN, --USED BY MEMORY
                OUTPUT_MEM_PC => OUTPUT_MEM_PC, --USED BY MEMORY
                EXEP_STACK_POINTER_OUT => EXEP_STACK_POINTER_OUT, --NOT USED
                OUTPUT_PC_TO_STACK => OUTPUT_PC_TO_STACK, --USED BY MEMORY
                OUTPUT_RTI => OUTPUT_RTI, --USED BY MEMORY
                OUTPUT_WB => OUTPUT_WB, --USED BY MEMORY
                OUTPUT_LOAD_IMM => OUTPUT_LOAD_IMM, --USED BY MEMORY
                OUTPUT_PORT_READ => OUTPUT_PORT_READ, --USED BY MEMORY
                OUTPUT_MEM_TO_REG => OUTPUT_MEM_TO_REG, --USED BY MEMORY
                OUTPUT_RETURN => OUTPUT_RETURN, --USED BY MEMORY
                OUTPUT_CALL => OUTPUT_CALL, --USED BY MEMORY
                is_Jump => is_Jump_out, --USED BY FETCH AND DECODE
                flags_out => EXE_FLAG_OUT, --USED BY MEMORY
                OUT_PORT_OUT => out_port  --------------------------------------------------------HUSSEIN
                -----------------
        );

        ------------------------------------Memory Stage-------------------------------------------
        MEMORY_STAGE : memory_stage_project PORT MAP(
                clk => clk,
                rst => reset,
                mem_write => OUTPUT_MEM_WRITE,
                mem_read => OUTPUT_MEM_READ,
                pc_signal => OUTPUT_PC_TO_STACK,
                call => OUTPUT_CALL,
                ret => OUTPUT_RETURN,
                rti => OUTPUT_RTI,
                wb_signal_in => OUTPUT_WB,
                load_imm_in => OUTPUT_LOAD_IMM,
                port_read_in => OUTPUT_PORT_READ,
                mem_to_reg_in => OUTPUT_MEM_TO_REG,
                mem_to_pc_in => OUTPUT_MEM_PC,

                push_pop => OUTPUT_STACK,

                data_from_memory => MEMORY_DATA_OUT,
                alu_result => ALU_RESULT_OUT,
                sp => STACK_DATA_OUT,
                pc => PC_DATA_32BIT_OUT,
                r_src_2_32_bits => OUTPUT_RSRC2,
                imm_or_offset_IN => OFFSET_IMM_OUT,
                flags => EXE_FLAG_OUT(2 DOWNTO 0),
                r_src_1_3_bits_IN => ADDRESS_RSRC1_OUT,
                r_src_2_3_bits_IN => ADDRESS_RSRC2_OUT,
                r_dst_3_bits_IN => ADDRESS_RDST_OUT,

                push_pop_out => PUSH_POP_MEM_OUT,
                flags_out => FLAGS_MEM_OUT,
                sp_out => SP_MEM_OUT,
                address => ADDRESS_MEM_OUT,
                data => DATA_MEM_OUT,
                pc_out => PC_MEM_OUT,

                r_src_1_3_bits_OUT_buff4 => R_SRC_1_3_BITS_BUFF4_OUT,
                r_src_2_3_bits_OUT_buff4 => R_SRC_2_3_BITS_BUFF4_OUT,
                r_dst_3_bits_OUT_buff4 => R_DST_3_BITS_BUFF4_OUT,
                data_from_memory_out_buff4 => DATA_FROM_MEMORY_BUFF4_OUT,
                alu_result_out_buff4 => ALU_RESULT_BUFF4_OUT,
                pc_out_buff4 => PC_BUFF4_OUT,
                r_src_2_32_bits_out_buff4 => R_SRC_2_32_BITS_BUFF4_OUT,
                imm_or_offset_out_buff4 => IMM_OR_OFFSET_BUFF4_OUT,

                address_is_invalid_out => ADDRESS_IS_INVALID_MEM_OUT,
                sp_error_out => SP_ERROR_MEM_OUT,

                sp_error_out_buff4 => SP_ERROR_BUFF4_OUT,
                address_is_invalid_out_buff4 => ADDRESS_IS_INVALID_BUFF4_OUT,

                mem_write_out => MEM_WRITE_MEM_OUT,
                mem_read_out => MEM_READ_MEM_OUT,
                pc_signal_out => PC_SIGNAL_MEM_OUT,
                call_out => CALL_MEM_OUT,
                ret_out => RET_MEM_OUT,
                rti_out => RTI_MEM_OUT,
                wb_signal_out_buff4 => WB_SIGNAL_BUFF4_OUT,
                load_imm_out_buff4 => LOAD_IMM_BUFF4_OUT,
                port_read_out_buff4 => PORT_READ_BUFF4_OUT,
                mem_to_reg_out_buff4 => MEM_TO_REG_BUFF4_OUT,
                mem_to_pc_out_buff4 => MEM_TO_PC_BUFF4_OUT,
                inPort_read_in => OUTOUT_PORT_IN,
                inPort_read_out_buff4 => INPORT_READ_BUFF4_OUT,
                mem_read_out_buff4 => MEM_READ_SIGNAL_BUFF4_OUT
        );

        ------------------------------------Write Back Stage-------------------------------------------
        WRITE_BACK_STAGE : WB_STAGE PORT MAP(
                clk => clk,
                rst => reset,

                PORT_READ => PORT_READ_BUFF4_OUT,
                LOAD_IMM => LOAD_IMM_BUFF4_OUT,
                MEM_TO_REG => MEM_TO_REG_BUFF4_OUT,

                ADDRESS_IS_INVALID => ADDRESS_IS_INVALID_BUFF4_OUT,
                SP_ERROR => SP_ERROR_BUFF4_OUT,

                MEMORY_DATA => DATA_FROM_MEMORY_BUFF4_OUT,
                ALU_RESULT => ALU_RESULT_BUFF4_OUT,
                IMM => IMM_OR_OFFSET_BUFF4_OUT,
                IN_VECTOR => INPORT_READ_BUFF4_OUT,

                PC => PC_BUFF4_OUT,

                ERROR_PC => WB_ERROR_PC_OUT,
                WRITE_BACK_VAL_OUT => WB_VALUE_OUT, -- not used
                R_DST_OUT => WB_RDEST_OUT --not used
        );

END arch_Processor;
