LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity operation_type is
    port(ir: in std_logic_vector (15 downto 0);
         selector: out std_logic_vector(1 downto 0));
end entity;
         
architecture op_type of operation_type is
  begin
    selector <= "10" when ir(14)='1' or ir(13)='1' or ir(12)='1' else  -- 2 operand
                "01" when ir(11)='1' or (ir(10)='1' or ir(9)='1') else -- 1 operand or Branch
                "00";
end op_type;

