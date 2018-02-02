----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2018 03:13:35 PM
-- Design Name: 
-- Module Name: multiplier - Behavioral
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

entity multiplier is  Port (
    op1 : in std_logic_vector(31 downto 0); 
    op2 : in std_logic_vector(31 downto 0);
    output : out std_logic_vector(31 downto 0)
 );
end multiplier;

architecture Behavioral of multiplier is

begin
    --output <= op1*op2 ;
    output <= std_logic_vector( signed(op1) * signed(op2) );
end Behavioral;
