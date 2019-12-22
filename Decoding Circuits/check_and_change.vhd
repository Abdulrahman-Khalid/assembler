LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity check_and_change is
    port(dst,src: in std_logic_vector (15 downto 0);
         selector: in std_logic_vector(1 downto 0);
         new_src: out std_logic_vector (15 downto 0);
         new_selector: out std_logic_vector(1 downto 0));
end entity;
         
architecture checking of check_and_change is
  begin
    new_selector <= "01" when selector = "10" else
                    "00" when selector = "01";
    
    new_src <= dst when selector = "10" else
               src when selector = "01"; 
end checking;