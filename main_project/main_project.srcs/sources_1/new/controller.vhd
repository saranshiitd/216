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
    P_temp: out std_logic;
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


begin
    arithRegShiftCons <= '1' when ( (instruction_type = arith) and ( Instruction(4) = '0') ) else '0' ; 
    arithRegNoShift <= '1' when ((instruction_type = arith) and ( Instruction(11 downto 7) = "00000") and (Instruction(4) = '0') ) ; 
    arithRegShiftReg <= '1' when ((instruction_type = arith) and )
 

--    arithRegShiftCons <= '1' when ( (instruction_type = arith) and ( Instruction(4) = '0') ) else '0' ; 
--    arithRegNoShift <= '1' when ((instruction_type = arith) and  )
    
    
end Behavioral;
