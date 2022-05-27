LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memory_stage_project IS
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
		--sp_error_in : IN STD_LOGIC;

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
END ENTITY memory_stage_project;

ARCHITECTURE arch_memory_stage_project OF memory_stage_project IS

	COMPONENT MUX2x1 IS
		GENERIC (
			n : INTEGER := 18
		);
		PORT (
			inputA, inputB : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			sel : IN STD_LOGIC;
			result : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
	END COMPONENT MUX2x1;

	COMPONENT memory_validating_address IS
		PORT (
			mem_write, mem_read : IN STD_LOGIC;
			push_pop : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			address_invalid : OUT STD_LOGIC);
	END COMPONENT memory_validating_address;

	COMPONENT stack_pointer IS
		PORT (
			clk, rst, call, ret, rti : IN STD_LOGIC;
			push_pop : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			stack_pointer_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			sp_unexpected : OUT STD_LOGIC;
			stack_pointer_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT stack_pointer;

	COMPONENT memory_buffer IS PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		sp_error : IN STD_LOGIC;
		address_invalid : IN STD_LOGIC;
		wb_signal_in : IN STD_LOGIC;
		load_imm_in : IN STD_LOGIC;
		port_read_in : IN STD_LOGIC;
		mem_to_reg_in : IN STD_LOGIC;
		mem_to_pc_in : IN STD_LOGIC;

		data_from_memory_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		alu_result_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_vector_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		imm_or_offset_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		r_scr_1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		r_scr_2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		r_dst_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

		data_from_memory_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		alu_result_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_vector_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		imm_or_offset_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

		r_src_1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		r_src_2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		r_dst_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

		sp_error_out : OUT STD_LOGIC;
		address_invalid_out : OUT STD_LOGIC;
		wb_signal_out : OUT STD_LOGIC;
		load_imm_out : OUT STD_LOGIC;
		port_read_out : OUT STD_LOGIC;
		mem_to_reg_out : OUT STD_LOGIC;
		mem_to_pc_out : OUT STD_LOGIC;
		inPort_value_read_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		inPort_value_read_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		mem_read_in : IN STD_LOGIC;
		mem_read_out : OUT STD_LOGIC
		);

	END COMPONENT memory_buffer;

	SIGNAL push_or_pop : STD_LOGIC;
	SIGNAL current_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL address_is_invalid_to_buff4 : STD_LOGIC;
	SIGNAL sp_error_to_buff4 : STD_LOGIC;
BEGIN
	sp_error_out <= sp_error_to_buff4;
	address_is_invalid_out <= address_is_invalid_to_buff4;
	mem_write_out <= mem_write;
	mem_read_out <= mem_read;
	pc_out <= pc;
	flags_out <= flags;
	pc_signal_out <= pc_signal;
	call_out <= call;
	ret_out <= ret;
	rti_out <= rti;
	push_pop_out <= push_pop;

	push_or_pop <= push_pop(0) OR push_pop(1);
	address <= current_address;

	u_mux2x1_1 : MUX2x1 GENERIC MAP(32) PORT MAP(alu_result, sp, push_or_pop, address);
	u_mux2x1_2 : MUX2x1 GENERIC MAP(32) PORT MAP(r_src_2_32_bits, pc, pc_signal, data);
	u_validating_mem : memory_validating_address PORT MAP(mem_write, mem_read, push_pop, current_address, address_is_invalid_to_buff4);
	u_new_sp : stack_pointer PORT MAP(clk, rst, call, ret, rti, push_pop, sp, sp_error_to_buff4, sp_out);
	u_memory_buffer : memory_buffer PORT MAP(
		clk => clk,
		rst => rst,
		sp_error => sp_error_to_buff4,
		address_invalid => address_is_invalid_to_buff4,
		wb_signal_in => wb_signal_in,
		load_imm_in => load_imm_in,
		port_read_in => port_read_in,
		mem_to_reg_in => mem_to_reg_in,
		mem_to_pc_in => mem_to_pc_in,

		data_from_memory_IN => data_from_memory,
		alu_result_IN => alu_result,
		PC_vector_IN => pc,
		imm_or_offset_IN => imm_or_offset_IN,
		r_scr_1_IN => r_src_1_3_bits_IN,
		r_scr_2_IN => r_src_2_3_bits_IN,
		r_dst_IN => r_dst_3_bits_IN,

		data_from_memory_OUT => data_from_memory_out_buff4,
		alu_result_OUT => alu_result_out_buff4,
		PC_vector_OUT => pc_out_buff4,
		imm_or_offset_OUT => imm_or_offset_out_buff4,

		r_src_1_OUT => r_src_1_3_bits_OUT_buff4,
		r_src_2_OUT => r_src_2_3_bits_OUT_buff4,
		r_dst_OUT => r_dst_3_bits_OUT_buff4,
		sp_error_out => sp_error_out_buff4,
		address_invalid_out => address_is_invalid_out_buff4,
		wb_signal_out => wb_signal_out_buff4,
		load_imm_out => load_imm_out_buff4,
		port_read_out => port_read_out_buff4,
		mem_to_reg_out => mem_to_reg_out_buff4,
		mem_to_pc_out => mem_to_pc_out_buff4,
		inPort_value_read_in => inPort_read_in,
		inPort_value_read_out => inPort_read_out_buff4,
		mem_read_in => mem_read,
		mem_read_out => mem_read_out_buff4
		
	);

END arch_memory_stage_project;