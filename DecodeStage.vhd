LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decode_stage IS
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

        STRUC_HAZARD_IN : IN STD_LOGIC_VECTOR(0 DOWNTO 0); -------------------ADDED

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
        buffer_disable_out_decode : OUT STD_LOGIC;
        STRUC_HAZARD_OUT : OUT STD_LOGIC_VECTOR(0 DOWNTO 0) -------------------ADDED
    );
END decode_stage;

ARCHITECTURE a_decode_stage OF decode_stage IS
    COMPONENT generic_register_rising IS
        GENERIC (
            width : INTEGER := 32
        );
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
        );
    END COMPONENT generic_register_rising;

    COMPONENT control_unit IS
        PORT (
            opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            fired_signals : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
        );
    END COMPONENT control_unit;

    COMPONENT reg_file IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            read_addr_1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_addr_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT reg_file;
    COMPONENT id_ex_buffer IS
        PORT (

            clock : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            buffer_enable : IN STD_LOGIC;
            fired_signals : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
            data_in_Rsrc1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in_Rsrc2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in_rsrc1_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_in_rsrc2_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_in_rdst_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_in_offset_immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in_family_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_in_function_code : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            address_out_of_bound : IN STD_LOGIC;
            empty_stack : IN STD_LOGIC;
            jump : IN STD_LOGIC;
            BUFF2_STRUC_HAZARD_IN : IN STD_LOGIC_VECTOR(0 DOWNTO 0); ---------------ADDED
            in_port_id_ex_buffer_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            int_id_ex_buffer_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_out_alu_src : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_alu_op : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_out_mem_write : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_mem_read : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_mem_to_reg : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_reg_write : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_stack : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_out_port_read : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_port_write : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_ldm : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_pc_to_stack : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_mem_to_pc : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_rti : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_ret : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_call : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            data_out_Rsrc1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out_Rsrc2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out_pc : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out_rsrc1_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_out_rsrc2_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_out_rdst_address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_out_offset_immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out_family_code : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_out_function_code : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            in_port_id_ex_buffer_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            int_id_ex_buffer_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            BUFF2_STRUC_HAZARD_OUT : OUT STD_LOGIC_VECTOR(0 DOWNTO 0) ---------------ADDED
        );
    END COMPONENT id_ex_buffer;
    COMPONENT MUX2x1 IS
        PORT (
            inputA, inputB : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
            sel : IN STD_LOGIC;
            result : OUT STD_LOGIC_VECTOR(17 DOWNTO 0));
    END COMPONENT MUX2x1;
    COMPONENT hazard_detection_unit IS
        PORT (
            id_ex_mem_read : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            id_ex_rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            if_id_rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            if_id_rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            freeze_pc : OUT STD_LOGIC;
            buffer_disable : OUT STD_LOGIC;
            flush : OUT STD_LOGIC

        );
    END COMPONENT hazard_detection_unit;

    SIGNAL cu_fired_signals : STD_LOGIC_VECTOR(17 DOWNTO 0);
    SIGNAL cu_mux_signals : STD_LOGIC_VECTOR(17 DOWNTO 0);
    SIGNAL freeze_pc_signal : STD_LOGIC;
    SIGNAL buffer_disable_signal : STD_LOGIC;
    SIGNAL buffer_enable_signal : STD_LOGIC;
    SIGNAL flush_signal : STD_LOGIC;
    SIGNAL rsrc1_buffer_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rsrc2_buffer_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL opcode_signal : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL id_ex_mem_read_signal : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL id_ex_rdst_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL id_ex_mem_read_logic : STD_LOGIC;

    SIGNAL STRUC_INTERM : STD_LOGIC;
