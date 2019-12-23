LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY RAM IS
	GENERIC (wordSize : integer := 16; addressWidth: integer := 12; RAMSize: integer := 4096);
	PORT(	
		W  : IN std_logic;
		R  : IN std_logic;
		address : IN  std_logic_vector(addressWidth - 1 DOWNTO 0);
		dataInOut  : INOUT  std_logic_vector(wordSize - 1 DOWNTO 0));
END ENTITY RAM;

ARCHITECTURE RAM_arch OF RAM IS
    TYPE RAMType IS ARRAY(RAMSize - 1 DOWNTO 0) of std_logic_vector(wordSize - 1 DOWNTO 0);
    SIGNAL RAM : RAMType ;

BEGIN
 
PROCESS(W) IS
	BEGIN
	IF W = '1' THEN  
        RAM(to_integer(unsigned(address))) <= dataInOut;
	END IF;
END PROCESS;

PROCESS(R) IS
	BEGIN
	IF R = '1' THEN  
        dataInOut <= RAM(to_integer(unsigned(address)));
	END IF;
END PROCESS;
END RAM_arch;
