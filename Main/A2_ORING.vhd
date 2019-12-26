LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY A2_ORING IS
PORT(ENABLE, CLK : STD_LOGIC;
     IR : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
     SRC_DEST_SELECTOR : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
     ADRESS: IN STD_LOGIC_VECTOR (15 DOWNTO 11);
     NEXT_ADD: OUT STD_LOGIC_VECTOR (15 DOWNTO 11));
     
END ENTITY A2_ORING;

ARCHITECTURE A2_ORING_ARCH OF A2_ORING IS
  BEGIN
    
    
    PROCESS (ENABLE, CLK)
    BEGIN
      IF (ENABLE='1' AND RISING_EDGE(CLK) AND IR(15 DOWNTO 6) = "0000000010") THEN -- NOP
        NEXT_ADD <= "00000";
      -- 1op or 2op fetching destination
      elsif(ENABLE='1' AND RISING_EDGE(CLK) AND SRC_DEST_SELECTOR = "01" AND (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1')) THEN
          if IR(5 DOWNTO 3) = "011" OR IR(5 DOWNTO 3) = "111" THEN -- START OF INDEXED 
                  NEXT_ADD <= "00001";
          ELSIf IR(5 DOWNTO 3) = "101" OR IR(5 DOWNTO 3) = "001" THEN -- START OF AUTO INC 
                  NEXT_ADD <= "00011";
          ELSif IR(5 DOWNTO 3) = "010" OR IR(5 DOWNTO 3) = "110" THEN -- START OF AUTO DEC
                  NEXT_ADD <= "00010";
          ELSif IR(5 DOWNTO 3) = "111" THEN -- START OF REG INDIRECT
                  NEXT_ADD <= "00100";
          ELSif (ir(14) = '1' or ir(13) = '1' or ir(12) = '1') THEN
                  NEXT_ADD <= "00111";
          ELSE
                  NEXT_ADD <= "00110";     --REGISTER DIRECT DONE FETCH WE SHOULD GO TO 1OP0 !
          END IF;
      --2op fetching source
      elsif(ENABLE='1' AND RISING_EDGE(CLK) AND SRC_DEST_SELECTOR = "10" AND (ir(14) = '1' or ir(13) = '1' or ir(12) = '1')) THEN
          if IR(11 DOWNTO 9) = "011" OR IR(11 DOWNTO 9) = "111" THEN -- START OF INDEXED 
                  NEXT_ADD <= "00001";
          ELSif IR(11 DOWNTO 9) = "101" OR IR(11 DOWNTO 9) = "001" THEN -- START OF AUTO INC 
                  NEXT_ADD <= "00011";
          ELSif IR(11 DOWNTO 9) = "010" OR IR(11 DOWNTO 9) = "110" THEN -- START OF AUTO DEC
                  NEXT_ADD <= "00010";
          ELSif IR(11 DOWNTO 9) = "111" THEN -- START OF REG INDIRECT
                  NEXT_ADD <= "00100";
          ELSE
                  NEXT_ADD <= ADRESS;  
          END IF;  
      --Branch fetching destination
      elsif(ENABLE='1' AND RISING_EDGE(CLK) AND  SRC_DEST_SELECTOR = "01") THEN
                  NEXT_ADD <= "00101";             --I0 
      ELSE
        NEXT_ADD <= ADRESS;
      END IF;
       
    END PROCESS;
    
    --NEXT_ADD <= "00000" WHEN ADRESS="01010" AND IR = "0000000010" 
     --       ELSE ADRESS;

    
  END ARCHITECTURE A2_ORING_ARCH;

