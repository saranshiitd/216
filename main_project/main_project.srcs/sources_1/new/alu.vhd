----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2018 13:49:10
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
  Port ( a: in std_logic_vector(31 downto 0);
         b: in std_logic_vector(31 downto 0);
         carry: in std_logic_vector(0 downto 0);
         opcode: in std_logic_vector(3 downto 0);
         c: out std_logic_vector(31 downto 0);
         flags: out std_logic_vector(3 downto 0)
          );
end alu;

architecture Behavioral of alu is
signal z: std_logic;
signal n: std_logic;
signal carry_out: std_logic;
signal v: std_logic;
signal c31: std_logic;
signal out_signal: std_logic_vector(31 downto 0);
begin
    z<='1' when to_integer(unsigned(out_signal))=0 else
        '0';
    n<= out_signal(31);
    c31<= a(31) xor b(31) xor out_signal(31);
    carry_out<= (a(31) and b(31)) or  (a(31) and c31) or (b(31) and c31);
    out_signal<= a and b when opcode(3 downto 0)="000" else --and/tst
        a xor b when opcode(3 downto 0)="001" else --eor/teq
        std_logic_vector(unsigned(a)+unsigned(b)) when opcode="0100" else --add
        std_logic_vector(unsigned(a) + unsigned(not b)+ 1) when opcode(3 downto 0)="010" else --sub/cmp        
        std_logic_vector(unsigned(not a) + unsigned(b)) when opcode="0011" else --rsb            
        std_logic_vector(unsigned(a)+unsigned(b)+unsigned(carry)) when opcode="0101" else --adc
        std_logic_vector(unsigned(a) + unsigned(not b) + unsigned(carry) ) when opcode="0110" else --sbc
        std_logic_vector(unsigned(not a) + unsigned(b) + unsigned(carry)) when opcode="0111" else --rsc
        std_logic_vector(unsigned(a)+unsigned(b)) when opcode="1011" else --cmn
        a or b when opcode="1100" else --orr
        b when opcode="1101" else --mov
        not b when opcode="1111" else --mvn
        a and (not b) when opcode="1110"; --bic
                
                      
    c<=out_signal; 
    flags<=z & n & carry_out & v;
end Behavioral;
