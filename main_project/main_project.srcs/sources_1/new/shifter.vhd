----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2018 02:00:09 PM
-- Design Name: 
-- Module Name: shifter - Behavioral
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


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
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

entity shifter is port(

    input : in std_logic_vector(31 downto 0)  ;
    shift_amount : in std_logic_vector(4 downto 0) ;
    shift_type : in std_logic_vector(1 downto 0) ;
    output : out std_logic_vector(31 downto 0) 
     );
end shifter;

architecture Behavioral of shifter is
signal amount : integer range 0 to 31 ;
signal r_Unsigned_R : unsigned(31 downto 0) := (others => '0');
signal r_Unsigned_L : unsigned(31 downto 0) := (others => '0');
signal r_Signed_R : signed(31 downto 0) := (others => '0');
begin
    amount <= to_integer(unsigned(shift_amount)) ;
    --r_Unsigned_R <= shift_right(unsigned(input) , amount) ;
    --r_Unsigned_L <= shift_left(unsigned(input) , amount) ;
    --r_Signed_R <= shift_right(signed(input) , amount) ; 
    output <= to_stdlogicvector(to_bitvector(input) srl amount) when shift_type="00" else 
              to_stdlogicvector(to_bitvector(input) sll amount) when shift_type="01" else   
              to_stdlogicvector(to_bitvector(input) sra amount) when shift_type="10" else
              to_stdlogicvector(to_bitvector(input) ror amount) when shift_type="11" ;
                
    --output <= to_stdlogicvector(to_bitvector(input)) srl amount when shift_type = "00" else
    --       to_stdlogicvector(to_bitvector(input)) sll amount when shift_type = "01" else 
    --       to_stdlogicvector(to_bitvector(input)) sra amount when shift_type = "10" else 
    --       to_stdlogicvector(to_bitvector(input)) ror amount ; 

end Behavioral;


