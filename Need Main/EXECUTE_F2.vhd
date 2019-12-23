LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY EXECUTE_F2 IS
PORT(
  MIR : IN STD_LOGIC_VECTOR( 7 DOWNTO 6);
  EN_REG_IN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
);

END ENTITY EXECUTE_F2;


ARCHITECTURE EXECUTE_F2_ARCH OF EXECUTE_F2 IS 
BEGIN 
  EN_REG_IN <= "0001" WHEN MIR="00"
             ELSE "0010" WHEN MIR="01"
             ELSE "0100" WHEN MIR="10"
             ELSE "1000";
              
              
END ARCHITECTURE EXECUTE_F2_ARCH;


