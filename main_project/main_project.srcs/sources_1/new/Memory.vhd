----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2018 23:15:08
-- Design Name: 
-- Module Name: Memory - Behavioral
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

entity Memory is
  Port (
    address : in std_logic_vector(3 downto 0) ;
    write_enable : in std_logic ; 
    memory_input : in std_logic_vector(31 downto 0) ; 
    memory_output : out std_logic_vector(31 downto 0) ;
    clk : in std_logic 
   );
end Memory;
architecture Behavioral of Memory is
    
type MEMORY_ARRAY_TYPE is array (0 to 15) of std_logic_vector(31 downto 0);
signal memory_array : MEMORY_ARRAY_TYPE ;
begin

    memory_output <= memory_array(to_integer(unsigned(address)));
     process(clk)
       begin
       if rising_edge(clk) then
       
       end if;
       end process ;

end Behavioral;
