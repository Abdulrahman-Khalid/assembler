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
	  SIGNAL NEW_SRC, IR,DEST, MDR, SRC :STD_LOGIC_VECTOR(15 DOWNTO 0); 
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
	  signal operationCode:std_logic_vector(4 downto 0);
	  signal yRegOut,flagRegIn, flagRegOut, aluResult, zRegOut, mar_out ,mem_to_mdr ,mdr_out: std_logic_vector(15 downto 0);
	  -- SELECTOR SIGNALS 
	  -- SOURCE SIGNALS
	  -- Destination signals
	  -- MICRO IR SIGNALS
	  SIGNAL SIG_SEL, Q_SEL :STD_LOGIC_VECTOR(1 DOWNTO 0);
	  SIGNAL SIG_SRC, Q_SRC, SIG_DST, Q_DST :STD_LOGIC_VECTOR(15 DOWNTO 0);
	  SIGNAL E_SEL,E_SRC, E_DST : STD_LOGIC;
	  SIGNAL notClk: STD_LOGIC;
	  signal Q_MIR: std_logic_vector(15 downto 11);
	  -- SIGNALS FOR R0 TO R7 REGISTERS AND IR
	  SIGNAL SIG_R7:STD_LOGIC_VECTOR(15 DOWNTO 0);
	  SIGNAL Q_IR,Q_R0, Q_R1, Q_R2, Q_R3, Q_R4, Q_R5, Q_R6, Q_R7:STD_LOGIC_VECTOR(15 DOWNTO 0);
	  SIGNAL E_R0_TO_R6, E_R7 : STD_LOGIC;
	BEGIN
	   
	   irReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, EXE(irIn), CLK, RST, Q_IR);
	     
	   u0: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_R0, E_R0_TO_R6, CLK, RST, Q_R0);
	   u1: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_R1, E_R0_TO_R6, CLK, RST, Q_R1); 
	   u2: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_R2, E_R0_TO_R6, CLK, RST, Q_R2);
	   u3: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_R3, E_R0_TO_R6, CLK, RST, Q_R3);
	   u4: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_R4, E_R0_TO_R6, CLK, RST, Q_R4);
	   u5: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_R5, E_R0_TO_R6, CLK, RST, Q_R5);
	   u6: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_R6, E_R0_TO_R6, CLK, RST, Q_R6);
	   u7: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (SIG_R7, E_R7, CLK, RST, Q_R7);  
	   
	   mirReg: ENTITY WORK.REG GENERIC MAP (5) PORT MAP (NEXT_ADDRESS, '1', NOTCLK, RST,Q_MIR);  
	   
	   FR : ENTITY WORK.FETCH_REGISTERS PORT MAP(Q_IR,Q_R0,Q_R1,Q_R2,Q_R3,Q_R4,Q_R5,Q_R6,Q_R7,Q_SEL,DEST);
	   -- regDst: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (DEST, , CLK, RST, BUS_DATA);  	   
	   OT : ENTITY WORK.OPERATION_TYPE PORT MAP(Q_IR,SEL);
	   --FM : ENTITY WORK.FIRST_MIR PORT MAP(IR,Q_SEL,M_IR(15 DOWNTO 11));
	   BD : ENTITY WORK.BIG_DECODER PORT MAP('1',clk, Q_SEL,Q_MIR, NEXT_ADDRESS(15 DOWNTO 11), IR (15 DOWNTO 0),EXE);
	   
	   ch : ENTITY WORK.CHECK_AND_CHANGE PORT MAP(DEST,SRC,Q_SEL,NEW_SRC,NEW_SEL);
	   RE : ENTITY WORK.RETURN_DATA PORT MAP(Q_IR,Q_R0,Q_R1,Q_R2,Q_R3,Q_R4,Q_R5,Q_R6,Q_R7,DEST,NEW_R0,NEW_R1,NEW_R2,NEW_R3,NEW_R4,NEW_R5,NEW_R6,NEW_R7,TO_RAM);  
	   
	   --alu main implementation
	   yReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (BUS_DATA, EXE(yIn), CLK, RST, yRegOut);  
	   flagReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (flagRegIn, '1', notClk, RST, flagRegOut);  
	   alu0: entity work.alu generic map(16,5) port map(operationCode, BUS_DATA, yRegOut, aluResult,flagRegOut(flagsCount-1 downto 0), flagRegIn(flagsCount-1 downto 0));
	   zReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (aluResult, EXE(zIn), notClk, RST, zRegOut);  
	   
	   --ram --mar_out --mem_to_mdr --mdr_out
	   marReg: ENTITY WORK.REG GENERIC MAP (16) PORT MAP(BUS_DATA, EXE(marIn), CLK, RST, mar_out);  
	   mdrReg: ENTITY WORK.MDR GENERIC MAP (16) PORT MAP(Clk,RST, EXE(mdrIn), EXE(exeWrite), mem_to_mdr, BUS_DATA, mdr_out);
	   ram0: entity work.ram port map (EXE(exeWrite), EXE(exeRead), mar_out(11 downto 0), mdr_out, mem_to_mdr);
	   
	   -- SET SELECTOR AND SET SOURCE REGISTER AND SET DESTINATION REGISTER
	   SE: ENTITY WORK.REG GENERIC MAP (2) PORT MAP (SIG_SEL, E_SEL, CLK, RST, Q_SEL);
     SR: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (NEW_SRC, E_SRC, CLK, RST, Q_SRC);  
 	   dst: ENTITY WORK.REG GENERIC MAP (16) PORT MAP (SIG_DST, E_DST, CLK, RST, Q_DST);
	 
	   notClk <= not(Clk);
	   
		SIG_SEL <= SEL WHEN Q_MIR(15 DOWNTO 11) = "01010" ELSE
			NEW_SEL WHEN Q_MIR(15 DOWNTO 11) = "11000" ELSE
			Q_SEL;
	 
		E_SEL <= '1' WHEN Q_MIR(15 DOWNTO 11) = "01010" OR Q_MIR(15 DOWNTO 11) = "11000" ELSE
            '0';
		 
		E_SRC <= '1' WHEN (Q_SEL = "10" AND Q_MIR(15 DOWNTO 11) = "11000") or EXE(srcIn) = '1' ELSE
			'0';
			  
	 	SIG_DST <= DEST WHEN Q_MIR(15 DOWNTO 11) = "01010"
			 ELSE BUS_DATA WHEN EXE(dstIn) = '1'
			 ELSE Q_DST;

		-- don't remove EXE(dstIn) = '1' from the next line
	 	E_DST <= '1' WHEN Q_MIR(15 DOWNTO 11) = "01010" or EXE(dstIn) = '1' ELSE
					'0';
	  
	  E_R0_TO_R6 <= '1' WHEN Q_MIR(15 DOWNTO 11) = "00000" ELSE
	                '0';  
	   
	   SIG_R7 <= NEW_R7 WHEN Q_MIR(15 DOWNTO 11) = "00000" ELSE
	             BUS_DATA WHEN EXE(pcIn) = '1' ELSE
	             Q_R7;
	   E_R7 <= '1' WHEN Q_MIR(15 DOWNTO 11) = "00000" OR EXE(pcIn) = '1' ELSE
	           '0';
	   
	   --tristates out to bus
	   tristateRegDst: entity work.TriStateGeneric GENERIC MAP (16) port map(DEST,EXE(dstOut),BUS_DATA); 
	   tristatePC: entity work.TriStateGeneric GENERIC MAP (16) port map(R7,EXE(pcOut),BUS_DATA); 
	   tristateZ: entity work.TriStateGeneric GENERIC MAP (16) port map(zRegOut,EXE(zOut),BUS_DATA);   
	   tristateMDR: entity work.TriStateGeneric GENERIC MAP (16) port map(mdr_out,EXE(mdrOut),BUS_DATA);  
	   tristateSRC: entity work.TriStateGeneric GENERIC MAP (16) port map(Q_SRC,EXE(srcOut),BUS_DATA);
	   
		aluGetOp: entity work.ALU_OPERATION port map(IR,Q_MIR,operationCode);
	   --constant dstIn: integer := 19;
END main_arch;
