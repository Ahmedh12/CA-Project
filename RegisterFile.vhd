LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg_file IS
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
END reg_file;
ARCHITECTURE a_reg_file OF reg_file IS
    COMPONENT generic_register_falling IS
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
    END COMPONENT generic_register_falling;

    SIGNAL E0, E1, E2, E3, E4, E5, E6, E7 : STD_LOGIC;
    SIGNAL data0, data1, data2, data3, data4, data5, data6, data7 : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    E0 <= '1' WHEN (write_addr = "000" AND write_en = '1') ELSE
        '0';
    E1 <= '1' WHEN (write_addr = "001" AND write_en = '1') ELSE
        '0';
    E2 <= '1' WHEN (write_addr = "010" AND write_en = '1') ELSE
        '0';
    E3 <= '1' WHEN (write_addr = "011" AND write_en = '1') ELSE
        '0';
    E4 <= '1' WHEN (write_addr = "100" AND write_en = '1') ELSE
        '0';
    E5 <= '1' WHEN (write_addr = "101" AND write_en = '1') ELSE
        '0';
    E6 <= '1' WHEN (write_addr = "110" AND write_en = '1') ELSE
        '0';
    E7 <= '1' WHEN (write_addr = "111" AND write_en = '1') ELSE
        '0';

    reg0 : generic_register_falling PORT MAP(clk, rst, E0, data_in, data0);
    reg1 : generic_register_falling PORT MAP(clk, rst, E1, data_in, data1);
    reg2 : generic_register_falling PORT MAP(clk, rst, E2, data_in, data2);
    reg3 : generic_register_falling PORT MAP(clk, rst, E3, data_in, data3);
    reg4 : generic_register_falling PORT MAP(clk, rst, E4, data_in, data4);
    reg5 : generic_register_falling PORT MAP(clk, rst, E5, data_in, data5);
    reg6 : generic_register_falling PORT MAP(clk, rst, E6, data_in, data6);
    reg7 : generic_register_falling PORT MAP(clk, rst, E7, data_in, data7);

    data_out_1 <= data0 WHEN read_addr_1 = "000" ELSE
        data1 WHEN read_addr_1 = "001" ELSE
        data2 WHEN read_addr_1 = "010" ELSE
        data3 WHEN read_addr_1 = "011" ELSE
        data4 WHEN read_addr_1 = "100" ELSE
        data5 WHEN read_addr_1 = "101" ELSE
        data6 WHEN read_addr_1 = "110" ELSE
        data7 WHEN read_addr_1 = "111";

    data_out_2 <= data0 WHEN read_addr_2 = "000" ELSE
        data1 WHEN read_addr_2 = "001" ELSE
        data2 WHEN read_addr_2 = "010" ELSE
        data3 WHEN read_addr_2 = "011" ELSE
        data4 WHEN read_addr_2 = "100" ELSE
        data5 WHEN read_addr_2 = "101" ELSE
        data6 WHEN read_addr_2 = "110" ELSE
        data7 WHEN read_addr_2 = "111";

END a_reg_file;
