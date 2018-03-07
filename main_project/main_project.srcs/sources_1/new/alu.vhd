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
         carry: in std_logic ;
         opcode: in std_logic_vector(3 downto 0);
         c: out std_logic_vector(31 downto 0);
         flags: out std_logic_vector(3 downto 0)
          );
end alu;

architecture Behavioral of alu is

signal z: std_logic := '0' ;
signal n: std_logic := '0';
signal carry_out: std_logic := '0';
signal v: std_logic := '0';
signal c31: std_logic;
signal logic_op_ans: std_logic_vector(31 downto 0);
signal arith_op_ans: std_logic_vector(32 downto 0);
signal out_signal: std_logic_vector(31 downto 0);
signal carry_in: std_logic_vector(0 downto 0);
signal ans: signed(32 downto 0);
signal a_signext : std_logic_vector(32 downto 0);
signal b_signext: std_logic_vector(32 downto 0);
signal a_ext : std_logic_vector(32 downto 0);
signal b_ext: std_logic_vector(32 downto 0);

begin
    a_signext<= a(31) & a;
    b_signext <= b(31) & b;
    a_ext<= '0' & a;
    b_ext<= '0' & b;
    ans <= signed(arith_op_ans);
    carry_in(0) <= carry;
    z<='1' when to_integer(unsigned(out_signal))=0 else
        '0';
    n<= out_signal(31);
--    c31<= a_mod(31) xor b_mod(31) xor out_signal(31);
--    carry_out<= (a_mod(31) and b_mod(31)) or  (a_mod(31) and c31) or (b_mod(31) and c31);
    carry_out<= arith_op_ans(32);
    v <= '0' when ((ans>= "110000000000000000000000000000000") and (ans <= "001111111111111111111111111111111" )) else
     '1'; 
    logic_op_ans<= a and b when opcode(2 downto 0)="000" else --and/tst
        a xor b when opcode(2 downto 0)="001" else --eor/teq
        a or b when opcode="1100" else --orr
        b when opcode="1101" else --mov
        not b when opcode="1111" else --mvn
        a and (not b) when opcode="1110" else --bic
        (others => '0');
    
    
    
     arith_op_ans <= std_logic_vector(unsigned(a_ext)+unsigned(b_ext)) when opcode="0100" else --add
        std_logic_vector(unsigned(a_signext) + unsigned(not b_signext)+ 1) when opcode(2 downto 0)="010" else --sub/cmp        
        std_logic_vector(unsigned(not a_signext)+ 1  + unsigned(b_signext)) when opcode="0011" else --rsb            
        std_logic_vector(unsigned(a_ext)+unsigned(b_ext)+unsigned(carry_in)) when opcode="0101" else --adc
        std_logic_vector(unsigned(a_signext) + unsigned(not b_signext) + unsigned(carry_in) ) when opcode="0110" else --sbc
        std_logic_vector(unsigned(not a_signext) + unsigned(b_signext) + unsigned(carry_in)) when opcode="0111" else --rsc
        std_logic_vector(unsigned(a_ext)+unsigned(b_ext)) when opcode="1011" else --cmn
        (others => '0'); 
--        b_mod <= std_logic_vector(unsigned(not b) + 1) when  opcode(2 downto 0) = "010" else --sub/cmp 
--                    std_logic_vector(unsigned(b)+unsigned(carry_in)) when opcode = "0101" else  -- adc
--                    std_logic_vector(unsigned(not b)+unsigned(carry_in)) when opcode = "0110" else --sbc
--                    b;
--        a_mod <= std_logic_vector(unsigned(not a) + 1) when  opcode(3 downto 0) = "0011" else --rsb                                   
--                                        std_logic_vector(unsigned(not a)+unsigned(carry_in)) when opcode = "0111" else --rsc
--                                        a;
        
                                        
          
     out_signal<= logic_op_ans or arith_op_ans(31 downto 0);                
--    v <= carry_out xor c31 ;
    c<=out_signal; 
    flags<=z & n & carry_out & v;





end Behavioral;
