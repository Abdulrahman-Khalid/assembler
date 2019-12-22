LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_registers is
    port(ir,r0,r1,r2,r3,r4,r5,r6,r7: in std_logic_vector (15 downto 0);
         selector: in std_logic_vector(1 downto 0);
         dst: out std_logic_vector(15 downto 0));
end entity;

architecture my_fetch of fetch_registers is
  begin
    dst <= r0 when ir(8 downto 6) = "000" and selector = "10" else
           r1 when ir(8 downto 6) = "001" and selector = "10" else
           r2 when ir(8 downto 6) = "010" and selector = "10" else
           r3 when ir(8 downto 6) = "011" and selector = "10" else
           r4 when ir(8 downto 6) = "100" and selector = "10" else
           r5 when ir(8 downto 6) = "101" and selector = "10" else
           r6 when ir(8 downto 6) = "110" and selector = "10" else
           r7 when ir(8 downto 6) = "111" and selector = "10" else
           
           r0 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "000" and selector = "01" else
           r1 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "001" and selector = "01" else
           r2 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "010" and selector = "01" else
           r3 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "011" and selector = "01" else
           r4 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "100" and selector = "01" else
           r5 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "101" and selector = "01" else
           r6 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "110" and selector = "01" else
           r7 when (ir(14) = '1' or ir(13) = '1' or ir(12) = '1' or ir(11) = '1') and ir(2 downto 0) = "111" and selector = "01" else
           
           std_logic_vector(to_signed(to_integer(signed(ir(7 downto 0))),16));
            
end my_fetch;