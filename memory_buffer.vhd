LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memory_buffer IS PORT (
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
	inPort_value_read_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);

END memory_buffer;

ARCHITECTURE arch_memory_buffer OF memory_buffer IS
BEGIN
	PROCESS (clk, rst) IS
	BEGIN
		IF (rst = '1') THEN
			sp_error_out <= '0';
			address_invalid_out <= '0';
			wb_signal_out <= '0';
			load_imm_out <= '0';
			port_read_out <= '0';
			mem_to_reg_out <= '0';
			mem_to_pc_out <= '0';

			inPort_value_read_out <= (OTHERS => '0');
			data_from_memory_OUT <= (OTHERS => '0');
			alu_result_OUT <= (OTHERS => '0');
			PC_vector_OUT <= (OTHERS => '0');
			imm_or_offset_OUT <= (OTHERS => '0');
			r_src_1_OUT <= (OTHERS => '0');
			r_src_2_OUT <= (OTHERS => '0');
			r_dst_OUT <= (OTHERS => '0');

		ELSIF rising_edge(clk) THEN
			IF sp_error = '1' OR address_invalid = '1' THEN
				sp_error_out <= sp_error;
				address_invalid_out <= address_invalid;
				wb_signal_out <= '0';
				load_imm_out <= '0';
				port_read_out <= '0';
				mem_to_reg_out <= '0';
				mem_to_pc_out <= '0';
				inPort_value_read_out <= (OTHERS => '0');
			ELSE
				sp_error_out <= sp_error;
				address_invalid_out <= address_invalid;
				wb_signal_out <= wb_signal_in;
				load_imm_out <= load_imm_in;
				port_read_out <= port_read_in;
				mem_to_reg_out <= mem_to_reg_in;
				mem_to_pc_out <= mem_to_pc_in;

				data_from_memory_OUT <= data_from_memory_in;
				alu_result_OUT <= alu_result_in;
				PC_vector_OUT <= PC_vector_in;
				imm_or_offset_OUT <= imm_or_offset_in;
				r_src_1_OUT <= r_scr_1_IN;
				r_src_2_OUT <= r_scr_2_IN;
				r_dst_OUT <= r_dst_in;
				inPort_value_read_out <= inPort_value_read_in;
			END IF;
		END IF;
	END PROCESS;
END arch_memory_buffer;