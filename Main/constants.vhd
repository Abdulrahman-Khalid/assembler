library IEEE;
USE IEEE.std_logic_1164.all;
package constants is
--registers
    constant R0: std_logic_vector(2 downto 0) := "000";
    constant R1: std_logic_vector(2 downto 0) := "001";
    constant R2: std_logic_vector(2 downto 0) := "010";
    constant R3: std_logic_vector(2 downto 0) := "011";
    constant R4: std_logic_vector(2 downto 0) := "100";
    constant R5: std_logic_vector(2 downto 0) := "101";
    constant R6: std_logic_vector(2 downto 0) := "110";
    constant R7: std_logic_vector(2 downto 0) := "111";
--Instruction Type
    constant twoOperandInstruction: std_logic_vector(1 downto 0) := "00";
    constant oneOperandInstruction: std_logic_vector(1 downto 0) := "01";
    constant MemoryInstruction: std_logic_vector(1 downto 0) := "10";
    constant branchInstruction: std_logic_vector(1 downto 0) := "11";
--ALU operations
    constant OperationNOP: std_logic_vector(4 downto 0) :=  "00000";
    constant OperationADD: std_logic_vector(4 downto 0) :=  "00001";
    constant OperationSUB: std_logic_vector(4 downto 0) :=  "00010";
    constant OperationADC: std_logic_vector(4 downto 0) :=  "00011";
    constant OperationSBC: std_logic_vector(4 downto 0) :=  "00100";
    constant OperationAND: std_logic_vector(4 downto 0) :=  "00101";
    constant OperationOR: std_logic_vector(4 downto 0) :=  "00110";
    constant OperationXNOR: std_logic_vector(4 downto 0) :=  "00111";
    constant OperationINC: std_logic_vector(4 downto 0) :=  "01000";
    constant OperationDEC: std_logic_vector(4 downto 0) :=  "01001";
    constant OperationINV: std_logic_vector(4 downto 0) :=  "01010";
    constant OperationLSL: std_logic_vector(4 downto 0) :=  "01011";
    constant OperationROR: std_logic_vector(4 downto 0) :=  "01100";
    constant OperationRRC: std_logic_vector(4 downto 0) :=  "01101";
    constant OperationASR: std_logic_vector(4 downto 0) :=  "01110";
    constant OperationLSR: std_logic_vector(4 downto 0) :=  "01111";
    constant OperationROL: std_logic_vector(4 downto 0) :=  "10000";
    constant OperationRLC: std_logic_vector(4 downto 0) :=  "10001";
    constant OperationCLR: std_logic_vector(4 downto 0) :=  "10010";
    constant OperationCMP: std_logic_vector(4 downto 0) :=  "10100";
    constant OperationMOV: std_logic_vector(4 downto 0) :=  "11000";
    --flags 
    constant flagsCount: integer :=5;
    constant cFlag: integer :=0; --carry flag
    constant zFlag: integer :=1; --zero flag
    constant nFlag: integer :=2; --negative flag
    constant OFlag: integer :=3; --overflow flag
    constant pFlag: integer :=4; --parity flag
    --23 EXE signals
    --F1 -- 0 no trans
    constant pcOut: integer := 1;
    constant mdrOut: integer := 2;
    constant zOut: integer := 3;
    constant srcOut: integer := 4;
    constant dstOut: integer := 5;
    -- 6,7 not used
    --F2 -- 8 no trans 
    constant pcIn: integer := 9;
    constant irIn: integer := 10;
    constant zIn: integer := 11;
    --F3 --12 no trans
    constant marIn: integer := 13;
    constant mdrIn: integer := 14;
    --15 not used
    --F4 --16 no trans
    constant yIn: integer := 17;
    constant srcIn: integer := 18;
    constant dstIn: integer := 19;
    --F6 --20 no trans
    constant exeRead: integer := 21;
    constant exeWrite: integer := 22;
    --23 not used
    
    --ADDRESSES
    constant A0_NEXT: std_logic_vector(4 downto 0) :=  "01011";
    constant B0_NEXT: std_logic_vector(4 downto 0) :=  "01101";
    constant B3_NEXT: std_logic_vector(4 downto 0) :=  "10000";
    constant F0_NEXT: std_logic_vector(4 downto 0) :=  "10001";
    constant G0_NEXT: std_logic_vector(4 downto 0) :=  "10010";
    constant I1_NEXT: std_logic_vector(4 downto 0) :=  "10100";
    constant OP2_1_NEXT: std_logic_vector(4 downto 0) :=  "10111";
    constant OP1_0_NEXT: std_logic_vector(4 downto 0) :=  "10101";

    --OPCODES
    constant MOV_OPCODE: std_logic_vector(3 downto 0) :=  "0001";	
    constant ADD_OPCODE: std_logic_vector(3 downto 0) :=  "0110";
    constant ADC_OPCODE: std_logic_vector(3 downto 0) :=  "0100";
    constant SUB_OPCODE: std_logic_vector(3 downto 0) :=  "1110";
    constant SBC_OPCODE: std_logic_vector(3 downto 0) :=  "1001";
    constant AND_OPCODE: std_logic_vector(3 downto 0) :=  "0011";
    constant OR_OPCODE: std_logic_vector(3 downto 0) :=  "0101";
    constant XNOR_OPCODE: std_logic_vector(3 downto 0) :=  "0111";
    constant CMP_OPCODE: std_logic_vector(3 downto 0) :=  "0010";

    constant INC_OPCODE: std_logic_vector(9 downto 0) :=  "0000101010";
    constant DEC_OPCODE: std_logic_vector(9 downto 0) :=  "0000101011";
    constant CLR_OPCODE: std_logic_vector(9 downto 0) :=  "0000101000";
    constant INV_OPCODE: std_logic_vector(9 downto 0) :=  "0000101100";
    constant LSR_OPCODE: std_logic_vector(9 downto 0) :=  "0000110101";
    constant ROR_OPCODE: std_logic_vector(9 downto 0) :=  "0000110000";
    constant RRC_OPCODE: std_logic_vector(9 downto 0) :=  "1000110000";
    constant ASR_OPCODE: std_logic_vector(9 downto 0) :=  "0000110010";
    constant LSL_OPCODE: std_logic_vector(9 downto 0) :=  "0000110110";
    constant ROL_OPCODE: std_logic_vector(9 downto 0) :=  "0000110001";
    constant RLC_OPCODE: std_logic_vector(9 downto 0) :=  "1000110001";
    
end constants;
    