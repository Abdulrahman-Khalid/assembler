LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity return_data is
    port(ir,r0,r1,r2,r3,r4,r5,r6,r7,dst: in std_logic_vector (15 downto 0);
         r0_out,r1_out,r2_out,r3_out,r4_out,r5_out,r6_out,r7_out: out std_logic_vector (15 downto 0);
         to_ram: out std_logic);
end entity;
         
architecture checking of return_data is
  begin
    r0_out <= dst when ir(2 downto 0) = "000" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r0))+1,16)) when 
                    (ir(8 downto 6) = "000" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "000" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r0))-1,16)) when 
                    (ir(8 downto 6) = "000" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "000" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r0;
    r1_out <= dst when ir(2 downto 0) = "001" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r1))+1,16)) when 
                    (ir(8 downto 6) = "001" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "001" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r1))-1,16)) when 
                    (ir(8 downto 6) = "001" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "001" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r1;
    r2_out <= dst when ir(2 downto 0) = "010" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r2))+1,16)) when 
                    (ir(8 downto 6) = "010" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "010" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r2))-1,16)) when 
                    (ir(8 downto 6) = "010" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "010" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r2;
    r3_out <= dst when ir(2 downto 0) = "011" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r3))+1,16)) when 
                    (ir(8 downto 6) = "011" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "011" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r3))-1,16)) when 
                    (ir(8 downto 6) = "011" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "011" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r3;
    r4_out <= dst when ir(2 downto 0) = "100" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r4))+1,16)) when 
                    (ir(8 downto 6) = "100" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "100" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r4))-1,16)) when 
                    (ir(8 downto 6) = "100" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "100" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r4;
    r5_out <= dst when ir(2 downto 0) = "101" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r5))+1,16)) when 
                    (ir(8 downto 6) = "101" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "101" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r5))-1,16)) when
                    (ir(8 downto 6) = "101" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "101" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r5;
    r6_out <= dst when ir(2 downto 0) = "110" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r6))+1,16)) when 
                    (ir(8 downto 6) = "110" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "110" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r6))-1,16)) when
                    (ir(8 downto 6) = "110" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "110" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r6;
    r7_out <= dst when ir(2 downto 0) = "111" and ir(5 downto 3) = "000" and ir(15 downto 12)/="0010" else
              std_logic_vector(to_signed(to_integer(signed(r7))+1,16)) when
                    (ir(8 downto 6) = "111" and (ir(11 downto 9) = "001" or ir(11 downto 9) = "101")) or 
                    (ir(2 downto 0) = "111" and (ir(5 downto 3) = "001" or ir(5 downto 3) = "101")) else
              std_logic_vector(to_signed(to_integer(signed(r7))-1,16)) when 
                    (ir(8 downto 6) = "111" and (ir(11 downto 9) = "010" or ir(11 downto 9) = "110")) or 
                    (ir(2 downto 0) = "111" and (ir(5 downto 3) = "010" or ir(5 downto 3) = "110")) else
              r7;
              
    to_ram <= '0' when ir(5 downto 3) = "000" or ir(15 downto 12)="0010" else
              '1';
                   
end checking;