library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.constants.all;

entity alu_tb is
end entity;

architecture tb of alu_tb is
    constant OperationSUB: std_logic_vector(4 downto 0) :=  "00010";
    constant OperationCMP: std_logic_vector(4 downto 0) :=  "10100";
    constant OperationADC: std_logic_vector(4 downto 0) :=  "00011";
    constant OperationSBC: std_logic_vector(4 downto 0) :=  "00100";

    constant CLK_FREQ : integer := 100e6; -- 100 MHz
    constant CLK_PER  : time    := 1000 ms / CLK_FREQ;
    constant operationCodeBits:integer := 5;
    constant numOfFlags:integer := 5;
    constant bitsNum:integer := 16;
    signal clk: std_logic := '0';

    signal a, b, f : std_logic_vector(bitsNum-1 downto 0);
    signal flagIn, flagOut : std_logic_vector(numOfFlags-1 downto 0);
    signal operationControl : std_logic_vector(operationCodeBits-1 downto 0);

    variable result:  std_logic_vector(bitsNum-1 downto 0);
    variable flagResult:  std_logic_vector(flagsCount-1 downto 0);
begin
    clk <= not clk after CLK_PER / 2;
    alu : entity work.alu generic map(n => bitsNum, m => operationCodeBits) port map (operationControl => operationControl,a => A, b => B, f => F, flagIn => flagIn, flagOut => flagOut);
    
    f <= (others => 'Z');
    process
    begin
        -------------NOP-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="XXXXX";
        operationControl <= OperationNOP;
        wait for CLK_PER;
        result :=x"XXXX";
        flagResult:="XXXXX";
        assert (flagResult = flagOut and result = F ) report "NOP  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --------MOVE-------------------
        a <= x"FA0F"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationMOV;               
        wait for CLK_PER;
        result :=x"FA0F"  ;
        flagResult:="XXXXX";
        assert (flagResult = flagOut and result = F) report "MOVE ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;        
        ------------AND-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="XXXXX";
        operationControl <= OperationAND;
        wait for CLK_PER;
        result :=x"000A";
        flagResult:="10000";
        assert (flagResult = flagOut and result = F ) report "AND  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        -------------OR-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="XXXXX";
        operationControl <= OperationOR;
        wait for CLK_PER;
        result :=x"0F0F";
        flagResult:="XXXXX";
        assert (flagResult = flagOut and result = F ) report "OR  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        -------------XNOR-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="XXXXX";
        operationControl <= OperationXNOR;
        wait for CLK_PER;
        result :=x"F0FA";
        flagResult:="10100";
        assert (flagResult = flagOut and result = F ) report "XNOR  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        ---------- NOT ------------------
        a <= x"0000";
        b <= x"XXXX"; 
        flagIn<="XXXXX";
        operationControl <=OperationNOT;               
        wait for CLK_PER;
        result :=x"FFFF"  ;
        flagResult:="00100";
        assert (flagResult = flagOut and result = F ) report "NOT case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        a <= x"FFFF"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationINV;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F) report "NOT case 2 ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        --------Clear-------------------
        OperationMOV
        a <= x"FA0F"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationCLR;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F) report "CLR ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        --------dec-------------------
        a <= x"0001"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationDec;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F) report "dec ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        --------inc-------------------
        a <= x"0001"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationInc;               
        wait for CLK_PER;
        result :=x"0002"  ;
        flagResult:="10000";
        assert (flagResult = flagOut and result = F) report "inc case 1 ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;

        a <= x"FFFF"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationInc;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="01010";
        assert (flagResult = flagOut and result = F) report "inc case 2 ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        ----- LSL --------
        a <= x"FFFF"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationLSL;               
        wait for CLK_PER;
        result :=x"FFFE"  ;
        flagResult:="10101";
        assert (flagResult = flagOut and result = F) report "LSL ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        ----- LSR --------
        a <= x"FFFF"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationLSR;               
        wait for CLK_PER;
        result :=x"EFFF"  ;
        flagResult:="00001";
        assert (flagResult = flagOut and result = F) report "LSR ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        ------ROR---------
        a <= x"FFF0"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationROR;               
        wait for CLK_PER;
        result :=x"7FFF"  ;
        flagResult:="00000";
        assert (flagResult = flagOut and result = F) report "ROR case 1---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        
        a <= x"0000"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationROR;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F) report "ROR case 2---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        -----ROL---------
        a <= x"FFF0"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationROL;               
        wait for CLK_PER;
        result :=x"FFF1"  ;
        flagResult:="00000";
        assert (flagResult = flagOut and result = F) report "ROL case 1---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        
        a <= x"0000"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationROL;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F) report "ROL case 2---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        -----RLC---------
        a <= x"0011"; 
        b <= x"XXXX";
        flagIn<="XXXX1";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"0023"  ;
        flagResult:="00000";
        assert (flagResult = flagOut and result = F) report "RLC case 1---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;

        a <= x"0000"; 
        b <= x"XXXX";
        flagIn<="XXXX1";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"0001"  ;
        flagResult:="00000";
        assert (flagResult = flagOut and result = F) report "RLC case 2---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;

        a <= x"8000"; 
        b <= x"XXXX";
        flagIn<="XXXX0";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (flagResult = flagOut and result = F) report "RLC case 3---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        ------RRC--------
        a <= x"1100"; 
        b <= x"XXXX";
        flagIn<="XXXX1";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"8C00"  ;
        flagResult:="10100";
        assert (flagResult = flagOut and result = F) report "RLC case 1---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;

        a <= x"0000"; 
        b <= x"XXXX";
        flagIn<="XXXX1";
        operationControl<=OperationRRC;               
        wait for CLK_PER;
        result :=x"8000"  ;
        flagResult:="10100";
        assert (flagResult = flagOut and result = F) report "RRC case 2---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        
        a <= x"0001"; 
        b <= x"XXXX";
        flagIn<="XXXX0";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (flagResult = flagOut and result = F) report "RLC case 3---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        ----- LSR --------
        a <= x"FFFA"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationASR;               
        wait for CLK_PER;
        result :=x"FFFD"  ;
        flagResult:="00101";
        assert (flagResult = flagOut and result = F) report "ASR ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;
        
        a <= x"7FFE"; 
        b <= x"XXXX";
        flagIn<="XXXXX";
        operationControl<=OperationASR;               
        wait for CLK_PER;
        result :=x"3FFF"  ;
        flagResult:="00100";
        assert (flagResult = flagOut and result = F) report "ASR ---flag =   " & to_string(flagOut) &"  not equal to expected  "& to_string(flagResult)  severity error;    
        
        ---------- --------------------------   ADD   ----------------------------------------------------------
        --- case 1 (odrinary two positive numbers with no cary )
        a <= x"0010"; 
        b <= x"0010"; -- not importnat 
        flagIn<="XXXXX";
        Operation <=OperationADD;               
        wait for CLK_PER;
        result :=x"0020"  ;
        flagResult:="10000";
        assert (flagResult = flagOut and result= F ) report "add case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --- case 2 (odrinary two positive numbers with  overflow number will be negative )
        a <= x"7FFF"; 
        b <= x"7FFF"; -- not importnat 
        flagIn<="XXXXX";
        Operation <=OperationADD;               
        wait for CLK_PER;
        result :=x"FFFE"  ;
        flagResult:="11100";
        assert (flagResult = flagOut and result= F ) report "add case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --- case 3 (odrinary two negative numbers with  overflow number will be positive )
        a <= x"FFFF"; 
        b <= x"1FFF"; -- not importnat 
        flagIn<="XX11X";
        Operation <=OperationADD;               
        wait for CLK_PER;
        result :=x"1FFE"  ;
        flagResult:="11000";
        assert (flagResult = flagOut and result= F ) report "add case3  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        --- case 4 (negative number with  positive  )
        a <= x"F320"; 
        b <= x"0005"; -- not importnat 
        flagIn<="XXXXX";
        Operation <=OperationADD;               
        wait for CLK_PER;
        result :=x"F325"  ;
        flagResult:="00100";
        assert (flagResult = flagOut and result= F ) report "add case4  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        --- case 5 (negative + positive = 0   )
        a <= x"FFFD"; 
        b <= x"0003"; 
        flagIn<="XXXX1"; -- try with carry 1 should not affect
        Operation <=OperationADD;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="11010";
        assert (flagResult = flagOut and result= F ) report "add case5  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        --- case 6 (negative + negative =  negative  )
        a <= x"FFFD";  -- -3
        b <= x"FFFD"; --  -3  
        flagIn<="XXXXX";
        Operation <=OperationADD;               
        wait for CLK_PER;
        result :=x"FFFA"  ;  -- -6
        flagResult:="11100";
        assert (flagResult = flagOut and result= F ) report "add case6  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        ------------------------------- SUB -------------------------------
        --- a-b
        --p o n z c (flags)
        --- case 1 (odrinary two positive numbers with no cary )
        a <= x"0010"; 
        b <= x"0001"; -- not importnat 
        flagIn<="XXXXX";
        Operation <=OperationSUB;               
        wait for CLK_PER;
        result :=x"000F"  ;
        flagResult:="00001";
        assert (flagResult = flagOut and result= F ) report "sub case1  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        --- case 2 (positive - negative )
        a <= x"0010"; 
        b <= x"FFFF";  
        flagIn<="XXXXX";
        Operation <= OperationSUB;               
        wait for CLK_PER;
        result :=x"0011"  ;
        flagResult:="00000";
        assert (flagResult = flagOut and result= F ) report "sub case2  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        ----- case 3 ( negative - negative =0 )
        a <= x"FFFF"; 
        b <= x"FFFF";  
        flagIn<="XXXXX";
        Operation <= OperationSUB;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (flagResult = flagOut and result= F ) report "sub case3  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        ----- case 4 ( negative - negative = positive )
        a <= x"FFFF"; 
        b <= x"F325";  
        flagIn<="XXXXX";
        Operation <= OperationSUB;               
        wait for CLK_PER;
        result :=x"0CDA"  ;
        flagResult:="10001";
        assert (flagResult = flagOut and result= F ) report "sub case4  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        ----- case 5 ( negative - positive = negative )
        a <= x"FFFF"; 
        b <= x"0003";  
        flagIn<="XXXXX";
        Operation <= OperationSUB;               
        wait for CLK_PER;
        result :=x"FFFC"  ;
        flagResult:="10101";
        assert (flagResult = flagOut and result= F ) report "sub case5  ---flag =   " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;


        wait;
    end process;
end architecture;
