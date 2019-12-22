LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity first_mir is
    port(ir: in std_logic_vector (15 downto 0);
         selector: in std_logic_vector(1 downto 0);
         next_instruction: out std_logic_vector(4 downto 0));
end entity;
         
architecture micro_ir of first_mir is
  begin
    next_instruction <= "00001" when (ir(11 downto 9) = "011" or ir(11 downto 9) = "111") and selector = "10" else --indexed
                        "00010" when (ir(11 downto 9) = "110" or ir(11 downto 9) = "010") and selector = "10" else -- auto decrement
                        "00011" when (ir(11 downto 9) = "101" or ir(11 downto 9) = "001") and selector = "10" else -- auto increment
                        "00100" when ir(11 downto 9) = "100" and selector = "10" else -- Register indirect
                        
                        "00001" when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and (ir(5 downto 3) = "011" or ir(5 downto 3) = "111") and selector = "01" else --indexed
                        "00010" when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and (ir(5 downto 3) = "110" or ir(5 downto 3) = "010") and selector = "01" else -- auto decrement
                        "00011" when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and (ir(5 downto 3) = "101" or ir(5 downto 3) = "001") and selector = "01" else -- auto increment
                        "00100" when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(5 downto 3) = "100" and selector = "01" else -- Register indirect
                        
                        "00101" when ir(14 downto 11) =  "0000" and selector = "01" else --Branch
                        
                        "00000"; --Register direct 
end micro_ir;

