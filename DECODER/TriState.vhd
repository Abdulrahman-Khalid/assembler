LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY TRI_STATE IS
	PORT(input  : IN std_logic_vector(15 DOWNTO 11);
       Enable : IN std_logic;
	     output : OUT std_logic_vector(15 DOWNTO 11));
END TRI_STATE;

ARCHITECTURE A_TRI_STATE OF TRI_STATE IS
BEGIN
	 output <= input WHEN Enable = '1' ELSE (OTHERS => 'Z');
END A_TRI_STATE;
