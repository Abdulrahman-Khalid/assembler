
Library IEEE;
use ieee.std_logic_1164.all;

-- Register Entity
ENTITY Reg_SEL IS
	Generic(wordSize:integer :=32);
	PORT(
		D: in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
		en, clk, rst: in STD_LOGIC;
        Q: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
        Qbar: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);
END ENTITY Reg_SEL;

-- Register Architecture
ARCHITECTURE Reg_Arch of Reg_SEL is
BEGIN
	PROCESS(D,clk, en, rst)
		BEGIN
			IF rst ='1' THEN
           Q <= (others=>'0');
           Qbar <= (others=>'1');
      ELSIF en='1' THEN
           Q <= D;
           Qbar <= NOT D;
			END IF;
	END PROCESS;
END ARCHITECTURE;   