LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY D_ORING IS
PORT(ENABLE, CLK : STD_LOGIC;
     IR_OPERATION : IN STD_LOGIC_VECTOR (14 DOWNTO 6);
     ADRESS : IN STD_LOGIC_VECTOR (15 DOWNTO 11);
     NEXT_ADD : OUT STD_LOGIC_VECTOR (15 DOWNTO 11));
     --NXT: OUT STD_LOGIC_VECTOR (15 DOWNTO 11));
   END ENTITY D_ORING;
   
ARCHITECTURE D_ORING_ARCH OF D_ORING IS
BEGIN
  
   PROCESS (ENABLE, CLK)
    BEGIN
      IF (ENABLE='1' AND RISING_EDGE(CLK) AND ADRESS="01010" AND (IR_OPERATION(14)='1' OR IR_OPERATION(13)='1' OR IR_OPERATION(12)='1')) THEN
        NEXT_ADD <= "00111";
      ELSIF (ENABLE='1' AND RISING_EDGE(CLK) AND ADRESS="01010" AND (IR_OPERATION(14)='1' OR IR_OPERATION(13)='1' OR IR_OPERATION(12)='1')) THEN
        NEXT_ADD <= "00110";
      ELSIF (ENABLE='1' AND RISING_EDGE(CLK) AND ADRESS="01010" AND IR_OPERATION(11)='1' AND IR_OPERATION(9)='1') THEN
        NEXT_ADD <= "00110";
      ELSIF (ENABLE='1' AND RISING_EDGE(CLK) AND ADRESS="01010" AND IR_OPERATION(10 DOWNTO 7)="0001") THEN
        NEXT_ADD <= "00000";   
       ELSIF (ENABLE='1' AND RISING_EDGE(CLK) AND ADRESS="01010" AND IR_OPERATION(10 DOWNTO 7)="0000") THEN
        NEXT_ADD <= "00000"; 
       ELSIF (ENABLE='1' AND RISING_EDGE(CLK) AND ADRESS="01010") THEN
        NEXT_ADD <= "00101"; 
       ELSE 
        NEXT_ADD <= ADRESS;  
      END IF;
       
    END PROCESS; 
  
 -- NEXT_ADD <=  "00111" WHEN ADRESS="01010" AND (IR_OPERATION(14)='1' OR IR_OPERATION(13)='1' OR IR_OPERATION(12)='1') ELSE 
 --              "00110" WHEN ADRESS="01010" AND (IR_OPERATION(14)='1' OR IR_OPERATION(13)='1' OR IR_OPERATION(12)='1') ELSE
 --              "00110" WHEN ADRESS="01010" AND IR_OPERATION(11)='1' AND IR_OPERATION(9)='1' ELSE
 --           	  "00000" WHEN ADRESS="01010" AND IR_OPERATION(10 DOWNTO 7)="0001" ELSE
 --           	  "00000" WHEN ADRESS="01010" AND IR_OPERATION(10 DOWNTO 7)="0000" ELSE
 --           	  "00101" WHEN ADRESS="01010" ELSE
 --           	  ADRESS;
END ARCHITECTURE D_ORING_ARCH;   
