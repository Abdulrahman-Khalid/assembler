library ieee;
use ieee.std_logic_1164.all;

entity ROM is
	port ( Address : in  std_logic_vector(4 downto 0);
		NextAddress : out std_logic_vector(15 downto 0));
end entity ROM;

architecture Behavioral of ROM is
begin
	process(Address)
    begin
        ---Instruction------NxtAdd-----F1-----F2-----F3-----F4-----F6--
        case Address is
        -- A0 Instruction
		when "00000" =>
		NextAddress <= "01011" & "001" & "11" & "01" & "00" & "01";	
        -- B0 Instruction
		when "00001" =>
        NextAddress <= "01101" & "001" & "11" & "01" & "00" & "01";
        -- F0 Instruction
        when "00010" =>
        NextAddress <= "10001" & "101" & "11" & "00" & "00" & "00";
        -- G0 Instruction
        when "00011" =>
        NextAddress <= "10010" & "101" & "11" & "01" & "00" & "01";
        -- H0 Instruction - Bit ORed
        when "00100" =>
        NextAddress <= "01000" & "101" & "00" & "01" & "00" & "01";
        -- I0 Instruction
        when "00101" =>
        NextAddress <= "10011" & "001" & "00" & "00" & "01" & "00";
        -- 1OP0 Instruction
        when "00110" =>
        NextAddress <= "10101" & "101" & "11" & "00" & "00" & "00";
        -- 2OP0 Instruction - Bit ORed
        when "00111" =>
        NextAddress <= "10101" & "100" & "00" & "00" & "01" & "00";
        -- C* Instruction
        when "01000" =>
        NextAddress <= "01001" & "010" & "00" & "01" & "00" & "01";
        -- C Instruction
        when "01001" =>
        NextAddress <= "11000" & "010" & "00" & "00" & "10" & "00";
        -- UNUSED Instruction
        when "01010" =>
        NextAddress <= "01010" & "000" & "00" & "00" & "00" & "00";
        -- A1 Instruction
        when "01011" =>
        NextAddress <= "01100" & "011" & "01" & "00" & "00" & "00";
        -- A2 Instruction - Bit ORed
        when "01100" =>
        NextAddress <= "01010" & "010" & "10" & "00" & "00" & "00";
        -- B1 Instruction
        when "01101" =>
        NextAddress <= "01110" & "011" & "01" & "00" & "00" & "00";
        -- B2 Instruction
        when "01110" =>
        NextAddress <= "01111" & "010" & "00" & "00" & "01" & "00";
        -- B3 Instruction
        when "01111" =>
        NextAddress <= "10000" & "101" & "11" & "00" & "00" & "00";
        -- B4 Instruction - Bit ORed
        when "10000" =>
        NextAddress <= "01000" & "011" & "00" & "01" & "00" & "01";
        -- F1 Instruction - Bit ORed
        when "10001" =>
        NextAddress <= "01000" & "011" & "00" & "01" & "11" & "01";
        -- G1 Instruction - Bit ORed
        when "10010" =>
        NextAddress <= "01000" & "011" & "00" & "00" & "11" & "00";
        -- I1 Instruction
        when "10011" =>
        NextAddress <= "10100" & "101" & "11" & "00" & "00" & "00";
        -- I2 Instruction
        when "10100" =>
        NextAddress <= "00000" & "011" & "01" & "00" & "00" & "00";
        -- 1OP1 Instruction
        when "10101" =>
        NextAddress <= "00000" & "011" & "00" & "00" & "11" & "00";
        -- 2OP1 Instruction - Bit ORed
        when "10110" =>
        NextAddress <= "10111" & "101" & "11" & "00" & "00" & "00";
        -- 2OP2 Instruction
        when "10111" =>
        NextAddress <= "00000" & "011" & "00" & "00" & "11" & "00";
        -- D Instruction - Bit ORed
        when "11000" =>
        NextAddress <= "01010" & "000" & "00" & "00" & "00" & "00";
		when others =>
		NextAddress <= "10101" & "000" & "00" & "00" & "00" & "00";	
		end case;
	end process;
end architecture;