BEGIN
    --id_ex_mem_read_logic<=id_ex_mem_read_signal(0 downto 0);
    data_out_mem_read_decode(0 DOWNTO 0) <= id_ex_mem_read_signal;
    buf_rdst_address_out <= id_ex_rdst_signal;
    buffer_enable_signal <= NOT buffer_disable_signal;
    opcode_signal <= family_code_in & function_code_in;
    freeze_pc_out_decode <= freeze_pc_signal;
    flush_out_decode <= flush_signal;
    buffer_disable_out_decode <= buffer_disable_signal;
    cu : control_unit PORT MAP(
        opcode => opcode_signal,
        fired_signals => cu_fired_signals
    );

    hazard_detection_unit_component : hazard_detection_unit PORT MAP(
        id_ex_mem_read => id_ex_mem_read_signal,
        id_ex_rdst => id_ex_rdst_signal,
        if_id_rsrc1 => rsrc1_address_in,
        if_id_rsrc2 => rsrc2_address_in,
        opcode => opcode_signal,
        freeze_pc => freeze_pc_signal,
        buffer_disable => buffer_disable_signal,
        flush => flush_signal

    );
    register_file : reg_file PORT MAP(
        clk => clock,
        rst => reset,
        write_en => mem_wb_reg_write,
        read_addr_1 => rsrc1_address_in,
        read_addr_2 => rsrc2_address_in,
        write_addr => write_addr_reg_file,
        data_in => data_in_reg_file,
        data_out_1 => rsrc1_buffer_in,
        data_out_2 => rsrc2_buffer_in
    );
    id_ex_component : id_ex_buffer PORT MAP(
        clock => clock,
        rst => flush_signal,
        buffer_enable => buffer_enable_signal,
        fired_signals => cu_fired_signals,
        data_in_Rsrc1 => rsrc1_buffer_in,
        data_in_Rsrc2 => rsrc2_buffer_in,
        data_in_pc => pc_in,
        data_in_rsrc1_address => rsrc1_address_in,
        data_in_rsrc2_address => rsrc2_address_in,
        data_in_rdst_address => rdst_address,
        data_in_offset_immediate => offset_immediate,
        data_in_family_code => family_code_in,
        data_in_function_code => function_code_in,
        address_out_of_bound => address_out_of_bound_in,
        empty_stack => empty_stack_in,
        jump => jump_in,
        BUFF2_STRUC_HAZARD_IN => STRUC_HAZARD_IN,
        in_port_id_ex_buffer_in => in_port_decode,
        int_id_ex_buffer_in => int_decode,
        data_out_alu_src => data_out_alu_src_decode,
        data_out_alu_op => data_out_alu_op_decode,
        --data_out_alu_op=> cu_mux_signals(16 downto 14),
        data_out_mem_write => data_out_mem_write_decode,
        data_out_mem_read => id_ex_mem_read_signal,
        data_out_mem_to_reg => data_out_mem_to_reg_decode,
        data_out_reg_write => data_out_reg_write_decode,
        data_out_stack => data_out_stack_decode,
        data_out_port_read => data_out_port_read_decode,
        data_out_port_write => data_out_port_write_decode,
        data_out_ldm => data_out_ldm_decode,
        data_out_pc_to_stack => data_out_pc_to_stack_decode,
        data_out_mem_to_pc => data_out_mem_to_pc_decode,
        data_out_rti => data_out_rti_decode,
        data_out_ret => data_out_ret_decode,
        data_out_call => data_out_call_decode,
        data_out_Rsrc1 => buf_rsrc1,
        data_out_Rsrc2 => buf_rsrc2,
        data_out_pc => buf_pc_out,
        data_out_rsrc1_address => buf_rsrc1_address_out,
        data_out_rsrc2_address => buf_rsrc2_address_out,
        data_out_rdst_address => id_ex_rdst_signal,
        data_out_offset_immediate => buf_offset_immediate_out,
        data_out_family_code => buf_family_code_out,
        data_out_function_code => buf_function_code_out,
        in_port_id_ex_buffer_out => buf_in_port_out,
        int_id_ex_buffer_out => data_out_int_decode,
        BUFF2_STRUC_HAZARD_OUT => STRUC_HAZARD_OUT
    );
    mux_component : MUX2x1 GENERIC MAP(
        18) PORT MAP(
        inputA => cu_fired_signals,
        inputB => "000000000000000000",
        sel => flush_signal,
        result => cu_mux_signals
    );

END a_decode_stage;
