----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2018 13:15:30
-- Design Name: 
-- Module Name: controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
Port(    clk : in std_logic ;
    PW : out std_logic ;
    IorD : out std_logic_vector(1 downto 0) ;
    MR : out std_logic ;
    MW : out std_logic ;
    IW : out std_logic ; 
    DW : out std_logic ;
    M2R : out std_logic ;
    R1src: out std_logic_vector(1 downto 0);
    Wsrc: out std_logic;
    Rsrc : out std_logic ;
    RW : out std_logic ;
    AW : out std_logic ;
    BW : out std_logic ;
    CW : out std_logic ;
    Asrc1 : out std_logic ;
    Asrc2 : out std_logic_vector(2 downto 0) ;
    Fset : out std_logic ;
    ReW : out std_logic ;
    op : out std_logic_vector(3 downto 0) ;
    Flags : in std_logic_vector(3 downto 0) ;
    Reset_register_file : out std_logic  ;
    Instruction : in std_logic_vector(31 downto 0 )    
);
end controller;



architecture Behavioral of controller is
type state is (fetch , RdAB , RdBC , RdC , WriteRes ) ; 
--type instruction_type_type is (arith , mul , test , halfwordTranfer) ; 
type instruction_type_type is (DP, DT, Branch) ;
type dpsubclass_type is (mul,arith,tst, NotDP);
type dtsubclass_type is ( wordTransfer , byteTransfer , halfwordTranfer , NotDT ) ;
signal Immediate : std_logic ;
signal arithRd : std_logic_vector(3 downto 0) ; 
signal arithRn : std_logic_vector(3 downto 0) ; 
signal arithRm : std_logic_vector(3 downto 0) ; 
signal arithRs : std_logic_vector(3 downto 0) ;
signal instruction_type : instruction_type_type ;
signal dpInstructionSubtype : dpsubclass_type ; 
signal arithRegNoShift : std_logic ;
signal arithRegShiftCons : std_logic ; 
signal arithRegShiftReg : std_logic ;
signal PrePost : std_logic ; 
signal UpDown : std_logic ; 
signal dtInstructionSubtype : dtsubclass_type ; 
signal loadOrStore : std_logic ; -- 0 then store else load 
signal ImmediateOffset : std_logic ;
signal writeBackDT : std_logic ;
signal 
  
begin
    instruction_type <=  DT when ( Instruction(27 downto 26) = "01" or ((Instruction(27 downto 26) = "00" and Instruction(11 downto 8) = "0000" and Instruction(4) = '1' and Instruction(7) = '1' and Instruction(6 downto 5) /= "00" ))) else
                        Branch when (Instruction(27 downto 26) = "10") else 
                        DP ;
    Immediate <= Instruction(25) ; 
    arithRegShiftCons <= '1' when ( ( instruction_type = DP)   and (dpInstructionSubtype = arith) and ( Instruction(4) = '0') ) else '0' ; 
    arithRegNoShift <= '1' when (( instruction_type = DP)   and (dpInstructionSubtype = arith) and ( Instruction(11 downto 7) = "00000") and (Instruction(4) = '0') ) else '0'; 
    arithRegShiftReg <= '1' when (( instruction_type = DP)   and (dpInstructionSubtype = arith) and Instruction(4) = '1') else '0' ; 
    dpInstructionSubtype <= arith when ( instruction_type = DP and ((Instruction(7) and Instruction(4)) = '0') and (Instruction(24 downto 23) /= "10") ) else
                        mul when (instruction_type = DP and Instruction(7 downto 4) = "1001" and Immediate = '0') else 
                        tst when ( instruction_type = DP and Instruction(24 downto 23) = "00" and ((Instruction(7) and Instruction(4)) = '0') ) else
                        NotDP   ;
    dtInstructionSubtype <= halfwordTranfer when ((instruction_type = DT) and Instruction(11 downto 8) = "0000" and Instruction(4) = '1' and Instruction(7) = '1' and Instruction(6 downto 5) /= "00" ) else 
                            byteTransfer when ((instruction_type = DT) and Instruction(22) = '1' ) else
                            wordTransfer when ((instruction_type = DT ) and Instruction(22) = '0' ) else
                            NotDT ;     
    loadOrStore <= Instruction(20) when (instruction_type = DT) else 'Z' ;

    ImmediateOffset <= 'Z' when instruction_type /= DT else
                        Instruction(25) when ((dpInstructionSubtype = wordTransfer) or (dpInstructionSubtype = byteTransfer) ) else
                        Instruction(22) when dpInstructionSubtype = halfwordTranfer ;

    PrePost <= 'Z' when instruction_type /= DT else
                Instruction(24) ;
    UpDown <= 'Z' when instruction_type /= DT else 
                Instruction(23) ;
    writeBackDP <= 'Z' when instruction_type /= DT else
                   Instruction(21) ;

    
 
 

end Behavioral;