LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
LIBRARY WORK;
USE work.constants.all;

ENTITY main IS
	PORT( Clk,Rst : IN std_logic;
	      BUS_DATA	: INOUT   std_logic_vector (15 DOWNTO 0));
END main;

ARCHITECTURE main_arch OF main IS
	  SIGNAL TO_RAM,RD,WR : STD_LOGIC;
	  SIGNAL SEL,NEW_SEL :STD_LOGIC_VECTOR(1 DOWNTO 0);
	  SIGNAL M_IR,NEW_SRC,IR, R0 , R1, R2 ,R3, R4, R5, R6, R7 ,DEST, MDR, SRC :STD_LOGIC_VECTOR(15 DOWNTO 0); 
	  SIGNAL ENAPLE_REGISTER: STD_LOGIC_VECTOR(7 DOWNTO 0);
	  SIGNAL MAR : STD_LOGIC_VECTOR (12 DOWNTO 0);
	  SIGNAL OUT_DEC_SRC,OUT_DEC_DST : STD_LOGIC_VECTOR (7 DOWNTO 0);
	  SIGNAL ADRESS, NEXT_ADDRESS : STD_LOGIC_VECTOR (15 DOWNTO 11);
	  SIGNAL NEW_R0,NEW_R1,NEW_R2,NEW_R3,NEW_R4,NEW_R5,NEW_R6,NEW_R7 : STD_LOGIC_VECTOR (15 DOWNTO 0);
	  signal EXE: std_logic_vector(23 downto 0);
	  --alu signals
	  --bus_data
	  --y_reg with enable
	  --operation_code
	  signal yRegOut:std_logic_vector(16,0);
	  signal operationCode:std_logic_vector(4 downto 0);
	  signal flagRegIn, flagRegOut, aluResult, zRegOut,: std_logic_vector(16 downto 0);
	BEGIN
	   
	   --DEC_REG_DIR_SRC : DECODER GENERIC MAP (3) PORT MAP (IR(8 DOWNTO 6), OUT_DEC_SRC);
	   DEC_REG_DIR_DST : DECODER GENERIC MAP (3) PORT MAP (IR(2 DOWNTO 0), ENAPLE_REGISTER);
	    
	   u0: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(0), CLK, RST, R0);
	   u1: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(1), CLK, RST, R1); 
	   u2: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(2), CLK, RST, R2);
	   u3: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(3), CLK, RST, R3);
	   u4: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(4), CLK, RST, R4);
	   u5: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(5), CLK, RST, R5);
	   u6: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(6), CLK, RST, R6);
	   u7: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, ENAPLE_REGISTER(7), CLK, RST, R7);  
	   
	   
	   mirReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (, ENAPLE_REGISTER(7), CLK, RST, R7);  
	   
	   FR : ENTITY WORK.FETCH_REGISTERS PORT MAP(IR,R0,R1,R2,R3,R4,R5,R6,R7,NEW_SEL,DEST);
	   -- regDst: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (DEST, , CLK, RST, BUS_DATA);  
	   tristateRegDst: entity work.TriStateGeneric GENERIC MAP (16) port map(DEST,EXE(),BUS_DATA); 
	   tristatePC: entity work.TriStateGeneric GENERIC MAP (16) port map(R7,EXE(),BUS_DATA); 
	   OT : ENTITY WORK.OPERATION_TYPE PORT MAP(IR,SEL);
	   FM : ENTITY WORK.FIRST_MIR PORT MAP(IR,SEL,M_IR(15 DOWNTO 11));
	   BD : ENTITY WORK.BIG_DECODER PORT MAP(clk, SEL,ADRESS (15 DOWNTO 11), NEXT_ADDRESS(15 DOWNTO 11), IR (15 DOWNTO 0),EXE);
	   
	   ch : ENTITY WORK.CHECK_AND_CHANGE PORT MAP(DEST,SRC,SEL,NEW_SRC,NEW_SEL);
	   RE : ENTITY WORK.RETURN_DATA PORT MAP(IR,R0,R1,R2,R3,R4,R5,R6,R7,DEST,NEW_R0,NEW_R1,NEW_R2,NEW_R3,NEW_R4,NEW_R5,NEW_R6,NEW_R7,TO_RAM);  
	   
	   --alu main implementation
	   yReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, EXE(), CLK, RST, yRegOut);  
	   flagReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (flagRegIn, '1', not(CLK), RST, flagRegOut);  
	   alu0: entity work.alu generic map(16,5) port map(operationCode, BUS_DATA, yRegOut, aluResult,flagRegOut(flagsCount-1 downto 0), flagRegIn(flagsCount-1 downto 0));
	   zReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (aluResult, '1', not(CLK), RST, zRegOut);  
	   tristateZ: entity work.TriStateGeneric GENERIC MAP (16) port map(zRegOut,EXE(),BUS_DATA);   
	   
	   END main_arch;