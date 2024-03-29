LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY EX_STAGE IS
	PORT (

		--Inputs:
		--Control unit Signals
		--E_M_BUFFER_WB		:IN std_logic;
		--M_WB_BUFFER_WB  	:IN std_logic;

		buffer_disable_in : IN STD_LOGIC;

		--------------------------------------MUX COMPONENTS---------------------------------------
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

		-------------- OUTPUT SIGNALS---------------------------
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
		-----------------

		----------------------------is_Jump----------------------------
		is_Jump : OUT STD_LOGIC;
		flags_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

		--------------------------OUTPUT PORT--------------------------
		OUT_PORT_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

		OUT_DATA_MUX_RSRC2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

	);
END ENTITY EX_STAGE;
ARCHITECTURE ARCH_Execute_stage OF EX_STAGE IS

	-- COMPONENTS
	-- MUX8X1
	COMPONENT MUX8X1 IS
		GENERIC (n : INTEGER := 32); -- n: is the size of the actual data
		PORT (
			in0, in1, in2, in3, in4, in5, in6, in7 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			S : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));

	END COMPONENT;

	-- MUX2X1
	COMPONENT mux2 IS
		GENERIC (n : INTEGER := 32); -- n: is the size of the actual data
		PORT (
			in0, in1 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
			S : IN STD_LOGIC;
			F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));

	END COMPONENT;
	-- FORWARD UNIT
	COMPONENT FORWARD_UNIT IS
		PORT (

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

			--Outputs:
			FUNC_SIG_OUT_1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			FUNC_SIG_OUT_2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

		);
	END COMPONENT;
	-----JUMP DETECT UNIT
	COMPONENT JMP_DETECT_UNIT IS
		PORT (
			disable : IN STD_LOGIC;
			FLAGS_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			OT_CODE : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --(OPERATIONAL TYPE)
			ID_CODE : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --(Instruction identification)

			CHECK_JMP : OUT STD_LOGIC;
			FLAGS_OUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	--CCR
	COMPONENT CCR IS
		PORT (
			EN, CLK, RESET : IN STD_LOGIC;
			DATA_IN : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			DATA_OUT : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
	END COMPONENT;
	-- OUTPUT PORT
	COMPONENT Output_port IS
		PORT (
			PORt_WRITE, CLK, RESET : IN STD_LOGIC;
			DATA_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
	END COMPONENT;
	-- ALU
	COMPONENT ALU IS
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

	END COMPONENT;

	---------EXECUTE_MEMORY_BUFFER
	COMPONENT EXECUTE_MEMORY_BUFFER IS
		PORT (

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

			--------------------ALU RESULT
			ALU_RESULT_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			-------------------

			--------------------OFFSET/IMMEDIATE
			OFFSET_IMM_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			---------------------
			---------------------ADDRESSES
			--INPUT ADRRESSS
			ADDRESS_RSRC1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			ADDRESS_RSRC2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			ADDRESS_RDST_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			------------------

			----------------------RSRC2
			INPUT_RSRC2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			----------------------

			-------------- INPUT SIGNALS
			INPUT_MEM_PC : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			RESET : IN STD_LOGIC;
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
			MUX_RSRC2_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --------------UPDATE
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
			-----------------
			flags_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			flags_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			MUX_RSRC2_DATA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) --------------UPDATE
		);
	END COMPONENT;
	------------SIGNALS
	---OUTPUT SELECTION LINES FROM THE  FORWARDING UNIT TO THE MUX1 AND MUX2
	SIGNAL FU_OUT_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL FU_OUT_2 : STD_LOGIC_VECTOR(2 DOWNTO 0);

	---OUTPUT DATA FROM MUX1 AND MUX2 TO ALU UNIT
	SIGNAL MUX1_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL INTERM_MUX2_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MUX2_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

	---JDU
	SIGNAL IS_JUMP_SIG : STD_LOGIC;
	SIGNAL FLAGS_OUT_JDU : STD_LOGIC_VECTOR(3 DOWNTO 0);

	--ALU
	SIGNAL ALU_RESULT_INTERM : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL FLAGS_INTERM_IN : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL FLAGS_INTERM_OUT : STD_LOGIC_VECTOR(3 DOWNTO 0);

	--MUX3_CRC_INTERM
	SIGNAL MUX3_CCR_INTERM : STD_LOGIC_VECTOR(3 DOWNTO 0);

	--CCR
	SIGNAL CCR_INTERM : STD_LOGIC_VECTOR(3 DOWNTO 0);
	--ALU
	SIGNAL MUX_RSCR2_DATA_OUTER : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
	----MUX8X1 COMPONENTS
	MUX1 : MUX8X1 PORT MAP(RSCR1_DATA, MEM_WB_BUFF_MEMORY_VAL, EX_MEM_BUFF_ALU, MEM_WB_BUFF_ALU, EX_MEM_BUFF_IMM, MEM_WB_BUFF_IMM, EX_MEM_PORT_IN, MEM_WB_PORT_IN, FU_OUT_1, MUX1_OUT);

	MUX2_INTER : MUX8X1 PORT MAP(RSCR2_DATA, MEM_WB_BUFF_MEMORY_VAL, EX_MEM_BUFF_ALU, MEM_WB_BUFF_ALU, EX_MEM_BUFF_IMM, MEM_WB_BUFF_IMM, EX_MEM_PORT_IN, MEM_WB_PORT_IN, FU_OUT_2, INTERM_MUX2_OUT);

	---MUX2X1
	MUX4 : mux2 PORT MAP(OFFEST_IMM, INTERM_MUX2_OUT, ALU_SRC, MUX2_OUT);
	---FORWARDING UNIT
	FU : FORWARD_UNIT PORT MAP(E_M_BUFFER_WB, M_WB_BUFFER_WB, E_MEM_BUFFER_PortRead, M_WB_BUFFER_PortRead, M_WB_BUFFER_MemRead, E_M_BUFFER_LDM, M_WB_BUFFER_LDM, D_E_BUFFER_SRC1, D_E_BUFFER_SRC2, E_MEM_BUFFER_DEST, M_WB_BUFFER_DEST, FU_OUT_1, FU_OUT_2);
	---JDU
	JDU : JMP_DETECT_UNIT PORT MAP(buffer_disable_in, FLAGS_INTERM_OUT, OP_CODE(4 DOWNTO 3), OP_CODE(2 DOWNTO 0), IS_JUMP_SIG, FLAGS_OUT_JDU);
	-- ALU
	ALU_X : ALU PORT MAP(OP_CODE, MUX1_OUT, MUX2_OUT, ALU_RESULT_INTERM, FLAGS_INTERM_OUT, FLAGS_INTERM_IN, '1');

	-- OUTPUT PORT
	OUT_PORT : Output_port PORT MAP(PORT_WRITE_SIG, CLK, RESET, MUX1_OUT, OUT_PORT_OUT);

	---MUX2X1 second BETWEEN CCR AND MUX3
	MUX3 : mux2 GENERIC MAP(4) PORT MAP(FLAGS_INTERM_OUT, FLAGS_OUT_JDU, IS_JUMP_SIG, FLAGS_INTERM_IN);

	---CCR 
	CCR_UNIT : CCR PORT MAP('1', CLK, RESET, FLAGS_INTERM_IN, CCR_INTERM);
	---------EXECUTE_MEMORY_BUFFER
	flags_out <= CCR_INTERM;
	EXE_MEM_BUFF : EXECUTE_MEMORY_BUFFER PORT MAP(
		INPUT_STACK,
		INPUT_INTERRUPT,
		STACK_DATA_IN,
		INPUT_MEM_READ,
		INPUT_MEM_WRITE,
		PC_DATA_32BIT_IN,
		ALU_RESULT_INTERM,
		OFFEST_IMM,
		ADDRESS_RSRC1_IN,
		ADDRESS_RSRC2_IN,
		ADDRESS_RDST_IN,
		RSCR2_DATA,
		INPUT_MEM_PC,
		CLK,
		RESET,
		EXEP_STACK_POINTER,
		INVALID_ADD_BIT,
		INPUT_PC_TO_STACK,
		INPUT_RTI,
		INPUT_WB,
		INPUT_LOAD_IMM,
		INPUT_PORT_READ,
		INPUT_MEM_TO_REG,
		INPUT_RETURN,
		INPUT_CALL,
		INPUT_PORT_IN,
		INTERM_MUX2_OUT,
		OUTPUT_STACK,
		OUTPUT_INTERRUPT,
		STACK_DATA_OUT,
		OUTPUT_MEM_READ,
		OUTPUT_MEM_WRITE,
		PC_DATA_32BIT_OUT,
		ALU_RESULT_OUT,
		OFFSET_IMM_OUT,
		ADDRESS_RSRC1_OUT,
		ADDRESS_RSRC2_OUT,
		ADDRESS_RDST_OUT,
		OUTPUT_RSRC2,
		OUTOUT_PORT_IN,
		OUTPUT_MEM_PC,
		EXEP_STACK_POINTER_OUT,
		OUTPUT_PC_TO_STACK,
		OUTPUT_RTI,
		OUTPUT_WB,
		OUTPUT_LOAD_IMM,
		OUTPUT_PORT_READ,
		OUTPUT_MEM_TO_REG,
		OUTPUT_RETURN,
		OUTPUT_CALL,
		MUX3_CCR_INTERM,
		flags_out,
		MUX_RSCR2_DATA_OUTER
	);
	OUT_DATA_MUX_RSRC2 <= MUX_RSCR2_DATA_OUTER;

	is_Jump <= IS_JUMP_SIG;
END ARCH_Execute_stage;