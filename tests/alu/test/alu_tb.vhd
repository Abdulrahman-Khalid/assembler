Library IEEE;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
USE work.constants.all;
use ieee.math_real.all;

entity alu_tb is
end entity;

architecture tb of alu_tb is
    constant CLK_FREQ : integer := 100e6; -- 100 MHz
    constant CLK_PER  : time    := 1000 ms / CLK_FREQ;
    signal clk: std_logic := '0';
    signal a, b, f : std_logic_vector(15 downto 0);
    signal flagIn, flagOut : std_logic_vector(4 downto 0);
    signal operationControl : std_logic_vector(4 downto 0);
	constant Xs: std_logic_vector(15 downto 0):= (others=>'X');
    
    function to_string ( aa: std_logic_vector) return string is
    variable bb : string (1 to aa'length) := (others => NUL);
    variable stri : integer := 1; 
    begin
        for i in aa'range loop
            bb(stri) := std_logic'image(aa((i)))(2);
        stri := stri+1;
        end loop;
    return bb;
    end function;

begin
    clk <= not clk after CLK_PER / 2;
    alu : entity work.alu generic map(n => 16, m => 5) port map (operationControl => operationControl,a => A, b => B, f => F, flagIn => flagIn, flagOut => flagOut);
    process
    variable result:  std_logic_vector(15 downto 0);
    variable flagResult:  std_logic_vector(4 downto 0);
    begin
        -------------NOP-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="00000";
        operationControl <= OperationNOP;
        wait for CLK_PER;
        flagResult := "00000";
        result := x"0000";
        assert (flagResult = flagOut and result = F ) report "NOP ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --------MOVE-------------------
        a <= x"FA0F"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationMOV;               
        wait for CLK_PER;
        result :=x"FA0F"  ;
        flagResult:="00000";
        assert (flagResult = flagOut and result = F ) report "MOVE ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        ------------AND-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="00000";
        operationControl <= OperationAND;
        wait for CLK_PER;
        result :=x"000A";
        flagResult:="10000";
        assert (flagResult = flagOut and result = F ) report "AND ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        -------------OR-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="00000";
        operationControl <= OperationOR;
        wait for CLK_PER;
        result :=x"0F0F";
        flagResult:="00000";
        assert (flagResult = flagOut and result = F ) report "OR ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        -------------XNOR-----------------
        a <= x"0F0F";
        b <= x"000A";
        flagIn<="00000";
        operationControl <= OperationXNOR;
        wait for CLK_PER;
        result :=x"F0FA";
        flagResult:="10100";
        assert (flagResult = flagOut and result = F ) report "XNOR ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        ---------- NOT ------------------
        a <= x"0000";
        b <= x"0000"; 
        flagIn<="00000";
        operationControl <=OperationINV;               
        wait for CLK_PER;
        result :=x"FFFF"  ;
        flagResult:="00100";
        assert (flagResult = flagOut and result = F ) report "NOT 1 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        a <= x"FFFF"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationINV;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F ) report "NOT 2 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --------Clear-------------------
        a <= x"FA0F"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationCLR;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F ) report "CLR ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --------dec-------------------
        --p o n z c (flags)
        a <= x"0001"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationDec;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (flagResult = flagOut and result = F ) report "DEC ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --------inc-------------------
        a <= x"0001"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationInc;               
        wait for CLK_PER;
        result :=x"0002"  ;
        flagResult:="10000";
        assert (result = F ) report "INC Case 1 result Error";
        assert (flagResult = flagOut ) report "INC Case 1 flag Error";

        a <= x"FFFF"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationInc;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (flagResult = flagOut and result = F ) report "INC Case 2  ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        ----- LSL --------
        a <= x"FFFF"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationLSL;               
        wait for CLK_PER;
        result :=x"FFFE"  ;
        flagResult:="10101";
        assert (result = F ) report "LSL result Error";
        assert (flagResult = flagOut ) report "LSL flag Error";
        ----- LSR --------
        a <= x"FFFF"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationLSR;               
        wait for CLK_PER;
        result :=x"7FFF"  ;
        flagResult:="00001";
        assert (flagResult = flagOut and result = F ) report "LSR ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        ------ROR---------
        a <= x"FFF1"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationROR;               
        wait for CLK_PER;
        result :=x"FFF8"  ;
        flagResult:="10100";
        assert (flagResult = flagOut and result = F ) report "ROR 1 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        a <= x"0000"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationROR;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (flagResult = flagOut and result = F ) report "ROR 2 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        -----ROL---------
        a <= x"FFF0"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationROL;               
        wait for CLK_PER;
        result :=x"FFE1"  ;
        flagResult:="00100";
        assert (flagResult = flagOut and result = F ) report "ROL 1 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        a <= x"0000"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationROL;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10010";
        assert (result = F ) report "ROL Case 2 result Error";
        assert (flagResult = flagOut ) report "ROL Case 2 flag Error";
        -----RLC---------
        a <= x"0011"; 
        b <= x"0000";
        flagIn<="00001";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"0023"  ;
        flagResult:="00000";
        assert (result = F ) report "RLC Case 1 result Error";
        assert (flagResult = flagOut ) report "RLC Case 1 flag Error";

        a <= x"0000"; 
        b <= x"0000";
        flagIn<="00001";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"0001"  ;
        flagResult:="00000";
        assert (result = F ) report "RLC Case 2 result Error";
        assert (flagResult = flagOut ) report "RLC Case 2 flag Error";

        a <= x"8000"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationRLC;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (result = F ) report "RLC Case 3 result Error";
        assert (flagResult = flagOut ) report "RLC Case 3 flag Error";
        ------RRC--------
        a <= x"1100"; 
        b <= x"0000";
        flagIn<="00001";
        operationControl<=OperationRRC;               
        wait for CLK_PER;
        result :=x"8880"  ;
        flagResult:="10100";
        assert (flagResult = flagOut and result = F ) report "RRC 1 , input = " & to_string(a) & "---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        a <= x"0000"; 
        b <= x"0000";
        flagIn<="00001";
        operationControl<=OperationRRC;               
        wait for CLK_PER;
        result :=x"8000"  ;
        flagResult:="10100";
        assert (flagResult = flagOut and result = F ) report "RRC 2 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        a <= x"0001"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationRRC;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (flagResult = flagOut and result = F ) report "RRC 3 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        ----- ASR --------
        a <= x"FFFA"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationASR;               
        wait for CLK_PER;
        result :=x"FFFD"  ;
        flagResult:="00100";
        --p o n z c (flags)
        assert (flagResult = flagOut and result = F ) report "ASR 1 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        a <= x"7FFE"; 
        b <= x"0000";
        flagIn<="00000";
        operationControl<=OperationASR;               
        wait for CLK_PER;
        result :=x"3FFF"  ;
        flagResult:="00000";
        assert (flagResult = flagOut and result = F ) report "ASR 2 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        ---------- --------------------------   ADD   ----------------------------------------------------------
        --- case 1 (odrinary two positive numbers with no cary )
        a <= x"0010"; 
        b <= x"0010"; -- not importnat 
        flagIn<="00000";
        operationControl <=OperationADD;               
        wait for CLK_PER;
        result :=x"0020"  ;
        flagResult:="10000";
        assert (flagResult = flagOut and result = F ) report "ADD 1 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --- case 2 (odrinary two positive numbers with  overflow number will be negative )
        a <= x"7FFF"; 
        b <= x"7FFF"; -- not importnat 
        flagIn<="00000";
        operationControl <=OperationADD;               
        wait for CLK_PER;
        result :=x"FFFE"  ;
        flagResult:="11100";
        assert (flagResult = flagOut and result = F ) report "ADD 2 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --- case 3 (odrinary two negative numbers with  overflow number will be positive )
        a <= x"FFFF"; 
        b <= x"1FFF"; -- not importnat 
        flagIn<="XX11X";
        operationControl <=OperationADD;               
        wait for CLK_PER;
        result :=x"1FFE"  ;
        flagResult:="10001";
        assert (flagResult = flagOut and result = F ) report "ADD 3 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        --- case 4 (negative number with  positive  )
        a <= x"F320"; 
        b <= x"0005"; -- not importnat 
        flagIn<="00000";
        operationControl <=OperationADD;               
        wait for CLK_PER;
        result :=x"F325"  ;
        flagResult:="00100";
        assert (flagResult = flagOut and result = F ) report "ADD 4 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        --- case 5 (negative + positive = 0   )
        a <= x"FFFD"; 
        b <= x"0003"; 
        flagIn<="00001"; -- try with carry 1 should not affect
        operationControl <=OperationADD;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (flagResult = flagOut and result = F ) report "ADD 5 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --p o n z c (flags)

        --- case 6 (negative + negative =  negative  )
        a <= x"FFFD";  -- -3
        b <= x"FFFD"; --  -3  
        flagIn<="00000";
        operationControl <=OperationADD;               
        wait for CLK_PER;
        result :=x"FFFA"  ;  -- -6
        flagResult:="10101";
        assert (flagResult = flagOut and result = F ) report "ADD 6 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --p o n z c (flags)
        ------------------------------- SUB -------------------------------
        --- a-b
        --p o n z c (flags)
        --- case 1 (odrinary two positive numbers with no cary )
        a <= x"0010"; 
        b <= x"0001"; -- not importnat 
        flagIn<="00000";
        operationControl <=OperationSUB;               
        wait for CLK_PER;
        result :=x"000F"  ;
        flagResult:="00001";
        assert (result = F ) report "SUB Case 1 result Error";
        assert (flagResult = flagOut ) report "SUB Case 1 flag Error";

        --- case 2 (positive - negative )
        a <= x"0010"; 
        b <= x"FFFF";  
        flagIn<="00000";
        operationControl <= OperationSUB;               
        wait for CLK_PER;
        result :=x"0011"  ;
        flagResult:="00000";
        assert (result = F ) report "SUB Case 2 result Error";
        assert (flagResult = flagOut ) report "SUB Case 2 flag Error";

        ----- case 3 ( negative - negative =0 )
        a <= x"FFFF"; 
        b <= x"FFFF";  
        flagIn<="00000";
        operationControl <= OperationSUB;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (result = F ) report "SUB Case 3 result Error";
        assert (flagResult = flagOut ) report "SUB Case 3 flag Error";

        ----- case 4 ( negative - negative = positive )
        a <= x"FFFF"; 
        b <= x"F325";  
        flagIn<="00000";
        operationControl <= OperationSUB;               
        wait for CLK_PER;
        result :=x"0CDA"  ;
        flagResult:="10001";
        assert (result = F ) report "SUB Case 4 result Error";
        assert (flagResult = flagOut ) report "SUB Case 4 flag Error";
        ----- case 5 ( negative - positive = negative )
        a <= x"FFFF"; 
        b <= x"0003";  
        flagIn<="00000";
        operationControl <= OperationSUB;               
        wait for CLK_PER;
        result :=x"FFFC"  ;
        flagResult:="10101";
        assert (result = F ) report "SUB Case 5 result Error";
        assert (flagResult = flagOut ) report "SUB Case 5 flag Error";

        ------------------------------- CMP -------------------------------
        --- a-b
        --p o n z c (flags)
        --- case 1 (odrinary two positive numbers with no cary )
        a <= x"0010"; 
        b <= x"0001"; -- not importnat 
        flagIn<="00000";
        operationControl <=OperationCMP;               
        wait for CLK_PER;
        result :=x"000F"  ;
        flagResult:="00001";
        assert (result = F ) report "CMP Case 1 result Error";
        assert (flagResult = flagOut ) report "CMP Case 1 flag Error";

        --- case 2 (positive - negative )
        a <= x"0010"; 
        b <= x"FFFF";  
        flagIn<="00000";
        operationControl <= OperationCMP;               
        wait for CLK_PER;
        result :=x"0011"  ;
        flagResult:="00000";
        assert (result = F ) report "CMP Case 2 result Error";
        assert (flagResult = flagOut ) report "CMP Case 2 flag Error";

        ----- case 3 ( negative - negative =0 )
        a <= x"FFFF"; 
        b <= x"FFFF";  
        flagIn<="00000";
        operationControl <= OperationCMP;               
        wait for CLK_PER;
        result :=x"0000"  ;
        flagResult:="10011";
        assert (result = F ) report "CMP Case 3 result Error";
        assert (flagResult = flagOut ) report "CMP Case 3 flag Error";

        ----- case 4 ( negative - negative = positive )
        a <= x"FFFF"; 
        b <= x"F325";  
        flagIn<="00000";
        operationControl <= OperationCMP;               
        wait for CLK_PER;
        result :=x"0CDA"  ;
        flagResult:="10001";
        assert (result = F ) report "CMP Case 4 result Error";
        assert (flagResult = flagOut ) report "CMP Case 4 flag Error";
        ----- case 5 ( negative - positive = negative )
        a <= x"FFFF"; 
        b <= x"0003";  
        flagIn<="00000";
        operationControl <= OperationCMP;               
        wait for CLK_PER;
        result :=x"FFFC"  ;
        flagResult:="10101";
        assert (result = F ) report "CMP Case 5 result Error";
        assert (flagResult = flagOut ) report "CMP Case 5 flag Error";
        ------------------------------- SBC -------------------------------
        --- a-b
        --p o n z c (flags)
        --- case 1 (odrinary two positive numbers with no cary )
        a <= x"0010"; 
        b <= x"0001"; -- not importnat 
        flagIn<="00001";
        operationControl <=OperationSBC;               
        wait for CLK_PER;
        result :=x"000E"  ;
        flagResult:="10001";
        assert (flagResult = flagOut and result = F ) report "SBC 1 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        --- case 2 (positive - negative )
        a <= x"0010"; 
        b <= x"FFFF";  
        flagIn<="00001";
        operationControl <= OperationSBC;               
        wait for CLK_PER;
        result :=x"0010"  ;
        flagResult:="10000";
        assert (flagResult = flagOut and result = F ) report "SBC 2 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        ----- case 3 ( negative - negative )
        a <= x"FFFF"; 
        b <= x"FFFF";  
        flagIn<="00001";
        operationControl <= OperationSBC;               
        wait for CLK_PER;
        result :=x"FFFF"  ;
        flagResult:="00101";
        assert (flagResult = flagOut and result = F ) report "SBC 3 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        ----- case 4 ( negative - negative = positive )
        a <= x"FFFF"; 
        b <= x"F325";  
        flagIn<="00000";
        operationControl <= OperationSBC;               
        wait for CLK_PER;
        result :=x"0CDA"  ;
        flagResult:="10001";
        assert (flagResult = flagOut and result = F ) report "SBC 4 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        ----- case 5 ( negative - positive = negative )
        a <= x"FFFF"; 
        b <= x"0003";  
        flagIn<="00000";
        operationControl <= OperationSBC;               
        wait for CLK_PER;
        result :=x"FFFC"  ;
        flagResult:="10101";
        assert (flagResult = flagOut and result = F ) report "SBC 5 ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        ---------- --------------------------   ADC   ----------------------------------------------------------
        --- case 1 (odrinary two positive numbers with no cary )
        a <= x"0010"; 
        b <= x"0010"; -- not importnat 
        flagIn<="XXXX0";
        operationControl <= OperationADC;               
        wait for CLK_PER;
        result := x"0020"  ;
        flagResult := "10000";
        assert (flagResult = flagOut and result= F ) report "ADC case1  ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --- case 2 (odrinary two positive numbers with  overflow number will be negative )
        a <= x"7FFF"; 
        b <= x"7FFF"; -- not importnat 
        flagIn<="XXXX1";
        operationControl <= OperationADC;               
        wait for CLK_PER;
        result := x"FFFF"  ;
        flagResult := "01100";
        assert (flagResult = flagOut and result= F ) report "ADC case2  ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        --- case 3 (odrinary two negative numbers with  overflow number will be positive )
        a <= x"FFFF"; 
        b <= x"1FFF"; -- not importnat 
        flagIn<="XX110";
        operationControl <= OperationADC;               
        wait for CLK_PER;
        result := x"1FFE"  ;
        flagResult:= "10001";
        assert (flagResult = flagOut and result= F ) report "ADC case3  ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        --- case 4 (negative number with  positive  )
        a <= x"F320"; 
        b <= x"0005"; -- not importnat 
        flagIn<="XXXX1";
        operationControl <= OperationADC;               
        wait for CLK_PER;
        result := x"F326"  ;
        flagResult := "10100";
        assert (flagResult = flagOut and result= F ) report "ADC case4  ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;
        
        --- case 5 (negative + positive = 0   )
        a <= x"FFFD"; 
        b <= x"0003"; 
        flagIn<="XXXX1"; -- try with carry 1 should not affect
        operationControl <= OperationADC;               
        wait for CLK_PER;
        result := x"0001"  ;
        flagResult:="00001";
        assert (flagResult = flagOut and result= F ) report "ADC case5  ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        --- case 6 (negative + negative =  negative  )
        a <= x"FFFD";  -- -3
        b <= x"FFFD"; --  -3  
        flagIn <= "XXXX1";
        operationControl <= OperationADC;
        wait for CLK_PER;
        result := x"FFFB"  ;  -- -6
        flagResult := "00101";
        assert (flagResult = flagOut and result= F ) report "ADC case6  ---flag = " & to_string(flagOut) & "--- output = "&to_string(F) &"  not equal to expected flag "& to_string(flagResult)&" output ="&to_string(result)  severity error;

        wait;
    end process;
end architecture;
