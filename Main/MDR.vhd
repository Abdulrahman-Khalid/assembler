LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MDR IS
    GENERIC (n : integer := 16);
    PORT(Clk,RST, enBusWrite, enReadFromMem: IN std_logic; mem_to_mdr, bus_to_mdr : IN std_logic_vector(n-1 DOWNTO 0); mdr_out : OUT std_logic_vector(n-1 DOWNTO 0));
END MDR;

ARCHITECTURE ARCH_MDR OF MDR IS
BEGIN
    PROCESS(Clk, RST, enBusWrite, enReadFromMem, mem_to_mdr, bus_to_mdr)
    BEGIN
        IF RST ='1' THEN
            mdr_out <= (others=>'0');
        ELSIF clk'EVENT AND clk='1' AND enBusWrite='1' THEN
            mdr_out <= bus_to_mdr;
        ELSIF enReadFromMem'EVENT THEN
            mdr_out <= mem_to_mdr;
        END IF;
    END PROCESS;
END ARCH_MDR;
