LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY TWO_OP0_ORING IS
  PORT (ENABLE, CLK : STD_LOGIC;
        IR: IN STD_LOGIC_VECTOR (15 DOWNTO 12);
        ADRESS : IN STD_LOGIC_VECTOR (15 DOWNTO 11);
        NEXT_ADD: OUT STD_LOGIC_VECTOR (15 DOWNTO 11));
    
    
    
END ENTITY TWO_OP0_ORING;
  
ARCHITECTURE TWO_OP0_ORING_ARCH OF TWO_OP0_ORING IS 

BEGIN
  
  PROCESS (ENABLE, CLK)
    BEGIN
      IF (ENABLE='1' AND RISING_EDGE(CLK) AND ADRESS = "10110" AND IR = "0001" ) THEN
        NEXT_ADD <= "10111";
      ELSE 
        NEXT_ADD <= ADRESS;
      END IF;
       
    END PROCESS;
  
 -- NEXT_ADD <= "10111" WHEN ADRESS = "10110" AND IR = "0001" ELSE
  --            ADRESS;
     
END TWO_OP0_ORING_ARCH;
  
