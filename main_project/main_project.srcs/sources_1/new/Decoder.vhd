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


use work.typePackage.all ;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
Port(   

    Instruction : in std_logic_vector(31 downto 0 ) ;
    out_instruction_type : out instruction_type_type ;
    out_dpInstructionSubtype : out dpsubclass_type ; 
    out_dtInstructionSubtype : out  dtsubclass_type ; 
    out_mulType : out multiply_type ; 
    out_loadOrStore : out dtLoadOrStoreType ; 
    out_dpvariant : out dpvariant_type ; 
    out_setFlag : out std_logic ; 
    out_immediate : out std_logic ;
    out_preIndex : out std_logic ; 
    out_writeBack : out std_logic ; 
    out_upDown : out std_logic  
);
end Decoder;



architecture Behavioral of Decoder is

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
--signal loadOrStore : std_logic ; -- 0 then store else load 
signal ImmediateOffset : std_logic ;
signal writeBackDT : std_logic ;
signal mulType : multiply_type ;
signal loadOrStore : dtLoadOrStoreType ; 
signal setFlag : std_logic ;
signal dpvariant : dpvariant_type ;

begin
    
    out_immediate <= Instruction(25) ;
    out_setFlag <= Instruction(20) ;
    out_preIndex <= Instruction(24) ; 
    out_writeBack <= Instruction(21) ; 
    out_upDown <= Instruction(23) ; 
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
    loadOrStore <= none when (instruction_type /= DT) else
                    load when Instruction(20) = '1' else
                    store ;

    ImmediateOffset <= 'Z' when instruction_type /= DT else
                        Instruction(25) when ( (dtInstructionSubtype = wordTransfer) or (dtInstructionSubtype = byteTransfer) ) else
                        Instruction(22) when dtInstructionSubtype = halfwordTranfer ;


--    PrePost <= 'Z' when instruction_type /= DT else
--                Instruction(24) ;

--    UpDown <= 'Z' when instruction_type /= DT else 
--                Instruction(23) ;

--    writeBackDT <= 'Z' when (instruction_type /= DT) else
--                   Instruction(21) ;

    mulType <= notMul when ( dpInstructionSubtype /= mul ) else
             mult when (Instruction(21) = '0') else 
             mla ;
             
   dpvariant <= imm when Immediate = '1' else
                reg_imm when arithRegNoShift = '1' else
                reg_shift_const when arithRegShiftCons = '1' else 
                reg_shift_reg ;
                


end Behavioral;
