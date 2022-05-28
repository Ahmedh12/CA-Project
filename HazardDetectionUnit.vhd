LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hazard_detection_unit IS
	PORT (
		id_ex_mem_read: in std_logic_vector(0 downto 0);
--id_ex_mem_read: in std_logic;
		id_ex_rdst: in std_logic_vector(2 downto 0);
		if_id_rsrc1: in std_logic_vector(2 downto 0);
 		if_id_rsrc2: in std_logic_vector(2 downto 0); 
        opcode: in std_logic_vector(4 downto 0); 
        freeze_pc: out std_logic;
buffer_disable: out std_logic;
flush: out std_logic
		
	);
END hazard_detection_unit;

ARCHITECTURE hazard_detection_unit_arch OF hazard_detection_unit IS
BEGIN
	process(id_ex_mem_read, id_ex_rdst, if_id_rsrc1, if_id_rsrc2)
    begin
        if (id_ex_mem_read = "1" and opcode /= "10000" and opcode/="10001" and((if_id_rsrc1=id_ex_rdst) or (if_id_rsrc2=id_ex_rdst) )) then
           freeze_pc <= '1';
	   buffer_disable <= '1';
	  flush<='1';
        else
                freeze_pc <= '0';
	   buffer_disable <= '0';
	  flush<='0';
        end if;   
        end process;   
END hazard_detection_unit_arch;
