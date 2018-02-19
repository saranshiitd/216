----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2018 22:40:43
-- Design Name: 
-- Module Name: datapath - Behavioral
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
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
 Port ( 
    clk : in std_logic
 
 );
end datapath;

architecture Behavioral of datapath is

signal selected_memory_input : std_logic_vector(31 downto 0) ; 
signal selectd_alu_first_operand : std_logic_vector(31 downto 0) ;
signal selectd_alu_second_operand : std_logic_vector(31 downto 0) ;
signal selected_register_number : std_logic_vector(3 downto 0) ;
signal memory_address : std_logic_vector(3 downto 0) ;
signal memory_write_enable : std_logic ;
signal memory_output : std_logic_vector(31 downto 0) ;
signal register_file_input : std_logic_vector(31 downto 0) ;
signal register_file_read_addr1 : std_logic_vector(3 downto 0) ;
signal register_file_read_addr2 : std_logic_vector(3 downto 0) ;
signal register_file_write_enable : std_logic ;
begin

    memory_instantiation : entity work.Memory port map (
        
        address => memory_address ,
        write_enable => memory_write_enable ,
        memory_input => selected_memory_input ,
        memory_output => memory_output ,
        clk => clk
        
    
    );
    
    register_file_instantiation : entity work.Register_File port map (
        
        clk => clk ,
        input_data => register_file_input ,
        read_addr_1 => register_file_read_addr1 ,
        read_addr_2 => register_file_read_addr2 ,
        
    
    
    );
   
end Behavioral;
