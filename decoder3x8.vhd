LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--3*8 decoder with enable 
--on_enable = 0 decoder is off d=0

ENTITY decoder3x8 IS
    PORT (
        sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        d : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        en : IN STD_LOGIC);
END decoder3x8;

ARCHITECTURE a_decoder3x8 OF decoder3x8 IS
BEGIN
    PROCESS (en, sel)
    BEGIN
        d <= "00000000";
        IF (en = '1') THEN
            CASE sel IS
                WHEN "000" => d(0) <= '1';
                WHEN "001" => d(1) <= '1';
                WHEN "010" => d(2) <= '1';
                WHEN "011" => d(3) <= '1';
                WHEN "100" => d(4) <= '1';
                WHEN "101" => d(5) <= '1';
                WHEN "110" => d(6) <= '1';
                WHEN "111" => d(7) <= '1';
                WHEN OTHERS => d <= "00000000";
            END CASE;
        END IF;
    END PROCESS;
END a_decoder3x8;
