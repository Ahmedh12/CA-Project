LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
      GENERIC (n : INTEGER := 32); -- n: is the size of the actual data
      PORT (
            OP_CODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Data1 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Data2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            ALU_Result : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            FLAGS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            FLAGS_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            EN : IN STD_LOGIC --always on
      );

END ALU;

ARCHITECTURE arch_ALU OF ALU IS

      ------------------------------ components -----------------------------------  
      -- Adder component
      COMPONENT Nbit_adder IS
            GENERIC (Z : INTEGER := 32);
            PORT (
                  A : IN STD_LOGIC_VECTOR(Z - 1 DOWNTO 0);
                  B : IN STD_LOGIC_VECTOR(Z - 1 DOWNTO 0);
                  Cin : IN STD_LOGIC;
                  S : OUT STD_LOGIC_VECTOR(Z - 1 DOWNTO 0);
                  COUT : OUT STD_LOGIC);
      END COMPONENT;

      -- Subtractor component
      COMPONENT Nbit_subtractor IS
            GENERIC (Z : INTEGER := 32);
            PORT (
                  X : IN STD_LOGIC_VECTOR(Z - 1 DOWNTO 0);
                  Y : IN STD_LOGIC_VECTOR(Z - 1 DOWNTO 0);
                  Bin : IN STD_LOGIC;
                  s : OUT STD_LOGIC_VECTOR(Z - 1 DOWNTO 0);
                  Bout : OUT STD_LOGIC);
      END COMPONENT;

      -------------------------------SIGNALS-----------------------------------------
      SIGNAL ADDER_INTERMDIATE : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
      SIGNAL ADDER_INTERMDIATE2 : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);

      SIGNAL SUBTRACTOR_INTERMDIATE : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);

      SIGNAL CARRY_OUT : STD_LOGIC;
      SIGNAL CARRY_OUT2 : STD_LOGIC;

      SIGNAL CRC_ORIGINAL_DATA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

      SIGNAL BORROW_OUT : STD_LOGIC;

