Library IEEE;
use ieee.std_logic_1164.all;

-- MUX4 Entity
ENTITY Mux4 IS
	Generic(wordSize:integer :=32);
	PORT(
		A, B, C, D: in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
		S: in STD_LOGIC_VECTOR(1 DOWNTO 0);
		Z: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);
END ENTITY Mux4;

-- MUX4 Architecture
ARCHITECTURE Mux4Arch of Mux4 is
    BEGIN
        Z <= A when S = "00"
        else B when S = "01"
        else C when S = "10"
        else D when S = "11";
END ARCHITECTURE;
