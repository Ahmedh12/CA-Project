LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--32 bit D flipflop with enable and reset
--on_reset read_data(output) equals 0
--on write_en = 1 read_data = write_data

ENTITY generic_register_rising IS
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
END generic_register_rising;

ARCHITECTURE a_generic_register_rising OF generic_register_rising IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
            data_out <= (OTHERS => '0');
            elsif flush_in_reg='1' then 
                 data_out <= (OTHERS => '0');
            
            ElSIF write_en = '1' THEN
                data_out <= data_in;
            END IF;
        END IF;
    END PROCESS;
END a_generic_register_rising;
