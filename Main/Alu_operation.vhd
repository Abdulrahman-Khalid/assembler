library ieee;
use ieee.std_logic_1164.all;
USE work.constants.all;

entity ALU_OPERATION is
	port ( IR : in  std_logic_vector(15 downto 0);
		     ADDRESS: in std_logic_vector(15 downto 11);
		     OPERATION_CODE : out std_logic_vector(4 downto 0));
end entity ALU_OPERATION;

architecture AL_OP of ALU_OPERATION is
begin           
  OPERATION_CODE <= OperationNOP when IR = "0000000010100000"  ELSE
               OperationADD when ADDRESS = B3_NEXT OR ADDRESS = I1_NEXT OR (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = ADD_OPCODE) ELSE
               OperationSUB when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = SUB_OPCODE) ELSE
               OperationADC when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = ADC_OPCODE) ELSE
               OperationSBC when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = SBC_OPCODE) ELSE
               OperationAND when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = AND_OPCODE) ELSE
               OperationOR when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = OR_OPCODE) ELSE
               OperationXNOR when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = XNOR_OPCODE) ELSE
               OperationINC when ADDRESS = A0_NEXT OR ADDRESS = B0_NEXT OR ADDRESS = G0_NEXT OR (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = INC_OPCODE) ELSE
               OperationDEC when ADDRESS = F0_NEXT OR (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = DEC_OPCODE) ELSE
               OperationINV when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = INV_OPCODE) ELSE
               OperationLSL when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = LSL_OPCODE) ELSE
               OperationROR when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = ROR_OPCODE) ELSE
               OperationRRC when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = RRC_OPCODE) ELSE
               OperationASR when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = ASR_OPCODE) ELSE
               OperationLSR when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = LSR_OPCODE) ELSE
               OperationROL when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = ROL_OPCODE) ELSE
               OperationRLC when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = RLC_OPCODE) ELSE
               OperationCLR when (ADDRESS = OP1_0_NEXT AND IR(15 DOWNTO 6) = CLR_OPCODE) ELSE
               OperationCMP when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = CMP_OPCODE) ELSE
               OperationMOV when (ADDRESS = OP2_1_NEXT AND IR(15 DOWNTO 12) = MOV_OPCODE);
END AL_OP;

