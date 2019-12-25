LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.math_real.all;

-- TristateGeneric Entity

ENTITY TristateGeneric IS
    GENERIC (wordSize : integer := 16);
    PORT(
            input : IN STD_LOGIC_VECTOR(wordSize-1  DOWNTO 0);
            en:IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
        );

END TristateGeneric;

-- Tristate Architecture
ARCHITECTURE TriStateGenericArch OF TristateGeneric IS

BEGIN
    output <= input WHEN en='1'
    else (others=>'Z');
END TriStateGenericArch;
