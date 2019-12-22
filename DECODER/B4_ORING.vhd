LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY B4_ORING IS
  PORT (IR5, IR11 :IN STD_LOGIC;
        SRC_DEST_SELECTOR : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        ADRESS :IN STD_LOGIC_VECTOR (15 DOWNTO 11);
        NEXT_ADD :INOUT STD_LOGIC_VECTOR (15 DOWNTO 11));
     
END ENTITY;


    
ARCHITECTURE B4_ORING_ARCH OF B4_ORING IS
  BEGIN
    
     
  NEXT_ADD <= "01001" WHEN ADRESS = "01000" AND ((SRC_DEST_SELECTOR="00" AND IR11='0')
                                               OR (SRC_DEST_SELECTOR="01" AND IR5='0')) ELSE
              ADRESS;

  END ARCHITECTURE B4_ORING_ARCH;
