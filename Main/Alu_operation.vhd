library ieee;
use ieee.std_logic_1164.all;

entity ALU_OPERATION is
	port ( IR : in  std_logic_vector(15 downto 0);
		     ADDRESS: in std_logic(15 downto 11);
		     OPERATION_CODE : out std_logic_vector(5 downto 0));
end entity ALU_OPERATION;

architecture AL_OP of ALU_OPERATION is
begin           
  OPERATION <= OperationNOP when IR = "0000000010100000"  ELSE
               OperationADD when ADDRESS = B3_NEXT OR ADDRESS = I1_NEXT OR (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = ADD_OPCODE) ELSE
               OperationSUB when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = SUB_OPCODE) ELSE
               OperationADC when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = ADC_OPCODE) ELSE
               OperationSBC when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = SBC_OPCODE) ELSE
               OperationAND when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = AND_OPCODE) ELSE
               OperationOR when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = OR_OPCODE) ELSE
               OperationXNOR when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = XNOR_OPCODE) ELSE
               OperationINC when ADDRESS = A0_NEXT OR ADDRESS = B0_NEXT OR ADDRESS = G0_NEXT OR (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = INC_OPCODE) ELSE
               OperationDEC when ADDRESS = F0_NEXT OR (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = DEC_OPCODE) ELSE
               OperationINV when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = INV_OPCODE) ELSE
               OperationLSL when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = LSL_OPCODE) ELSE
               OperationROR when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = ROR_OPCODE) ELSE
               OperationRRC when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = RRC_OPCODE) ELSE
               OperationASR when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = ASR_OPCODE) ELSE
               OperationLSR when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = LSR_OPCODE) ELSE
               OperationROL when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = ROL_OPCODE) ELSE
               OperationRLC when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = RLC_OPCODE) ELSE
               OperationCLR when (ADDRESS = 1OP0_NEXT AND IR(15 DOWNTO 7) = CLR_OPCODE) ELSE
               OperationCMP when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = CMP_OPCODE) ELSE
               OperationMOV when (ADDRESS = 2OP1_NEXT AND IR(15 DOWNTO 12) = MOV_OPCODE);
END AL_OP;
