library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.constants.all;

--operation codes
    -- mov (A)
    -- ADD (A + B)
    -- ADC (A + B + carry)
    -- SUB (A - B) dst is A src is B
    -- CMP (A - B) src is A dst is B
    -- SBC (A- B - carry)
    -- OR (A or B)
    -- AND (A and B)
    -- XNOR (A xnor B)
    -- one operand operations on B
    -- INC (B + 1)
    -- DEC (B - 1)
    -- INV (not B)
    -- CLR (clear B)
    -- LSR
    -- ROR
    -- RRC
    -- ASR
    -- LSL
    -- ROL
    -- RLC

entity alu is
    generic(n: integer := 16; m: integer := 5);
    port(
        operationControl: in std_logic_vector(m-1 downto 0);
        A, B: in std_logic_vector(n-1 downto 0);
        F: out std_logic_vector(n-1 downto 0);
        flagIn: in std_logic_vector(flagsCount-1 downto 0);
        flagOut: out std_logic_vector(flagsCount-1 downto 0));
end entity alu;

architecture aluArch of alu is
    signal sigA, sigB, sigF, subTowsCompB, sbcResult, carryTwosComp: std_logic_vector(n-1 downto 0);
    signal carryIn, carryOut, sbcCarryOut: std_logic;
    signal FTemp: std_logic_vector(n-1 downto 0);
    constant ZEROS: std_logic_vector(n-1 downto 0):= (others=>'0');
    begin
        F <= FTemp;
        
        fAdder: entity work.nbitAdder generic map(n) port map(sigB, sigA, carryIn, sigF, carryOut);
        twosSUB: entity work.TwosComplement generic map(n) port map(B, subTowsCompB);
        sbcB: entity work.nbitAdder generic map(n) port map(carryTwosComp, sigF, '0', sbcResult, sbcCarryOut);

        carryTwosComp <= (others => '1') when flagIn(cFlag) = '1'
        else (others => '0');
        
        sigB <= A when operationControl = OperationSUB or operationControl = OperationCMP or operationControl = OperationSBC
        else B;

        sigA <= subTowsCompB when operationControl = OperationSUB or operationControl = OperationCMP or operationControl = OperationSBC
        else (others => '0') when operationControl = OperationINC
        else (others => '1') when operationControl = OperationDEC
        else A;

        carryIn <= flagIn(cFlag) when operationControl = OperationADC
        else '1' when operationControl = OperationINC
        else '0';

        FTemp <= A when operationControl = OperationMOV
        else (others => '0') when (operationControl = OperationNOP or operationControl = OperationCLR)
        else sigF when (operationControl = OperationADD or operationControl = OperationADC or operationControl = OperationSUB 
                        or operationControl = OperationCMP or operationControl = OperationINC 
                        or operationControl = OperationDEC)
        else sbcResult when operationControl = OperationSBC
        else (A and B) when operationControl = OperationAND
        else (A or B) when operationControl = OperationOR
        else (A xnor B) when operationControl = OperationXNOR
        else (B(0) & B(n-1 downto 1)) when operationControl = OperationROR 
        else (flagIn(cFlag) & B(n-1 downto 1)) when operationControl = OperationRRC
        else (B(n-2 downto 0) & B(n-1)) when operationControl = OperationROL
        else (B(n-2 downto 0) & flagIn(cFlag)) when operationControl = OperationRLC
        else not(B) when operationControl = OperationINV
        else (B(n-2 downto 0) & '0') when operationControl = OperationLSL
        else ('0' & B(n-1 downto 1)) when operationControl = OperationLSR
        else (B(n-1) & B(n-1 downto 1)) when operationControl = OperationASR
        else (others => 'Z');
        
        --carry flag
        --if no op change zero flag happened flagOut(cFlag) = flagIn(cFlag)
        flagOut(cFlag) <= carryOut  when (operationControl = OperationADD or operationControl = OperationADC or operationControl = OperationSUB
                                    or operationControl = OperationCMP or operationControl = OperationINC 
                                    or operationControl = OperationDEC)
        else sbcCarryOut when operationControl = OperationSBC
        else B(0) when operationControl = OperationRRC or operationControl = OperationLSR or operationControl = OperationASR
        else B(n-1) when operationControl = OperationLSL or operationControl = OperationRLC
        else flagIn(cFlag);

        --zero flag
        --if no op change zero flag happened flagOut(zFlag) = flagIn(zFlag)
        flagOut(zFlag) <= flagIn(zFlag) 
            when (operationControl = OperationMOV or operationControl = OperationNOP)
        else '1' when  FTemp = ZEROS
        else '0';

        --negative flag
        --if no op change neg flag happened flagOut(nFlag) = flagIn(nFlag)
        flagOut(nFlag) <= flagIn(nFlag) 
            when(operationControl = OperationMOV or operationControl = OperationNOP) 
        else FTemp(n-1);

        --overflow flag
        --if no op change neg flag happened flagOut(oFlag) = flagIn(oFlag)
        flagOut(oFlag) <= flagIn(oFlag) 
            when(operationControl = OperationMOV or operationControl = OperationNOP) 
        else '1' 
            when ( --if p-n=n or n-p=p
                (((A(n-1) xor B(n-1)) = '1') and FTemp(n-1) = not(A(n-1)) 
                    and (operationControl = OperationSUB 
                        or operationControl = OperationSBC 
                        or operationControl = OperationCMP))
                or --if n+n=p or p+p=n
                (((A(n-1) xnor B(n-1)) = '1') and FTemp(n-1) = not(A(n-1)) 
                    and (operationControl = OperationADD or operationControl = OperationADC))
                )
        else '0';

        --parity flag
        --if no op change neg flag happened flagOut(pFlag) = flagIn(pFlag)
        --flagOut(pFlag) <= flagIn(pFlag) 
        --    when(operationControl = OperationMOV or operationControl = OperationNOP) 
        --else not(FTemp(0));
	--sigParity <= xor FTemp;
	--variable sigParity: std_logic := 0;
	--for i in FTemp'range loop:
  	--    sigParity := sigParity xor FTemp(i);
	--end loop;
	flagOut(pFlag) <= flagIn(pFlag) 
            when(operationControl = OperationMOV or operationControl = OperationNOP) 
        else not(FTemp(0));
end architecture;