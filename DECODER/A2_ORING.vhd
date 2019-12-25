LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY A2_ORING IS
PORT(
     IR : IN STD_LOGIC_VECTOR (15 DOWNTO 6);
     ADRESS: IN STD_LOGIC_VECTOR (15 DOWNTO 11);
     NEXT_ADD: OUT STD_LOGIC_VECTOR (15 DOWNTO 11));
     
END ENTITY A2_ORING;

ARCHITECTURE A2_ORING_ARCH OF A2_ORING IS
  BEGIN
    
    NEXT_ADD <= "00000" WHEN ADRESS="01010" AND IR = "0000000010" 
            ELSE ADRESS;

    
  END ARCHITECTURE A2_ORING_ARCH;

