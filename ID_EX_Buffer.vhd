LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY id_ex_buffer IS
    PORT (
        FLUSH_ID_EX: IN   std_logic;  
        clock: in std_logic;
        rst: in std_logic;
	buffer_enable: in std_logic;
        fired_signals: in std_logic_vector(17 downto 0);
	data_in_Rsrc1: in std_logic_vector(31 downto 0);
        data_in_Rsrc2: in std_logic_vector(31 downto 0);
        data_in_pc: in std_logic_vector(31 downto 0);
        data_in_rsrc1_address: in std_logic_vector(2 downto 0);
	data_in_rsrc2_address: in std_logic_vector(2 downto 0);
        data_in_rdst_address: in std_logic_vector(2 downto 0);
	data_in_offset_immediate: in std_logic_vector(31 downto 0);
	data_in_family_code: in std_logic_vector(1 downto 0);
        data_in_function_code: in std_logic_vector(2 downto 0);
	address_out_of_bound: in std_logic;
	empty_stack: in std_logic;
	jump: in std_logic; 
	BUFF2_STRUC_HAZARD_IN: IN std_logic_vector(0 downto 0); ---------------ADDED
        in_port_id_ex_buffer_in: in std_logic_vector(31 downto 0);
	int_id_ex_buffer_in:in std_logic_vector(1 downto 0);
        data_out_alu_src: out std_logic_vector(0 downto 0);
        data_out_alu_op: out std_logic_vector(2 downto 0);
        data_out_mem_write: out std_logic_vector(0 downto 0);
        data_out_mem_read: out std_logic_vector(0 downto 0);
        data_out_mem_to_reg: out std_logic_vector(0 downto 0);
        data_out_reg_write: out std_logic_vector(0 downto 0);
        data_out_stack: out std_logic_vector(1 downto 0);
        data_out_port_read: out std_logic_vector(0 downto 0);
        data_out_port_write: out std_logic_vector(0 downto 0);
        data_out_ldm: out std_logic_vector(0 downto 0);
        data_out_pc_to_stack: out std_logic_vector(0 downto 0);
        data_out_mem_to_pc: out std_logic_vector(0 downto 0);
        data_out_rti: out std_logic_vector(0 downto 0);
        data_out_ret: out std_logic_vector(0 downto 0);
        data_out_call: out std_logic_vector(0 downto 0);
	data_out_Rsrc1: out std_logic_vector(31 downto 0);
        data_out_Rsrc2: out std_logic_vector(31 downto 0);
	data_out_pc: out std_logic_vector(31 downto 0);
        data_out_rsrc1_address: out std_logic_vector(2 downto 0);
	data_out_rsrc2_address: out std_logic_vector(2 downto 0);
        data_out_rdst_address: out std_logic_vector(2 downto 0);
	data_out_offset_immediate: out std_logic_vector(31 downto 0);
	data_out_family_code: out std_logic_vector(1 downto 0);
	data_out_function_code: out std_logic_vector(2 downto 0);
	in_port_id_ex_buffer_out: out std_logic_vector(31 downto 0);
	int_id_ex_buffer_out:out std_logic_vector(1 downto 0);
	BUFF2_STRUC_HAZARD_OUT: OUT std_logic_vector(0 downto 0) ---------------ADDED
    );
END id_ex_buffer;

ARCHITECTURE a_id_ex_buffer OF id_ex_buffer IS
    COMPONENT generic_register_rising IS
        GENERIC (
            width : INTEGER := 32
        );
        PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        write_en : IN STD_LOGIC;
        flush_in_reg:  IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
        );
    END COMPONENT generic_register_rising;
   signal reset: std_logic;
   BEGIN

STRUC_HAZARD_id_ex: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
        flush_in_reg=> FLUSH_ID_EX,
        data_in => BUFF2_STRUC_HAZARD_IN,
        data_out=> BUFF2_STRUC_HAZARD_OUT
);


reset<= rst or jump or address_out_of_bound or empty_stack;
int_id_ex_buffer: generic_register_rising generic map(2) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
        flush_in_reg=> FLUSH_ID_EX,
        data_in => int_id_ex_buffer_in,
        data_out=> int_id_ex_buffer_out
);
in_port_id_ex: generic_register_rising generic map(32) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => in_port_id_ex_buffer_in,
        data_out=> in_port_id_ex_buffer_out
);
family_code: generic_register_rising generic map(2) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_family_code,
        data_out=> data_out_family_code
);
function_code: generic_register_rising generic map(3) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_function_code,
        data_out=> data_out_function_code
);
offset_immediate: generic_register_rising generic map(32) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_offset_immediate,
        data_out=> data_out_offset_immediate
);
pc: generic_register_rising generic map(32) port map (
        clk => clock,
        rst => reset,
        write_en =>buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_pc,
        data_out=> data_out_pc
);
Rsrc1_address: generic_register_rising generic map(3) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_rsrc1_address,
        data_out=> data_out_rsrc1_address
);
Rsrc2_address: generic_register_rising generic map(3) port map (
        clk => clock,
        rst => reset,
        write_en =>buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_rsrc2_address,
        data_out=> data_out_rsrc2_address
);
Rdst_address: generic_register_rising generic map(3) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_rdst_address,
        data_out=> data_out_rdst_address
);
Rsrc1: generic_register_rising generic map(32) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_Rsrc1,
        data_out=> data_out_Rsrc1
);
Rsrc2: generic_register_rising generic map(32) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => data_in_Rsrc2,
        data_out=> data_out_Rsrc2
);
	
alu_src: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(17 downto 17),
        data_out=> data_out_alu_src(0 downto 0)
);
alu_op: generic_register_rising generic map(3) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(16 downto 14),
        data_out=> data_out_alu_op(2 downto 0)
);
mem_write: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(13 downto 13),
        data_out=> data_out_mem_write(0 downto 0)
);
mem_read: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(12 downto 12),
        data_out(0 downto 0)=> data_out_mem_read
);
mem_to_reg: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(11 downto 11),
        data_out(0 downto 0)=> data_out_mem_to_reg
);
reg_write: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(10 downto 10),
        data_out(0 downto 0)=> data_out_reg_write
);
stack: generic_register_rising generic map(2) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(9 downto 8),
        data_out(1 downto 0)=> data_out_stack
);
port_read: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(7 downto 7),
        data_out(0 downto 0)=> data_out_port_read
);
port_write: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(6 downto 6),
        data_out(0 downto 0)=> data_out_port_write
);
ldm: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(5 downto 5),
        data_out(0 downto 0)=> data_out_ldm
);
pc_to_stack: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,

         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(4 downto 4),
        data_out(0 downto 0)=> data_out_pc_to_stack
);
mem_to_pc: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(3 downto 3),
        data_out(0 downto 0)=> data_out_mem_to_pc
);

rti: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(2 downto 2),
        data_out(0 downto 0)=> data_out_rti
);
ret: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(1 downto 1),
        data_out(0 downto 0)=> data_out_ret
);
call: generic_register_rising generic map(1) port map (
        clk => clock,
        rst => reset,
        write_en => buffer_enable,
         flush_in_reg=> FLUSH_ID_EX,
        data_in => fired_signals(0 downto 0),
        data_out(0 downto 0)=> data_out_call
);
end a_id_ex_buffer;
