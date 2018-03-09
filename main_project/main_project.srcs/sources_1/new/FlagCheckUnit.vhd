----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2018 01:57:47 PM
-- Design Name: 
-- Module Name: FlagCheckUnit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FlagCheckUnit is
  Port ( 
    Flags : in std_logic_vector(3 downto 0) ;
    Predicate : out std_logic ;
    condition : in std_logic_vector(3 downto 0) 
  );
  
end FlagCheckUnit;

architecture Behavioral of FlagCheckUnit is
signal Z : std_logic ;
signal N : std_logic ;
signal C : std_logic ;
signal V : std_logic ;
signal check_cond_cond : std_logic ;
signal check_cond_output : std_logic ;
signal number : integer ;
begin
    
    number <= to_integer(unsigned(condition)) ;
    Z <= Flags(3) ;
    N <= Flags(2) ;
    C <= Flags(1) ;
    V <= Flags(0) ;
    
    Predicate <= Z when number = 0 else  --eq
                 (not Z) when number = 1 else --ne 
                 C when number = 2 else --hs/cs
                 (not C) when number = 3 else --lo/cc
                 N when number = 4 else --mi
                 (not N) when number = 5 else --pl 
                 V when number = 6 else --vs
                 (not V) when number = 7 else --vc 
                 (C and (not Z)) when number = 8 else --hi
                 not((C and (not Z)))  when number = 9 else --ls 
                 (N xnor C)  when number = 10 else --ge
                 (N xor C)  when number = 11 else --lt
                 ((N xnor C) and (not Z)) when number = 12 else --gt 
                 (not ((N xnor C) and (not Z)) ) when number = 13 else --le
                 '1' when number = 14 else  --al
                 '0' ; -- not a valid condition
                 
                 
                         
                        
    
    
    
    -- Flags order Z:3, N:2, C:1, V:0
     
    
        
end Behavioral;
