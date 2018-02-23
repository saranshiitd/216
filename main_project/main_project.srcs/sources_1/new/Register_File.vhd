----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2018 01:29:24 PM
-- Design Name: 
-- Module Name: Register_File - Behavioral
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

entity Register_File is
  Port ( 
    input_data : in std_logic_vector(31 downto 0);
    read_addr_1 : in std_logic_vector(3 downto 0);
    read_addr_2 : in std_logic_vector(3 downto 0);
    write_addr : in std_logic_vector(3 downto 0);
    clk : in std_logic ;
    reset : in std_logic ;
    write_enable : in std_logic ; 
    output_1 : out std_logic_vector(31 downto 0);
    output_2 : out std_logic_vector(31 downto 0);
    pc_output : out std_logic_vector(31 downto 0);
    pc_input : in std_logic_vector(31 downto 0) ;
    write_enable_pc : in std_logic 
  );
end Register_File;

architecture Behavioral of Register_File is
type REGISTER_ARRAY_TYPE is array (0 to 15) of std_logic_vector(31 downto 0);
signal register_array : REGISTER_ARRAY_TYPE ;
begin
    pc_output <= register_array(15);
    process(clk)
    begin
    if rising_edge(clk) then
        output_1 <= register_array(to_integer(unsigned(read_addr_1)));
        output_2 <= register_array(to_integer(unsigned(read_addr_2)));
        if(write_enable = '1') then
            register_array(to_integer(unsigned(write_addr))) <= input_data ;
        end if ;
        if(reset = '1') then 
            register_array(15) <= (others => '0') ; 
        end if;
    end if;
    end process;

end Behavioral;