BEGIN

      -- Nbit adder instance
      U_ADDER : Nbit_adder GENERIC MAP(32) PORT MAP(Data1, Data2, '0', ADDER_INTERMDIATE, CARRY_OUT);
      U_ADDER2 : Nbit_adder GENERIC MAP(32) PORT MAP(Data1, "00000000000000000000000000000001", '0', ADDER_INTERMDIATE2, CARRY_OUT2);
      u_SUBTRACTOR : Nbit_subtractor GENERIC MAP(32) PORT MAP(Data1, Data2, '0', SUBTRACTOR_INTERMDIATE, BORROW_OUT);
      ALU_Result <= NOT Data1 WHEN EN = '1' AND OP_CODE = "00100" -- NOT Rdst -done
            ELSE
            ADDER_INTERMDIATE2 WHEN EN = '1' AND OP_CODE = "00010" -- INC Rdst -done
            ELSE
            Data1 WHEN EN = '1' AND OP_CODE = "00110" -- MOV Rsrc, Rdst
            --ELSE WHEN EN = '1' and OP_CODE = '01001' -- SWAP Rsrc, Rdst-------------ask
            ELSE
            ADDER_INTERMDIATE WHEN EN = '1' AND OP_CODE = "00001" -- ADD Rdst, Rsrc1, Rscr2 -done
            ELSE
            SUBTRACTOR_INTERMDIATE WHEN EN = '1' AND OP_CODE = "00011" -- SUB Rdst, Rsrc1, Rsrc2 -done
            ELSE
            (Data2 AND Data1) WHEN EN = '1' AND OP_CODE = "00101" -- AND Rdst, Rsrc1, Rsrc2 -done
            ELSE
            ADDER_INTERMDIATE WHEN EN = '1' AND OP_CODE = "00111" -- IADD Rdst, Rsrc, Imm -done
            ELSE
            Data2 WHEN EN = '1' AND OP_CODE = "01011" -- LDM Rdst, Imm 
            ELSE
            ADDER_INTERMDIATE WHEN EN = '1' AND OP_CODE = "01010" -- LDD Rdst, offset(Rsrc) -done
            ELSE
            Data1; ---AHMED ASK
      --(Others=>'0');

      --crc zero no change

      ----------------------------- FLAGS UPDATE ------------------------------------------
      -- CCR(0)= zero flag, change after arithmetic, logical, or shift operations
      -- CCR(1)= negative flag, change after arithmetic, logical, or shift operations
      -- CCR(2)= carry flag, change after arithmetic or shift operations.
      PROCESS (OP_CODE, Data1, Data2, EN)
      BEGIN
            IF EN = '1' THEN
                  ----------------------------- ZERO FLAGE --------------------------------------------       

                  IF (OP_CODE = "00001" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE)) = 0) THEN -- ADD Rdst, Rsrc1, Rscr2
                        CRC_ORIGINAL_DATA(0) <= '1';
                  ELSIF (OP_CODE = "00111" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE)) = 0) THEN --IADD Rdst,Imm
                        CRC_ORIGINAL_DATA(0) <= '1';
                  ELSIF (OP_CODE = "00011" AND EN = '1' AND to_integer(signed(SUBTRACTOR_INTERMDIATE)) = 0) THEN -- SUB Rsrc, Rdst
                        CRC_ORIGINAL_DATA(0) <= '1';
                  ELSIF (OP_CODE = "00101" AND EN = '1' AND to_integer(signed(Data1 AND Data2)) = 0) THEN -- AND Rsrc, Rdst
                        CRC_ORIGINAL_DATA(0) <= '1';
                  ELSIF (OP_CODE = "00100" AND EN = '1' AND to_integer(signed(NOT Data1)) = 0) THEN -- NOT Rdst
                        CRC_ORIGINAL_DATA(0) <= '1';
                  ELSIF (OP_CODE = "00010" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE2)) = 0) THEN -- INC Rdst 
                        CRC_ORIGINAL_DATA(0) <= '1';
                  ELSIF (OP_CODE = "01010" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE)) = 0) THEN -- LDD Rdst, offset(Rsrc)(remove)
                        CRC_ORIGINAL_DATA(0) <= '1';
                  ELSE
                        CRC_ORIGINAL_DATA(0) <= '0';
                  END IF;
                  -----------------------  NEGATIVE FLAGE --------------------------------------------       

                  IF (OP_CODE = "00001" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE)) < 0) THEN -- ADD Rsrc, Rdst
                        CRC_ORIGINAL_DATA(1) <= '1';
                  ELSIF (OP_CODE = "00111" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE)) < 0) THEN --IADD Rdst,Imm
                        CRC_ORIGINAL_DATA(1) <= '1';
                  ELSIF (OP_CODE = "00011" AND EN = '1' AND to_integer(signed(SUBTRACTOR_INTERMDIATE)) < 0) THEN -- SUB Rsrc, Rdst
                        CRC_ORIGINAL_DATA(1) <= '1';
                  ELSIF (OP_CODE = "00101" AND EN = '1' AND to_integer(signed(Data1 AND Data2)) < 0) THEN -- AND Rsrc, Rdst
                        CRC_ORIGINAL_DATA(1) <= '1';
                  ELSIF (OP_CODE = "00100" AND EN = '1' AND to_integer(signed(NOT Data2)) < 0) THEN -- NOT Rdst 
                        CRC_ORIGINAL_DATA(1) <= '1';
                  ELSIF (OP_CODE = "00010" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE2)) < 0) THEN-- INC Rdst 
                        CRC_ORIGINAL_DATA(1) <= '1';
                  ELSIF (OP_CODE = "01010" AND EN = '1' AND to_integer(signed(ADDER_INTERMDIATE)) < 0) THEN -- LDD Rdst, offset(Rsrc)(remove)	
                        CRC_ORIGINAL_DATA(1) <= '1';
                  ELSE
                        CRC_ORIGINAL_DATA(1) <= '0';
                  END IF;
                  ----------------------------- CARRY FLAGE -------------------------------------------
                  IF (OP_CODE = "00001" AND EN = '1') THEN -- ADD Rsrc, Rdst
                        CRC_ORIGINAL_DATA(2) <= CARRY_OUT;
                  ELSIF (OP_CODE = "00111" AND EN = '1') THEN--IADD Rdst,Imm 
                        CRC_ORIGINAL_DATA(2) <= CARRY_OUT;
                  ELSIF (OP_CODE = "00011" AND EN = '1') THEN-- SUB Rsrc, Rdst	
                        CRC_ORIGINAL_DATA(2) <= BORROW_OUT;
                  ELSIF (OP_CODE = "00010" AND EN = '1') THEN-- iNC
                        CRC_ORIGINAL_DATA(2) <= CARRY_OUT2;
                  ELSIF (OP_CODE = "01010" AND EN = '1') THEN-- LDD Rdst, offset(Rsrc)(remove)
                        CRC_ORIGINAL_DATA(2) <= CARRY_OUT;
                  ELSE
                        CRC_ORIGINAL_DATA(2) <= '0';
                  END IF;
            END IF;

            IF OP_CODE = "00000" THEN
                  CRC_ORIGINAL_DATA <= FLAGS_IN OR "0100";
            END IF;

      END PROCESS;

      FLAGS <= CRC_ORIGINAL_DATA WHEN ((EN = '1') AND (OP_CODE = "00001" OR OP_CODE = "00111" OR OP_CODE = "00011" OR OP_CODE = "00101" OR OP_CODE = "00100" OR OP_CODE = "00010" OR OP_CODE = "10011")) OR OP_CODE = "01010" OR OP_CODE = "00000" --MOV/LDM
            ELSE
            FLAGS_IN;

END arch_ALU;